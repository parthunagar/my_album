// ignore_for_file: unnecessary_null_comparison, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:monirth_memories/core/app.locator.dart';
import 'package:monirth_memories/core/services/favorites_service.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:monirth_memories/utils/globals.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:pip_view/pip_view.dart';

class MyPlayerViewModel extends BaseViewModel {
  final String videoUrl;
  final BuildContext context;
  MyPlayerViewModel(this.context, this.videoUrl);

  late VideoPlayerController videoController;
  final model = locator<PreferenceService>();

  bool showControls = true;
  bool isFullscreen = false;
  bool showSeekIcon = false;
  bool isForward = true;
  double volume = 1.0;
  double brightness = 0.5;
  double speed = 1.0;
  Timer? hideTimer;

  // gesture variables
  double initialVerticalDragValue = 0.0;
  double verticalDragStartY = 0.0;
  bool showVolumeIndicator = false;
  bool showBrightnessIndicator = false;

  // Add these variables in your State class
  bool isDownloading = false;
  bool cancelDownload = false;
  double downloadProgress = 0.0;
  double downloadedMB = 0.0;
  double totalMB = 0.0;
  http.Client? httpClient;

  // ✅ Stream for download progress
  final StreamController<double> _progressController =
      StreamController.broadcast();
  Stream<double> get progressStream => _progressController.stream;

  Future<void> init() async {
    initializePlayer(videoUrl);
  }

  Future<void> initializePlayer(String url) async {
    videoController = VideoPlayerController.networkUrl(Uri.parse(url));
    await videoController.initialize();
    videoController.setVolume(volume);
    videoController.setPlaybackSpeed(speed);
    videoController.play();
    notifyListeners();
    startAutoHideControls();
  }

  @override
  void dispose() {
    videoController.dispose();
    hideTimer?.cancel();
    _progressController.close();
    super.dispose();
  }

  void togglePlayPause() {
    if (videoController.value.isPlaying) {
      videoController.pause();
    } else {
      videoController.play();
    }
    notifyListeners();
    startAutoHideControls();
  }

  void seekBy(Duration offset, {required bool forward}) async {
    final pos = await videoController.position ?? Duration.zero;
    final duration = videoController.value.duration;
    Duration target = pos + offset;
    if (target < Duration.zero) target = Duration.zero;
    if (target > duration) target = duration;
    videoController.seekTo(target);

    showSeekIcon = true;
    isForward = forward;
    notifyListeners();

    Future.delayed(const Duration(milliseconds: 600), () {
      showSeekIcon = false;
      notifyListeners();
    });
  }

  void toggleControls() {
    showControls = !showControls;
    notifyListeners();
    if (showControls) startAutoHideControls();
  }

  void startAutoHideControls() {
    hideTimer?.cancel();
    hideTimer = Timer(const Duration(seconds: 3), () {
      showControls = false;
      notifyListeners();
    });
  }

  void toggleFullScreen() {
    if (isFullscreen) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }
    isFullscreen = !isFullscreen;
    notifyListeners();
  }

  void enterPiP() {
    final pip = PIPView.of(context);
    pip?.presentBelow(const SizedBox());
  }

  void changeSpeed(double newSpeed) {
    videoController.setPlaybackSpeed(newSpeed);
    speed = newSpeed;
    notifyListeners();
  }

  void setVolume(double value) {
    videoController.setVolume(value);
    volume = value;
    notifyListeners();
  }

  void setBrightness(double value) {
    brightness = value.clamp(0.0, 1.0);
    notifyListeners();
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '${twoDigits(duration.inHours)}:$minutes:$seconds';
  }

  Future<void> downloadVideo() async {
    try {
      if (Platform.isAndroid) {
        if (await Permission.manageExternalStorage.isDenied) {
          await Permission.manageExternalStorage.request();
        }
        if (await Permission.storage.isDenied) {
          await Permission.storage.request();
        }
        if (await Permission.manageExternalStorage.isDenied &&
            await Permission.storage.isDenied) {
          snackBar(context, 'Storage permission denied', showInTop: true);
          return;
        }
      }

      final downloadsDir = Directory('/storage/emulated/0/Download');
      if (!await downloadsDir.exists()) {
        await downloadsDir.create(recursive: true);
      }

      final fileName = videoUrl.split('/').last;
      final filePath = '${downloadsDir.path}/$fileName';
      final file = File(filePath);

      httpClient = http.Client();
      final request = http.Request('GET', Uri.parse(videoUrl));
      final response = await httpClient!.send(request);

      final total = response.contentLength ?? 0;
      int received = 0;
      final sink = file.openWrite();

      isDownloading = true;
      cancelDownload = false;
      downloadedMB = 0;
      totalMB = total / (1024 * 1024);
      notifyListeners();

      double lastProgress = 0.0;

      late StreamSubscription<List<int>> subscription;
      subscription = response.stream.listen(
        (chunk) {
          if (cancelDownload) {
            subscription.cancel();
            return;
          }

          received += chunk.length;
          sink.add(chunk);

          if (total > 0) {
            final newProgress = received / total;
            if ((newProgress - lastProgress).abs() >= 0.005) {
              // ✅ Push progress to stream
              downloadedMB = received / (1024 * 1024);
              _progressController.add(newProgress);
              lastProgress = newProgress;
            }
          }
        },
        onDone: () async {
          await sink.close();

          if (cancelDownload) {
            snackBar(context, 'Download cancelled', showInTop: true);
          } else {
            snackBar(context, 'Downloaded to: $filePath', showInTop: true);
          }

          isDownloading = false;
          _progressController.add(1.0);
          notifyListeners();
        },
        onError: (e) async {
          await sink.close();
          isDownloading = false;
          _progressController.addError(e);
          notifyListeners();
          snackBar(context, 'Download failed', showInTop: true);
        },
        cancelOnError: true,
      );
    } catch (e) {
      isDownloading = false;
      _progressController.addError(e);
      notifyListeners();
      snackBar(context, 'Download failed', showInTop: true);
    }
  }

  void cancelDownloadNow() {
    if (isDownloading) {
      cancelDownload = true;
      notifyListeners();
      _progressController.addError('cancelled');
      httpClient?.close();
    }
  }
}

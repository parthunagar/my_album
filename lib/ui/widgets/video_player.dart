// ignore_for_file: use_build_context_synchronously

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:monirth_memories/ui/widgets/custom_app_bar.dart';
import 'package:monirth_memories/ui/widgets/progress_bar.dart';
import 'package:monirth_memories/utils/globals.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:pip_view/pip_view.dart';
import 'package:http/http.dart' as http;

class MyPlayer extends StatefulWidget {
  final String videoUrl;
  const MyPlayer({super.key, required this.videoUrl});

  @override
  State<MyPlayer> createState() => _MyPlayerState();
}

class _MyPlayerState extends State<MyPlayer> {
  late VideoPlayerController _videoController;
  bool _showControls = true;
  bool _isFullscreen = false;
  bool _showSeekIcon = false;
  bool _isForward = true;
  double _volume = 1.0;
  double _brightness = 0.5; // pseudo brightness (visual only)
  double _speed = 1.0;
  Timer? _hideTimer;

  @override
  void initState() {
    super.initState();
    _initializePlayer(widget.videoUrl);
  }

  Future<void> _initializePlayer(String url) async {
    _videoController = VideoPlayerController.networkUrl(Uri.parse(url));
    await _videoController.initialize();
    _videoController.setVolume(_volume);
    _videoController.setPlaybackSpeed(_speed);
    _videoController.play();
    setState(() {});
    _startAutoHideControls();
  }

  @override
  void dispose() {
    _videoController.dispose();
    _hideTimer?.cancel();
    super.dispose();
  }

  void _togglePlayPause() {
    if (_videoController.value.isPlaying) {
      _videoController.pause();
    } else {
      _videoController.play();
    }
    setState(() {});
    _startAutoHideControls();
  }

  void _seekBy(Duration offset, {required bool forward}) async {
    final pos = await _videoController.position ?? Duration.zero;
    final duration = _videoController.value.duration;
    Duration target = pos + offset;
    if (target < Duration.zero) target = Duration.zero;
    if (target > duration) target = duration;
    _videoController.seekTo(target);

    setState(() {
      _showSeekIcon = true;
      _isForward = forward;
    });
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) setState(() => _showSeekIcon = false);
    });
  }

  void _toggleControls() {
    setState(() => _showControls = !_showControls);
    if (_showControls) _startAutoHideControls();
  }

  void _startAutoHideControls() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) setState(() => _showControls = false);
    });
  }

  void _toggleFullScreen() {
    if (_isFullscreen) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }
    setState(() => _isFullscreen = !_isFullscreen);
  }

  void _enterPiP() {
    final pip = PIPView.of(context);
    pip?.presentBelow(const SizedBox());
  }

  void _changeSpeed(double newSpeed) {
    _videoController.setPlaybackSpeed(newSpeed);
    setState(() => _speed = newSpeed);
  }

  void _setVolume(double value) {
    _videoController.setVolume(value);
    setState(() => _volume = value);
  }

  void _setBrightness(double value) {
    setState(() => _brightness = value.clamp(0.0, 1.0));
    // Note: Real system brightness changes require a package like `screen_brightness`.
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '${twoDigits(duration.inHours)}:$minutes:$seconds';
  }

  // gesture variables
  double _initialVerticalDragValue = 0.0;
  double _verticalDragStartY = 0.0;
  bool _showVolumeIndicator = false;
  bool _showBrightnessIndicator = false;

  @override
  Widget build(BuildContext context) {
    if (!_videoController.value.isInitialized) {
      return ParentView(
        title: '',
        body: const SmoothImagePlaceholder(),
      );
    }

    final currentPosition = _videoController.value.position;
    final totalDuration = _videoController.value.duration;

    return PIPView(
      builder: (context, isFloating) {
        return ParentView(
          title: '',
          body: GestureDetector(
            onTap: _toggleControls,
            onDoubleTapDown: (details) {
              final width = MediaQuery.of(context).size.width;
              final dx = details.globalPosition.dx;
              if (dx < width / 2) {
                _seekBy(const Duration(seconds: -10), forward: false);
              } else {
                _seekBy(const Duration(seconds: 10), forward: true);
              }
            },
            onVerticalDragStart: (details) {
              final width = MediaQuery.of(context).size.width;
              _verticalDragStartY = details.globalPosition.dy;

              if (details.globalPosition.dx > width / 2) {
                _initialVerticalDragValue = _volume;
                setState(() => _showVolumeIndicator = true);
              } else {
                _initialVerticalDragValue = _brightness;
                setState(() => _showBrightnessIndicator = true);
              }
            },
            onVerticalDragUpdate: (details) {
              final width = MediaQuery.of(context).size.width;
              final dragDelta = _verticalDragStartY - details.globalPosition.dy;
              double newValue =
                  _initialVerticalDragValue + (dragDelta / 300); // sensitivity

              if (details.globalPosition.dx > width / 2) {
                _setVolume(newValue);
              } else {
                _setBrightness(newValue);
              }
            },
            onVerticalDragEnd: (details) {
              setState(() {
                _showVolumeIndicator = false;
                _showBrightnessIndicator = false;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Background gradient for dark theme
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.black, Color(0xFF0A0A0A)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),

                // Video
                Center(
                  child: AspectRatio(
                    aspectRatio: _videoController.value.aspectRatio,
                    child: VideoPlayer(_videoController),
                  ),
                ),

                // Dim layer to simulate brightness
                Container(
                  color: Colors.black.withValues(alpha: 1 - _brightness),
                ),

                // 🔊 Volume Indicator
                if (_showVolumeIndicator)
                  _buildIndicator(
                    Icons.volume_up,
                    _volume,
                    Alignment.centerRight,
                    Colors.redAccent,
                  ),

                // ☀️ Brightness Indicator
                if (_showBrightnessIndicator)
                  _buildIndicator(
                    Icons.brightness_6,
                    _brightness,
                    Alignment.centerLeft,
                    Colors.amberAccent,
                  ),

                // Seek animation
                if (_showSeekIcon)
                  Container(
                    padding: const EdgeInsets.only(left: 50, right: 50),
                    alignment: _isForward
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Icon(
                      _isForward
                          ? Icons.forward_10_rounded
                          : Icons.replay_10_rounded,
                      color: Colors.white.withValues(alpha: 0.7),
                      size: 50,
                    ),
                  ),

                // Central play/pause button
                if (_showControls)
                  AnimatedOpacity(
                    opacity: _showControls ? 1 : 0,
                    duration: const Duration(milliseconds: 300),
                    child: GestureDetector(
                      onTap: _togglePlayPause,
                      child: Icon(
                        _videoController.value.isPlaying
                            ? Icons.pause_circle_filled
                            : Icons.play_circle_fill,
                        size: 50,
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                  ),

                // Bottom control bar
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: AnimatedOpacity(
                    opacity: _showControls ? 1 : 0,
                    duration: const Duration(milliseconds: 300),
                    child:
                        _buildControls(context, currentPosition, totalDuration),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildIndicator(
      IconData icon, double value, Alignment align, Color color) {
    return Align(
      alignment: align,
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 40),
            const SizedBox(height: 10),
            Container(
              width: 6,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white30,
                borderRadius: BorderRadius.circular(3),
              ),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 120 * value,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Add these variables in your State class
  bool _isDownloading = false;
  bool _cancelDownload = false;
  double _downloadProgress = 0.0;
  double _downloadedMB = 0.0;
  double _totalMB = 0.0;
  http.Client? _httpClient;

// --- Download Method with Cancel Support ---
  Future<void> _downloadVideo() async {
    try {
      // ✅ Ask for permissions
      if (Platform.isAndroid) {
        if (await Permission.manageExternalStorage.isDenied) {
          await Permission.manageExternalStorage.request();
        }
        if (await Permission.storage.isDenied) {
          await Permission.storage.request();
        }

        if (await Permission.manageExternalStorage.isDenied &&
            await Permission.storage.isDenied) {
          snackBar(context, 'Storage permission denied');
          return;
        }
      }

      // ✅ Prepare save directory
      final downloadsDir = Directory('/storage/emulated/0/Download');
      if (!await downloadsDir.exists()) {
        await downloadsDir.create(recursive: true);
      }

      final fileName = widget.videoUrl.split('/').last;
      final filePath = '${downloadsDir.path}/$fileName';
      final file = File(filePath);

      _httpClient = http.Client();
      final request = http.Request('GET', Uri.parse(widget.videoUrl));
      final response = await _httpClient!.send(request);

      final total = response.contentLength ?? 0;
      int received = 0;
      final sink = file.openWrite();

      setState(() {
        _isDownloading = true;
        _cancelDownload = false;
        _downloadProgress = 0.0;
        _downloadedMB = 0;
        _totalMB = total / (1024 * 1024);
      });

      late StreamSubscription<List<int>> subscription;
      subscription = response.stream.listen(
        (chunk) {
          if (_cancelDownload) {
            subscription.cancel();
            return;
          }

          received += chunk.length;
          sink.add(chunk);

          if (total > 0) {
            setState(() {
              _downloadProgress = received / total;
              _downloadedMB = received / (1024 * 1024);
            });
          }
        },
        onDone: () async {
          await sink.close();

          if (_cancelDownload) {
            snackBar(context, 'Download cancelled');
          } else {
            snackBar(context, 'Downloaded to: $filePath');
          }

          setState(() {
            _isDownloading = false;
            _downloadProgress = 0.0;
          });
        },
        onError: (e) async {
          await sink.close();
          snackBar(context, 'Download cancelled');

          setState(() => _isDownloading = false);
        },
        cancelOnError: true,
      );
    } catch (e) {
      setState(() => _isDownloading = false);
      snackBar(context, 'Download cancelled');
    }
  }

  void _cancelDownloadNow() {
    if (_isDownloading) {
      setState(() {
        _cancelDownload = true;
      });
      _httpClient?.close();
    }
  }

  Widget _buildControls(
      BuildContext context, Duration position, Duration totalDuration) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          color: Colors.black.withValues(alpha: 0.6),
          child: SafeArea(
            top: false,
            child: Row(
              children: [
                // Current time
                Text(_formatDuration(position)),

                const SizedBox(width: 8),

                // Progress bar (expandable)
                Expanded(
                  child: VideoProgressIndicator(
                    _videoController,
                    allowScrubbing: true,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    colors: const VideoProgressColors(
                      playedColor: Colors.redAccent,
                      bufferedColor: Colors.white38,
                      backgroundColor: Colors.white10,
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                // Total duration
                Text(_formatDuration(totalDuration)),

                const SizedBox(width: 8),

                // Speed control
                PopupMenuButton<double>(
                  initialValue: _speed,
                  onSelected: _changeSpeed,
                  color: Colors.black87,
                  itemBuilder: (context) => [
                    for (var s in [0.5, 1.0, 1.5, 2.0])
                      PopupMenuItem(
                        value: s,
                        child: Text('Speed ${s}x'),
                      ),
                  ],
                  child: const Icon(Icons.speed, size: 22),
                ),

                IconButton(
                  icon: _isDownloading
                      ? Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 26,
                              height: 26,
                              child: CircularProgressIndicator(
                                value: _downloadProgress,
                                strokeWidth: 3,
                                color: Colors.white,
                              ),
                            ),
                            const Icon(Icons.close,
                                size: 18, color: Colors.redAccent),
                          ],
                        )
                      : const Icon(Icons.download, color: Colors.white),
                  onPressed:
                      _isDownloading ? _cancelDownloadNow : _downloadVideo,
                ),
                if (_isDownloading)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      '${_downloadedMB.toStringAsFixed(1)} MB / ${_totalMB.toStringAsFixed(1)} MB',
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ),

                // PiP button
                IconButton(
                  icon: const Icon(Icons.picture_in_picture_alt,
                      color: Colors.white, size: 22),
                  onPressed: _enterPiP,
                ),

                // Fullscreen button
                IconButton(
                  icon: Icon(
                    _isFullscreen ? Icons.fullscreen_exit : Icons.fullscreen,
                    color: Colors.white,
                    size: 22,
                  ),
                  onPressed: _toggleFullScreen,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

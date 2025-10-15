part of my_player_view;

class _MyPlayerMobile extends ViewModelWidget<MyPlayerViewModel> {
  const _MyPlayerMobile();

  @override
  Widget build(BuildContext context, MyPlayerViewModel vm) {
    if (!vm.videoController.value.isInitialized) {
      return ParentView(body: const SmoothImagePlaceholder());
    }

    final currentPosition = vm.videoController.value.position;
    final totalDuration = vm.videoController.value.duration;

    return ParentView(
      body: GestureDetector(
        onTap: vm.toggleControls,
        onDoubleTapDown: (details) {
          final width = MediaQuery.of(context).size.width;
          final dx = details.globalPosition.dx;
          if (dx < width / 2) {
            vm.seekBy(const Duration(seconds: -10), forward: false);
          } else {
            vm.seekBy(const Duration(seconds: 10), forward: true);
          }
        },
        onVerticalDragStart: (details) {
          final width = MediaQuery.of(context).size.width;
          vm.verticalDragStartY = details.globalPosition.dy;

          if (details.globalPosition.dx > width / 2) {
            vm.initialVerticalDragValue = vm.volume;
            vm.showVolumeIndicator = true;
            vm.notifyListeners();
          } else {
            vm.initialVerticalDragValue = vm.brightness;
            vm.showBrightnessIndicator = true;
            vm.notifyListeners();
          }
        },
        onVerticalDragUpdate: (details) {
          final width = MediaQuery.of(context).size.width;
          final dragDelta = vm.verticalDragStartY - details.globalPosition.dy;
          double newValue = vm.initialVerticalDragValue + (dragDelta / 300);

          if (details.globalPosition.dx > width / 2) {
            vm.setVolume(newValue);
          } else {
            vm.setBrightness(newValue);
          }
        },
        onVerticalDragEnd: (details) {
          vm.showVolumeIndicator = false;
          vm.showBrightnessIndicator = false;
          vm.notifyListeners();
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: vm.model.isDark
                      ? [Colors.black, const Color(0xFF0A0A0A)]
                      : [Colors.white, Colors.white],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),

            Center(
              child: AspectRatio(
                aspectRatio: vm.videoController.value.aspectRatio,
                child: VideoPlayer(vm.videoController),
              ),
            ),

            // 🔊 Volume Indicator
            if (vm.showVolumeIndicator)
              _buildIndicator(
                Icons.volume_up,
                vm.volume,
                Alignment.centerRight,
                Colors.redAccent,
                vm,
              ),

            // ☀️ Brightness Indicator
            if (vm.showBrightnessIndicator)
              _buildIndicator(
                Icons.brightness_6,
                vm.brightness,
                Alignment.centerLeft,
                Colors.amberAccent,
                vm,
              ),

            // Seek animation
            if (vm.showSeekIcon)
              Container(
                padding: const EdgeInsets.only(left: 50, right: 50),
                alignment:
                    vm.isForward ? Alignment.centerRight : Alignment.centerLeft,
                child: Icon(
                  vm.isForward
                      ? Icons.forward_10_rounded
                      : Icons.replay_10_rounded,
                  color: Colors.white.withValues(alpha: 0.7),
                  size: 50,
                ),
              ),

            // Central play/pause button
            if (vm.showControls)
              AnimatedOpacity(
                opacity: vm.showControls ? 1 : 0,
                duration: const Duration(milliseconds: 300),
                child: GestureDetector(
                  onTap: vm.togglePlayPause,
                  child: Icon(
                    vm.videoController.value.isPlaying
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
                opacity: vm.showControls ? 1 : 0,
                duration: const Duration(milliseconds: 300),
                child:
                    _buildControls(context, currentPosition, totalDuration, vm),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIndicator(IconData icon, double value, Alignment align,
      Color color, MyPlayerViewModel vm) {
    return Align(
      alignment: align,
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 30),
            const SizedBox(height: 10),
            Container(
              width: 6,
              height: 120,
              decoration: BoxDecoration(
                color: vm.model.isDark ? Colors.white54 : Colors.black54,
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

  Widget _buildControls(BuildContext context, Duration position,
      Duration totalDuration, MyPlayerViewModel vm) {
    bool isDark = vm.model.isDark;
    final style = TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: isDark ? Colors.black : Colors.white);
    Color iconColor = isDark ? Colors.black : Colors.white;
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          color: isDark ? Colors.white70 : Colors.black87,
          child: SafeArea(
            top: false,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Current time
                Text(vm.formatDuration(position), style: style),

                // Progress bar (expandable)
                Expanded(
                  child: VideoProgressIndicator(
                    vm.videoController,
                    allowScrubbing: true,
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    colors: VideoProgressColors(
                      playedColor: Colors.redAccent,
                      bufferedColor: isDark ? Colors.black38 : Colors.white38,
                      backgroundColor: isDark ? Colors.black12 : Colors.white10,
                    ),
                  ),
                ),

                // Total duration
                Text(vm.formatDuration(totalDuration), style: style),

                // Speed control
                /*
                PopupMenuButton<double>(
                  initialValue: vm.speed,
                  onSelected: vm.changeSpeed,
                  color: Colors.black87,
                  itemBuilder: (context) => [
                    for (var s in [0.5, 1.0, 1.5, 2.0])
                      PopupMenuItem(
                        value: s,
                        child: Text('Speed ${s}x'),
                      ),
                  ],
                  child: const Icon(Icons.speed, size: 22,color: iconColor),
                ), */

                StreamBuilder<double>(
                  stream: vm.progressStream,
                  initialData: 0.0,
                  builder: (context, snapshot) {
                    final progress = snapshot.data ?? 0.0;
                    final downloadedMB = vm.totalMB * progress;
                    return IconButton(
                      icon: vm.isDownloading
                          ? Column(
                              children: [
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    SizedBox(
                                      width: 26,
                                      height: 26,
                                      child: CircularProgressIndicator(
                                        value: progress,
                                        strokeWidth: 3,
                                        color: isDark
                                            ? Colors.black
                                            : Colors.white,
                                        backgroundColor: isDark
                                            ? Colors.black26
                                            : Colors.white24,
                                      ),
                                    ),
                                    const Icon(Icons.close,
                                        size: 18, color: Colors.redAccent),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    '${downloadedMB.toStringAsFixed(1)} MB / ${vm.totalMB.toStringAsFixed(1)} MB',
                                    style: style,
                                  ),
                                ),
                              ],
                            )
                          : Icon(Icons.download, color: iconColor),
                      onPressed: vm.isDownloading
                          ? vm.cancelDownloadNow
                          : vm.downloadVideo,
                    );
                  },
                ),

                // PiP button
                IconButton(
                  icon: Icon(Icons.picture_in_picture_alt, color: iconColor),
                  onPressed: vm.enterPiP,
                ),

                // Fullscreen button
                IconButton(
                  icon: Icon(
                      vm.isFullscreen
                          ? Icons.fullscreen_exit
                          : Icons.fullscreen,
                      size: 22,
                      color: iconColor),
                  onPressed: vm.toggleFullScreen,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

part of full_image_view;

class _FullImageMobile extends StatefulWidget {
  final FullImageViewModel viewModel;
  const _FullImageMobile({required this.viewModel});

  @override
  State<_FullImageMobile> createState() => _FullImageMobileState();
}

class _FullImageMobileState extends State<_FullImageMobile>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    widget.viewModel.animController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
  }

  Widget buildFullImage(
      PhotoModel photo, int i, bool isCurrent, FullImageViewModel vm) {
    return Hero(
      tag: 'photo_$i',
      child: AnimatedOpacity(
        opacity: isCurrent ? 1 : 0.4,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        child: AnimatedScale(
          scale: isCurrent ? 1.0 : 0.9,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          child: Transform.translate(
            offset: Offset(0, vm.verticalDrag),
            child: Transform.rotate(
              angle: vm.rotation,
              child: GestureDetector(
                onDoubleTap: () {
                  setState(() {
                    final nextScale =
                        (vm.controllers[i].scale ?? 1.0) == 1.0 ? 2.5 : 1.0;
                    vm.controllers[i].scale = nextScale;
                  });
                },
                child: PhotoView(
                  controller: vm.controllers[i],
                  scaleStateController: vm.scaleControllers[i],
                  imageProvider: CachedNetworkImageProvider(
                    photo.url,
                    cacheKey: photo.url,
                  ),
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.covered * 3,
                  backgroundDecoration:
                      const BoxDecoration(color: Colors.transparent),
                  loadingBuilder: (_, __) => const SmoothImagePlaceholder(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildThumb(PhotoModel photo, bool isSelected, FullImageViewModel vm) {
    final model = locator<PreferenceService>();
    return GestureDetector(
      onTap: () => vm.pageController.jumpToPage(vm.photos.indexOf(photo)),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          border: isSelected
              ? Border.all(
                  color: model.isDark ? Colors.white : Colors.black, width: 1.5)
              : null,
          borderRadius: BorderRadius.circular(6),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: CachedNetworkImage(
              imageUrl: photo.url,
              width: 55,
              memCacheWidth: 120,
              memCacheHeight: 120,
              fit: BoxFit.fill,
              placeholder: (_, __) => ShimmerEffect()),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final model = locator<PreferenceService>();
    FullImageViewModel vm = widget.viewModel;
    return Opacity(
      opacity: vm.bgOpacity,
      child: ParentView(
        backgroundColor: Colors.transparent,
        showLeading: true,
        showAppBar: false,
        body: GestureDetector(
          onVerticalDragUpdate: (d) {
            setState(() => vm.verticalDrag += d.delta.dy);
          },
          onVerticalDragEnd: (_) {
            vm.verticalDrag > 150 ? Navigator.pop(context) : vm.animateBack();
          },
          child: Stack(
            children: [
              Container(
                  color: model.isDark
                      ? Colors.black.withValues(alpha: vm.bgOpacity)
                      : Colors.white.withValues(alpha: vm.bgOpacity)),
              PageView.builder(
                controller: vm.pageController,
                itemCount: vm.photos.length,
                onPageChanged: (i) {
                  setState(() {
                    vm.initialIndex = i;
                    vm.rotation = 0;
                  });
                  vm.scaleControllers[i].scaleState =
                      PhotoViewScaleState.initial;

                  vm.prefetchImages(i);
                  vm.scrollThumb(i);
                },
                itemBuilder: (_, i) =>
                    buildFullImage(vm.photos[i], i, i == vm.initialIndex, vm),
              ),
              Positioned(
                top: MediaQuery.of(context).padding.top + 4,
                right: 16,
                child: Row(
                  children: [
                    IconButton(
                        icon: const Icon(Icons.download, color: Colors.white),
                        onPressed: () =>
                            vm.saveImage(vm.photos[vm.initialIndex].url)),
                    IconButton(
                        icon:
                            const Icon(Icons.rotate_right, color: Colors.white),
                        onPressed: () =>
                            setState(() => vm.rotation += 90 * 3.14159 / 180)),
                    FutureBuilder<bool>(
                      future: vm.prefService
                          .contains(vm.photos[vm.initialIndex].url),
                      builder: (_, snap) {
                        final isFav = snap.data ?? false;
                        return IconButton(
                          icon: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            color: isFav ? Colors.redAccent : Colors.white,
                          ),
                          onPressed: () async {
                            final url = vm.photos[vm.initialIndex].url;
                            isFav
                                ? await vm.prefService.remove(url)
                                : await vm.prefService.add(url);
                            setState(() {});
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 16,
                left: 0,
                right: 0,
                height: 60,
                child: ListView.builder(
                  controller: vm.thumbController,
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: vm.visibleThumbs.length,
                  itemBuilder: (_, i) {
                    final photo = vm.visibleThumbs[i];
                    return buildThumb(
                      photo,
                      vm.photos.indexOf(photo) == vm.initialIndex,
                      vm,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

part of video_list_view;

class _VideoListMobile extends ViewModelWidget<VideoListViewModel> {
  const _VideoListMobile();

  @override
  Widget build(BuildContext context, VideoListViewModel vm) {
    return ParentView(
      title: "🎞️ Video Memories",
      body: vm.isLoading && vm.visibleVideos.isEmpty
          ? VideoGrid(videos: List.generate(12, (_) => null), useShimmer: true)
          : RefreshIndicator(
              color: Colors.deepPurple,
              onRefresh: () async {
                vm.currentPage = 0;
                vm.visibleVideos.clear();
                vm.allLoaded = false;
                await vm.fetchVideos();
              },
              child: VideoGrid(
                controller: vm.scrollController,
                videos: vm.visibleVideos,
                isLoading: vm.isLoading,
                useVideoObject: true,
              ),
            ),
    );
  }
}

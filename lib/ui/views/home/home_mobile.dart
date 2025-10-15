part of home_view;

class _HomeMobile extends ViewModelWidget<HomeViewModel> {
  Future<void> toggleTheme(bool isDark) async {}

  @override
  Widget build(BuildContext context, HomeViewModel vm) {
    return ParentView(
      title: 'Moments Hub',
      showLeading: false,
      actions: [
        Switch(
          value: vm.model.isDark,
          onChanged: (value) {
            vm.model.toggleTheme(value);
            vm.model.notifyListeners();
            vm.notifyListeners();
          },
        ),
      ],
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AlbumThumbnailCard(
              title: "Dukhna",
              imageUrl: "${vm.imgUrl}dukhana/IMG_0838.JPG",
              onTap: () => vm.navigateTo("dukhna"),
            ),
            AlbumThumbnailCard(
              title: "Kanku Pagla",
              imageUrl: "${vm.imgUrl}kanku_pagla/IMG_0461.JPG",
              onTap: () => vm.navigateTo("kanku_pagla"),
            ),
            AlbumThumbnailCard(
              title: "Pre-Wedding Album",
              imageUrl: "${vm.imgUrl}pre_wedding_album_pic/album/album1.jpg",
              onTap: () => vm.navigateTo("pre_wedding_album"),
            ),
            AlbumThumbnailCard(
              title: "Pre-Wedding Days",
              imageUrl: "${vm.imgUrl}pre_wedding_album_pic/days/day2.jpg",
              onTap: () => vm.navigateTo("pre_wedding_days"),
            ),
            AlbumThumbnailCard(
              title: "Frame",
              imageUrl: "${vm.imgUrl}marriage_pic/frame_photo/frame1.jpg",
              onTap: () => vm.navigateTo("frame"),
              //total image : 2
            ),
            AlbumThumbnailCard(
              title: "Marriage Album",
              imageUrl: "${vm.imgUrl}marriage_pic/marriage_album/PAD1.jpg",
              onTap: () => vm.navigateTo("marriage_album"),
            ),
            AlbumThumbnailCard(
              title: "Couple Photo",
              imageUrl: "${vm.imgUrl}marriage_pic/couple_pic/126A0572.JPG",
              onTap: () => vm.navigateTo("couple_pic"),
            ),
            AlbumThumbnailCard(
              title: "Album Selection Photo",
              imageUrl:
                  "${vm.imgUrl}marriage_pic/album_selection/02/126A1741.JPG",
              onTap: () => vm.navigateTo("album_selection"),
            ),
            AlbumThumbnailCard(
              title: "Marriage  Photo",
              imageUrl: "${vm.imgUrl}marriage_pic/album/02/126A1741.JPG",
              onTap: () => vm.navigateTo("marriage_all_pic"),
              //total image : 799 + 1836 = 2635
            ),
            AlbumThumbnailCard(
              title: "Pre Wedding Photo",
              imageUrl: "${vm.imgUrl}pre_wedding_album_pic/all_pic/01.jpg",
              onTap: () => vm.navigateTo("pre_wedding_all_pic"),
              //total image : 415
            ),
            AlbumThumbnailCard(
              title: "Banner Photo",
              imageUrl: "${vm.imgUrl}marriage_pic/banner/126A4509.JPG",
              onTap: () => vm.navigateTo("banner"),
              //total image : 22
            ),
            AlbumThumbnailCard(
              title: "Video",
              imageUrl: "${vm.imgUrl}marriage_pic/banner/126A4509.JPG",
              onTap: () => vm.navigateToVideo('video'),
            ),
          ],
        ),
      ),
    );
  }
}

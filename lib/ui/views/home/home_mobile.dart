part of home_view;

class _HomeMobile extends StatelessWidget {
  final HomeViewModel viewModel;
  const _HomeMobile(this.viewModel);

  Future<void> toggleTheme(bool isDark) async {}

  @override
  Widget build(BuildContext context) {
    final model = locator<PreferenceService>();
    const imgUrl =
        "https://raw.githubusercontent.com/parthunagar/my_album/images/assets/images/";
    const jsonUrl =
        "https://raw.githubusercontent.com/parthunagar/my_album/images/assets/";

    navigateTo(String json) => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GalleryView(
              jsonUrl: "$jsonUrl$json.json",
            ),
          ),
        );
    navigateToVideo(String json) => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoListView(
              "$jsonUrl$json.json",
            ),
          ),
        );
    return ParentView(
      title: 'Home',
      showLeading: false,
      actions: [
        Switch(
          value: model.isDark,
          onChanged: (value) {
            model.toggleTheme(value);
            model.notifyListeners();
            viewModel.notifyListeners();
          },
        )
      ],
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AlbumThumbnailCard(
              title: "Pre-Wedding Album",
              imageUrl: "${imgUrl}pre_wedding_album_pic/album/album1.jpg",
              onTap: () => navigateTo("pre_wedding_album"),
            ),
            AlbumThumbnailCard(
              title: "Pre-Wedding Days",
              imageUrl: "${imgUrl}pre_wedding_album_pic/days/day2.jpg",
              onTap: () => navigateTo("pre_wedding_days"),
            ),
            AlbumThumbnailCard(
              title: "Frame",
              imageUrl: "${imgUrl}marriage_pic/frame_photo/frame1.jpg",
              onTap: () => navigateTo("frame"),
              //total image : 2
            ),
            AlbumThumbnailCard(
              title: "Marriage Album",
              imageUrl: "${imgUrl}marriage_pic/marriage_album/PAD1.jpg",
              onTap: () => navigateTo("marriage_album"),
            ),
            AlbumThumbnailCard(
              title: "Couple Photo",
              imageUrl: "${imgUrl}marriage_pic/couple_pic/126A0572.JPG",
              onTap: () => navigateTo("couple_pic"),
            ),
            AlbumThumbnailCard(
              title: "Album Selection Photo",
              imageUrl: "${imgUrl}marriage_pic/album_selection/02/126A1741.JPG",
              onTap: () => navigateTo("album_selection"),
            ),
            AlbumThumbnailCard(
              title: "Marriage  Photo",
              imageUrl: "${imgUrl}marriage_pic/album/02/126A1741.JPG",
              onTap: () => navigateTo("marriage_all_pic"),
              //total image : 799 + 1836 = 2635
            ),
            AlbumThumbnailCard(
              title: "Pre Wedding Photo",
              imageUrl: "${imgUrl}pre_wedding_album_pic/all_pic/01.jpg",
              onTap: () => navigateTo("pre_wedding_all_pic"),
              //total image : 415
            ),
            AlbumThumbnailCard(
              title: "Banner Photo",
              imageUrl: "${imgUrl}marriage_pic/banner/126A4509.JPG",
              onTap: () => navigateTo("banner"),
              //total image : 22
            ),
            AlbumThumbnailCard(
              title: "Video",
              imageUrl: "${imgUrl}marriage_pic/banner/126A4509.JPG",
              onTap: () => navigateToVideo('video'),
            ),
          ],
        ),
      ),
    );
  }
}

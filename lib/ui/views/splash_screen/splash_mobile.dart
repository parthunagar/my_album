part of splash_screen_view;

class _SplashScreenMobile extends StatefulWidget {
  final SplashScreenViewModel viewModel;
  const _SplashScreenMobile(this.viewModel);

  @override
  State<_SplashScreenMobile> createState() => _SplashScreenMobileState();
}

class _SplashScreenMobileState extends State<_SplashScreenMobile> {
  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Scaffold(
      body: FlameSplashScreen(
        controller: FlameSplashController(
          // waitDuration: const Duration(milliseconds: 1),
          fadeInDuration: const Duration(milliseconds: 1),
          fadeOutDuration: const Duration(milliseconds: 1),
        ),
        theme: FlameSplashTheme.dark,
        // showAfter: (context) {
        //   return Image.asset(
        //     "assets/images/pre_wedding_album_pic/album/album1.jpg",
        //     height: 220,
        //     width: 250,
        //   );
        // },
        // showBefore: (context) => const Padding(
        //   padding: EdgeInsets.only(bottom: 60.0),
        //   child: Text(
        //     "Capture your thoughts. Anytime, anywhere.",
        //     textAlign: TextAlign.center,
        //     style: TextStyle(
        //       color: Colors.lightBlue,
        //       fontSize: 16,
        //       fontStyle: FontStyle.italic,
        //     ),
        //   ),
        // ),
        showBefore: (context) => Container(
          width: w, //  SizeConfig.screenWidth,
          height: h, // SizeConfig.screenHeight,
          color: AppColor.gray01,
          child: Image(
            fit: BoxFit.cover,
            image: AssetImage(AppString.loginBackgroundImage),
          ),
        ),
        onFinish: (context) {
          // Navigator.of(context).pushReplacement(
          //   MaterialPageRoute(
          //     builder: (context) => const HomeView(),
          //   ),
          // );

          AutoRouter.of(context).replaceNamed('/home');
        },
      ),
    );
  }

  // Future<void> navigatePage() async {
  //   AutoRouter.of(context).replaceNamed('/home');
  // }
}

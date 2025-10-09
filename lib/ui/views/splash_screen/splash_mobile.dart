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
    return ParentView(
      title: '',
      body: FlameSplashScreen(
        controller: FlameSplashController(
          fadeInDuration: const Duration(milliseconds: 1),
          fadeOutDuration: const Duration(milliseconds: 1),
        ),
        theme: FlameSplashTheme.dark,
        showBefore: (context) => Container(
          width: w,
          height: h,
          color: Colors.white,
          child: Image(
            fit: BoxFit.cover,
            image: AssetImage(loginBackgroundImage),
          ),
        ),
        onFinish: (context) {
          AutoRouter.of(context).replaceNamed('/home');
        },
      ),
    );
  }
}

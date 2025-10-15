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
    return ParentView(
      body: const Text('Splash SCreen'),
    );
  }
}

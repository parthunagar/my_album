part of splash_screen_view;

class _SplashScreenDesktop extends StatelessWidget {
  final SplashScreenViewModel viewModel;
  const _SplashScreenDesktop(this.viewModel);
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('SplashScreenDesktop'),
      ),
    );
  }
}

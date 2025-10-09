part of splash_screen_view;

class _SplashScreenDesktop extends StatelessWidget {
  final SplashScreenViewModel viewModel;
  const _SplashScreenDesktop(this.viewModel);
  @override
  Widget build(BuildContext context) {
    return ParentView(
      title: 'SplashScreenDesktop',
      body: const SizedBox.shrink(),
    );
  }
}

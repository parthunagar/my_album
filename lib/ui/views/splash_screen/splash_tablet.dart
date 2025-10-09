part of splash_screen_view;

class _SplashScreenTablet extends StatelessWidget {
  final SplashScreenViewModel viewModel;
  const _SplashScreenTablet(this.viewModel);
  @override
  Widget build(BuildContext context) {
    return ParentView(
      title: 'SplashScreenTablet',
      body: const SizedBox.shrink(),
    );
  }
}

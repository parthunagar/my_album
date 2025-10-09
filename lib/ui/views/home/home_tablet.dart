part of home_view;

class _HomeTablet extends StatelessWidget {
  final HomeViewModel viewModel;
  const _HomeTablet(this.viewModel);
  @override
  Widget build(BuildContext context) {
    return ParentView(
      title: 'Tablet',
      body: const SizedBox.shrink(),
    );
  }
}

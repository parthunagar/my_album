part of home_view;

class _HomeDesktop extends StatelessWidget {
  final HomeViewModel viewModel;
  const _HomeDesktop(this.viewModel);
  @override
  Widget build(BuildContext context) {
    return ParentView(
      title: 'Desktop',
      body: const SizedBox.shrink(),
    );
  }
}

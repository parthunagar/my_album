part of home_view;

class _HomeTablet extends StatelessWidget {
  final HomeViewModel viewModel;
  const _HomeTablet(this.viewModel);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tablet'),
        backgroundColor: Colors.indigo,
      ),
      body: const Center(),
    );
  }
}

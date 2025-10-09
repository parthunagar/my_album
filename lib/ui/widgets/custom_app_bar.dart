import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ParentView extends StatelessWidget {
  final Widget body;
  String title;
  List<Widget>? actions;
  bool? showLeading;
  Widget? bottomNavigationBar;
  ParentView({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.showLeading,
    this.bottomNavigationBar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _CustomAppBar(
        title: title,
        actions: actions,
        showLeading: showLeading,
      ),
      bottomNavigationBar: bottomNavigationBar,
      body: body,
    );
  }
}

// ignore: must_be_immutable
class _CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double _preferredHeight = 56;
  List<Widget>? actions;
  final String title;
  bool? showLeading;
  _CustomAppBar({
    required this.title,
    this.actions,
    this.showLeading = true,
  });

  @override
  Widget build(BuildContext context) {
    final appBarActions = actions != null && actions!.isNotEmpty
        ? [
            ...actions!,
            const Padding(padding: EdgeInsets.only(right: 16)),
          ]
        : actions;
    return AppBar(
      elevation: 0,
      centerTitle: true,
      leadingWidth: 80,
      leading: showLeading == true
          ? IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios_rounded),
            )
          : const SizedBox.shrink(),
      title: Text(title),
      actions: appBarActions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(_preferredHeight);
}

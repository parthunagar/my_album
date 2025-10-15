import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monirth_memories/core/app.locator.dart';
import 'package:monirth_memories/core/services/favorites_service.dart';

// ignore: must_be_immutable
class ParentView extends StatelessWidget {
  final Widget body;
  String? title;
  List<Widget>? actions;
  bool? showLeading;
  Widget? bottomNavigationBar;
  Color? backgroundColor;
  bool showAppBar;
  ParentView({
    super.key,
    this.title,
    required this.body,
    this.actions,
    this.showLeading,
    this.bottomNavigationBar,
    this.backgroundColor,
    this.showAppBar = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: showAppBar
          ? _CustomAppBar(
              title: title ?? '',
              actions: actions,
              showLeading: showLeading,
            )
          : null,
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
    final model = locator<PreferenceService>();
    // print('title : $title');
    // IconData icon = title == "Moments Hub"
    //     ? FontAwesomeIcons.bookOpenReader
    //     : title == "SnapScape" //"Gallery Flow"
    //         ? FontAwesomeIcons.images
    //         : title == "HeartVault"
    //             ? FontAwesomeIcons.solidHeart
    //             : FontAwesomeIcons.clapperboard;
    final appBarActions = actions != null && actions!.isNotEmpty
        ? [
            ...actions!,
            const Padding(padding: EdgeInsets.only(right: 16)),
            // Switch(
            //   value: model.isDark,
            //   onChanged: (value) {
            //     model.toggleTheme(value);
            //     model.notifyListeners();
            //     // viewModel.notifyListeners();
            //   },
            // ),
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
      title: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // if (title.isNotEmpty)
          //   Padding(
          //     padding: const EdgeInsets.only(right: 8),
          //     child: FaIcon(icon, size: 22),
          //   ),

          DefaultTextStyle(
            style: GoogleFonts.dancingScript(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: model.isDark ? Colors.white : Colors.black,
            ),
            textAlign: TextAlign.center,
            child: AnimatedTextKit(
              pause: const Duration(milliseconds: 2000),
              repeatForever: true,
              totalRepeatCount: 5,
              animatedTexts: [TyperAnimatedText(title)],
            ),
          ),
        ],
      ),
      actions: appBarActions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(_preferredHeight);
}

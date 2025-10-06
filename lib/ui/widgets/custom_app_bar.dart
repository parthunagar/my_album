import 'package:monirth_memories/utils/colors_utils.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double _preferredHeight = 56;
  final void Function()? onTap;
  List<Widget>? actions;
  final String title;
  String? buttonTitle;
  PreferredSizeWidget? bottom;
  bool? showLeading;
  CustomAppBar({
    super.key,
    this.buttonTitle,
    required this.title,
    this.onTap,
    this.actions,
    this.bottom,
    this.showLeading = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primary,
      elevation: 0,
      centerTitle: true,
      // automaticallyImplyLeading: true,
      leadingWidth: 80,
      // leading: Conditional.ifelse(
      //   showLeading == false,
      //   valid: SizedBox(),
      //   invalid: Padding(
      //     padding: EdgeInsets.only(left: 16),
      //     child: InkWell(
      //       onTap: onTap,
      //       child: Row(
      //         children: [
      //           SvgPicture.asset(AngloIcon.backIcon),
      //           const SizedBox(width: 5),
      //           Text('Back'),
      //         ],
      //       ),
      //     ),
      //   ),
      // ),
      bottom: bottom,
      title: Text(
        title,
        style: Theme.of(context).textTheme.labelMedium!.copyWith(
              color: AppColors.secondary,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
      ),
      actions: actions ?? [],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(_preferredHeight);
}

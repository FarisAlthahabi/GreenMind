import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:green_mind/global/gen/assets.gen.dart';
import 'package:green_mind/global/utils/constants.dart';

class MainAppBar extends StatefulWidget implements PreferredSizeWidget {
  const MainAppBar({
    super.key,
    this.actions,
    this.title = "green_mind",
    this.centerTitle = true,
    this.bottom,
    this.automaticallyImplyLeading = true,
    // this.bgColor = AppColors.white,
  });

  final List<Widget>? actions;
  final String title;
  final bool centerTitle;
  final PreferredSizeWidget? bottom;
  final bool automaticallyImplyLeading;
  // final Color bgColor;

  @override
  State<MainAppBar> createState() => _MainAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(60);
}

class _MainAppBarState extends State<MainAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: widget.automaticallyImplyLeading,
      // backgroundColor: widget.bgColor,
      // surfaceTintColor: widget.bgColor,
      // shadowColor: AppColors.black,
      // titleTextStyle: const TextStyle(fontSize: 20, color: AppColors.black),
      centerTitle: widget.centerTitle,
      elevation: 8,
      bottom: widget.bottom,
      title: Text(
        widget.title.tr(),
        style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
      ),
      flexibleSpace: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: AppConstants.padding8,
              child: Assets.images.png.greenMindPng.image(),
            ),
            const SizedBox(width: 10),
          ],
        ),
      ),
      actions: const [SizedBox(width: 24)],
    );
  }
}

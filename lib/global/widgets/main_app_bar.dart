import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:green_mind/global/theme/theme_x.dart';
import 'package:green_mind/global/utils/constants.dart';
import 'package:green_mind/global/utils/utils.dart';

class MainAppBar extends StatefulWidget implements PreferredSizeWidget {
  const MainAppBar({
    super.key,
    this.actions,
    this.title = "green_mind",
    this.centerTitle = true,
    this.bottom,
    this.automaticallyImplyLeading = true,
  });

  final List<Widget>? actions;
  final String title;
  final bool centerTitle;
  final PreferredSizeWidget? bottom;
  final bool automaticallyImplyLeading;

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
      centerTitle: widget.centerTitle,
      elevation: 8,
      bottom: widget.bottom,
      title: Text(
        widget.title.tr(),
        style: context.tt.headlineSmall?.copyWith(fontWeight: .bold),
      ),
      actions: [
        SizedBox(width: 24),
        Padding(
          padding: AppConstants.padding14,
          child: Utils.appImage(context).image(),
        ),
      ],
    );
  }
}

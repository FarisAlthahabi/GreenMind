import 'package:flutter/material.dart';

class MainFab extends StatelessWidget {
  const MainFab({super.key, required this.onTap, this.icon = Icons.add});
  final void Function() onTap;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onTap,
      shape: CircleBorder(),
      child: Icon(icon),
    );
  }
}

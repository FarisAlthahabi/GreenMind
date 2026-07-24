import 'package:flutter/material.dart';

class MainFab extends StatelessWidget {
  const MainFab({super.key, required this.onTap});
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onTap,
      shape: CircleBorder(),
      child: Icon(Icons.add),
    );
  }
}

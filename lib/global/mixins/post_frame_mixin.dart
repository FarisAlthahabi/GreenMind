import 'package:flutter/widgets.dart';

mixin PostFrameMixin<T extends StatefulWidget> on State<T> {
  void onPostFrame();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => onPostFrame());
  }
}

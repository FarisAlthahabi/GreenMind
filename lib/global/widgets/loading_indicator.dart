import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    super.key,
    this.color,
    this.width,
    this.height,
    this.size = 40,
    this.isInBtn = false,
  });

  final Color? color;
  final double? width;
  final double? height;
  final double size;
  final bool isInBtn;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      child: SpinKitFadingCircle(size: isInBtn ? 20 : size),
    );
  }
}

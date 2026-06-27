import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:green_mind/global/utils/app_colors.dart';

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
    Color staticColor = isInBtn ? AppColors.white : AppColors.black;
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      child: SpinKitFadingCircle(
        size: isInBtn ? 20 : size,
        color: color ?? staticColor,
      ),
    );
  }
}

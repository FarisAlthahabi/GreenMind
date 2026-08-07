import 'package:flutter/material.dart';
import 'package:green_mind/global/theme/theme_x.dart';
import 'package:green_mind/global/utils/constants.dart';

class MainTile extends StatelessWidget {
  const MainTile({
    super.key,
    required this.child,
    this.height,
    this.width,
    this.padding = AppConstants.padding16,
    this.boxShadow,
  });
  final Widget child;
  final EdgeInsets padding;
  final double? width;
  final double? height;
  final List<BoxShadow>? boxShadow;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: context.cs.surface,
        borderRadius: AppConstants.borderRadius20,
        border: .all(width: 0.2, color: context.cs.onSurface),
        boxShadow:
            boxShadow ??
            [
              BoxShadow(
                offset: const Offset(0, 4),
                blurRadius: 4,
                color: context.cs.surfaceContainerLow,
              ),
            ],
      ),
      child: child,
    );
  }
}

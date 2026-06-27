import 'package:flutter/material.dart';
import 'package:green_mind/global/theme/theme_x.dart';
import 'package:shimmer/shimmer.dart';

class ImagePlaceHolderWidget extends StatelessWidget {
  const ImagePlaceHolderWidget({
    super.key,
    this.height,
    this.radius = 12,
    this.baseColor,
    this.highlightColor,
  });

  final double? height;
  final double radius;
  final Color? baseColor;
  final Color? highlightColor;

  @override
  Widget build(BuildContext context) {
    final base = baseColor ?? context.cs.surfaceContainerHighest;
    final highlight = highlightColor ?? context.cs.surface;
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Shimmer.fromColors(
        baseColor: base,
        highlightColor: highlight,
        child: Container(height: height, color: base),
      ),
    );
  }
}

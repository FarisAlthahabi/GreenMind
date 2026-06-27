import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:green_mind/global/theme/theme_x.dart';
import 'package:green_mind/global/utils/constants.dart';
import 'package:green_mind/global/widgets/image_place_holder_widget.dart';

class AppImageWidget extends StatelessWidget {
  const AppImageWidget({
    super.key,
    this.url,
    this.borderRadius = BorderRadius.zero,
    this.fit,
    this.width,
    this.height,
    this.border,
    this.shadows,
    this.errorWidget,
    this.onImageLoaded,
    this.backgroundColor,
    this.padding = AppConstants.padding0,
    this.errorText = "Failed to load image",
  });

  final String? url;
  final BorderRadiusGeometry borderRadius;
  final BoxFit? fit;
  final double? width;
  final double? height;
  final Border? border;
  final List<BoxShadow>? shadows;
  final EdgeInsets padding;
  final Color? backgroundColor;
  final Widget? errorWidget;
  final void Function(ImageProvider)? onImageLoaded;
  final String errorText;

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? context.cs.surface;
    final Widget defaultErrorWidget =
        errorWidget ??
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.broken_image,
              color: context.cs.onSurfaceVariant,
              size: 40,
            ),
            const SizedBox(height: 8),
            Text(
              errorText,
              style: context.tt.bodyMedium?.copyWith(
                color: context.cs.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        );

    Widget child = defaultErrorWidget;
    if (url != null) {
      child = CachedNetworkImage(
        imageBuilder: (context, imageProvider) {
          if (onImageLoaded != null) {
            onImageLoaded!(imageProvider);
          }
          return Image(image: imageProvider, fit: fit);
        },
        imageUrl: url!,
        fit: fit,
        errorWidget: (context, url, error) {
          return defaultErrorWidget;
        },
        placeholder: (context, url) =>
            ImagePlaceHolderWidget(height: height, radius: 0),
      );
    }

    return Container(
      padding: padding,
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: borderRadius,
        border: border,
        boxShadow: [...?shadows],
      ),
      child: ClipRRect(borderRadius: borderRadius, child: child),
    );
  }
}

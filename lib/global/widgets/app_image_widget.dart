import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
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
    this.padding = AppConstants.padding0,
  });

  final String? url;
  final BorderRadiusGeometry borderRadius;
  final BoxFit? fit;
  final double? width;
  final double? height;
  final Border? border;
  final List<BoxShadow>? shadows;
  final EdgeInsets padding;
  final Widget? errorWidget;
  final void Function(ImageProvider)? onImageLoaded;

  @override
  Widget build(BuildContext context) {
    final Widget errorWidget =
        this.errorWidget ??
        const Center(
          child: Text(
            "Failed to load image",
            style: TextStyle(color: Colors.black, fontSize: 20),
            textAlign: TextAlign.center,
          ),
        );
    return Container(
      padding: padding,
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        border: border,
        boxShadow: [...?shadows],
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: url != null
            ? CachedNetworkImage(
                imageBuilder: (context, imageProvider) {
                  if (onImageLoaded != null) {
                    onImageLoaded!(imageProvider);
                  }
                  return Image(image: imageProvider, fit: fit);
                },
                imageUrl: url!,
                fit: fit,
                errorWidget: (context, url, error) {
                  return errorWidget;
                },
                placeholder: (context, url) => const ImagePlaceHolderWidget(),
              )
            : errorWidget,
      ),
    );
  }
}

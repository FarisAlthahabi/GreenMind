import 'package:flutter/material.dart';
import 'package:green_mind/global/gen/assets.gen.dart';
import 'package:green_mind/global/theme/theme_x.dart';
import 'package:green_mind/global/utils/constants.dart';
import 'package:green_mind/global/widgets/app_image_widget.dart';

abstract class MainDialogs {
  static void showImageFullScreen(BuildContext context, String? image) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: AppConstants.padding0,
        backgroundColor: Colors.transparent,
        child: Stack(
          children: [
            Positioned.fill(
              child: AppImageWidget(
                url: image,
                fit: .fitWidth,
                bgColor: context.cs.surface,
                errorWidget: Assets.images.svg.greenMindSvg.svg(),
              ),
            ),
            Positioned(
              top: 20,
              right: 20,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close, size: 35),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:green_mind/global/blocs/upload_image_cubit/cubit/upload_image_cubit.dart';
import 'package:green_mind/global/di/di.dart';
import 'package:green_mind/global/theme/theme_x.dart';
import 'package:green_mind/global/utils/constants.dart';
import 'package:green_mind/global/widgets/main_snack_bar.dart';
// import 'package:image_picker/image_picker.dart';

class ChooseImageWidget extends StatelessWidget {
  const ChooseImageWidget({
    super.key,
    // required this.onSetImage,
    this.initialImage,
  });
  // final void Function(XFile? image) onSetImage;
  final String? initialImage;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => get<UploadImageCubit>(),
      child: BlocConsumer<UploadImageCubit, UploadImageState>(
        listener: (context, state) {
          if (state is UploadImageSuccess) {
            // onSetImage(state.image);
          } else if (state is UploadImageFail) {
            MainSnackBar.showErrorMessage(context, state.message);
            // onSetImage(null);
          }
        },
        builder: (context, state) {
          String? imagePath;
          if (state is UploadImageSuccess) {
            // imagePath = state.image.path;
          }
          return Column(
            spacing: 30,
            children: [
              InkWell(
                onTap: () => onTap(context),
                child: DottedBorder(
                  options: RoundedRectDottedBorderOptions(
                    radius: Radius.circular(20),
                    // TODO fix this color
                    color: context.cs.primary,
                    strokeWidth: 2,
                    dashPattern: [6, 4],
                    padding: AppConstants.padding1,
                  ),
                  child: Container(
                    padding: AppConstants.padding20,
                    child: Column(
                      crossAxisAlignment: .stretch,
                      spacing: 10,
                      children: [
                        // TODO fix color
                        Icon(
                          Icons.cloud_upload,
                          size: 50,
                          color: context.cs.onSurface,
                        ),
                        Text(
                          "press_to_upload_image".tr(),
                          textAlign: TextAlign.center,
                          style: context.tt.titleLarge,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              ?_buildImageChosen(imagePath, initialImage),
            ],
          );
        },
      ),
    );
  }

  void onTap(BuildContext context) {
    // final cubit = context.read<UploadImageCubit>();
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: AppConstants.padding16,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'choose_image_source'.tr(),
                      style: context.tt.titleLarge,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextButton(
                        onPressed: () {},
                        // onPressed: () => cubit.uploadImage(ImageSource.gallery),
                        style: const ButtonStyle(
                          alignment: AlignmentDirectional.centerStart,
                        ),
                        child: Text('gallery'..tr(),style: context.tt.bodyMedium),
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () {},
                        // onPressed: () => cubit.uploadImage(ImageSource.camera),
                        style: const ButtonStyle(
                          alignment: AlignmentDirectional.centerStart,
                        ),
                        child: Text('camera'..tr() , style: context.tt.bodyMedium),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget? _buildImageChosen(String? imagePath, String? initialImage) {
    final image = imagePath ?? initialImage;
    if (image == null)return null;
    return ClipRRect(
      borderRadius: AppConstants.borderRadius20,
      child: Image.file(File(image), fit: BoxFit.cover),
    );
  }
}

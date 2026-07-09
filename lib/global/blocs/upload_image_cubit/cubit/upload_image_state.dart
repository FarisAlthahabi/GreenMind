part of 'upload_image_cubit.dart';

@immutable
sealed class UploadImageState{}

final class UploadImageInitial extends UploadImageState {}

final class UploadImageSuccess extends UploadImageState {
  UploadImageSuccess({
    required this.image,
    });

    final XFile image;
}

final class UploadImageFail extends UploadImageState {
  UploadImageFail(this.error);

  final String error;
}


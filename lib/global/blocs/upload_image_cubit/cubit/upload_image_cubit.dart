import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

part 'upload_image_state.dart';

@injectable
class UploadImageCubit extends Cubit<UploadImageState> {
  UploadImageCubit() : super(UploadImageInitial());

  Future<void> uploadImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final image = await picker.pickImage(source: source);

      if (image != null) {
        emit(UploadImageSuccess(image: image));
      } else {
        emit(UploadImageFail('no_image_chosen'.tr()));
      }
    } catch (e) {
      emit(UploadImageFail('no_image_chosen'.tr()));
    }
  }
}

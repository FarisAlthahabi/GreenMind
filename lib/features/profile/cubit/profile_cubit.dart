import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:green_mind/features/auth/model/user_model/user_model.dart';
import 'package:green_mind/features/profile/model/change_password_model/change_password_model.dart';
import 'package:green_mind/features/profile/service/profile_service.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

part 'states/general_profile_state.dart';
part 'states/profile_state.dart';
part 'states/change_password_state.dart';

@injectable
class ProfileCubit extends Cubit<GeneralProfileState> {
  ProfileCubit({required this.profileService}) : super(GeneralProfileInitial());
  final ProfileService profileService;

  UserModel? user;
  ChangePasswordModel changePasswordModel = ChangePasswordModel();

  void setCurrentPassword(String? password) {
    changePasswordModel = changePasswordModel.copyWith(
      currentPassword: () => password,
    );
  }

  void setNewPassword(String? password) {
    changePasswordModel = changePasswordModel.copyWith(
      newPassword: () => password,
    );
  }

  void clearPasswordModel() {
    changePasswordModel = ChangePasswordModel();
  }

  Future<void> getProfile() async {
    emit(ProfileLoading());
    if (isClosed) return;
    try {
      final user = await profileService.getProfile();
      this.user = user;
      if (isClosed) return;
      emit(ProfileSuccess(user));
    } catch (e) {
      if (isClosed) return;
      emit(ProfileFail(e.toString()));
    }
  }

  Future<void> changePassword() async {
    emit(ChangePasswordLoading());
    if (isClosed) return;
    try {
      await profileService.changePassword(changePasswordModel);
      if (isClosed) return;
      emit(ChangePasswordSuccess("password_changed_successfully".tr()));
      clearPasswordModel();
    } catch (e) {
      if (isClosed) return;
      emit(ChangePasswordFail(e.toString()));
    }
  }

  // Helper method to refresh profile after password change
  Future<void> refreshProfile() async {
    await getProfile();
  }
}
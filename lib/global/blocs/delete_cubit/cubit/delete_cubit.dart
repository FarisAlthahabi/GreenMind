import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:green_mind/global/services/delete_service/delete_service.dart';
import 'package:green_mind/global/widgets/insure_delete_widget.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

part 'delete_state.dart';

@injectable
class DeleteCubit extends Cubit<DeleteState> {
  DeleteCubit(this.deleteService) : super(DeleteInitial());
  final DeleteService deleteService;

  Future<void> deleteItem<T extends DeleteModel>(T item) async {
    emit(DeleteLoading());
    try {
      await deleteService.deleteItem(item);
      emit(DeleteSuccess("item_delete_success".tr()));
    } catch (e) {
      emit(DeleteFail(e.toString()));
    }
  }
}

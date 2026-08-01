part of 'delete_service.dart';

@Injectable(as: DeleteService)
class DeleteServiceImp implements DeleteService {
  final dio = DioClient();

  @override
  Future<void> deleteItem<T extends DeleteModel>(T item) async {
    try {
      await dio.delete(item.apiDeleteUrl);
    } catch (e, stackTrace) {
      if (kDebugMode) print("stackTrace of deleteItem is : $stackTrace");
      rethrow;
    }
  }
}

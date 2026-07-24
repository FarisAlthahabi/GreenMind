import 'package:flutter/foundation.dart';
import 'package:green_mind/global/dio/dio_client.dart';
import 'package:green_mind/global/widgets/insure_delete_widget.dart';
import 'package:injectable/injectable.dart';

part 'delete_service_imp.dart';

abstract class DeleteService {
  Future<void> deleteItem<T extends DeleteModel>(T item);
}

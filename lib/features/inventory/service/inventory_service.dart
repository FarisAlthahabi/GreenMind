// inventory_service.dart
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:green_mind/features/inventory/model/dispatch_inventory_model/dispatch_inventory_model.dart';
import 'package:green_mind/features/inventory/model/inventory_model/inventory_model.dart';
import 'package:green_mind/global/blocs/internet_connection/cubit/internet_connection_cubit.dart';
import 'package:green_mind/global/di/di.dart';
import 'package:green_mind/global/models/paginated_model/paginated_model.dart';
import 'package:injectable/injectable.dart';
import 'package:green_mind/global/dio/dio_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'inventory_service_imp.dart';

abstract class InventoryService {
  Future<PaginatedModel<InventoryModel>> getInventories({
    int page = 1,
    String? search,
  });
  Future<InventoryModel> dispatchInventory(
    int id,
    DispatchInventoryModel model,
  );
}

part of '../inventory_cubit.dart';

@immutable
class InventoriesState extends GeneralInventoryState {}

final class InventoriesLoading extends InventoriesState {}

final class InventoriesSuccess extends InventoriesState {
  final List<InventoryModel> inventories;
  final int currentPage;
  final bool hasReachedMax;

  InventoriesSuccess(
    this.inventories, {
    this.hasReachedMax = false,
    required this.currentPage,
  });
}

final class InventoriesEmpty extends InventoriesState {
  final String message;

  InventoriesEmpty(this.message);
}

final class InventoriesFail extends InventoriesState {
  final String error;

  InventoriesFail(this.error);
}
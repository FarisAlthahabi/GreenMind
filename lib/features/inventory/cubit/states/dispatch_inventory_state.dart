part of '../inventory_cubit.dart';

@immutable
class DispatchInventoryState extends GeneralInventoryState {}

final class DispatchInventoryInitial extends DispatchInventoryState {}

final class DispatchInventoryLoading extends DispatchInventoryState {}

final class DispatchInventorySuccess extends DispatchInventoryState {
  final String message;
  final InventoryModel plant;

  DispatchInventorySuccess(this.message, this.plant);
}

final class DispatchInventoryFail extends DispatchInventoryState {
  final String error;

  DispatchInventoryFail(this.error);
}

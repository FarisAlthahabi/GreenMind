part of '../inventory_activity_cubit.dart';

@immutable
class ActivitiesState extends GeneralInventoryActivityState {}

final class ActivitiesLoading extends ActivitiesState {}

final class ActivitiesSuccess extends ActivitiesState {
  final List<InventoryActivityModel> activities;
  final int currentPage;
  final bool hasReachedMax;

  ActivitiesSuccess(
    this.activities, {
    this.hasReachedMax = false,
    required this.currentPage,
  });
}

final class ActivitiesEmpty extends ActivitiesState {
  final String message;

  ActivitiesEmpty(this.message);
}

final class ActivitiesFail extends ActivitiesState {
  final String error;

  ActivitiesFail(this.error);
}
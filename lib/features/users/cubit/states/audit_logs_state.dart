part of '../users_cubit.dart';

@immutable
class AuditLogsState extends GeneralUsersState {}

final class AuditLogsInitial extends AuditLogsState {}

final class AuditLogsLoading extends AuditLogsState {}

final class AuditLogsSuccess extends AuditLogsState {
  final List<AuditLogModel> auditLogs;
  final int currentPage;
  final bool hasReachedMax;

  AuditLogsSuccess(
    this.auditLogs, {
    this.hasReachedMax = false,
    required this.currentPage,
  });
}

final class AuditLogsEmpty extends AuditLogsState {
  final String message;

  AuditLogsEmpty(this.message);
}

final class AuditLogsFail extends AuditLogsState {
  final String error;

  AuditLogsFail(this.error);
}

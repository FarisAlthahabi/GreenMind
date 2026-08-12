import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:green_mind/features/users/cubit/users_cubit.dart';
import 'package:green_mind/features/users/model/audit_log_model/audit_log_model.dart';
import 'package:green_mind/global/di/di.dart';
import 'package:green_mind/global/theme/theme_x.dart';
import 'package:green_mind/global/utils/constants.dart';
import 'package:green_mind/global/widgets/loading_indicator.dart';
import 'package:green_mind/global/widgets/main_app_bar.dart';
import 'package:green_mind/global/widgets/main_error_widget.dart';
import 'package:green_mind/global/widgets/main_text_field.dart';

@RoutePage()
class AuditLogsView extends StatelessWidget {
  const AuditLogsView({super.key, required this.userId});
  final int userId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => get<UsersCubit>()..getAuditLogs(userId, reset: true),
      child: AuditLogsPage(userId: userId),
    );
  }
}

class AuditLogsPage extends StatefulWidget {
  const AuditLogsPage({super.key, required this.userId});
  final int userId;

  @override
  State<AuditLogsPage> createState() => _AuditLogsPageState();
}

class _AuditLogsPageState extends State<AuditLogsPage> {
  late final UsersCubit usersCubit = context.read();

  void fetchAuditLogs({bool isRefresh = false}) =>
      usersCubit.getAuditLogs(widget.userId, reset: isRefresh);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(title: "audit_logs"),
      body: Padding(
        padding: AppConstants.padding16,
        child: Column(
          children: [
            MainTextField(
              hintText: "search",
              prefixIcon: Icon(Icons.search),
              onChanged: (value) =>
                  usersCubit.setSearchAuditQuery(value, widget.userId),
            ),
            Expanded(
              child: BlocBuilder<UsersCubit, GeneralUsersState>(
                buildWhen: (_, current) => current is AuditLogsState,
                builder: (context, state) {
                  if (state is AuditLogsLoading &&
                      usersCubit.auditLogs.isEmpty) {
                    return const Align(child: LoadingIndicator());
                  } else if (state is AuditLogsSuccess) {
                    final logs = state.auditLogs;
                    final hasReachedMax = state.hasReachedMax;
                    final currentPage = state.currentPage;

                    return NotificationListener(
                      onNotification: (scrollInfo) {
                        if (scrollInfo is ScrollUpdateNotification) {
                          final maxScroll = scrollInfo.metrics.maxScrollExtent;
                          final currentScroll = scrollInfo.metrics.pixels;

                          if (maxScroll > 0 &&
                              currentScroll >= maxScroll - 200 &&
                              !usersCubit.isLoadingMore &&
                              !hasReachedMax) {
                            usersCubit.loadMoreAuditLogs(widget.userId);
                          }
                        }
                        return true;
                      },
                      child: RefreshIndicator(
                        onRefresh: () async => fetchAuditLogs(isRefresh: true),
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            spacing: 16,
                            children: AnimationConfiguration.toStaggeredList(
                              duration: AppConstants.duration500ms,
                              childAnimationBuilder: (widget) => SlideAnimation(
                                horizontalOffset: 50.0,
                                child: FadeInAnimation(child: widget),
                              ),
                              children: [
                                ...logs.map(_buildAuditLogTile),
                                if (!hasReachedMax && logs.isNotEmpty) ...[
                                  const Padding(
                                    padding: AppConstants.paddingV8,
                                    child: LoadingIndicator(size: 30),
                                  ),
                                ] else if (hasReachedMax &&
                                    logs.isNotEmpty &&
                                    currentPage != 1) ...[
                                  MainErrorWidget(error: 'no_more_data'.tr()),
                                ],
                                const SizedBox(height: 35),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  } else if (state is AuditLogsEmpty) {
                    return MainErrorWidget(
                      error: state.message,
                      isRefresh: true,
                      onTryAgainTap: () => fetchAuditLogs(isRefresh: true),
                    );
                  } else if (state is AuditLogsFail) {
                    return MainErrorWidget(
                      error: state.error,
                      onTryAgainTap: () => fetchAuditLogs(isRefresh: true),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAuditLogTile(AuditLogModel log) {
    final isUpdate = log.description.toLowerCase().contains('update');
    final isDelete = log.description.toLowerCase().contains('delete');
    final isCreate = log.description.toLowerCase().contains('create');

    Color getStatusColor() {
      if (isDelete) return Colors.red;
      if (isCreate) return Colors.green;
      if (isUpdate) return Colors.orange;
      return Colors.grey;
    }

    String getStatusText() {
      if (isDelete) return 'deleted'.tr();
      if (isCreate) return 'created'.tr();
      if (isUpdate) return 'updated'.tr();
      return log.description.tr();
    }

    return Container(
      padding: AppConstants.padding16,
      decoration: BoxDecoration(
        color: context.cs.surface,
        borderRadius: AppConstants.borderRadius20,
        border: .all(width: 0.2, color: context.cs.onSurface),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 4),
            blurRadius: 4,
            color: context.cs.surfaceContainerLow,
          ),
        ],
      ),
      child: Column(
        spacing: 10,
        crossAxisAlignment: .start,
        children: [
          Row(
            spacing: 10,
            children: [
              Expanded(
                child: Text(
                  '${"entity".tr()}: ${log.entityType.tr()}',
                  style: context.tt.titleLarge?.copyWith(fontWeight: .bold),
                ),
              ),
              Container(
                padding: AppConstants.paddingH12V4,
                decoration: BoxDecoration(
                  borderRadius: AppConstants.borderRadius20,
                  color: getStatusColor().withOpacity(0.1),
                  border: .all(color: getStatusColor().withOpacity(0.3)),
                ),
                child: Text(
                  getStatusText(),
                  style: context.tt.labelMedium?.copyWith(
                    color: getStatusColor(),
                    fontWeight: .w600,
                  ),
                ),
              ),
            ],
          ),
          if (log.oldValues.isNotEmpty || log.newValues.isNotEmpty) ...[
            const Divider(height: 0),
            Column(
              crossAxisAlignment: .start,
              spacing: 8,
              children: [
                if (log.oldValues.isNotEmpty)
                  _buildValueTile('old_values'.tr(), log.oldValues, context),
                if (log.newValues.isNotEmpty)
                  _buildValueTile('new_values'.tr(), log.newValues, context),
              ],
            ),
          ],
          Row(
            crossAxisAlignment: .start,
            children: [
              Icon(Icons.person, size: 16, color: context.cs.onSurfaceVariant),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${"by".tr()}: ${log.causer.name} (${log.causer.role.displayName})',
                  style: context.tt.bodyMedium?.copyWith(
                    color: context.cs.onSurfaceVariant,
                  ),
                ),
              ),
              Text(
                log.createdAt,
                style: context.tt.bodySmall?.copyWith(
                  color: context.cs.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildValueTile(
    String title,
    Map<String, dynamic> values,
    BuildContext context,
  ) {
    return Column(
      crossAxisAlignment: .start,
      spacing: 4,
      children: [
        Text(
          title,
          style: context.tt.labelMedium?.copyWith(
            fontWeight: .w600,
            color: context.cs.onSurfaceVariant,
          ),
        ),
        ...values.entries.map(
          (entry) => Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Row(
              crossAxisAlignment: .start,
              children: [
                Text(
                  '${entry.key}: ',
                  style: context.tt.bodyMedium?.copyWith(fontWeight: .w500),
                ),
                Expanded(
                  child: Text(
                    entry.value?.toString() ?? '---',
                    style: context.tt.bodyMedium?.copyWith(
                      color: context.cs.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

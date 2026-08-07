import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:green_mind/features/diagnosing_diseases/model/diagnose_model/diagnose_model.dart';
import 'package:green_mind/features/irrigation_schedule/model/irrigation_schedule_model/irrigation_schedule_model.dart';
import 'package:green_mind/features/stats/cubit/stats_cubit.dart';
import 'package:green_mind/features/stats/model/diagnose_count_model/diagnose_count_model.dart';
import 'package:green_mind/features/stats/model/kpis_model/kpis_model.dart';
import 'package:green_mind/global/di/di.dart';
import 'package:green_mind/global/extensions/string_x.dart';
import 'package:green_mind/global/theme/theme_x.dart';
import 'package:green_mind/global/utils/constants.dart';
import 'package:green_mind/global/widgets/loading_indicator.dart';
import 'package:green_mind/global/widgets/main_app_bar.dart';
import 'package:green_mind/global/widgets/main_drawer.dart';
import 'package:green_mind/global/widgets/main_error_widget.dart';
import 'package:green_mind/global/widgets/main_tile.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class IconTitleValueColor {
  final String text;
  final String value;
  final IconData icon;
  final Color color;

  const IconTitleValueColor(this.text, this.value, this.icon, this.color);
}

class ChartModel {
  final String text;
  final double percentage;
  final Color color;

  const ChartModel(this.text, this.percentage, this.color);
}

@RoutePage()
class StatsView extends StatelessWidget {
  const StatsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => get<StatsCubit>(),
      child: const StatsPage(),
    );
  }
}

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  late final StatsCubit statsCubit;
  final columnCount = 2;

  final List<Color> diseaseColorPalette = [
    Colors.blue.shade400,
    Colors.red.shade400,
    Colors.green.shade400,
    Colors.orange.shade400,
    Colors.purple.shade400,
    Colors.cyan.shade400,
    Colors.pink.shade400,
    Colors.teal.shade400,
    Colors.amber.shade400,
    Colors.indigo.shade400,
    Colors.lime.shade400,
    Colors.deepOrange.shade400,
    Colors.brown.shade400,
    Colors.grey.shade600,
    Colors.deepPurple.shade400,
  ];

  @override
  void initState() {
    statsCubit = context.read();
    statsCubit.getStats();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppBar(title: "stats"),
      drawer: const MainDrawer(),
      body: BlocBuilder<StatsCubit, StatsState>(
        builder: (context, state) {
          if (state is StatsLoading) {
            return const LoadingIndicator();
          } else if (state is StatsSuccess) {
            final stats = state.stats;
            final kpis = stats.kpis;
            final confidenceRanges = stats.confidenceRanges;
            final confidenceRangesColumns = [
              ChartModel(
                "less_than_40",
                confidenceRanges.lessThan40.toDouble(),
                Colors.red.shade400, // Low confidence - Red
              ),
              ChartModel(
                "from_40_to_59",
                confidenceRanges.from40To59.toDouble(),
                Colors.orange.shade400, // Below average - Orange
              ),
              ChartModel(
                "from_60_to_79",
                confidenceRanges.from60To79.toDouble(),
                Colors.amber.shade400, // Average - Amber/Yellow
              ),
              ChartModel(
                "from_80_to_89",
                confidenceRanges.from80To89.toDouble(),
                Colors.green.shade400, // Good - Light Green
              ),
              ChartModel(
                "from_90_to_100",
                confidenceRanges.from90To100.toDouble(),
                Colors.teal.shade400, // Excellent - Teal/Green
              ),
            ];

            final diseasesAppearance = stats.diseaseDistribution
                .asMap()
                .map(
                  (index, e) => MapEntry(
                    index,
                    ChartModel(
                      e.name,
                      e.count.toDouble(),
                      diseaseColorPalette[index % diseaseColorPalette.length],
                    ),
                  ),
                )
                .values
                .toList();
            return RefreshIndicator(
              onRefresh: () async => statsCubit.getStats(),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: AppConstants.padding16,
                child: Column(
                  spacing: 20,
                  crossAxisAlignment: .start,
                  children: [
                    // _buildExportPdfBtn(),
                    _buildStatsTiles(kpis),
                    DiseasesDistributionPieChartWidget(
                      diseases: diseasesAppearance,
                    ),
                    TrustPercentageDistributionBarChartWidget(
                      trustPercentags: confidenceRangesColumns,
                    ),
                    WeaklyDiagnosis(diagnosis: stats.weeklyDiagnoses),
                    LastDiagnosisCard(diagnosis: stats.recentDiagnoses),
                    IncommingIrrigation(irrigations: stats.upcomingSchedules),
                  ],
                ),
              ),
            );
          } else if (state is StatsFail) {
            return MainErrorWidget(
              error: state.error,
              onTryAgainTap: statsCubit.getStats,
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  // Widget _buildExportPdfBtn() {
  //   return MainActionButton(
  //     padding: AppConstants.padding16,
  //     borderRadius: AppConstants.borderRadius20,
  //     onPressed: () {},
  //     text: "تصدير التقرير PDF",
  //   );
  // }

  Widget _buildStatsTiles(KpisModel kpis) {
    final stats = [
      IconTitleValueColor(
        "total_plants",
        kpis.totalPlants.toString(),
        Icons.local_florist_outlined,
        context.cs.secondary,
      ),
      IconTitleValueColor(
        "healthy_plants",
        kpis.healthyPlants.toString(),
        Icons.health_and_safety,
        context.cs.primary,
      ),
      IconTitleValueColor(
        "diseased_plants",
        kpis.diseasedPlants.toString(),
        Icons.error,
        context.cs.error,
      ),
      IconTitleValueColor(
        "total_quantity",
        kpis.totalQuantity.toString(),
        Icons.storage,
        context.cs.tertiaryFixedDim,
      ),
    ];
    return AnimationLimiter(
      child: GridView.count(
        crossAxisSpacing: 10,
        mainAxisSpacing: 30,
        shrinkWrap: true,
        childAspectRatio: 1.2,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: columnCount,
        children: List.generate(stats.length, (int index) {
          final stat = stats[index];
          return AnimationConfiguration.staggeredGrid(
            delay: AppConstants.duration200ms,
            position: index,
            duration: AppConstants.duration500ms,
            columnCount: columnCount,
            child: ScaleAnimation(
              child: FadeInAnimation(child: _buildStatsTile(stat)),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildStatsTile(IconTitleValueColor stat) {
    return MainTile(
      child: Column(
        crossAxisAlignment: .start,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: stat.color.withAlpha(50),
              borderRadius: AppConstants.borderRadius10,
            ),
            child: Padding(
              padding: AppConstants.padding8,
              child: Icon(stat.icon, color: stat.color),
            ),
          ),
          Spacer(),
          Text(stat.text.tr()),
          Spacer(),
          Text(
            stat.value,
            style: context.tt.headlineMedium?.copyWith(
              color: stat.color,
              fontWeight: .bold,
            ),
          ),
        ],
      ),
    );
  }
}

class DiseasesDistributionPieChartWidget extends StatelessWidget {
  const DiseasesDistributionPieChartWidget({super.key, required this.diseases});

  final List<ChartModel> diseases;

  @override
  Widget build(BuildContext context) {
    return MainTile(
      height: 400,
      child: SfCircularChart(
        title: ChartTitle(
          text: "disease_distribution".tr(),
          textStyle: context.tt.titleLarge,
        ),
        legend: const Legend(isVisible: true, overflowMode: .wrap),
        series: <DoughnutSeries<ChartModel, String>>[
          DoughnutSeries<ChartModel, String>(
            explode: true,
            explodeAll: true,
            explodeOffset: '6%',
            dataSource: diseases,
            xValueMapper: (ChartModel t, _) => t.text,
            yValueMapper: (ChartModel t, _) => t.percentage,
            dataLabelSettings: DataLabelSettings(
              textStyle: context.tt.bodyLarge?.copyWith(fontWeight: .bold),
              isVisible: true,
              labelPosition: .inside,
            ),
            pointColorMapper: (ChartModel item, index) {
              return item.color;
            },
          ),
        ],
      ),
    );
  }
}

class TrustPercentageDistributionBarChartWidget extends StatelessWidget {
  const TrustPercentageDistributionBarChartWidget({
    super.key,
    required this.trustPercentags,
  });

  final List<ChartModel> trustPercentags;

  @override
  Widget build(BuildContext context) {
    return MainTile(
      child: SfCartesianChart(
        title: ChartTitle(
          text: "confidence_distributions".tr(),
          textStyle: context.tt.titleLarge,
        ),
        primaryXAxis: const CategoryAxis(labelRotation: 90),
        primaryYAxis: const NumericAxis(
          minimum: 0,
          maximum: 100,
          interval: 25,
          // labelFormat: '{value}%',
        ),
        series: <ColumnSeries<ChartModel, String>>[
          ColumnSeries<ChartModel, String>(
            dataSource: trustPercentags,
            xValueMapper: (ChartModel template, _) => template.text.tr(),
            yValueMapper: (ChartModel template, _) => template.percentage,
            pointColorMapper: (ChartModel item, _) {
              return item.color;
            },
            borderRadius: AppConstants.borderRadiusT5,
            dataLabelSettings: const DataLabelSettings(isVisible: true),
            spacing: 0.3,
          ),
        ],
      ),
    );
  }
}

class LastDiagnosisCard extends StatefulWidget {
  const LastDiagnosisCard({super.key, required this.diagnosis});
  final List<DiagnoseModel> diagnosis;

  @override
  State<LastDiagnosisCard> createState() => _LastDiagnosisCardState();
}

class _LastDiagnosisCardState extends State<LastDiagnosisCard> {
  @override
  Widget build(BuildContext context) {
    final items = widget.diagnosis;
    final headerTitles = ["date", "plant", "disease", "accuracy"];
    return Center(
      child: MainTile(
        width: .maxFinite,
        child: Column(
          spacing: 10,
          children: [
            Text("recent_diagnoses".tr(), style: context.tt.titleLarge),
            SingleChildScrollView(
              scrollDirection: .horizontal,
              child: DataTable(
                headingRowHeight: 50,
                dataRowMinHeight: 50,
                dataRowMaxHeight: 60,
                columnSpacing: 10,
                horizontalMargin: 20,
                dividerThickness: .4,
                headingTextStyle: context.tt.titleMedium?.copyWith(
                  //TODO color from theme
                  fontWeight: .bold,
                  color: Color(0xff344054),
                ),
                columns: headerTitles
                    .map(
                      (header) => DataColumn(
                        label: Text(header.tr()),
                        headingRowAlignment: .center,
                      ),
                    )
                    .toList(),
                rows: List.generate(items.length, (index) {
                  final item = items[index];
                  // final color = item.hasDisease
                  //     ? context.cs.error
                  //     : context.cs.primary;
                  // final bgColor = item.hasDisease
                  //     ? context.cs.errorContainer
                  //     : context.cs.primaryContainer;
                  final color = context.cs.error;
                  final bgColor = context.cs.errorContainer;
                  return DataRow(
                    cells: [
                      DataCell(Center(child: Text(item.createdAt.formatYYYYMMDD))),
                      DataCell(Center(child: Text(item.plant?.name ?? "---"))),
                      DataCell(
                        Center(
                          child: Container(
                            padding: AppConstants.paddingH8V4,
                            decoration: BoxDecoration(
                              color: bgColor,
                              borderRadius: AppConstants.borderRadius15,
                            ),
                            child: Text(
                              item.diseaseNameArabic,
                              style: context.tt.bodyMedium?.copyWith(
                                color: color,
                              ),
                            ),
                          ),
                        ),
                      ),
                      DataCell(
                        SizedBox(
                          width: 70,
                          child: Row(
                            spacing: 5,
                            children: [
                              Expanded(
                                child: LinearProgressIndicator(
                                  minHeight: 12,
                                  value: .tryParse(item.confidencePercentage),
                                  // TODO color from theme
                                  backgroundColor: const Color(0xffe5e7eb),
                                  valueColor: AlwaysStoppedAnimation(color),
                                  borderRadius: AppConstants.borderRadius12,
                                ),
                              ),
                              Text(
                                "${item.confidencePercentage}%",
                                style: context.tt.bodyMedium?.copyWith(
                                  color: color,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class IncommingIrrigation extends StatefulWidget {
  const IncommingIrrigation({super.key, required this.irrigations});
  final List<IrrigationScheduleModel> irrigations;

  @override
  State<IncommingIrrigation> createState() => _IncommingIrrigationState();
}

class _IncommingIrrigationState extends State<IncommingIrrigation> {
  @override
  Widget build(BuildContext context) {
    return MainTile(
      child: Column(
        crossAxisAlignment: .start,
        spacing: 16,
        children: [
          Row(
            spacing: 5,
            mainAxisSize: .min,
            children: [
              Icon(Icons.water_drop, size: 20),
              Text(
                "upcoming_irrigation".tr(),
                style: context.tt.titleMedium?.copyWith(fontWeight: .bold),
              ),
            ],
          ),
          ...widget.irrigations.map(
            (irrigation) => _buildIrrigationTile(context, irrigation),
          ),
        ],
      ),
    );
  }

  Widget _buildIrrigationTile(
    BuildContext context,
    IrrigationScheduleModel irrigation,
  ) {
    return MainTile(
      child: Column(
        spacing: 10,
        crossAxisAlignment: .start,
        children: [
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Text(irrigation.plant?.name ?? "---"),
              Container(
                padding: AppConstants.paddingH8V4,
                decoration: BoxDecoration(
                  color: Colors.yellow,
                  // color: irrigation.color.withAlpha(15),
                  borderRadius: AppConstants.borderRadius15,
                ),
                child: Text("incomming".tr(), style: context.tt.bodySmall),
              ),
            ],
          ),
          Row(
            spacing: 5,
            mainAxisSize: .min,
            children: [
              Icon(Icons.date_range),
              Text(irrigation.recommendedDate.formatYYYYMMDD),
              // Text("•", style: TextStyle(fontWeight: .bold)),
              // Text(irrigation.plant?.name ?? "---"),
            ],
          ),
        ],
      ),
    );
  }
}

class WeaklyDiagnosis extends StatelessWidget {
  const WeaklyDiagnosis({super.key, required this.diagnosis});
  final List<DiagnoseCountModel> diagnosis;

  @override
  Widget build(BuildContext context) {
    return MainTile(
      child: SfCartesianChart(
        title: ChartTitle(
          text: "weekly_diagnoses".tr(),
          textStyle: context.tt.titleLarge,
        ),
        primaryXAxis: CategoryAxis(labelStyle: context.tt.bodySmall),
        primaryYAxis: NumericAxis(maximum: 50, minimum: 0),
        series: <LineSeries<DiagnoseCountModel, String>>[
          LineSeries<DiagnoseCountModel, String>(
            color: context.cs.primary,
            width: 3,
            enableTrackball: true,
            dataSource: diagnosis,
            xValueMapper: (DiagnoseCountModel data, _) => data.dayName,
            yValueMapper: (DiagnoseCountModel data, _) => data.count,
            markerSettings: MarkerSettings(
              isVisible: true,
              color: context.cs.primary,
              shape: .circle,
              borderWidth: 2,
              height: 10,
              width: 10,
            ),
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
              labelAlignment: .top,
            ),
          ),
        ],
      ),
    );
  }
}

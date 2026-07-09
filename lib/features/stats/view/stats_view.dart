import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:green_mind/global/theme/theme_x.dart';
import 'package:green_mind/global/utils/constants.dart';
import 'package:green_mind/global/widgets/main_action_button.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class IconTitleValueColor {
  final String text;
  final String value;
  final IconData icon;
  final Color color;

  IconTitleValueColor(this.text, this.value, this.icon, this.color);
}

class ChartModel {
  final String text;
  final double percentage;
  final Color color;

  ChartModel(this.text, this.percentage, this.color);
}

class DiagnoseModel {
  final String date;
  final String plant;
  final String disease;
  final bool hasDisease;
  final double percentage;

  DiagnoseModel(
    this.date,
    this.plant,
    this.disease,
    this.hasDisease,
    this.percentage,
  );
}

class IrrigationModel {
  final String name;
  final String plantName;
  final String date;
  final String status;
  final Color color;

  IrrigationModel(
    this.name,
    this.plantName,
    this.date,
    this.status,
    this.color,
  );
}

class WeaklyDiagnosisModel {
  WeaklyDiagnosisModel(this.day, this.value);
  final String day;
  final double value;
}

@RoutePage()
class StatsView extends StatelessWidget {
  const StatsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const StatsPage();
  }
}

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  final columnCount = 2;

  @override
  Widget build(BuildContext context) {
    final stats = [
      IconTitleValueColor(
        "إجمالي النباتات",
        "1700",
        Icons.flood,
        context.cs.primary,
      ),
      IconTitleValueColor(
        "نباتات سليمة",
        "1200",
        Icons.done,
        context.cs.primaryFixedDim,
      ),
      IconTitleValueColor("نباتات مصابة", "350", Icons.error, context.cs.error),
      IconTitleValueColor(
        "تحت المراقبة",
        "150",
        Icons.warning,
        context.cs.tertiaryFixedDim,
      ),
      IconTitleValueColor(
        "إجمالي التشخيصات",
        "89",
        Icons.show_chart,
        context.cs.secondary,
      ),
      IconTitleValueColor(
        "متوسط الدقة",
        "91.5%",
        Icons.done,
        context.cs.primary,
      ),
    ];
    final diseases = [
      ChartModel("لفحة متأخرة", 30.0, Colors.red),
      ChartModel("تبقع الأوراق", 20.0, Colors.blue),
      ChartModel("صدأ الأوراق", 15.0, Colors.yellow),
      ChartModel("عفن رمادي", 15.0, Colors.pink),
      ChartModel("بياض دقيقي", 10.0, Colors.purple),
      ChartModel("أخرى", 10.0, Colors.cyan),
    ];
    return Scaffold(
      // appBar: MainAppBar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: AppConstants.padding16,
        child: Column(
          spacing: 20,
          crossAxisAlignment: .start,
          children: [
            MainActionButton(
              padding: AppConstants.padding16,
              borderRadius: AppConstants.borderRadius20,
              onPressed: () {},
              text: "تصدير التقرير PDF",
            ),
            AnimationLimiter(
              child: GridView.count(
                crossAxisSpacing: 10,
                mainAxisSpacing: 30,
                shrinkWrap: true,
                childAspectRatio: 1.2,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: columnCount,
                children: List.generate(6, (int index) {
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
            ),
            DiseasesDistributionPieChartWidget(diseases: diseases),
            TrustPercentageDistributionBarChartWidget(
              trustPercentags: diseases,
            ),
            WeaklyDiagnosis(),
            LastDiagnosisCard(),
            IncommingIrrigation(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsTile(IconTitleValueColor stat) {
    return Container(
      padding: AppConstants.padding16,
      decoration: BoxDecoration(
        color: context.cs.surface,
        borderRadius: AppConstants.borderRadius20,
        border: Border.all(width: 0.2, color: context.cs.onSurface),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 4,
            color: context.cs.surfaceContainerLow,
          ),
        ],
      ),
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
          Text(stat.text),
          Spacer(),
          Text(
            stat.value,
            style: context.tt.headlineMedium?.copyWith(
              color: stat.color,
              fontWeight: FontWeight.bold,
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
    return Container(
      height: 400,
      padding: AppConstants.padding16,
      decoration: BoxDecoration(
        color: context.cs.surface,
        borderRadius: AppConstants.borderRadius20,
        border: Border.all(width: 0.2, color: context.cs.onSurface),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 4,
            color: context.cs.surfaceContainerLow,
          ),
        ],
      ),
      child: SfCircularChart(
        title: ChartTitle(
          text: "توزيع الأمراض".tr(),
          textStyle: const TextStyle(fontSize: 20),
        ),
        legend: const Legend(
          isVisible: true,
          overflowMode: LegendItemOverflowMode.wrap,
        ),
        series: <DoughnutSeries<ChartModel, String>>[
          DoughnutSeries<ChartModel, String>(
            explode: true,
            explodeAll: true,
            explodeOffset: '6%',
            dataSource: diseases,
            xValueMapper: (ChartModel t, _) => t.text,
            yValueMapper: (ChartModel t, _) => t.percentage,
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
              labelPosition: ChartDataLabelPosition.inside,
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
    return Container(
      padding: AppConstants.padding16,
      decoration: BoxDecoration(
        color: context.cs.surface,
        borderRadius: AppConstants.borderRadius20,
        border: Border.all(width: 0.2, color: context.cs.onSurface),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 4,
            color: context.cs.surfaceContainerLow,
          ),
        ],
      ),
      child: SfCartesianChart(
        title: ChartTitle(
          text: "توزيع نسبة الثقة".tr(),
          textStyle: const TextStyle(fontSize: 20),
        ),
        primaryXAxis: const CategoryAxis(labelRotation: 90),
        primaryYAxis: const NumericAxis(
          minimum: 0,
          maximum: 100,
          interval: 25,
          labelFormat: '{value}%',
        ),
        series: <ColumnSeries<ChartModel, String>>[
          ColumnSeries<ChartModel, String>(
            dataSource: trustPercentags,
            xValueMapper: (ChartModel template, _) => template.text,
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
  const LastDiagnosisCard({super.key});

  @override
  State<LastDiagnosisCard> createState() => _LastDiagnosisCardState();
}

class _LastDiagnosisCardState extends State<LastDiagnosisCard> {
  final items = [
    DiagnoseModel("2026-06-14", "طماطم", "لفحة متأخرة", true, 94),
    DiagnoseModel("2026-06-14", "تفاح", "تبقع الأوراق", true, 88),
    DiagnoseModel("2026-06-13", "بطاطا", "لفحة متأخرة", true, 91),
    DiagnoseModel("2026-06-13", "طماطم", "سليم", false, 97),
    DiagnoseModel("2026-06-12", "تفاح", "صدأ الأوراق", true, 76),
  ];
  @override
  Widget build(BuildContext context) {
    final headerTitles = ["التاريخ", "النبات", "المرض", "الدقة"];
    return Container(
      padding: AppConstants.padding16,
      decoration: BoxDecoration(
        color: context.cs.surface,
        borderRadius: AppConstants.borderRadius20,
        border: Border.all(width: 0.2, color: context.cs.onSurface),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 4,
            color: context.cs.surfaceContainerLow,
          ),
        ],
      ),
      child: Column(
        spacing: 10,
        children: [
          Text("اخر التشخيصات".tr(), style: context.tt.titleLarge),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowHeight: 50,
              dataRowMinHeight: 50,
              dataRowMaxHeight: 60,
              columnSpacing: 10,
              horizontalMargin: 20,
              dividerThickness: .4,
              headingTextStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xff344054),
              ),
              columns: headerTitles
                  .map(
                    (header) => DataColumn(
                      label: Text(header.tr()),
                      headingRowAlignment: MainAxisAlignment.center,
                    ),
                  )
                  .toList(),
              rows: List.generate(items.length, (index) {
                final item = items[index];
                final color = item.hasDisease
                    ? context.cs.error
                    : context.cs.primary;
                final bgColor = item.hasDisease
                    ? context.cs.errorContainer
                    : context.cs.primaryContainer;
                return DataRow(
                  cells: [
                    DataCell(Text(item.date)),
                    DataCell(Text(item.plant)),
                    DataCell(
                      Center(
                        child: Container(
                          padding: AppConstants.paddingH8V4,
                          decoration: BoxDecoration(
                            color: bgColor,
                            borderRadius: AppConstants.borderRadius15,
                          ),
                          child: Text(
                            item.disease,
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
                                value: item.percentage / 100,
                                backgroundColor: const Color(0xffe5e7eb),
                                valueColor: AlwaysStoppedAnimation(color),
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            Text(
                              "${item.percentage.toStringAsFixed(0)}%",
                              style: TextStyle(color: color),
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
    );
  }
}

class IncommingIrrigation extends StatefulWidget {
  const IncommingIrrigation({super.key});

  @override
  State<IncommingIrrigation> createState() => _IncommingIrrigationState();
}

class _IncommingIrrigationState extends State<IncommingIrrigation> {
  @override
  Widget build(BuildContext context) {
    final items = [
      IrrigationModel(
        "حقل طماطم 1",
        "طماطم",
        "2026-06-15",
        "مجدد",
        Colors.green,
      ),
      IrrigationModel(
        "بستان تفاح",
        "تفاح",
        "2026-06-16",
        "بانتظار الموافقة",
        Colors.orange,
      ),
      IrrigationModel(
        "حقل بطاطا",
        "بطاطا",
        "2026-06-17",
        "تعديل يدوي",
        Colors.orange,
      ),
    ];
    return Container(
      padding: AppConstants.padding20,
      decoration: BoxDecoration(
        color: context.cs.surface,
        borderRadius: AppConstants.borderRadius20,
        border: Border.all(width: 0.2, color: context.cs.onSurface),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 4,
            color: context.cs.surfaceContainerLow,
          ),
        ],
      ),
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
                "الري القادم",
                style: context.tt.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          ...items.map(
            (irrigation) => _buildIrrigationTile(context, irrigation),
          ),
        ],
      ),
    );
  }

  Widget _buildIrrigationTile(
    BuildContext context,
    IrrigationModel irrigation,
  ) {
    return Container(
      padding: AppConstants.padding16,
      decoration: BoxDecoration(
        color: context.cs.surface,
        borderRadius: AppConstants.borderRadius20,
        border: Border.all(width: 0.2, color: context.cs.onSurface),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 4,
            color: context.cs.surfaceContainerLow,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: .spaceBetween,
        crossAxisAlignment: .start,
        children: [
          Column(
            spacing: 10,
            crossAxisAlignment: .start,
            children: [
              Text(irrigation.name),
              Row(
                spacing: 5,
                mainAxisSize: .min,
                children: [
                  Icon(Icons.date_range),
                  Text(irrigation.date),
                  Text("•", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(irrigation.plantName),
                ],
              ),
            ],
          ),
          Container(
            padding: AppConstants.paddingH8V4,
            decoration: BoxDecoration(
              color: irrigation.color.withAlpha(15),
              borderRadius: AppConstants.borderRadius15,
            ),
            child: Text(
              irrigation.status,
              style: context.tt.bodySmall?.copyWith(color: irrigation.color),
            ),
          ),
        ],
      ),
    );
  }
}

class WeaklyDiagnosis extends StatelessWidget {
  const WeaklyDiagnosis({super.key});

  @override
  Widget build(BuildContext context) {
    final List<WeaklyDiagnosisModel> dataSource = [
      WeaklyDiagnosisModel('Sun', 10),
      WeaklyDiagnosisModel('Mon', 28),
      WeaklyDiagnosisModel('Tus', 34),
      WeaklyDiagnosisModel('Wen', 32),
      WeaklyDiagnosisModel('Tur', 40),
      WeaklyDiagnosisModel('Fri', 30),
      WeaklyDiagnosisModel('Sat', 40),
    ];
    return Container(
      padding: AppConstants.padding16,
      decoration: BoxDecoration(
        color: context.cs.surface,
        borderRadius: AppConstants.borderRadius20,
        border: Border.all(width: 0.2, color: context.cs.onSurface),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 4,
            color: context.cs.surfaceContainerLow,
          ),
        ],
      ),
      child: SfCartesianChart(
        title: ChartTitle(
          text: "التشخيصات الأسبوعية".tr(),
          textStyle: const TextStyle(fontSize: 20),
        ),
        primaryXAxis: CategoryAxis(
          labelStyle: TextStyle(color: context.cs.onSurface),
        ),
        primaryYAxis: NumericAxis(maximum: 50, minimum: 0),
        series: <LineSeries<WeaklyDiagnosisModel, String>>[
          LineSeries<WeaklyDiagnosisModel, String>(
            color: context.cs.primary,
            width: 3,
            enableTrackball: true,
            dataSource: dataSource,
            xValueMapper: (WeaklyDiagnosisModel sales, _) => sales.day,
            yValueMapper: (WeaklyDiagnosisModel sales, _) => sales.value,
            markerSettings: MarkerSettings(
              isVisible: true,
              color: context.cs.primary,
              shape: DataMarkerType.circle,
              borderWidth: 2,
              height: 10,
              width: 10,
            ),
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
              labelAlignment: ChartDataLabelAlignment.top,
            ),
            animationDuration: 800,
          ),
        ],
      ),
    );
  }
}

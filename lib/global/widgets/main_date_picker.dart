import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:green_mind/global/extensions/date_x.dart';
import 'package:green_mind/global/theme/theme_x.dart';
import 'package:green_mind/global/utils/constants.dart';

class MainDatePicker extends StatefulWidget {
  const MainDatePicker({
    super.key,
    this.label = "date",
    required this.onDateSelected,
    this.padding = AppConstants.padding0,
    this.initialDate,
    this.hintText = "pick_date",
    this.isStart = false,
    this.isEnd = false,
    this.firstDate,
    this.selectedDate,
    this.suffix,
    this.contentPadding = AppConstants.padding16,
    this.onDateInitialSelected,
    this.title,
  });

  final String? title;
  final String label;
  final String hintText;
  final bool isStart;
  final bool isEnd;
  final DateTime? selectedDate;
  final DateTime? firstDate;
  final void Function(DateTime? date) onDateSelected;
  final void Function(DateTime? date)? onDateInitialSelected;
  final String? initialDate;
  final EdgeInsets padding;
  final EdgeInsets contentPadding;
  final Widget? suffix;

  @override
  State<MainDatePicker> createState() => _MainDatePickerState();
}

class _MainDatePickerState extends State<MainDatePicker> {
  DateTime? selectedDate;

  @override
  void didUpdateWidget(covariant MainDatePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedDate != null) {
      setState(() {
        selectedDate = widget.selectedDate;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.initialDate != null) {
      selectedDate = DateTime.tryParse(widget.initialDate!);
      widget.onDateInitialSelected?.call(selectedDate);
    }
  }

  Future<void> onPickDate() async {
    final date = await showDatePicker(
      context: context,
      firstDate: widget.firstDate ?? DateTime(2000),
      lastDate: DateTime(3000),
    );
    setState(() {
      selectedDate = date;
    });
    widget.onDateSelected(date);
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.title;
    final isStart = widget.isStart;
    final isEnd = widget.isEnd;
    final label = isStart
        ? "start_date"
        : isEnd
        ? "end_date"
        : widget.label;
    final hintText = isStart
        ? "pick_start_date"
        : isEnd
        ? "pick_end_date"
        : widget.hintText;
    return Padding(
      padding: widget.padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Padding(
              padding: AppConstants.paddingV5,
              child: Text(title, style: context.tt.titleMedium),
            ),
          InkWell(
            onTap: onPickDate,
            child: Container(
              padding: widget.contentPadding,
              decoration: BoxDecoration(
                color: context.cs.surfaceContainer,
                borderRadius: AppConstants.borderRadius10,
                border: Border.all(color: context.cs.outline, width: 0.5),
              ),
              child: Row(
                children: [
                  InkWell(
                    onTap: onPickDate,
                    child: const Icon(
                      Icons.date_range,
                      // color: AppColors.black,
                    ),
                  ),
                  const SizedBox(width: 12),
                  if (selectedDate?.formatYYYYMMDD != null)
                    Text("${label.tr()}: "),
                  Expanded(
                    child: Text(selectedDate?.formatYYYYMMDD ?? hintText.tr()),
                  ),
                  ?widget.suffix,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

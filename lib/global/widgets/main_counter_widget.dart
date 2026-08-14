import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:green_mind/global/widgets/main_text_field.dart';

class MainCounterWidget extends StatefulWidget {
  const MainCounterWidget({
    super.key,
    this.title,
    this.icon,
    this.minCount = 0,
    this.onChanged,
    this.maxCount,
    this.initialCount,
    this.isRequired = true,
    this.hint,
  });
  final void Function(int value)? onChanged;
  final int? initialCount;
  final int minCount;
  final int? maxCount;
  final String? title;
  final String? hint;
  final IconData? icon;
  final bool isRequired;

  @override
  State<MainCounterWidget> createState() => _MainCounterWidgetState();
}

class _MainCounterWidgetState extends State<MainCounterWidget> {
  late final TextEditingController controller;
  late int counter;

  @override
  void initState() {
    super.initState();
    counter = widget.initialCount ?? widget.minCount;
    controller = TextEditingController(text: widget.initialCount?.toString());

    controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final text = controller.text.trim();
    if (text.isEmpty) return;

    final value = int.tryParse(text);
    if (value != null) {
      var newValue = value;

      if (newValue < widget.minCount) {
        newValue = widget.minCount;
      }
      if (widget.maxCount != null && newValue > widget.maxCount!) {
        newValue = widget.maxCount!;
        controller.text = newValue.toString();
      }

      if (newValue != counter) {
        setState(() => counter = newValue);
        widget.onChanged?.call(counter);
      }
    }
  }

  void onIncreaseTap() {
    if (widget.maxCount != null && counter == widget.maxCount!) return;
    setState(() => counter++);
    controller.text = counter.toString();
    widget.onChanged?.call(counter);
  }

  void onDecreaseTap() {
    if (counter <= widget.minCount) return;
    setState(() => counter--);
    controller.text = counter.toString();
    widget.onChanged?.call(counter);
  }

  // String? requiredValueValidator(String? val) {
  //   if (val == null || val.isEmpty || int.tryParse(val) == null) {
  //     return "required".tr();
  //   } else if (int.parse(val) < widget.minCount ||
  //       (widget.maxCount != null && int.parse(val) > widget.maxCount!)) {
  //     return "invalid_value".tr();
  //   } else {
  //     return null;
  //   }
  // }

  // String? optionalValueValidator(String? val) {
  //   if (val != null && val.isNotEmpty || int.tryParse(val!) != null) {
  //     if (int.parse(val) < widget.minCount ||
  //         (widget.maxCount != null && int.parse(val) > widget.maxCount!)) {
  //       return "invalid_value".tr();
  //     }
  //     return null;
  //   } else {
  //     return null;
  //   }
  // }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MainTextField(
      controller: controller,
      title: widget.title,
      hintText: widget.hint,
      // icon: widget.icon,
      suffixIcon: Column(
        children: [
          InkWell(onTap: onIncreaseTap, child: Icon(Icons.arrow_drop_up)),
          InkWell(onTap: onDecreaseTap, child: Icon(Icons.arrow_drop_down)),
        ],
      ),
      textInputType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      // validator: widget.isRequired
      //     ? requiredValueValidator
      //     : optionalValueValidator,
    );
  }
}

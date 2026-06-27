import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:green_mind/global/utils/app_colors.dart';
import 'package:green_mind/global/utils/constants.dart';

class MainTextField extends StatefulWidget {
  const MainTextField({
    super.key,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.labelText,
    this.textInputType,
    this.hintText,
    this.inputFormatters,
    this.initialText,
    this.errorText,
    this.padding,
    this.readOnly = false,
    this.onTap,
    this.suffixIcon,
    this.obscureText = false,
    this.controller,
    this.textColor = AppColors.black,
    this.floatingLabelColor,
    this.hintStyle,
    this.borderRadius,
    this.borderColor = AppColors.whiteShade,
    this.borderWidth = 1,
    this.outlineInputBorder,
    this.fillColor,
    this.filled = true,
    this.onClearTap,
    this.showCloseIcon,
    this.title,
    this.subTitle,
    this.prefixIcon,
    this.hintColor,
    this.validator,
    this.maxLines,
    this.minLines = 1,
    this.titleSize = 20,
    this.titlePadding = AppConstants.padding0,
    this.titleHeight = 10,
    this.titleColor = AppColors.greyShade3,
    this.boxShadow = const [],
  });

  final String? hintText;
  final String? initialText;
  final String? title;
  final String? subTitle;
  final ValueSetter<String>? onChanged;
  final ValueSetter<String>? onSubmitted;
  final VoidCallback? onTap;
  final FocusNode? focusNode;
  final TextInputType? textInputType;
  final List<TextInputFormatter>? inputFormatters;
  final String? errorText;
  final EdgeInsets? padding;
  final String? labelText;
  final bool readOnly;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool obscureText;
  final TextEditingController? controller;
  final Color textColor;
  final Color? floatingLabelColor;
  final Color borderColor;
  final double borderWidth;
  final Color? fillColor;
  final TextStyle? hintStyle;
  final Color? hintColor;
  final BorderRadius? borderRadius;
  final InputBorder? outlineInputBorder;
  final bool? filled;
  final VoidCallback? onClearTap;
  final bool? showCloseIcon;
  final String? Function(String?)? validator;
  final int? maxLines;
  final int? minLines;
  final double titleSize;
  final EdgeInsets titlePadding;
  final double titleHeight;
  final Color titleColor;
  final List<BoxShadow> boxShadow;

  @override
  State<MainTextField> createState() => _MainTextFieldState();
}

class _MainTextFieldState extends State<MainTextField> {
  late Color? floatingLabelColor = widget.floatingLabelColor;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ?? TextEditingController(text: widget.initialText);
  }

  @override
  Widget build(BuildContext context) {
    final suffixIcon = widget.suffixIcon;
    final prefixIcon = widget.prefixIcon;
    final showCloseIcon = widget.showCloseIcon ?? true;
    final title = widget.title;
    final subTitle = widget.subTitle;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Padding(
            padding: widget.titlePadding,
            child: Text(
              title,
              style: TextStyle(
                fontSize: widget.titleSize,
                fontWeight: FontWeight.w700,
                color: widget.titleColor,
              ),
            ),
          ),
          if (subTitle == null) SizedBox(height: widget.titleHeight),
        ],
        if (subTitle != null) ...[
          Padding(padding: widget.titlePadding, child: Text(subTitle)),
          SizedBox(height: widget.titleHeight),
        ],

        DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius ?? AppConstants.borderRadius15,
            boxShadow: widget.boxShadow,
          ),
          child: TextFormField(
            controller: _controller,
            obscureText: widget.obscureText,
            readOnly: widget.readOnly,
            onTap: widget.onTap,
            onChanged: (text) {
              widget.onChanged?.call(text);
              setState(() {});
            },
            minLines: widget.minLines,
            maxLines: widget.maxLines,
            onFieldSubmitted: widget.onSubmitted,
            focusNode: widget.focusNode,
            keyboardType: widget.textInputType ?? TextInputType.name,
            inputFormatters: widget.inputFormatters,
            cursorColor: widget.textColor,
            style: TextStyle(color: widget.textColor),
            decoration: InputDecoration(
              contentPadding: widget.padding ?? AppConstants.padding16,
              labelText: widget.labelText,
              floatingLabelStyle: TextStyle(
                color: widget.errorText == null
                    ? floatingLabelColor ?? AppColors.black
                    : AppColors.red,
              ),
              labelStyle: TextStyle(
                color: widget.errorText == null
                    ? AppColors.grey
                    : AppColors.red,
                fontSize: 14,
              ),
              alignLabelWithHint: true,
              hintText: widget.hintText,
              hintStyle:
                  widget.hintStyle ??
                  TextStyle(
                    fontSize: 16,
                    color: widget.hintColor ?? AppColors.greyShade,
                  ),
              errorStyle: const TextStyle(fontSize: 16, color: AppColors.red),
              errorText: widget.errorText,
              border: widget.outlineInputBorder ?? outlineInputBorder(),
              focusedBorder: widget.outlineInputBorder ?? outlineInputBorder(),
              enabledBorder: widget.outlineInputBorder ?? outlineInputBorder(),
              suffixIcon: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (suffixIcon != null) suffixIcon,
                  if (_controller.text.isNotEmpty && showCloseIcon)
                    InkWell(
                      onTap: () {
                        _controller.clear();
                        widget.onChanged?.call("");
                        widget.onClearTap?.call();
                        setState(() {});
                      },
                      child: const Icon(Icons.close, color: AppColors.grey),
                    ),
                  if (!widget.readOnly &&
                      _controller.text.isNotEmpty &&
                      showCloseIcon)
                    const SizedBox(width: 10),
                ],
              ),
              prefixIcon: prefixIcon,
              fillColor: widget.fillColor ?? AppColors.whiteShade,
              filled: widget.filled,
            ),
            validator: widget.validator,
          ),
        ),
      ],
    );
  }

  OutlineInputBorder outlineInputBorder() {
    return OutlineInputBorder(
      borderRadius: widget.borderRadius ?? AppConstants.borderRadius15,
      borderSide: BorderSide(
        color: widget.borderColor,
        width: widget.borderWidth,
      ),
    );
  }
}

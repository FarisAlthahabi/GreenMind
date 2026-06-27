import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:green_mind/global/theme/theme_x.dart';
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
    this.hintStyle,
    this.borderRadius,
    this.borderWidth = 1,
    this.outlineInputBorder,
    this.fillColor,
    this.filled = true,
    this.onClearTap,
    this.showCloseIcon,
    this.title,
    this.subTitle,
    this.prefixIcon,
    this.validator,
    this.maxLines,
    this.minLines = 1,
    this.titleSize = 20,
    this.titlePadding = AppConstants.padding0,
    this.titleHeight = 10,
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
  final TextStyle? hintStyle;
  final Color? fillColor;
  final bool filled;
  final VoidCallback? onClearTap;
  final bool? showCloseIcon;
  final String? Function(String?)? validator;
  final int? maxLines;
  final int? minLines;
  final double titleSize;
  final EdgeInsets titlePadding;
  final double titleHeight;
  final List<BoxShadow> boxShadow;
  final BorderRadius? borderRadius;
  final double borderWidth;
  final InputBorder? outlineInputBorder;

  @override
  State<MainTextField> createState() => _MainTextFieldState();
}

class _MainTextFieldState extends State<MainTextField> {
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
              style: context.tt.titleLarge?.copyWith(
                fontSize: widget.titleSize,
                fontWeight: FontWeight.w700,
                color: context.cs.onSurface,
              ),
            ),
          ),
          if (subTitle == null) SizedBox(height: widget.titleHeight),
        ],
        if (subTitle != null) ...[
          Padding(
            padding: widget.titlePadding,
            child: Text(
              subTitle,
              style: context.tt.bodyMedium?.copyWith(
                color: context.cs.onSurfaceVariant,
              ),
            ),
          ),
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
            cursorColor: context.cs.primary,
            style: context.tt.bodyLarge?.copyWith(color: context.cs.onSurface),
            decoration: InputDecoration(
              contentPadding: widget.padding ?? AppConstants.padding16,
              labelText: widget.labelText,
              floatingLabelStyle: context.tt.bodyMedium?.copyWith(
                color: widget.errorText == null
                    ? context.cs.primary
                    : context.cs.error,
              ),
              labelStyle: context.tt.bodyMedium?.copyWith(
                color: widget.errorText == null
                    ? context.cs.onSurfaceVariant
                    : context.cs.error,
                fontSize: 14,
              ),
              alignLabelWithHint: true,
              hintText: widget.hintText,
              hintStyle:
                  widget.hintStyle ??
                  context.tt.bodyLarge?.copyWith(
                    fontSize: 16,
                    color: context.cs.onSurfaceVariant.withOpacity(0.6),
                  ),
              errorStyle: context.tt.bodyMedium?.copyWith(
                fontSize: 16,
                color: context.cs.error,
              ),
              errorText: widget.errorText,
              border: widget.outlineInputBorder ?? _outlineInputBorder(context),
              focusedBorder:
                  widget.outlineInputBorder ??
                  _outlineInputBorder(context, isFocused: true),
              enabledBorder:
                  widget.outlineInputBorder ?? _outlineInputBorder(context),
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
                      child: Icon(
                        Icons.close,
                        color: context.cs.onSurfaceVariant,
                      ),
                    ),
                  if (!widget.readOnly &&
                      _controller.text.isNotEmpty &&
                      showCloseIcon)
                    const SizedBox(width: 10),
                ],
              ),
              prefixIcon: prefixIcon,
              fillColor: widget.fillColor ?? context.cs.surfaceVariant,
              filled: widget.filled,
            ),
            validator: widget.validator,
          ),
        ),
      ],
    );
  }

  InputBorder _outlineInputBorder(
    BuildContext context, {
    bool isFocused = false,
  }) {
    return OutlineInputBorder(
      borderRadius: widget.borderRadius ?? AppConstants.borderRadius15,
      borderSide: BorderSide(
        color: isFocused
            ? context.cs.primary
            : widget.errorText != null
            ? context.cs.error
            : context.cs.outlineVariant,
        width: isFocused ? 2 : widget.borderWidth,
      ),
    );
  }
}

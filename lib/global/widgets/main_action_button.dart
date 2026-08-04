import 'package:flutter/material.dart';
import 'package:green_mind/global/theme/theme_x.dart';
import 'package:green_mind/global/utils/constants.dart';
import 'package:green_mind/global/widgets/loading_indicator.dart';

class MainActionButton extends StatefulWidget {
  const MainActionButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.textColor,
    this.duration,
    this.buttonColor,
    this.isExpandText = false,
    this.width,
    this.border,
    this.height,
    this.fontSize,
    this.shadow,
    this.fontWeight,
    this.borderRadius = AppConstants.borderRadius15,
    this.padding = AppConstants.paddingH36V8,
    this.child,
    this.icon,
    this.isLoading = false,
    this.margin,
  });

  final VoidCallback onPressed;
  final Duration? duration;
  final Color? buttonColor;
  final String text;
  final Color? textColor;
  final double? width;
  final double? height;
  final BoxBorder? border;
  final double? fontSize;
  final List<BoxShadow>? shadow;
  final FontWeight? fontWeight;
  final BorderRadiusGeometry? borderRadius;
  final EdgeInsets padding;
  final EdgeInsets? margin;
  final Widget? child;
  final Icon? icon;
  final bool isExpandText;
  final bool isLoading;

  @override
  State<MainActionButton> createState() => _MainActionButtonState();
}

class _MainActionButtonState extends State<MainActionButton> {
  @override
  Widget build(BuildContext context) {
    final textWidget = Text(
      widget.text,
      style: context.tt.bodyLarge?.copyWith(
        color: widget.textColor ?? context.cs.onPrimary,
        fontSize: widget.fontSize,
        fontWeight: widget.fontWeight,
      ),
      textAlign: .center,
      overflow: .ellipsis,
    );
    final buildText = widget.isExpandText
        ? Expanded(child: textWidget)
        : textWidget;
    final icon = widget.icon;
    return InkWell(
      onTap: widget.isLoading ? null : widget.onPressed,
      child: Container(
        height: widget.height,
        width: widget.width,
        margin: widget.margin,
        padding: widget.padding,
        decoration: BoxDecoration(
          border: widget.border,
          color: widget.buttonColor ?? context.cs.primary,
          borderRadius: widget.borderRadius,
          boxShadow: widget.shadow,
        ),
        child: Center(
          child: widget.isLoading
              ? LoadingIndicator(size: 25, color: context.cs.onPrimary)
              : Row(
                  mainAxisSize: .min,
                  children: [
                    if (icon != null) ...[icon, const SizedBox(width: 5)],
                    widget.child ?? buildText,
                  ],
                ),
        ),
      ),
    );
  }
}

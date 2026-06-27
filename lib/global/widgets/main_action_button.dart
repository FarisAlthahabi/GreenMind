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
    this.borderRadius,
    this.padding,
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
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Widget? child;
  final Icon? icon;
  final bool isExpandText;
  final bool isLoading;

  @override
  State<MainActionButton> createState() => _MainActionButtonState();
}

class _MainActionButtonState extends State<MainActionButton> {
  late Widget textWidget = Text(
    widget.text,
    style: TextStyle(
      color: widget.textColor ?? context.cs.secondary,
      height: 1.19,
      fontSize: widget.fontSize ?? 20,
      fontWeight: widget.fontWeight,
    ),
    textAlign: TextAlign.center,
    overflow: TextOverflow.ellipsis,
  );
  late final buildText = widget.isExpandText
      ? Expanded(child: textWidget)
      : textWidget;
  @override
  Widget build(BuildContext context) {
    final icon = widget.icon;
    return InkWell(
      onTap: widget.isLoading ? null : widget.onPressed,
      child: Container(
        height: widget.height,
        width: widget.width,
        margin: widget.margin,
        padding: widget.padding ?? AppConstants.paddingH36V8,
        decoration: BoxDecoration(
          border: widget.border,
          color: widget.buttonColor ?? context.cs.primary,
          borderRadius: widget.borderRadius ?? AppConstants.borderRadius15,
          boxShadow: widget.shadow,
        ),
        child: Center(
          child: widget.isLoading
              ? const LoadingIndicator(size: 25)
              : Row(
                  mainAxisSize: MainAxisSize.min,
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
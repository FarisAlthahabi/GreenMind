import 'package:flutter/material.dart';
import 'package:green_mind/global/theme/theme_x.dart';
import 'package:green_mind/global/utils/constants.dart';
import 'package:green_mind/global/widgets/loading_indicator.dart';

class MainActionButton extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final textWidget = Text(
      text,
      style: context.tt.bodyLarge?.copyWith(
        color: textColor ?? context.cs.onPrimary,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
      textAlign: .center,
      overflow: .ellipsis,
    );
    final buildText = isExpandText ? Expanded(child: textWidget) : textWidget;
    final icon = this.icon;
    return InkWell(
      onTap: isLoading ? null : onPressed,
      child: Container(
        height: height,
        width: width,
        margin: margin,
        padding: padding,
        decoration: BoxDecoration(
          border: border,
          color: buttonColor ?? context.cs.primary,
          borderRadius: borderRadius,
          boxShadow: shadow,
        ),
        child: Center(
          child: isLoading
              ? LoadingIndicator(
                  size: 25,
                  color: textColor ?? context.cs.onPrimary,
                )
              : Row(
                  mainAxisSize: .min,
                  children: [
                    if (icon != null) ...[icon, const SizedBox(width: 5)],
                    child ?? buildText,
                  ],
                ),
        ),
      ),
    );
  }
}

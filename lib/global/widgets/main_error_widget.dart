import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:green_mind/global/theme/theme_x.dart';

class MainErrorWidget extends StatelessWidget {
  const MainErrorWidget({
    super.key,
    required this.error,
    this.onTryAgainTap,
    this.height = 0,
    this.isRefresh = false,
  });

  final String error;
  final VoidCallback? onTryAgainTap;
  final bool isRefresh;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: .min,
        crossAxisAlignment: .center,
        spacing: 5,
        children: [
          SizedBox(height: height),
          if (!isRefresh) Icon(Icons.error_outline, size: 40),
          Text(error, style: context.tt.titleMedium, textAlign: .center),
          if (onTryAgainTap != null)
            InkWell(
              onTap: onTryAgainTap,
              child: Text(
                isRefresh ? "refresh".tr() : "try_again".tr(),
                style: context.tt.titleLarge,
              ),
            ),
        ],
      ),
    );
  }
}

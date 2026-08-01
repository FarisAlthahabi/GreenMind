import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:green_mind/global/theme/theme_x.dart';
import 'package:green_mind/global/utils/constants.dart';

abstract class DropDownItemModel {
  String get displayName;
  int get id;
  String? get description;
}

class MainDropDownWidget<T extends DropDownItemModel> extends StatefulWidget {
  const MainDropDownWidget({
    super.key,
    required this.items,
    required this.text,
    this.offsetY = -5,
    required this.onChanged,
    this.focusNode,
    this.selectedValue,
    this.expandedHeight = 200,
    this.errorText,
    this.height,
    this.width,
    this.label,
    this.backgrounColor,
    this.borderRadius = AppConstants.borderRadius10,
    this.color,
    this.onClearTap,
    this.prefixIcon,
    this.hasSearch = true,
    this.displayName,
  });

  final List<T> items;
  final String text;
  final ValueSetter<T?> onChanged;
  final T? selectedValue;
  final double? expandedHeight;
  final String? errorText;
  final double offsetY;
  final FocusNode? focusNode;
  final double? height;
  final double? width;
  final String? label;
  final Color? backgrounColor;
  final BorderRadius borderRadius;
  final Color? color;
  final VoidCallback? onClearTap;
  final IconData? prefixIcon;
  final bool hasSearch;
  final String Function(T)? displayName;

  @override
  State<MainDropDownWidget<T>> createState() => _MainDropDownWidgetState<T>();
}

class _MainDropDownWidgetState<T extends DropDownItemModel>
    extends State<MainDropDownWidget<T>> {
  // T? selectedValue;
  late final ValueNotifier<T?> _selectedNotifier; // ✅ Add this
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _selectedNotifier = ValueNotifier<T?>(widget.selectedValue); // ✅ Initialize
    widget.onChanged(widget.selectedValue);
  }

  void _onChanged(T? value) {
    _selectedNotifier.value = value;
    widget.onChanged(value);
  }

  @override
  void dispose() {
    _selectedNotifier.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.items;
    final label = widget.label;
    final errorText = widget.errorText;
    final borderRadius = widget.borderRadius;

    return Focus(
      focusNode: widget.focusNode,
      onFocusChange: (_) => setState(() {}),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label != null)
            Padding(
              padding: AppConstants.paddingV5,
              child: Text(label, style: context.tt.titleMedium),
            ),
          DropdownButtonHideUnderline(
            child: DropdownButton2<T>(
              isExpanded: true,
              valueListenable: _selectedNotifier,
              // style: const TextStyle(
              //   color: AppColors.black,
              //   fontSize: 14,
              //   fontWeight: FontWeight.w400,
              //   height: 1.19,
              //   overflow: TextOverflow.ellipsis,
              // ),
              items: items.map((T item) {
                return DropdownItem<T>(
                  value: item, // ✅ الآن لا يوجد تكرار (حسب id)
                  child: Text(
                    widget.displayName?.call(item) ?? item.displayName,
                    style: const TextStyle(fontSize: 14),
                  ),
                );
              }).toList(),
              onChanged: _onChanged,
              dropdownStyleData: DropdownStyleData(
                maxHeight: widget.expandedHeight,
                width: widget.width,
                offset: Offset(0, widget.offsetY),
                decoration: BoxDecoration(borderRadius: borderRadius),
              ),
              dropdownSearchData: _buildSearchDataField(),
              customButton: Container(
                height: widget.height,
                padding: AppConstants.padding16,
                decoration: BoxDecoration(
                  color: widget.backgrounColor ?? context.cs.surfaceContainer,
                  border: Border.all(color: context.cs.outline, width: 0.5),
                  borderRadius: borderRadius,
                ),
                child: Row(
                  children: [
                    if (widget.prefixIcon != null) ...[
                      Icon(
                        widget.prefixIcon,
                        size: 20,
                        // color: widget.errorText == null
                        //     ? widget.color ?? AppColors.mainColorSecondary
                        //     : AppColors.red,
                      ),
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      child: Text(
                        _selectedNotifier.value?.displayName ?? widget.text
                        // selectedValue?.displayName ?? widget.text,
                        // style: TextStyle(
                        //   color: selectedValue != null
                        //       ? AppColors.black
                        //       : widget.errorText == null
                        //       ? widget.color ?? AppColors.greyShade
                        //       : AppColors.red,
                        //   fontSize: 20,
                        //   overflow: TextOverflow.ellipsis,
                        // ),
                      ),
                    ),
                    // if (selectedValue != null)
                    if (_selectedNotifier.value != null)
                      GestureDetector(
                        onTap: () => _onChanged(null),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4),
                          child: Icon(
                            Icons.close,
                            size: 20,
                            // color: AppColors.black,
                          ),
                        ),
                      ),
                    Icon(
                      Icons.keyboard_arrow_down,
                      // color: widget.color ?? context.cs.secondary,
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (errorText != null) ...[
            const SizedBox(height: 8),
            Padding(
              padding: AppConstants.paddingH8,
              child: Text(
                errorText,
                // style: const TextStyle(fontSize: 10, color: AppColors.red),
              ),
            ),
          ],
        ],
      ),
    );
  }

  DropdownSearchData<T>? _buildSearchDataField() {
    const bor = OutlineInputBorder(borderRadius: AppConstants.borderRadius15);
    if (widget.hasSearch) {
      return DropdownSearchData(
        searchController: _searchController,
        searchBarWidgetHeight: 50,
        searchBarWidget: Padding(
          padding: const EdgeInsets.all(8),
          child: TextFormField(
            controller: _searchController,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: AppConstants.paddingH10V8,
              hintText: "search".tr(),
              border: bor,
            ),
          ),
        ),
        searchMatchFn: (item, searchValue) {
          return item.value?.displayName.toLowerCase().contains(
                searchValue.toLowerCase(),
              ) ??
              false;
        },
      );
    }
    return null;
  }
}

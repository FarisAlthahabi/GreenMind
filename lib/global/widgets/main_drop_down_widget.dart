import 'package:collection/collection.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:green_mind/global/theme/theme_x.dart';
import 'package:green_mind/global/utils/constants.dart';

abstract class DropDownItemModel extends Equatable {
  String get displayName;
  int get id;
  String? get description;
}

// class MainDropDownWidget<T extends DropDownItemModel> extends StatefulWidget {
//   const MainDropDownWidget({
//     super.key,
//     required this.items,
//     required this.text,
//     this.offsetY = -5,
//     required this.onChanged,
//     this.focusNode,
//     this.selectedValue,
//     this.expandedHeight = 200,
//     this.errorText,
//     this.height,
//     this.width,
//     this.label,
//     this.backgrounColor,
//     this.borderRadius = AppConstants.borderRadius10,
//     this.prefixIcon,
//     this.hasSearch = true,
//     this.displayName,
//     this.textColor,
//   });

//   final List<T> items;
//   final String text;
//   final ValueSetter<T?> onChanged;
//   final T? selectedValue;
//   final double? expandedHeight;
//   final String? errorText;
//   final double offsetY;
//   final FocusNode? focusNode;
//   final double? height;
//   final double? width;
//   final String? label;
//   final Color? backgrounColor;
//   final Color? textColor;
//   final BorderRadius borderRadius;
//   final IconData? prefixIcon;
//   final bool hasSearch;
//   final String Function(T)? displayName;

//   @override
//   State<MainDropDownWidget<T>> createState() => _MainDropDownWidgetState<T>();
// }

// class _MainDropDownWidgetState<T extends DropDownItemModel>
//     extends State<MainDropDownWidget<T>> {
//   // T? selectedValue;
//   late final ValueNotifier<T?> _selectedNotifier; // ✅ Add this
//   late TextEditingController _searchController;

//   @override
//   void initState() {
//     super.initState();
//     _searchController = TextEditingController();
//     _selectedNotifier = ValueNotifier<T?>(widget.selectedValue); // ✅ Initialize
//   }

//   void _onChanged(T? value) {
//     _selectedNotifier.value = value;
//     widget.onChanged(value);
//   }

//   @override
//   void dispose() {
//     _selectedNotifier.dispose();
//     _searchController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final items = widget.items;
//     final label = widget.label;
//     final errorText = widget.errorText;
//     final borderRadius = widget.borderRadius;

//     return Focus(
//       focusNode: widget.focusNode,
//       onFocusChange: (_) => setState(() {}),
//       child: Column(
//         crossAxisAlignment: .start,
//         children: [
//           if (label != null)
//             Padding(
//               padding: AppConstants.paddingV5,
//               child: Text(label, style: context.tt.titleMedium),
//             ),
//           DropdownButtonHideUnderline(
//             child: DropdownButton2<T>(
//               isExpanded: true,
//               valueListenable: _selectedNotifier,
//               items: items.map((T item) {
//                 return DropdownItem<T>(
//                   value: item,
//                   child: Text(
//                     widget.displayName?.call(item) ?? item.displayName,
//                     style: context.tt.bodyMedium,
//                   ),
//                 );
//               }).toList(),
//               onChanged: _onChanged,
//               dropdownStyleData: DropdownStyleData(
//                 maxHeight: widget.expandedHeight,
//                 width: widget.width,
//                 offset: Offset(0, widget.offsetY),
//                 decoration: BoxDecoration(
//                   borderRadius: borderRadius,
//                   border: .all(width: 0.2, color: context.cs.onSurface),
//                 ),
//               ),
//               dropdownSearchData: _buildSearchDataField(),
//               customButton: Container(
//                 height: widget.height,
//                 padding: AppConstants.padding16,
//                 decoration: BoxDecoration(
//                   color: widget.backgrounColor ?? context.cs.surfaceContainer,
//                   border: .all(color: context.cs.outline, width: 0.5),
//                   borderRadius: borderRadius,
//                 ),
//                 child: Row(
//                   children: [
//                     if (widget.prefixIcon != null) ...[
//                       Icon(widget.prefixIcon, size: 20),
//                       const SizedBox(width: 12),
//                     ],
//                     Expanded(
//                       child: Text(
//                         _selectedNotifier.value?.displayName ?? widget.text,
//                         style: context.tt.bodyMedium?.copyWith(
//                           color: widget.textColor,
//                         ),
//                       ),
//                     ),
//                     // if (selectedValue != null)
//                     // if (_selectedNotifier.value != null)
//                     //   GestureDetector(
//                     //     onTap: () => _onChanged(null),
//                     //     child: const Padding(
//                     //       padding: EdgeInsets.symmetric(horizontal: 4),
//                     //       child: Icon(Icons.close, size: 20),
//                     //     ),
//                     //   ),
//                     Icon(Icons.keyboard_arrow_down),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           if (errorText != null) ...[
//             const SizedBox(height: 8),
//             Padding(padding: AppConstants.paddingH8, child: Text(errorText)),
//           ],
//         ],
//       ),
//     );
//   }

//   DropdownSearchData<T>? _buildSearchDataField() {
//     const bor = OutlineInputBorder(borderRadius: AppConstants.borderRadius15);
//     if (widget.hasSearch) {
//       return DropdownSearchData(
//         searchController: _searchController,
//         searchBarWidgetHeight: 50,
//         searchBarWidget: Padding(
//           padding: const EdgeInsets.all(8),
//           child: TextFormField(
//             controller: _searchController,
//             decoration: InputDecoration(
//               isDense: true,
//               contentPadding: AppConstants.paddingH10V8,
//               hintText: "search".tr(),
//               border: bor,
//             ),
//           ),
//         ),
//         searchMatchFn: (item, searchValue) {
//           return item.value?.displayName.toLowerCase().contains(
//                 searchValue.toLowerCase(),
//               ) ??
//               false;
//         },
//       );
//     }
//     return null;
//   }
// }

// Create a wrapper class
class DropdownOption<T extends DropDownItemModel> {
  final T? value;
  final String displayName;
  final bool isAllOption;

  const DropdownOption({
    this.value,
    required this.displayName,
    this.isAllOption = false,
  });

  factory DropdownOption.all({String displayName = "all"}) {
    return DropdownOption(
      value: null,
      displayName: displayName,
      isAllOption: true,
    );
  }

  factory DropdownOption.item(T item) {
    return DropdownOption(
      value: item,
      displayName: item.displayName,
      isAllOption: false,
    );
  }
}

// Update MainDropDownWidget to use DropdownOption
class MainDropDownWidget<T extends DropDownItemModel> extends StatefulWidget {
  const MainDropDownWidget({
    super.key,
    required this.items,
    required this.text,
    this.showAllOption = true,
    this.allOptionText = "all",

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
    this.prefixIcon,
    this.hasSearch = true,
    this.displayName,
    this.textColor,
  });

  final List<T> items;
  final bool showAllOption;
  final String allOptionText;
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
  final Color? textColor;
  final BorderRadius borderRadius;
  final IconData? prefixIcon;
  final bool hasSearch;
  final String Function(T)? displayName;

  @override
  State<MainDropDownWidget<T>> createState() => _MainDropDownWidgetState<T>();
}

class _MainDropDownWidgetState<T extends DropDownItemModel>
    extends State<MainDropDownWidget<T>> {
  late final ValueNotifier<DropdownOption<T>?> _selectedNotifier;
  late TextEditingController _searchController;
  late List<DropdownOption<T>> _dropdownOptions;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _dropdownOptions = _buildDropdownOptions();

    // final selectedOption = widget.selectedValue != null
    //     ? _dropdownOptions.firstWhere(
    //         (opt) => opt.value == widget.selectedValue,
    //         orElse: () => _dropdownOptions.first,
    //       )
    //     : _dropdownOptions.first;

    final selectedOption = _dropdownOptions.firstWhereOrNull(
      (opt) => opt.value == widget.selectedValue,
    );
    _selectedNotifier = ValueNotifier<DropdownOption<T>?>(selectedOption);
  }

  List<DropdownOption<T>> _buildDropdownOptions() {
    final options = <DropdownOption<T>>[];
    if (widget.showAllOption) {
      options.add(DropdownOption.all(displayName: widget.allOptionText.tr()));
    }
    options.addAll(widget.items.map(DropdownOption.item));
    return options;
  }

  void _onChanged(DropdownOption<T>? option) {
    // _selectedNotifier.value = option;
    setState(() {
      _selectedNotifier.value = option;
    });
    widget.onChanged(option?.value);
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = widget.borderRadius;
    return DropdownButtonHideUnderline(
      child: DropdownButton2<DropdownOption<T>>(
        isExpanded: true,
        valueListenable: _selectedNotifier,
        items: _dropdownOptions.map((option) {
          return DropdownItem<DropdownOption<T>>(
            value: option,
            child: Text(option.displayName, style: context.tt.bodyMedium),
          );
        }).toList(),
        onChanged: _onChanged,
        dropdownStyleData: DropdownStyleData(
          maxHeight: widget.expandedHeight,
          width: widget.width,
          offset: Offset(0, widget.offsetY),
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            border: .all(width: 0.2, color: context.cs.onSurface),
          ),
        ),
        dropdownSearchData: _buildSearchDataField(),
        customButton: Container(
          height: widget.height,
          padding: AppConstants.padding16,
          decoration: BoxDecoration(
            color: widget.backgrounColor ?? context.cs.surfaceContainer,
            border: Border.all(color: context.cs.outline, width: 0.5),
            borderRadius: widget.borderRadius,
          ),
          child: Row(
            children: [
              if (widget.prefixIcon != null) ...[
                Icon(widget.prefixIcon, size: 20),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Text(
                  _selectedNotifier.value?.displayName ?? widget.text,
                  style: context.tt.bodyMedium?.copyWith(
                    color: widget.textColor,
                  ),
                ),
              ),
              Icon(Icons.keyboard_arrow_down),
            ],
          ),
        ),
      ),
    );
  }

  // Update search to work with DropdownOption
  DropdownSearchData<DropdownOption<T>>? _buildSearchDataField() {
    if (!widget.hasSearch) return null;

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
            border: const OutlineInputBorder(
              borderRadius: AppConstants.borderRadius15,
            ),
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
}

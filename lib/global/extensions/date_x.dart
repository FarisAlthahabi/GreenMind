import 'package:easy_localization/easy_localization.dart';

extension DateX on DateTime {
  String get formatYYYYMMDD {
    return DateFormat('yyyy-MM-dd').format(this);
  }

  String get formatDDMMYYYY {
    return DateFormat('dd/MM/yyyy').format(this);
  }
}
import 'package:easy_localization/easy_localization.dart';

extension StringX on String {
  String get formatYYYYMMDD {
    final isAlreadyFormatted = RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(this);
    if (isAlreadyFormatted) return this;

    try {
      final parsedDate = DateTime.parse(this);
      return DateFormat('yyyy-MM-dd', 'en').format(parsedDate);
    } catch (e) {
      return this;
    }
  }

  String get formatYYYYMMDDHHmmss {
    try {
      final parsedDate = DateTime.parse(this);
      return DateFormat('yyyy-MM-dd-HH:mm:ss', 'en').format(parsedDate);
    } catch (e) {
      return this;
    }
  }
}

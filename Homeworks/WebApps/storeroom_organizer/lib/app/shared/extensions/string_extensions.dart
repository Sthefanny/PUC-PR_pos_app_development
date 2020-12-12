import 'package:flutter/foundation.dart';

extension StringExtension on String {
  bool isNotNullOrEmpty() {
    return this != null && isNotEmpty;
  }

  bool isNullOrEmpty() {
    return this == null || isEmpty;
  }

  String enumToString(EnumProperty enumProperty) {
    return enumProperty.toString().split('.').last;
  }
}

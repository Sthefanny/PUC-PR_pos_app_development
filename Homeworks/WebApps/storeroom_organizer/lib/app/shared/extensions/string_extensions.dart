import 'package:flutter/foundation.dart';

extension StringExtension on String {
  bool isNotNullOrEmpty() {
    return this != null && this.isNotEmpty;
  }

  bool isNullOrEmpty() {
    return this == null || this.isEmpty;
  }

  String enumToString(EnumProperty enumProperty) {
    return enumProperty.toString().split('.').last;
  }
}

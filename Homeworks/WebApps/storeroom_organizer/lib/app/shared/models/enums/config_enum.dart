import 'package:flutter/foundation.dart';

enum ConfigurationEnum {
  token,
  refreshToken,
  userData,
}

extension ConfigurationEnumToStr on ConfigurationEnum {
  String get toStr => describeEnum(this);
}

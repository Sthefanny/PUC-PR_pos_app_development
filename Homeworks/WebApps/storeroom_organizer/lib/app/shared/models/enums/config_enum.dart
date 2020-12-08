import 'package:flutter/foundation.dart';

enum ConfigurationEnum {
  token,
  refreshToken,
  userName,
}

extension ConfigurationEnumToStr on ConfigurationEnum {
  String get toStr => describeEnum(this);
}

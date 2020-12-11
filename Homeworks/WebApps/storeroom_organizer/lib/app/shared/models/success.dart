import 'package:flutter/foundation.dart';

class Success<T> {
  ///Parsed response returned object
  final T data;

  Success({@required this.data});
}

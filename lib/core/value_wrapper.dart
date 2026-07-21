import 'package:flutter/material.dart';

class ValueWrapper<T> extends ChangeNotifier {
  T _value;

  ValueWrapper(this._value);

  set value(T value) {
    _value = value;
    notifyListeners();
  }

  T get value => _value;
}

import 'package:flutter/material.dart';

class FormCtl {
  final Map<String, TextEditingController> _store = {};

  TextEditingController key(String k, {String? text}) {
    if (_store[k] == null) {
      _store[k] = TextEditingController(text: text);
    }
    return _store[k]!;
  }

  String getString(String k) {
    final ctl = key(k);
    return ctl.text;
  }

  void dispose() {
    _store.forEach((_, value) {
      value.dispose();
      _store.remove(value);
    });
  }

  void disposeKey(String k) {
    final ctl = _store[k];
    if (ctl == null) {
      return;
    }
    // ctl.dispose();
    _store.remove(k);
  }

  Map<String, String> values() {
    var data = <String, String>{};
    _store.forEach((key, value) {
      data[key] = value.text;
    });
    return data;
  }
}

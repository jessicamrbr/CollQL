import 'dart:convert';

import 'package:collql/collql.dart';

class MulModifier extends AritmeticFieldBasedModifier {
  dynamic defaultValue;

  MulModifier(super.selector, super.value, { this.defaultValue = 1 });

  @override
  void apply(Document doc) {
    dynamic newValue = (doc.get(selector) ?? defaultValue) * value;
    doc.set(selector, newValue);
  }

  @override
  toString() => jsonEncode({ "op": "replace", "_op": "mul", "path": selector, "_multiplier": value });
}
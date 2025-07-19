import 'dart:convert';

import 'package:collql/collql.dart';

class IncModifier extends AritmeticFieldBasedModifier {
  dynamic defaultValue;

  IncModifier(super.selector, super.value, { this.defaultValue = 0 });

  @override
  Document apply(Document doc) {
    dynamic newValue = (doc.get(selector) ?? defaultValue) + value;
    doc.set(selector, newValue);
    return doc;
  }

  @override
  toString() => jsonEncode({ "op": "replace", "_op": "inc", "path": selector, "_increment": value });
}
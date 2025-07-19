import 'dart:convert';

import 'package:collql/collql.dart';

class AddToSetModifier extends ListFieldBasedModifier {
  AddToSetModifier(String selector, dynamic value): super(selector, value, null);

  @override
  Document apply(Document doc) {
    final currentValue = doc.get(selector);
    final currentValueAsSet = ((currentValue != null && currentValue is List) ? currentValue : []).toSet();
    currentValueAsSet.add(value);
    final newValue = currentValueAsSet.toList();
    doc.set(selector, newValue);
    return doc;
  }

  @override
  toString() => jsonEncode({ "op": "add", "_op": "addToSet", "path": selector, "value": value });
}
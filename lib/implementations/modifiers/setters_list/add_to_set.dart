import 'dart:convert';

import 'package:collql/collql.dart';

class AddToSetModifier extends ListFieldBasedModifier {
  AddToSetModifier(String selector, dynamic value): super(selector, value, null);

  @override
  void apply(Document doc) {
    Set<dynamic> newValueAsSet = ((doc.get(selector) ?? []) as List).toSet();
    newValueAsSet.add(value);
    List<dynamic> newValue = newValueAsSet.toList();
    doc.set(selector, newValue);
  }

  @override
  toString() => jsonEncode({ "op": "add", "_op": "addToSet", "path": selector, "value": value });
}
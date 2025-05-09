import 'dart:convert';

import 'package:collql/collql.dart';

class MinModifier extends FieldBasedModifier with ConditionedFieldBasedModifier {
  MinModifier(super.selector, super.value);

  @override
  void apply(Document doc) {
    if(doc.get(selector) > value) doc.set(selector, value);
  }

  @override
  toString() => jsonEncode({ "op": "replace", "_op": "min", "path": selector, "value": value });
}
import 'dart:convert';

import 'package:collql/collql.dart';

class MaxModifier extends FieldBasedModifier with ConditionedFieldBasedModifier {
  MaxModifier(super.selector, super.value);

  @override
  void apply(Document doc) {
    if(doc.get(selector) < value) doc.set(selector, value);
  }

  @override
  toString() => jsonEncode({ "op": "replace", "_op": "max", "path": selector, "value": value });
}
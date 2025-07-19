import 'dart:convert';

import 'package:collql/collql.dart';

class SetModifier extends FieldBasedModifier {
  SetModifier(super.selector, super.value);

  @override
  Document apply(Document doc) {
    doc.set(selector, value);
    return doc;
  }

  @override
  toString() => jsonEncode({ "op": "replace", "_op": "set", "path": selector, "value": value });
}
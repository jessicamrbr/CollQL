import 'dart:convert';

import 'package:collql/collql.dart';

class UnsetModifier extends FieldBasedModifier {
  UnsetModifier(String selector): super(selector, null);

  @override
  void apply(Document doc) {
    doc.remove(selector);
  }

  @override
  toString() => jsonEncode({ "op": "remove", "_op": "unset", "path": selector });
}
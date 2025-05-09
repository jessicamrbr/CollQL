import 'dart:convert';

import 'package:collql/collql.dart';

class CurrentDateModifier extends FieldBasedModifier {
  CurrentDateModifier(String selector) : super(selector, null);

  @override
  void apply(Document doc) {
    doc.set(selector, DateTime.now().toIso8601String());
  }

  @override
  toString() => jsonEncode({ "op": "replace", "_op": "currentDate", "path": selector });
}
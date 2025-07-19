import 'dart:convert';

import 'package:collql/collql.dart';

class CurrentDateModifier extends FieldBasedModifier {
  CurrentDateModifier(String selector) : super(selector, null);

  @override
  Document apply(Document doc) {
    doc.set(selector, DateTime.utc(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      DateTime.now().hour - DateTime.now().timeZoneOffset.inHours,
      DateTime.now().minute,
      DateTime.now().second,
    ).toIso8601String());
    return doc;
  }

  @override
  toString() => jsonEncode({ "op": "replace", "_op": "currentDate", "path": selector });
}
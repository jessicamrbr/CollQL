import 'dart:convert';

import 'package:collql/collql.dart';

class PushModifier extends ListFieldBasedModifier {
  PushModifier(super.selector, super.value, super.position);

  @override
  Document apply(Document doc) {
    List<dynamic> listValue = (doc.get(selector) ?? []) as List;
    listValue.insert(position ?? ((doc.get(selector) ?? []) as List).length, value);
    doc.set(selector, listValue);
    return doc;
  }

  @override
  toString() => jsonEncode({ "op": "add", "_op": "push", "path": selector, "value": value, "_position": position });
}
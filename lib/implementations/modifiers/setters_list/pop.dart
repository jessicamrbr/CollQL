import 'dart:convert';

import 'package:collql/collql.dart';

class PopModifier extends ListFieldBasedModifier {
  PopModifier(String selector, int? position): super(selector, null, position);

  @override
  void apply(Document doc) {
    List<dynamic> listValue = (doc.get(selector) ?? []) as List;
    position = position ?? (listValue.length-1);
    listValue.removeAt(position!);
    doc.set(selector, listValue);
  }

  @override
  toString() => jsonEncode({ "op": "remove", "_op": "pop", "path": "$selector/$position" });
}
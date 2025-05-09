import 'dart:convert';

import 'package:collql/collql.dart';

class SortModifier extends ListFieldBasedModifier {
  SortModifier(String selector) : super(selector, null, null);

  @override
  void apply(Document doc) {
    List<dynamic> listValue = ((doc.get(selector) ?? []) as List);
    listValue.sort((a, b) => a.compareTo(b));
    doc.set(selector, listValue);
  }

  @override
  toString() => jsonEncode({ "op": "replace", "_op": "sort", "path": selector });
}
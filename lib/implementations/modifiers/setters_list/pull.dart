import 'dart:convert';

import 'package:collql/collql.dart';

class PullModifier extends ListFieldBasedModifier with ConditionedFieldBasedModifier {
  bool Function(dynamic) fnPredicate;
  PullModifier(String selector, this.fnPredicate) : super(selector, null, null);

  @override
  Document apply(Document doc) {
    List<dynamic> listValue = ((doc.get(selector) ?? []) as List);
    listValue.removeWhere(fnPredicate);
    doc.set(selector, listValue);
    return doc;
  }

  @override
  toString() => jsonEncode({ "op": "remove", "_op": "pull", "path": selector, "_predicate": fnPredicate });
}
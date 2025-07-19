import 'dart:convert';

import 'package:collql/collql.dart';

class RenameModifier extends FieldBasedModifier {
  RenameModifier(super.selector, super.value);

  @override
  Document apply(Document doc) {
    String selectorFrom = selector;
    String selectorTo = value;
    doc.move(selectorFrom, selectorTo);
    return doc;
  }

  @override
  toString() => jsonEncode({ "op": "move", "_op": "rename", "from": selector, "path": value });
}
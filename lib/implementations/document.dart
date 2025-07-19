import 'dart:convert';

import 'package:collql/abstractions/document.dart';
import 'package:json_schema/json_schema.dart';
import 'package:rfc_6901/rfc_6901.dart';
import 'package:uuid/uuid.dart';

class Document extends AbstractDocument 
  with IdUUIDV4, SelectorJsonPointer, JsonSchemaValidatorProperty 
{
  Document(super.data, {super.idPath = 'id'});
}

mixin IdUUIDV4 on AbstractDocument implements IdProperty {
  @override
  dynamic generateId() {
    if (internal[idPath] == null) {
      internal[idPath] = Uuid().v4();
    }
    return internal[idPath];
  }
}

mixin SelectorJsonPointer on AbstractDocument implements SelectorProperty {  
  @override
  T? get<T>(String selector, { T? defaultValue }) {
    try {
      selector = (selector.isEmpty || selector.substring(0, 1) != '/') ?  '/$selector' : selector;
      if (selector == '/') return internal as T;

      final pointer = JsonPointer(selector);
      return pointer.read(internal, orElse: () => defaultValue) as T?;
    } catch (e) {
      return null;
    }
  }

  @override
  void set(String selector, dynamic newValue) {
    selector = selector.substring(0, 1) != '/' ?  '/$selector' : selector;
    final pointer = JsonPointer(selector);
    internal = jsonDecode(jsonEncode(pointer.write(internal, newValue)));
  }

  @override
  void remove(Object? selector) {
    selector = selector as String;
    selector = selector.substring(0, 1) != '/' ?  '/$selector' : selector;
    final pointer = JsonPointer(selector);
    internal = jsonDecode(jsonEncode(pointer.remove(internal)));
  }

  @override
  dynamic operator [](Object? selector) => get(selector as String);

  @override
  void operator []=(String selector, dynamic newValue) => set(selector, newValue);
}

mixin JsonSchemaValidatorProperty on AbstractDocument implements ValidatorProperty {
  @override
  bool validate(String selector, String reference) {
    final jsonSchema = JsonSchema.create(reference);
    return jsonSchema.validate(get(selector)).isValid;
  }
}

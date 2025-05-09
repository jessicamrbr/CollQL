import 'dart:collection';
import 'dart:convert';

import 'package:collql/collql.dart';

abstract class AbstractDocument with MapMixin<String, dynamic> {
  /// Define the path to the document ID.
  String idPath;

  /// @nodoc
  Map<String, dynamic> internal;

  AbstractDocument(this.internal, {this.idPath = 'id'});

  /// Get the document ID.
  dynamic get id => get(idPath);

  /// Generate and return a new ID for the document.
  void generateId();

  /// Get a value from the document at the specified path selector.
  @override
  dynamic operator [](Object? selector) => get(selector as String);
  dynamic get(String selector, { dynamic defaultValue });

  @override
  Iterable<String> get keys => internal.keys;

  /// Get the type of the value at the specified path selector.
  String getType(String selector) => get(selector).runtimeType.toString();

  /// Set a value in the document at the specified path selector.
  void set(String selector, dynamic newValue);
  @override
  void operator []=(String selector, dynamic newValue) => set(selector, newValue);

  /// Add a new value to the document at the specified path selector.
  /// 
  /// This is a convenience alias method that calls [set] with the same selector and value.
  void add(String selector, dynamic newValue) => set(selector, newValue);

  /// Remove a value from the document at the specified path selector.
  @override
  void remove(Object? selector) { throw UnimplementedError('remove'); }

  @override
  void clear() { throw UnimplementedError('clear'); }

  /// Copy a value from one path to another in the document.
  void copy(String fromSelector, String toSelector) {
    final value = get(fromSelector);
    set(toSelector, value);
  }

  /// Move a value from one path to another in the document.
  void move(String fromSelector, String toSelector) {
    copy(fromSelector, toSelector);
    remove(fromSelector);
  }

  /// 
  List diff(String selector, Document doc) { throw UnimplementedError('diff'); }

  /// 
  void mergePatch(String selector, Document patch) { throw UnimplementedError('mergePath'); }

  /// Validate a value in the document at the specified path selector.
  /// 
  /// [reference] is the information used to validate, such as a JSON schema.
  /// It depends on the implementation of the document.
  bool validate(String selector, String reference);

  /// Get size information about the document.
  /// 
  /// [paths] is the number of paths in the document.
  /// [bytes] is the size of the document in bytes.
  ({int paths, int bytes}) sizeInfo() {
    return (
      paths: internal.length,
      // TODO: tipo especifico de gerenciamento de tamanho?
      bytes: utf8.encode(jsonEncode(internal, toEncodable: _toEncodable,)).length,
    );
  }

  /// Convert the document to Dart Map.
  Map<String, dynamic> toMap() => internal;

  /// Convert the document to a JSON string.
  Map<String, dynamic> toJsonMap() => jsonDecode(jsonEncode(internal, toEncodable: _toEncodable,));

  /// Convert the document to a JSON string.
  String toJsonString() => jsonEncode(internal, toEncodable: _toEncodable,);

  Object? _toEncodable(Object? obj) {
    if (obj is DateTime) return obj.toIso8601String();
    return obj;
  }
}

abstract interface class IdProperty {
  /// Generate and return a new ID for the document.
  void generateId();
}

abstract interface class SelectorProperty {
  dynamic get(String selector, { dynamic defaultValue });
  dynamic operator [](String selector) => get(selector);

  void set(String selector, dynamic newValue);
  void operator []=(String selector, dynamic newValue) => set(selector, newValue);
}

abstract interface class ValidatorProperty {
  bool validate(String selector, String reference);
}
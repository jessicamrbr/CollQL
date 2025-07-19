import 'dart:collection';
import 'package:collql/collql.dart';

import 'dart:collection';

class CollectionQL extends Object with ListMixin<Document> {
  final List<Document> _innerList;

  CollectionQL(List<Document>? initialData) : _innerList = initialData != null ? List<Document>.from(initialData) : [];

  @override
  int get length => _innerList.length;

  @override
  set length(int newLength) {
    _innerList.length = newLength;
  }

  @override
  Document operator [](int index) => _innerList[index];

  @override
  void operator []=(int index, Document value) {
    _innerList[index] = value;
  }

  CollectionQL fetch(Filter filter, {bool inplace = true}) {
    return CollectionQL(
      super
        .where((doc) => filter.apply(doc))
        .map((doc) => inplace ? doc : Document(doc.toJsonMap()))
        .toList()
    );
  }

  CollectionQL execute(Modifier modifier, Filter filter, {bool inplace = true}) {
    return CollectionQL(map<Document>((sourceDoc) {
      final doc = inplace ? sourceDoc : Document(sourceDoc.toJsonMap());
      return filter.apply(doc) ? modifier.apply(doc) : doc;
    }).toList());
  }
}
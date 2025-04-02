import 'dart:collection';

import 'package:collql/collql.dart';


abstract class Filter {
  bool apply(Document doc);

  Filter operator ~() {
    return NotFilter(this);
  }
  
  Filter not() {
    return NotFilter(this);
  }
}

abstract class CollQLFilter extends Filter {
  CollQLConfig? CollQLConfig;
  String? collectionName;
  bool objectFilter = false;

  Filter and(Filter filter) {
    return this & filter;
  }

  Filter or(Filter filter) {
    return this | filter;
  }

  Filter operator &(Filter other) {
    return and([this, other]);
  }

  Filter operator |(Filter other) {
    return or([this, other]);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CollQLFilter &&
          runtimeType == other.runtimeType &&
          toString() == other.toString();

  @override
  int get hashCode => toString().hashCode;
}




















Filter byId(CollQLId id) => EqualsFilter(docId, id.idValue);




abstract class StringFilter extends ComparableFilter {
  StringFilter(super.field, super.value);

  String get stringValue => value as String;
}

abstract class IndexOnlyFilter extends ComparableFilter {
  IndexOnlyFilter(super.field, super.value);
  
  String supportedIndexType();
  
  bool canBeGrouped(IndexOnlyFilter other);
}



// ################################ Stubs ####################################
class CollQLMapper {
}

class CollQLId {
  get idValue => null;
}

class Document {
  CollQLId get id => CollQLId();

  get(String field) {}

  dynamic operator [](Object? key) {    throw UnimplementedError();}
}

const docId = "_id";



class CollQLConfig {
  get CollQLMapper => null;
}

class DBNull {
  static var instance;
}

class IndexMap {
  get(Comparable value) {}

  lastKey() {}

  lowerKey(lastKey) {}

  ceilingKey(Comparable comparable) {}

  higherKey(ceilingKey) {}

  floorKey(Comparable comparable) {}

  firstKey() {}

  entries() {}
}

class TextTokenizer {
  tokenize(String searchString) {}
}

class CollQLMap<k, v> {  
  v? operator [](Object? key) {    throw UnimplementedError();}
  
  void operator []=(k key, v value) {  }
  
  void clear() {  }
  
  Iterable<k> get keys => throw UnimplementedError();
  
  v? remove(Object? key) {
    throw UnimplementedError();
  }

  entries() {}
}

Iterable<T> castList<T>($2) { return <T>[];}
compare(lastKey, Comparable comparable) {}
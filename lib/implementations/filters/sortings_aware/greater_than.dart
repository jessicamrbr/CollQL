import 'package:collql/collql.dart';

class GreaterThanFilter extends SortingAwareFilter {
  GreaterThanFilter(super.field, super.value);

  @override
  bool apply(Document doc) {
    var fieldValue = doc.get(field);
    if (fieldValue != null) {
      if (fieldValue is num && value is num) {
        return compare(fieldValue, value as num) > 0;
      } else if (fieldValue is Comparable) {
        return fieldValue.compareTo(value) > 0;
      } else {
        throw FilterException("$fieldValue is not comparable");
      }
    }
    return false;
  }

  @override
  Stream<dynamic> applyOnIndex(IndexMap indexMap) async* {
    if (isReverseScan) {
      var lastKey = await indexMap.lastKey();
      while (lastKey != null && compare(lastKey, value) > 0) {
        
        
        var val = await indexMap.get(lastKey);
        yield* yieldValues(val);
        lastKey = await indexMap.lowerKey(lastKey);
      }
    } else {
      var higherKey = await indexMap.higherKey(value);
      while (higherKey != null) {
        
        
        var val = await indexMap.get(higherKey);
        yield* yieldValues(val);
        higherKey = await indexMap.higherKey(higherKey);
      }
    }
  }

  @override
  toString() => "($field > $value)";
}
import 'package:collql/collql.dart';

class LesserEqualFilter extends SortingAwareFilter {
  LesserEqualFilter(super.field, super.value);

  @override
  bool apply(Document doc) {
    var fieldValue = doc.get(field);
    if (fieldValue != null) {
      if (fieldValue is num && value is num) {
        return compare(fieldValue, value as num) <= 0;
      } else if (fieldValue is Comparable) {
        return fieldValue.compareTo(value) <= 0;
      } else {
        throw FilterException("$fieldValue is not comparable");
      }
    }
    return false;
  }

  @override
  Stream<dynamic> applyOnIndex(IndexMap indexMap) async* {
    if (isReverseScan) {
      var floorKey = await indexMap.floorKey(value);
      while (floorKey != null) {
        
        
        var val = await indexMap.get(floorKey);
        yield* yieldValues(val);
        floorKey = await indexMap.lowerKey(floorKey);
      }
    } else {
      var firstKey = await indexMap.firstKey();
      while (firstKey != null && compare(firstKey, value) <= 0) {
        
        
        var val = await indexMap.get(firstKey);
        yield* yieldValues(val);
        firstKey = await indexMap.higherKey(firstKey);
      }
    }
  }

  @override
  toString() => "($field <= $value)";
}
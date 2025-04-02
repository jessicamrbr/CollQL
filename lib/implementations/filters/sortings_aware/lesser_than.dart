import 'package:collql/collql.dart';

class LesserThanFilter extends SortingAwareFilter {
  LesserThanFilter(super.field, super.value);

  @override
  bool apply(Document doc) {
    var fieldValue = doc.get(field);
    if (fieldValue != null) {
      if (fieldValue is num && value is num) {
        return compare(fieldValue, value as num) < 0;
      } else if (fieldValue is Comparable) {
        return fieldValue.compareTo(value) < 0;
      } else {
        throw FilterException("$fieldValue is not comparable");
      }
    }
    return false;
  }

  @override
  Stream<dynamic> applyOnIndex(IndexMap indexMap) async* {
    if (isReverseScan) {
      var lowerKey = await indexMap.lowerKey(value);
      while (lowerKey != null) {
        
        
        var val = await indexMap.get(lowerKey);
        yield* yieldValues(val);
        lowerKey = await indexMap.lowerKey(lowerKey);
      }
    } else {
      var firstKey = await indexMap.firstKey();
      while (firstKey != null && compare(firstKey, value) < 0) {
        
        
        var val = await indexMap.get(firstKey);
        yield* yieldValues(val);
        firstKey = await indexMap.higherKey(firstKey);
      }
    }
  }

  @override
  toString() => "($field < $value)";
}
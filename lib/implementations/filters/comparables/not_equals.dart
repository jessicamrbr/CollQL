import 'package:collql/collql.dart';
import 'package:collql/utils/utils.dart';

class NotEqualsFilter extends ComparableFilter with ApplicableToIndex {
  NotEqualsFilter(super.field, super.value);

  @override
  bool apply(Document doc) {
    var fieldValue = doc.get(field);
    return !deepEquals(fieldValue, value);
  }

  @override
  Stream<dynamic> applyOnIndex(IndexMap indexMap) async* {
    await for ((Comparable?, dynamic) entry in indexMap.entries()) {
      if (!deepEquals(value, entry.$1)) {
        yield* yieldValues(entry.$2);
      }
    }
  }

  @override
  toString() => "($field != $value)";
}
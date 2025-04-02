import 'package:collql/collql.dart';
import 'package:collql/utils/utils.dart';

class EqualsFilter extends FieldBasedFilter with ApplicableToIndex {
  EqualsFilter(super.field, super.value);

  @override
  bool apply(Document doc) {
    var fieldValue = doc.get(field);
    return deepEquals(fieldValue, value);
  }

  @override
  Stream<dynamic> applyOnIndex(IndexMap indexMap) async* {
    var val = await indexMap.get(value);
    if (val is List) {
      yield* Stream.fromIterable(val);
    } else if (val != null) {
      yield val;
    } else {
      yield* Stream.empty();
    }
  }

  @override
  toString() => "($field == $value)";
}
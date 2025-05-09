import 'package:collql/collql.dart';
import 'package:collql/utils/utils.dart';

class NotEqualsFilter extends ComparableFilter {
  NotEqualsFilter(super.field, super.value);

  @override
  bool apply(Document doc) {
    var fieldValue = doc.get(field);
    return !deepEquals(fieldValue, value);
  }
  
  @override
  toString() => "($field != $value)";
}
import 'package:collql/collql.dart';

class LesserThanFilter extends SortingAwareFilter {
  LesserThanFilter(super.field, super.value);

  @override
  bool apply(Document doc) {
    var fieldValue = doc.get(field);
    if (fieldValue != null) {
      if (fieldValue is Comparable) {
        return fieldValue.compareTo(value) < 0;
      } else {
        throw FilterException("$fieldValue is not comparable");
      }
    }
    return false;
  }

  @override
  toString() => "($field < $value)";
}
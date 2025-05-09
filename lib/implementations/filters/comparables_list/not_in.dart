import 'package:collql/collql.dart';

class NotInFilter extends ComparableInListFilter {
  final List<Comparable> _comparableSet = [];

  NotInFilter(String field, List<Comparable> values) : super(field, values) {
    _comparableSet.addAll(values);
  }

  @override
  bool apply(Document doc) {
    var fieldValue = doc.get(field);

    if (fieldValue is Comparable) {
      return !_comparableSet.contains(fieldValue);
    }
    return false;
  }

  @override
  toString() => "($field not in $value)";
}
import 'package:collql/collql.dart';

class InFilter extends ComparableInListFilter {
  final List<Comparable> _comparableSet = [];

  InFilter(String field, List<Comparable> values) : super(field, values) {
    _comparableSet.addAll(values);
  }

  @override
  bool apply(Document doc) {
    var fieldValue = doc.get(field);

    if (fieldValue is Comparable) {
      return _comparableSet.contains(fieldValue);
    }
    return false;
  }

  @override
  toString() => "($field in $value)";
}
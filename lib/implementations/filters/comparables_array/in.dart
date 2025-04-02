import 'package:collql/collql.dart';

class InFilter extends ComparableArrayFilter {
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

  Stream<dynamic> applyOnIndex(IndexMap indexMap) async* {
    await for ((Comparable?, dynamic) entry in indexMap.entries()) {
      if (_comparableSet.contains(entry.$1)) {
        yield* yieldValues(entry.$2);
      }
    }
  }

  @override
  toString() => "($field in $value)";
}
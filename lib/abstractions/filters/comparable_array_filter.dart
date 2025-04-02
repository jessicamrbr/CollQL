import 'package:collql/collql.dart';

abstract class ComparableArrayFilter extends FieldBasedFilter {
  ComparableArrayFilter(super.field, super.value);

  @override
  validateSearchTerm(CollQLMapper CollQLMapper, String field, dynamic value) {
    if (value is Iterable) {
      _validateFilterIterableField(value, field);
    }
  }

  void _validateFilterIterableField(Iterable value, String field) {
    for (var item in value) {
      if (item == null) continue;

      if (item is Iterable) {
        throw InvalidOperationException("Nested iterables are not supported");
      }

      if (item is! Comparable) {
        throw InvalidOperationException(
            "Each value for the iterable field '$field' must be comparable");
      }
    }
  }
}
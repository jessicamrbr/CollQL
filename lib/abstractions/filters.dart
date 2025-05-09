import 'package:collql/collql.dart';

/// The base definition for all filters.
abstract class Filter{
  bool apply(Document doc);

  Filter and(Filter filter) {
    return this & filter;
  }

  Filter or(Filter filter) {
    return this | filter;
  }

  Filter not() {
    return NotFilter(this);
  }

  Filter operator &(Filter other) {
    return AndFilter([this, other]);
  }

  Filter operator |(Filter other) {
    return OrFilter([this, other]);
  }

  Filter operator ~() {
    return NotFilter(this);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Filter &&
          runtimeType == other.runtimeType &&
          toString() == other.toString();

  @override
  int get hashCode => toString().hashCode;
}

/// This filter is used to create decision logic with anothers filters.
abstract class LogicalFilter extends Filter {
  List<Filter> filters;

  LogicalFilter(this.filters);
}

/// This filter is used to filter in fields with any value except null.
abstract class FieldBasedFilter extends Filter {
  String field;
  final dynamic value;

  FieldBasedFilter(this.field, this.value) : assert(field.isNotEmpty, "Field cannot be empty");

  validateSearchTerm(String field, dynamic value) {}
}

/// This filter is used to filter in fields that are comparable.
abstract class ComparableFilter extends FieldBasedFilter {
  ComparableFilter(super.field, Comparable super.value);
}

/// This filter is used to filter in fields that are iterables and contain comparable values.
abstract class ComparableInListFilter extends FieldBasedFilter {
  ComparableInListFilter(super.field, super.value);

  @override
  validateSearchTerm(String field, dynamic value) {
    if (value is Iterable) {
      for (var item in value) {
        if (item == null) continue;
        if (item is Iterable) throw FilterException("Nested iterables are not supported");
        if (item is! Comparable) throw FilterException("Each value for the iterable field '$field' must be comparable");
      }
    }
  }
}

/// This filter is used to filter in fields that are sorteable.
abstract class SortingAwareFilter extends ComparableFilter {
  SortingAwareFilter(super.field, super.value);

  bool isReverseScan = false;
}
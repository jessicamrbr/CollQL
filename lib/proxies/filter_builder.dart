import 'package:collql/collql.dart';

FilterBuilder where(FieldName field) => FilterBuilder(field);
Filter and(List<Filter> filters) => AndFilter(filters);
Filter or(List<Filter> filters) => OrFilter(filters);
Filter not(Filter filter) => NotFilter(filter);

class FilterBuilder {
  final FieldName field;

  FilterBuilder(this.field);
  Filter eq(dynamic value) => EqualsFilter(field, value);
  Filter gt(dynamic value) => GreaterThanFilter(field, value);
  Filter operator >(dynamic value) => GreaterThanFilter(field, value);
  Filter gte(dynamic value) => GreaterEqualFilter(field, value);
  Filter operator >=(dynamic value) => GreaterEqualFilter(field, value);
  Filter lt(dynamic value) => LesserThanFilter(field, value);
  Filter operator <(dynamic value) => LesserThanFilter(field, value);
  Filter lte(dynamic value) => LesserEqualFilter(field, value);
  Filter operator <=(dynamic value) => LesserEqualFilter(field, value);
  Filter within(List<Comparable> value) => InFilter(field, value);
  Filter notin(List<Comparable> value) => NotInFilter(field, value);
  Filter regex(String value) => RegexFilter(field, value);
  
  // Filter elemMatch(Filter filter) => ElementMatchFilter(field, filter);
}
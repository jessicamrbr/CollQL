import 'package:collql/collql.dart';

const FieldName rootSymbol = "\$";

FilterBuilder where(FieldName field) => FilterBuilder(field);

class FilterBuilder {
  final FieldName field;

  FilterBuilder(this.field);
  CollQLFilter eq(dynamic value) => EqualsFilter(field, value);
  CollQLFilter notEq(dynamic value) => NotEqualsFilter(field, value);
  CollQLFilter gt(dynamic value) => GreaterThanFilter(field, value);
  CollQLFilter gte(dynamic value) => GreaterEqualFilter(field, value);
  CollQLFilter lt(dynamic value) => LesserThanFilter(field, value);
  CollQLFilter lte(dynamic value) => LesserEqualFilter(field, value);
  CollQLFilter regex(String value) => RegexFilter(field, value);
  CollQLFilter within(List<Comparable> value) => InFilter(field, value);
  CollQLFilter notIn(List<Comparable> value) => NotInFilter(field, value);
  CollQLFilter elemMatch(Filter filter) => ElementMatchFilter(field, filter);
  CollQLFilter operator >(dynamic value) => GreaterThanFilter(field, value);
  CollQLFilter operator >=(dynamic value) => GreaterEqualFilter(field, value);
  CollQLFilter operator <(dynamic value) => LesserThanFilter(field, value);
  CollQLFilter operator <=(dynamic value) => LesserEqualFilter(field, value);
}
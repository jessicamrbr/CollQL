import 'package:collql/collql.dart';

extension FieldNameExt on FieldName {
  CollQLFilter eq(dynamic value) => where(this).eq(value);
  CollQLFilter notEq(dynamic value) => where(this).notEq(value);
  CollQLFilter gt(dynamic value) => where(this).gt(value);
  CollQLFilter operator >(dynamic value) => where(this).gt(value);
  CollQLFilter gte(dynamic value) => where(this).gte(value);
  CollQLFilter operator >=(dynamic value) => where(this).gte(value);
  CollQLFilter lt(dynamic value) => where(this).lt(value);
  CollQLFilter operator <(dynamic value) => where(this).lt(value);
  CollQLFilter lte(dynamic value) => where(this).lte(value);
  CollQLFilter operator <=(dynamic value) => where(this).lte(value);
  CollQLFilter between(Comparable lowerBound, Comparable upperBound,
      {upperInclusive = true, lowerInclusive = true}) => where(this).between(lowerBound, upperBound,
        upperInclusive: upperInclusive, lowerInclusive: lowerInclusive);
  CollQLFilter within(List<Comparable> values) => where(this).within(values);
  CollQLFilter notIn(List<Comparable> values) => where(this).notIn(values);
  CollQLFilter elemMatch(Filter filter) => where(this).elemMatch(filter);
  CollQLFilter text(String value) => where(this).text(value);
  CollQLFilter regex(String value) => where(this).regex(value);
}

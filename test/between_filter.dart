import 'package:collql/collql.dart';

class BetweenFilter<T> extends AndFilter {
  BetweenFilter(String field, Bound<T> bound)
      : super(<Filter>[_rhs(field, bound), _lhs(field, bound)]);

  static Filter _rhs<R>(String field, Bound<R> bound) {
    _validateBound(bound);
    R value = bound.upperBound;
    if (bound.upperInclusive) {
      return LesserEqualFilter(field, value as Comparable);
    } else {
      return LesserThanFilter(field, value as Comparable);
    }
  }

  static Filter _lhs<R>(String field, Bound<R> bound) {
    _validateBound(bound);
    R value = bound.lowerBound;
    if (bound.lowerInclusive) {
      return GreaterEqualFilter(field, value as Comparable);
    } else {
      return GreaterThanFilter(field, value as Comparable);
    }
  }

  static void _validateBound<R>(Bound<R> bound) {
    if (bound.upperBound is! Comparable || bound.lowerBound is! Comparable) {
      throw FilterException("Upper bound or lower bound value "
          "must be comparable");
    }
  }
}

class Bound<T> {
  T upperBound;
  T lowerBound;
  bool upperInclusive = true;
  bool lowerInclusive = true;

  Bound(this.upperBound, this.lowerBound,
      {this.upperInclusive = true, this.lowerInclusive = true});
}

class FilterBuilderWithBetween extends FilterBuilder {
  FilterBuilderWithBetween(super.field);

  Filter between(
    Comparable lowerBound, Comparable upperBound,
    {upperInclusive = true, lowerInclusive = true}
  ) =>
    BetweenFilter(
      field,
      Bound(upperBound, lowerBound, upperInclusive: upperInclusive, lowerInclusive: lowerInclusive),
    );
}

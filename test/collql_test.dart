import 'package:collql/collql.dart';
import 'package:test/test.dart';

import 'between_filter.dart';

void main() {
  group('Query Tests', () {
    test('Test match document. Simple filter in one property with FilterBuild', () {
      final doc = Document({
        'name': 'John',
        'age': 30,
        'city': 'New York',
      });
      final query = where('name').eq('John');
      assert(query.apply(doc) == true);
    });

    test('Simple filter in one property by String extension', () {
      final query = 'name'.notEq('John');

    });

    test('Composed filter in one property with logical filter (simple between)', () {
      final query = and([
        'age'.gte(18),
        'age'.lte(70)
      ]);

    });

    test('Custom filter in one property with FilterBuilderWithBetween', () {
      FilterBuilderWithBetween where(FieldName field) => FilterBuilderWithBetween(field);

      final query = where('age').between(18, 70);

    });
  });
}

class FilterBuilderWithBetween extends FilterBuilder {
  FilterBuilderWithBetween(super.field);

  CollQLFilter between(
    Comparable lowerBound, Comparable upperBound,
    {upperInclusive = true, lowerInclusive = true}
  ) =>
    BetweenFilter(
      field,
      Bound(upperBound, lowerBound, upperInclusive: upperInclusive, lowerInclusive: lowerInclusive),
    );
}
---
label: Querying
title: " "
order: 10000-100
---

## Introduction
Filters are used to test criteria on a document or a collection. They provide a way to specify the conditions that documents must meet to be included in the result set. Each filtering criterion is based on a property in the document and an assertion test.

## Fluent Language
CollQL is based on a fluent query language. It provides a global `where` method to start creating a filter. The `where` method takes the name of a field as an input parameter and returns a `Filter` object. The `Filter` object provides several methods to create different types of filters. Here is an example:

```dart
var filterProp = where('/name');
var filterEq = filterProp.eq('John');

filterEq.apply(document);
```

The code above creates a filter for the `name` property, then applies an equality test. The `apply` method will return true if the value of the name property in the document is equal to "John".

CollQL provides a `String` extension to create **access facilitators** for filters. It creates a filter based on the property name specified in the `String`. Changing the example above, we can use the `String` extension to create the filter:

```dart
'name'.eq('John').apply(document);
```

A third alternative is operator overloading to create filters. It creates a filter for the property name specified in the `String`. Example:

```dart
(where('age') > 18).apply(document);
// or //
('age' > 18).apply(document);
```

Valid operators in the `Filter` `String` extension.

| Operator | Description |
|----------|-------------|
| `>`      | Greater than filter |
| `>=`     | Greater than or equal filter |
| `<`      | Less than filter |
| `<=`     | Less than or equal filter |


## Filter Types
CollQL filters can be grouped into the following categories:

- Logical filters
- Comparison filters

### Logical Filters

Logical filters are used to combine multiple filters into a single filter. The following logical filters are supported:

| Operator | Description |
|----------|-------------|
| `and` or `&`  | Matches all documents that meet all specified filters. |
| `or` or `|` | Matches all documents that meet at least one of the specified filters. |
| `not` or `~` | Matches all documents that do not meet the specified filter. |

The following example shows some ways to use a logical filter:

```dart
final filter = where('name').eq('John').and('age').gt(18);
// or //
final filter = and([
  'name'.eq('John'),
  'age'.gt(18)
])
// or //
final filter = 'name'.eq('John') & 'age'.gt(18);
```

Querying through a list of criteria allows you to combine more than two filtering criteria. The chained format hierarchizes the criteria.

||| Hierarchy
`(name == 'John' and age > 18 and city == 'New York')`
||| Format
```dart
final filter = and([
  'name'.eq('John'),
  'age'.gt(18),
  'city'.eq('New York')
]);
```
|||

||| Hierarchy
`(name == 'John' and (age > 18 and city == 'New York'))`
||| Format
```dart
final filter = and([
  'name'.eq('John'),
  and([
    'age'.gt(18),
    'city'.eq('New York')
  ])
]);
```
|||

||| Hierarchy
`(name == 'John' and (age > 18 and city == 'New York'))`
||| Format
```dart
final filter = where('name').eq('John').and('age').gt(18).and('city').eq('New York');
```
|||

### Comparison Filters
Comparison filters are used to compare a property with a value. The following comparison filters are available:

| Operator | Description |
|----------|-------------|
| `eq` | Matches all documents where the property value is **equal** to the specified value. |
| `gt` | Matches all documents where the property value is **greater** than the specified value. |
| `gte` | Matches all documents where the property value is **greater than or equal** to the specified value. |
| `lt` | Matches all documents where the property value is **less** than the specified value. |
| `lte` | Matches all documents where the property value is **less than or equal** to the specified value. |
| `within` | Matches all documents where the property value is **within** a specified list. |
| `notin` | Matches all documents where the property value is **different** from all values specified in a list. |
| `regex` | Matches all documents where the property value matches a specified regular expression. |

Usage examples:

```dart
final filter = 'name'.eq('John');
// or //
final filter = where('age').gt(18);
// or //
final filter = where('color').within(['red', 'blue', 'green']);
// or //
final filter = where('name').regex(r'^[A-Z][a-z]+$');
```

## Extending Filters
You can extend filters to add new methods or functionalities. For example, you can create a custom filter that checks if a property is between specific values:

```dart
final filter = where('age').between(18, 50);
```

### Creating the Filter
To create a custom filter, you can extend the `Filter` class and add the desired method, or extend from an existing filter type. Here is an example of how to create a `between` filter:

```dart
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
```

### Extending Access Facilitators
To add the new `between` filter as an access facilitator, you can extend the `String` class and add the desired method. Here is an example of how to do this:

```dart
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
```
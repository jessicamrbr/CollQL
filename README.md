# CollQL
CollQL is a query builder in Dart inspired by the approaches of the Mingo and Nitrite libraries. Designed to work with collections in NoSQL databases – with potential to evolve to SQL support – CollQL allows you to build queries naturally and expressively, _**serving as an abstraction**_ for your data storage interface.

**WARNING:** In development, not yet functional.

## Features:
- Fluent Syntax: Build chained queries that read almost like natural language.
- Flexible Filters: Support for complex filters using logical and comparison operators, perfect for creating robust queries. _**You can extend the behavior and create your own filters**_.
- Collection-Oriented: Natively helps with collection manipulation, but you can use only the object structure and _**convert it to your repository's language**_.

## Usage Example

```Dart
final List<Map<String, dynamic>> collection = [
   { "name": "john", "age": 45 },
   { "name": "bob", "age": 21 },
   { "name": "alice", "age": 60 },
   { "name": "ted", "age": 10 }
];

// Match
final isMatch = where("name").eq("john").apply(collection[0]);
assert(isMatch == true);

// Query
final cursor = CollQL(collection, filter: and([
   where("age").gte(20),
   where("age").lte(50)
]);
assert(cursor == 2);
```

Check the test files and example directory for more examples.

## In Development
Index usage
// T = (r * f)
// T = ((log r) * f)

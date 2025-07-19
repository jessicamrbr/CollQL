# CollQL

A powerful and expressive Dart library for in-memory collection querying and manipulation, inspired by MongoDB. CollQL makes it easy to filter, update, and transform your data using a familiar, fluent API—perfect for Dart and Flutter projects.

[![pub package](https://img.shields.io/pub/v/collql.svg)](https://pub.dev/packages/collql)
[![GitHub stars](https://img.shields.io/github/stars/jessicamrbr/CollQL?style=social)](https://github.com/jessicamrbr/CollQL)

# Overview

CollQL is a Dart library inspired by MongoDB queries, designed for expressive and flexible in-memory collection manipulation and filtering.
- 🔍 **Filters**: Create complex queries using logical and comparison operators.
- ✏️ **Modifiers**: Update collections and documents with MongoDB-like operations.
- 🧩 **Extensions**: Utility methods to simplify usage with Dart collections.
- 🍰 **Proxies**: Builders for fluent construction of filters and modifiers.

For a comprehensive overview of all features, examples, and API references, please see the [official documentation](https://jessicamrbr.github.io/CollQL/).

# Getting Started

```dart
import 'package:collql/collql.dart';

final List<Document> data = [
  Document({'name': "john", 'age': 45}),
  Document({'name': "bob", 'age': 21}),
  Document({'name': "alice", 'age': 60}),
  Document({'name': "ted", 'age': 10}),
];

final filter = and([
  'age'.gte(18),
  'age'.lte(50)
]);

final List<Document> result = CollectionQL(data).fetch(filter).toList();
assert(result.length == 2); // true
```

## Quick Guide

### Documents
These are the basic data structure in CollQL. Each document is represented by an object containing key-value pairs, similar to a map or JSON object. [[Read more](/reference/00000-manipulating)]

```dart
import 'package:collql/collql.dart';

final doc = Document({
  "name": "John",
  "age": 30
});

assert(doc.get('/name') == "John"); // true
doc.set('/age', 31);
assert(doc.get('/age') == 31); // true
```

### Filters
Allow you to select documents from a collection or test values based on conditions. They are inspired by MongoDB operators. [[Read more](/reference/00100-filters)]

```dart
import 'package:collql/collql.dart';

final List<Document> data = [
  Document({'name': "john", 'age': 45}),
  // ... //
];

final query = and([
  'age'.gte(18),
  'age'.lte(50)
]);

assert(query.apply(data[0]) == true);  // true
```

Some operators: `eq`, `notEq`, `gt`, `gte`, `lt`, `lte`, `and`, `or`

### Modifiers
Allow you to update documents declaratively. [[Read more](/reference/00200-modifiers)]

```dart
import 'package:collql/collql.dart';

final List<Document> data = [
  Document({'name': "john", 'age': 45}),
  // ... //
];

final doc = Document({ "name": "john", "age": 45 });
final update = 'name'.rename('fullName');
update.apply(doc);
assert(doc.get('/name') == null); // true
assert(doc.get('/fullName') != null); // true
assert(data[0].get('/name') == doc.get('/fullName')); // true
```

Some modifiers: `get`, `set`, `unset`, `rename`, `push`, `pull`

## Credits
CollQL is inspired by [Nitrite](https://nitrite.dizitart.com/flutter-sdk/getting-started/index.html), and combines concepts from both
MongoDB and Dart's collection manipulation capabilities. It aims to provide a seamless and expressive way to work with in-memory data structures.

## License

CollQL is distributed under the MIT License, allowing you to use, modify, and distribute the library freely in your own projects. See the [LICENSE](LICENSE) file for details.
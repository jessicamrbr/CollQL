---
label: Manipulating
title: " "
order: 10000
---

## Documents
CollQL works with information organized into entities known as `Document`s. Each `Document` is structured as key-value pairs, similar to a **JavaScript** JSON or a **Dart** `Map<String, dynamic>`.

Consider the following document example:

```dart
final document = Document({
  "id": "550e8400-e29b-41d4-a716-446655440000",
  "name": "John",
  "age": 30,
  "contact": {
    "type": "email",
    "value": "john.doe@example.com"
  },
  "colors": [
    "red",
    "green",
  ]
});
```

In a `Document`, each property key must always be a non-null, non-empty `String` and cannot contain the sub-document wildcard delimiter. Every `Document` has a unique identifier, which can be provided or generated automatically. By default, the unique identifier is stored in the `id` property, but you can specify a different location using `idPath`.

```dart
final document = Document( 
    { 
        // ... //
    }, 
    idPath: '__id__'
);
```

`Document` is a very simple and flexible class, you can easily create your own implementation. Review the abstraction (*/lib/abstractions/document.dart*) and the default implementation (*/lib/implementations/document.dart*) to understand how it works.

In the following documentation, we will review the default behavior provided by `Document`.

### Automatically generating a unique document identifier
In the default implementation, `Document` uses UUID V4 as the unique identifier.

```dart
import 'package:collql/collql.dart';

final doc = Document({
  "name": "John",
  "age": 30,
}, idPath: '_id');

doc.generateId();
assert(doc.id != null); // true; e.g.: 550e8400-e29b-41d4-a716-446655440000
assert(doc.get("/_id") != null); // true
assert(doc.id == doc.get("/_id")); // true
```

### Reading and writing properties
To access or modify document properties, you can use the `get` and `set` methods. In the default implementation, you can use JSON Pointer for access.

```dart
final doc = Document({
  "id": "550e8400-e29b-41d4-a716-446655440000",
  "name": "John",
  "age": 30,
  "contact": {
    "type": "email",
    "value": "john.doe@example.com"
  },
  "colors": [
    "red",
    "green",
  ]
});

assert(doc.get("/contact/value") == "john.doe@example.com"); // true
assert(doc.get("/colors/0") == "red"); // true
doc.set("/age", 20);
assert(doc.get("/age") == 20); // true
```

If you wish, you can implement a custom property access version, for example, using `.` as a separator instead of JSON Pointer.

To remove a field, you can use the `remove` method.

```dart
doc.remove("/contact/type");
assert(doc.get("/contact/type") == null); // true
```

### Validating properties
You can validate document properties using the `validate` method, which accepts a path and a validation model reference.
In the default implementation, the model is defined as a JSON Schema.

```dart
final doc = Document({
  "name": "John",
  "age": 30,
});

final schema = '''{
  "\$schema": "http://json-schema.org/draft-07/schema#",
  "type": "object",
  "properties": {
    "name": {"type": "string"},
    "age": {"type": "integer", "minimum": 0}
  },
  "required": ["name", "age"]
}''';

assert(doc.validate("/", schema)); // true
```

### `Document` methods

| Method         | Description                                      | Default implementation |
|----------------|--------------------------------------------------|------------------------|
| `generateId()` | Generates a unique identifier for the document.  | UUID V4 |
| `id`           | Gets the unique identifier of the document.      | _ |
| `keys`         | Gets the document's property keys.               | _ |
| `get(path)`    | Gets the value of the specified property.        | JSON Pointer |
| `getType(path)`| Gets the type of the specified property.         | JSON Pointer |
| `set(path, value)` | Sets the value of the specified property.    | JSON Pointer |
| `add(path, value)` | Alias for `set`, with the same functionality.| JSON Pointer |
| `remove(path)` | Removes the specified property.                  | JSON Pointer |
| `copy(pathSource, pathTarget)` | Copies the value from one property to another. | JSON Pointer |
| `move(pathSource, pathTarget)` | Moves the value from one property to another. | JSON Pointer |
| `diff(path, Document)` | Gets the difference between a property and a document. | JSON Pointer |
| `mergePatch(path, Document)` | Copies attributes from a document to the specified location. | JSON Pointer |
| `validate(path, Reference)` | Validates the specified property against a reference model. | JSON Pointer + JSON Schema |
| `sizeInfo()`   | Returns information about the document size, number of properties, and estimated memory size `{paths: length, bytes: 400}`. | _ |
| `toMap()`      | Returns the document's internal map `Map<String, dynamic>`. | _ |
| `toJson()`     | Converts the document's internal map to a JSON map `Map<String, dynamic>` using Dart's `jsonEncode`. | jsonEncode |
| `toJsonString()` | Converts the document to a JSON map.           | jsonEncode |

## Collections
Collections are groups of documents that provide a way to organize and manage related documents. In CollQL, collections are represented by `CollectionQl` objects.

```dart
import 'package:collql/collql.dart';
final List<Document> data = [
  Document({'name': "john", 'age': 45}),
  Document({'name': "bob", 'age': 21}),
  Document({'name': "alice", 'age': 60}),
  Document({'name': "ted", 'age': 10}),
];
final collection = CollectionQl(data);
```

You can perform operations on collections, such as filters [[Read More](/reference/00100-filters)] and modifiers [[Read more](/reference/00200-modifiers)].

```dart
final result = collection.fetch(filter).toList();
// or
final result = collection.execute(modifier, filter).toList();
```
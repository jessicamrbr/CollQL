---
label: Updating
title: " "
order: 10000-200
---

## Introduction
Modifiers are used to update documents declaratively, allowing operations similar to those in MongoDB. They can be applied to individual documents or entire collections.

Modifiers can also be used in a fluent writing style. [Read more](/reference/00100-filters/#linguagem-fluente).

## Setters vs Modifiers
Modifiers work as a set of instructions that describe how data should be changed, without the need to specify a particular document.

```dart
// Setter
final doc = Document({'name': 'John', 'age': 30});
doc.set('/age', 31); // Update value in 'age' property from document

// Modifier
final update = 'name'.rename('fullName'); // Create a modifier to rename 'name' to 'fullName'
update.apply(doc);
```

The setter acts directly on the property of a single document, while the modifier describes the transformation that should be applied in the future to a document or a collection, and can also be combined with filters.

## Types of modifiers
CollQL modifiers can be grouped into the following categories:

- Value modifiers
- List modifiers
- Conditional modifiers

### Value modifiers
Value modifiers are used to change the value of a property. The following value modifiers are supported:

| Operator | Description |
|----------|-------------|
| `set` | Changes the value of a property. |
| `currentDate` | Sets the value of a property to the current date/time. |
| `inc` | Increments the value of a property by the specified amount. |
| `mul` | Multiplies the value of a property by the specified amount. |
| `rename` | Renames a property. |
| `unset` | Removes a property and its value. |

```dart
final modifier = 'name'.set('John');
// or //
final modifier = update('dueDate').currentDate();
```

### List modifiers
List modifiers are used to manipulate lists in a property. The following list modifiers are supported:

| Operator | Description |
|----------|-------------|
| `addToSet` | Adds a value to the end of a list if it is not already present. |
| `pop` | Removes the value from a list at the indicated position. If no position is indicated, removes the last value from the list. |
| `pull` | Removes values from a list that match a predicate. |
| `push` | Adds a value to a list at the indicated position. If no position is indicated, adds to the end of the list. |
| `sort` | Sorts the elements of a list. |

```dart
final modifier = 'colors'.push('red');
// or //
final modifier = update('positions').sort(18);
```

### Conditional modifiers
Conditional modifiers are used to change the value of a property based on a condition. The following conditional modifiers are supported:

| Operator | Description |
|----------|-------------|
| `max` | Sets the value of a property to the specified value if the specified value is greater than the current value. |
| `min` | Sets the value of a property to the specified value if the specified value is less than the current value. |

Usage examples:

```dart
final modifier = 'score'.max(100);
```

## Extending modifiers
You can create your own modifiers by extending the `Modifier` class. This allows you to add new functionality or modify the behavior of existing modifiers. See [Extending Filters](/reference/00100-filters/#extendendo-filtros) for an idea of how to create new modifiers.

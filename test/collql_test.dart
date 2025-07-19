import 'dart:convert';

import 'package:test/test.dart';
import 'package:collql/collql.dart';

import 'between_filter.dart';

void main() {
  group('Basic tests', () {
    test('Simple query in collection', () {
      final List<Document> data = [
        Document({'name': "john", 'age': 45}),
        Document({'name': "bob", 'age': 21}),
        Document({'name': "alice", 'age': 60}),
        Document({'name': "ted", 'age': 10})
      ];

      final filter = and([
        'age'.gte(18),
        'age'.lte(50)
      ]);

      final List<Document> result = CollectionQL(data).fetch(filter).toList();
      assert(result.length == 2);
    });

    test('Simple manipulation in Document', () {
      final doc = Document({
        "name": "John",
        "age": 30
      });

      assert(doc.get('/name') == "John");
      doc.set('/age', 31);
      assert(doc.get('/age') == 31);
    });

    test('Simple filter evaluation in Document', () {
      final List<Document> data = [
        Document({'name': "john", 'age': 45}),
      ];

      final query = and([
        'age'.gte(18),
        'age'.lte(50)
      ]);

      assert(query.apply(data[0]) == true);
    });

    test('Simple modifier evaluation in Document', () {
      final List<Document> data = [
        Document({'name': "john", 'age': 45}),
      ];

      final doc = Document({ "name": "john", "age": 45 });
      final update = 'name'.rename('fullName');
      update.apply(doc);
      assert(doc.get('/name') == null);
      assert(doc.get('/fullName') != null);
      assert(data[0].get('/name') == doc.get('/fullName'));
    });
  });

  group('Manipulating Documents tests', () {
    test('Generate ID for Document', () {
      final doc = Document({
        "name": "John",
        "age": 30,
      }, idPath: '_id');

      doc.generateId();
      assert(doc.id != null);
      assert(doc.get("/_id") != null);
      assert(doc.id == doc.get("/_id"));
    });

    test('Read and write values in Document', () {
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

      assert(doc.get("/contact/value") == "john.doe@example.com");
      assert(doc.get("/colors/0") == "red");

      doc.set("age", 20);
      assert(doc.get("age") == 20);

      doc.remove("/contact/type");
      assert(doc.get("/contact/type") == null); // true
    });

    test('Validation in Document', () {
      final doc = Document({
        "name": "John",
        "age": 30,
      });

      final doc2 = Document({
        "name": "John",
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

      assert(doc.validate("/", schema));
      assert(!doc2.validate("/", schema));
    });
  });
  group('Querying tests', () {
    final List<Document> sampleData = [
      Document({'name': "john", 'age': 45}),
      Document({'name': "bob", 'age': 21}),
      Document({'name': "alice1", 'age': 60}),
      Document({'name': "ted", 'age': 10})
    ];
    final sampleCollection = CollectionQL(sampleData);

    group('Logic Filters', () {
      test('And by long version', () {
        final List<Document> result = sampleCollection.fetch(and([
          where('age').gte(18),
          where('age').lte(50)
        ])).toList();
        assert(result.length == 2);
      });

      test('And by short (fluent) version', () {
        final List<Document> result = sampleCollection.fetch('age'.gte(18) & 'age'.lte(50)).toList();
        assert(result.length == 2);
      });

      test('Or by long version', () {
        final List<Document> result = sampleCollection.fetch(or([
          where('age').lte(18),
          where('age').gte(50)
        ])).toList();
        assert(result.length == 2);
      });

      test('Or by short (fluent) version', () {
        final List<Document> result = sampleCollection.fetch('age'.lte(18) | 'age'.gte(50)).toList();
        assert(result.length == 2);
      });

      test('Not by long version', () {
        final List<Document> result = sampleCollection.fetch(not(and([
          where('age').gte(18),
          where('age').lte(50)
        ]))).toList();
        assert(result.length == 2);
      });

      test('Not by short (fluent) version', () {
        final List<Document> result = sampleCollection.fetch(~('age'.gte(18) & 'age'.lte(50))).toList();
        assert(result.length == 2);
      });
    });

    group('Comparation Filters', () {
      test('Equality by long version', () {
        final List<Document> result = sampleCollection.fetch(where('age').eq(21)).toList();
        assert(result.length == 1);
      });

      test('Inequality by long version', () {
        final List<Document> result = sampleCollection.fetch(not(where('age').eq(21))).toList();
        assert(result.length == 3);
      });
  
      test('Inequality by short version', () {
        final List<Document> result = sampleCollection.fetch(~('age'.eq(21))).toList();
        assert(result.length == 3);
      });

      test('Greater than by long version', () {
        final List<Document> result = sampleCollection.fetch(where('age').gt(21)).toList();
        assert(result.length == 2);
      });

      test('Greater than by short version', () {
        final List<Document> result = sampleCollection.fetch('age' > 21).toList();
        assert(result.length == 2);
      });

      test('Greater than or equal by long version', () {
        final List<Document> result = sampleCollection.fetch(where('age').gte(21)).toList();
        assert(result.length == 3);
      });

      test('Greater than or equal by short version', () {
        final List<Document> result = sampleCollection.fetch('age' >= 21).toList();
        assert(result.length == 3);
      });

      test('Less than by long version', () {
        final List<Document> result = sampleCollection.fetch(where('age').lt(45)).toList();
        assert(result.length == 2);
      });

      test('Less than by short version', () {
        final List<Document> result = sampleCollection.fetch('age' < 45).toList();
        assert(result.length == 2);
      });

      test('Less than or equal by long version', () {
        final List<Document> result = sampleCollection.fetch(where('age').lte(45)).toList();
        assert(result.length == 3);
      });

      test('Less than or equal by short version', () {
        final List<Document> result = sampleCollection.fetch('age' <= 45).toList();
        assert(result.length == 3);
      });

      test('With In by long version', () {
        final List<Document> result = sampleCollection.fetch(where('age').within([21, 45])).toList();
        assert(result.length == 2);
      });

      test('Not In by long version', () {
        final List<Document> result = sampleCollection.fetch(not(where('age').notin([21, 45]))).toList();
        assert(result.length == 2);
      });

      test('Regex by long version', () {
        final List<Document> result = sampleCollection.fetch(where('name').regex(r'^[a-z]*$')).toList();
        assert(result.length == 3);
      });
    });
  });

  group('Extending tests', () {
    final List<Document> sampleData = [
      Document({'name': "john", 'age': 45}),
      Document({'name': "bob", 'age': 21}),
      Document({'name': "alice1", 'age': 60}),
      Document({'name': "ted", 'age': 10})
    ];
    final sampleCollection = CollectionQL(sampleData);

    test('Between by long version', () {
      FilterBuilderWithBetween filterBuilder = FilterBuilderWithBetween('age');
      final Filter filter = filterBuilder.between(18, 50);
      final List<Document> result = sampleCollection.fetch(filter).toList();
      assert(result.length == 2);
    });
  });

  group('Updating tests', () {
    group('Value Modifiers', () {
      final List<Document> sampleData = [
        Document({'name': "john", 'age': 45, 'lastUpdated': "2023-10-01T12:00:00.000Z"}),
        Document({'name': "bob", 'age': 21, 'lastUpdated': "2023-10-01T12:00:00.000Z"}),
      ];
      final sampleCollection = CollectionQL(sampleData);

      test('Set with Inplace disable by long version', () {
        final Modifier modifier = update('age').set(46);
        final Filter filter = where('name').eq("john");
        final List<Document> result = sampleCollection
          .execute(modifier, filter, inplace: false)
          .fetch(filter)
          .toList();

        assert(sampleCollection[0].get<String>('/name') == "john");
        assert(sampleCollection[0].get<int>('/age') == 45);

        assert(result[0].get<String>('/name') == "john");
        assert(result[0].get<int>('/age') == 46);
      });

      test('CurrentDate with Inplace disable by long version', () {
        final Modifier modifier = update('lastUpdated').currentDate();
        final Filter filter = where('name').eq("john");
        final List<Document> result = sampleCollection
          .execute(modifier, filter, inplace: false)
          .fetch(filter)
          .toList();

        assert(sampleCollection[0].get<String>('/lastUpdated') != result[0].get<String>('/lastUpdated'));
      });

      test('Inc with Inplace disable by long version', () {
        final Modifier modifier = update('age').inc(2);
        final Filter filter = where('name').eq("john");
        final List<Document> result = sampleCollection
          .execute(modifier, filter, inplace: false)
          .fetch(filter)
          .toList();

        assert(sampleCollection[0].get<int>('/age') == 45);
        assert(result[0].get<int>('/age') == 47);
      });

      test('Mul with Inplace disable by long version', () {
        final Modifier modifier = update('age').mul(2);
        final Filter filter = where('name').eq("bob");
        final List<Document> result = sampleCollection
          .execute(modifier, filter, inplace: false)
          .fetch(filter)
          .toList();

        assert(sampleCollection[1].get<int>('/age') == 21);
        assert(result[0].get<int>('/age') == 42);
      });

      test('Rename with Inplace disable by long version', () {
        final Modifier modifier = update('name').rename('fullName');
        final Filter filter = where('name').eq("john");
        final List<Document> result = sampleCollection
          .execute(modifier, filter, inplace: false)
          .toList();

        assert(sampleCollection[0].get<String>('/name') == "john");
        assert(result[0].get<String>('/fullName') == "john");
      });

      test('Unset with Inplace disable by long version', () {
        final Modifier modifier = update('age').unset();
        final Filter filter = where('name').eq("john");
        final List<Document> result = sampleCollection
          .execute(modifier, filter, inplace: false)
          .fetch(filter)
          .toList();

        assert(sampleCollection[0].get<int>('/age') == 45);
        assert(result[0].get<int?>('/age') == null);
      });
    });

    group('List Modifiers', () {
      final List<Document> sampleData = [
        Document({'name': "car", 'colors': <String>["red", "blue"]}),
        Document({'name': "bike", 'colors': <String>["green"]}),
      ];
      final sampleCollection = CollectionQL(sampleData);

      test('AddToSet with Inplace disable by long version', () {
        final Modifier modifier = update('colors').addToSet("yellow");
        final Filter filter = where('name').eq("car");
        final List<Document> result = sampleCollection
          .execute(modifier, filter, inplace: false)
          .execute(modifier, filter, inplace: false)
          .fetch(filter)
          .toList();

        assert(sampleCollection[0].get<List>('/colors')!.length == 2);
        assert(result[0].get<List>('/colors')!.length == 3);
        assert(result[0].get<List>('/colors')!.contains("yellow"));
      });

      test('Pop with Inplace disable by long version', () {
        final Modifier modifier = update('colors').pop(position: 0);
        final Filter filter = where('name').eq("car");
        final List<Document> result = sampleCollection
          .execute(modifier, filter, inplace: false)
          .fetch(filter)
          .toList();

        assert(sampleCollection[0].get<List>('/colors')!.length == 2);
        assert(result[0].get<List>('/colors')!.length == 1);
        assert(!result[0].get<List>('/colors')!.contains("red"));
      });

      test('Pull with Inplace disable by long version', () {
        final Modifier modifier = update('colors').pull((v) => v == "red");
        final Filter filter = where('name').eq("car");
        final List<Document> result = sampleCollection
          .execute(modifier, filter, inplace: false)
          .fetch(filter)
          .toList();

        assert(sampleCollection[0].get<List>('/colors')!.length == 2);
        assert(result[0].get<List>('/colors')!.length == 1);
        assert(!result[0].get<List>('/colors')!.contains("red"));
      });

      test('Push with Inplace disable by long version', () {
        final Modifier modifier = update('colors').push("yellow", position: 0);
        final Filter filter = where('name').eq("car");
        final List<Document> result = sampleCollection
          .execute(modifier, filter, inplace: false)
          .fetch(filter)
          .toList();

        assert(sampleCollection[0].get<List>('/colors')!.length == 2);
        assert(result[0].get<List>('/colors')!.length == 3);
        assert(result[0].get<List>('/colors')!.contains("yellow"));
      });

      test('Sort with Inplace disable by long version', () {
        final Modifier modifier = update('colors').sort();
        final Filter filter = where('name').eq("car");
        final List<Document> result = sampleCollection
          .execute(modifier, filter, inplace: false)
          .fetch(filter)
          .toList();

        assert(sampleCollection[0].get<List>('/colors')!.length == 2);
        assert(result[0].get<List>('/colors')!.length == 2);
        assert(result[0].get<List>('/colors')!.elementAt(0) == "blue");
      });
    });

    group('Conditional Modifiers', () {
      final List<Document> sampleData = [
        Document({'name': "john", 'age': 45, 'lastUpdated': "2023-10-01T12:00:00.000Z"}),
        Document({'name': "bob", 'age': 21, 'lastUpdated': "2023-10-01T12:00:00.000Z"}),
      ];
      final sampleCollection = CollectionQL(sampleData);

      test('Max with Inplace disable by long version', () {
        final Modifier modifier = update('age').max(50);
        final Filter filter = where('name').eq("john");
        final List<Document> result = sampleCollection
          .execute(modifier, filter, inplace: false)
          .fetch(filter)
          .toList();

        assert(sampleCollection[0].get<String>('/name') == "john");
        assert(sampleCollection[0].get<int>('/age') == 45);

        assert(result[0].get<String>('/name') == "john");
        assert(result[0].get<int>('/age') == 50);
      });

      test('Incorrect Max with Inplace disable by long version', () {
        final Modifier modifier = update('age').max(40);
        final Filter filter = where('name').eq("john");
        final List<Document> result = sampleCollection
          .execute(modifier, filter, inplace: false)
          .fetch(filter)
          .toList();

        assert(sampleCollection[0].get<String>('/name') == "john");
        assert(sampleCollection[0].get<int>('/age') == 45);

        assert(result[0].get<String>('/name') == "john");
        assert(result[0].get<int>('/age') == 45);
      });

      test('Min with Inplace disable by long version', () {
        final Modifier modifier = update('age').min(40);
        final Filter filter = where('name').eq("john");
        final List<Document> result = sampleCollection
          .execute(modifier, filter, inplace: false)
          .fetch(filter)
          .toList();

        assert(sampleCollection[0].get<String>('/name') == "john");
        assert(sampleCollection[0].get<int>('/age') == 45);

        assert(result[0].get<String>('/name') == "john");
        assert(result[0].get<int>('/age') == 40);
      });

      test('Incorrect Min with Inplace disable by long version', () {
        final Modifier modifier = update('age').min(50);
        final Filter filter = where('name').eq("john");
        final List<Document> result = sampleCollection
          .execute(modifier, filter, inplace: false)
          .fetch(filter)
          .toList();

        assert(sampleCollection[0].get<String>('/name') == "john");
        assert(sampleCollection[0].get<int>('/age') == 45);

        assert(result[0].get<String>('/name') == "john");
        assert(result[0].get<int>('/age') == 45);
      });
    });
  });
}
import 'package:collql/collql.dart';
import 'package:test/test.dart';

import 'between_filter.dart';

void main() {
  group('Query Tests', () {
    final List<Map<String, dynamic>> collection = [
      { "name": "john", "age": 45 },
      { "name": "bob", "age": 21 },
      { "name": "alice", "age": 60 },
      { "name": "ted", "age": 10 }
    ];

    test('Test match in a document. Simple filter on a property with FilterBuild', () {
      final doc = Document(collection[0]);
      final query = where('name').eq('john');
      assert(query.apply(doc) == true);
    });

    test('Composed filter in properties with logical filter', () {
      final doc = Document(collection[0]);
      final query = and([
        'age'.gte(18),
        'age'.lte(50)
      ]);
      assert(query.apply(doc) == true);
    });

    test('Custom filter in one property with FilterBuilderWithBetween', () {
      FilterBuilderWithBetween where(FieldName field) => FilterBuilderWithBetween(field);
      final doc = Document(collection[0]);
      final query = where('age').between(18, 70);
      assert(query.apply(doc) == true);
    });

    test('Simple update in one property', () {
      final doc = Document(collection[0]);
      final doc2 = Document({ "name": "Robert", "age": 45 });
      final update = 'name'.set('Robert');
      update.apply(doc);
      assert(doc.get('/name') == doc2.get('/name'));
      assert(doc.get('/age') == doc2.get('/age'));
    });

    test('Filter a collection', () {
      final query = and([
        'age'.gte(18),
        'age'.lte(50)
      ]);
      final col = CollectionQl(collection.map((m) => Document(m)).toList(), query);
      final res = col.execute();
      assert(res.length == 2);
    });
  });
}


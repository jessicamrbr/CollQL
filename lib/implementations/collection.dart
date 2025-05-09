import 'package:collql/collql.dart';

class CollectionQl {
  List<Document> documents = [];
  Filter filter;

  CollectionQl(this.documents, this.filter);

  List<Document> execute() {
    return documents.where((doc) => filter.apply(doc)).toList();
  }
}
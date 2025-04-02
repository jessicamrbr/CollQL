import 'package:collql/collql.dart';

class AndFilter extends LogicalFilter {
  AndFilter(super.filters) : assert(filters.length > 1);

  @override
  bool apply(Document doc) {
    for (var filter in filters) {
      if (!filter.apply(doc)) {
        return false;
      }
    }

    return true;
  }

  @override
  String toString() {
    StringBuffer buffer = StringBuffer();
    buffer.write("(");
    for (var i = 0; i < filters.length; i++) {
      if (i > 0) {
        buffer.write(" && ");
      }
      buffer.write(filters[i].toString());
    }
    buffer.write(")");
    return buffer.toString();
  }
}
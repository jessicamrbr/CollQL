import 'package:collql/collql.dart';

class NotFilter extends Filter {
  final Filter filter;

  NotFilter(this.filter);

  @override
  bool apply(Document element) {
    return !filter.apply(element);
  }

  @override
  String toString() => "!(${filter.toString()})";
}
import 'package:collql/collql.dart';

class NotFilter extends CollQLFilter {
  final Filter _filter;

  NotFilter(this._filter);

  @override
  bool apply(Document element) {
    return !_filter.apply(element);
  }

  @override
  String toString() => "!(${_filter.toString()})";
}
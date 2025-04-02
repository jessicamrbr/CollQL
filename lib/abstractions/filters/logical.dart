import 'package:collql/abstractions/filters/filter.dart';

abstract class LogicalFilter extends CollQLFilter {
  List<Filter> filters;

  LogicalFilter(this.filters);
}
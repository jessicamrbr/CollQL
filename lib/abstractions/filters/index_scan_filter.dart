import 'package:collql/collql.dart';

class IndexScanFilter {
  final Iterable<ComparableFilter> filters;

  IndexScanFilter(this.filters);
}
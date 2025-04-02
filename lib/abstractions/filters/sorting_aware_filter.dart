import 'package:collql/collql.dart';

abstract class SortingAwareFilter extends ComparableFilter {
  SortingAwareFilter(super.field, super.value);

  bool isReverseScan = false;
}
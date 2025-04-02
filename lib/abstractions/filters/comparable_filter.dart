import 'package:collql/collql.dart';

abstract class ComparableFilter extends FieldBasedFilter{
  ComparableFilter(super.field, Comparable super.value);
}
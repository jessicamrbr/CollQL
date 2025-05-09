import 'package:collql/collql.dart';

typedef FieldName = String;

class FilterOperation {
  static final and = FilterOperation(AndFilter([EqualsFilter('_', ''), EqualsFilter('_', '')]).name);
  static final or = FilterOperation(OrFilter([EqualsFilter('_', ''), EqualsFilter('_', '')]).name);
  static final not = FilterOperation(NotFilter(EqualsFilter('_', '')).name);

  static final eq = FilterOperation(EqualsFilter ('_', '').name);
  static final gt = FilterOperation(GreaterThanFilter('_', '').name);
  static final gte = FilterOperation(GreaterEqualFilter('_', '').name);
  static final lt = FilterOperation(LesserThanFilter('_', '').name);
  static final lte = FilterOperation(LesserEqualFilter('_', '').name);
  static final within = FilterOperation(InFilter('_', []).name);
  static final notIn = FilterOperation(NotInFilter('_', []).name);
  static final regex = FilterOperation(RegexFilter('_', '').name);

  final String _name;

  const FilterOperation(this._name);

  String get name => _name;
}
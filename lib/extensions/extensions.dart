
import 'package:collql/collql.dart';

extension FieldNameExt on FieldName {
  Filter eq(dynamic value) => where(this).eq(value);
  Filter gt(dynamic value) => where(this).gt(value);
  Filter operator >(dynamic value) => where(this).gt(value);
  Filter gte(dynamic value) => where(this).gte(value);
  Filter operator >=(dynamic value) => where(this).gte(value);
  Filter lt(dynamic value) => where(this).lt(value);
  Filter operator <(dynamic value) => where(this).lt(value);
  Filter lte(dynamic value) => where(this).lte(value);
  Filter operator <=(dynamic value) => where(this).lte(value);
  Filter within(List<Comparable> values) => where(this).within(values);
  Filter notIn(List<Comparable> values) => where(this).notin(values);
  Filter regex(String value) => where(this).regex(value);
  // Filter elemMatch(Filter filter) => ElementMatchFilter(field, filter);

  Modifier set(dynamic value) => update(this).set(value);
  Modifier currentDate() => update(this).currentDate();
  Modifier inc(dynamic value, { dynamic defaultValue = 0 }) => update(this).inc(value, defaultValue: defaultValue);
  Modifier mul(dynamic value, { dynamic defaultValue = 0 }) => update(this).mul(value, defaultValue: defaultValue);
  Modifier rename(FieldName newField) => update(this).rename(newField);
  Modifier unset() => update(this).unset();
  Modifier addToSet(dynamic value) => update(this).addToSet(value);
  Modifier pop({ int? position }) => update(this).pop(position: position);
  Modifier pull(bool Function(dynamic) fnPredicate) => update(this).pull(fnPredicate);
  Modifier push(dynamic value, { int? position }) => update(this).push(value, position: position);
  Modifier sort() => update(this).sort();
  Modifier max(dynamic value) => update(this).max(value);
  Modifier min(dynamic value) => update(this).min(value);
}

extension FilterExt on Filter {
  String get name => runtimeType.toString();
}
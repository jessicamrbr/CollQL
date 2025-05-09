import 'package:collql/collql.dart';

ModifierBuilder update(FieldName field) => ModifierBuilder(field);

class ModifierBuilder {
  final FieldName field;

  ModifierBuilder(this.field);
  Modifier set(dynamic value) => SetModifier(field, value);
  Modifier currentDate() => CurrentDateModifier(field);
  Modifier inc(dynamic value, { dynamic defaultValue = 0 }) => IncModifier(field, value, defaultValue: defaultValue);
  Modifier mul(dynamic value, { dynamic defaultValue = 0 }) => MulModifier(field, value, defaultValue: defaultValue);
  Modifier rename(FieldName newField) => RenameModifier(field, newField);
  Modifier unset() => UnsetModifier(field);
  Modifier addToSet(dynamic value) => AddToSetModifier(field, value);
  Modifier pop({ int? position }) => PopModifier(field, position);
  Modifier pull(bool Function(dynamic) fnPredicate) => PullModifier(field, fnPredicate);
  Modifier push(dynamic value, { int? position }) => PushModifier(field, value, position);
  Modifier sort() => SortModifier(field);
  Modifier max(dynamic value) => MaxModifier(field, value);
  Modifier min(dynamic value) => MinModifier(field, value);
}
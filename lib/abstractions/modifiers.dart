import 'package:collql/implementations/document.dart';

abstract class Modifier {
  Document apply(Document doc);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Modifier &&
          runtimeType == other.runtimeType &&
          toString() == other.toString();

  @override
  int get hashCode => toString().hashCode;
}

abstract class FieldBasedModifier extends Modifier {
  String selector;
  final dynamic value;

  FieldBasedModifier(this.selector, this.value) : assert(selector.isNotEmpty, "Selector cannot be empty");

  validateSearchTerm(String field, dynamic value) {}
}

abstract class AritmeticFieldBasedModifier extends FieldBasedModifier {
  AritmeticFieldBasedModifier(super.selector, super.value);
}

mixin ConditionedFieldBasedModifier on FieldBasedModifier { }

abstract class ListFieldBasedModifier extends FieldBasedModifier {
  int? position;

  ListFieldBasedModifier(super.selector, super.value, this.position);
}

mixin ConditionedListFieldBasedModifier on ListFieldBasedModifier { }

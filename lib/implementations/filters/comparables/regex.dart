import 'package:collql/collql.dart';

class RegexFilter extends FieldBasedFilter {
  final RegExp _pattern;

  RegexFilter(super.field, String super.value) : _pattern = RegExp(value);

  @override
  bool apply(Document doc) {
    var fieldValue = doc.get(field);

    if (fieldValue is! String) {
      throw FilterException("Regex filter can not be applied on "
          "non string field $field");
    }

    return _pattern.hasMatch(fieldValue);
  }
}
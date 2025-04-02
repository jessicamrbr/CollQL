import 'package:collql/collql.dart';

abstract class FieldBasedFilter extends CollQLFilter {
  String field;
  dynamic _value;
  bool _processed = false;

  FieldBasedFilter(this.field, this._value) 
    : assert(field.isNotEmpty, "Field cannot be empty");
  
  dynamic get value {
    if (_processed) return _value;
    if (_value == null) return null;

    if (objectFilter) {
      var mapper = CollQLConfig.CollQLMapper;
      validateSearchTerm(mapper, field, _value);
      if (_value is Comparable && _value is! DBNull) {
        _value = mapper.tryConvert<dynamic, Comparable>(_value);
      }
    }

    _processed = true;
    return _value;
  }
  
  void validateSearchTerm(CollQLMapper CollQLMapper, String field, dynamic value) {}
  
  Stream<dynamic> yieldValues(dynamic value) async* {
    if (value is List) {
      yield* Stream.fromIterable(value);
    } else if (value is Map) {
      yield value;
    }
  }
}
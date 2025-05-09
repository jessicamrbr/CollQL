// import 'package:collql/collql.dart';

// class ElementMatchFilter extends CollQLFilter {
//   final String _field;
//   final Filter _elementFilter;

//   ElementMatchFilter(this._field, this._elementFilter);

//   @override
//   bool apply(Document doc) {
//     if (_elementFilter is ElementMatchFilter) {
//       throw FilterException("Nested elemMatch filter is not supported");
//     }

//     if (_elementFilter is TextFilter) {
//       throw FilterException("Text filter is not supported in elemMatch filter");
//     }

//     var fieldValue = doc.get(_field);
//     if (fieldValue == null) return false;

//     if (fieldValue is Iterable) {
//       return _matches(fieldValue, _elementFilter);
//     } else {
//       throw FilterException("elemMatch filter only applies to iterables");
//     }
//   }

//   @override
//   String toString() => "elemMatch($_field : $_elementFilter)";

//   bool _matches(Iterable iterable, Filter filter) {
//     for (var element in iterable) {
//       if (_matchElement(element, filter)) {
//         return true;
//       }
//     }
//     return false;
//   }

//   bool _matchElement(dynamic element, Filter filter) {
//     if (filter is AndFilter) {
//       var filters = filter.filters;
//       for (var subFilter in filters) {
//         if (!_matchElement(element, subFilter)) {
//           return false;
//         }
//       }
//       return true;
//     } else if (filter is OrFilter) {
//       var filters = filter.filters;
//       for (var subFilter in filters) {
//         if (_matchElement(element, subFilter)) {
//           return true;
//         }
//       }
//       return false;
//     } else if (filter is NotFilter) {
//       var not = filter._filter;
//       return !_matchElement(element, not);
//     } else if (filter is EqualsFilter) {
//       return _matchEquals(element, filter);
//     } else if (filter is GreaterEqualFilter) {
//       return _matchGreaterEqual(element, filter);
//     } else if (filter is GreaterThanFilter) {
//       return _matchGreater(element, filter);
//     } else if (filter is LesserEqualFilter) {
//       return _matchLesserEqual(element, filter);
//     } else if (filter is LesserThanFilter) {
//       return _matchLesser(element, filter);
//     } else if (filter is InFilter) {
//       return _matchIn(element, filter);
//     } else if (filter is NotInFilter) {
//       return _matchNotIn(element, filter);
//     } else if (filter is RegexFilter) {
//       return _matchRegex(element, filter);
//     } else {
//       throw FilterException("Unsupported filter type in elemMatch: "
//           "${filter.runtimeType}");
//     }
//   }

//   bool _matchEquals(dynamic element, EqualsFilter filter) {
//     var value = filter.value;
//     if (element is Document) {
//       var docValue = element[filter.field];
//       return deepEquals(value, docValue);
//     } else {
//       return deepEquals(value, element);
//     }
//   }

//   bool _matchGreater(dynamic element, GreaterThanFilter filter) {
//     var comparable = filter.comparable;

//     if (element is num && comparable is num) {
//       return compare(element, comparable) > 0;
//     } else if (element is Comparable) {
//       return element.compareTo(comparable) > 0;
//     } else if (element is Document) {
//       var docValue = element[filter.field];
//       if (docValue is Comparable) {
//         return docValue.compareTo(comparable) > 0;
//       } else {
//         throw FilterException("${filter.field} is not comparable");
//       }
//     } else {
//       throw FilterException("$element is not comparable");
//     }
//   }

//   bool _matchGreaterEqual(dynamic element, GreaterEqualFilter filter) {
//     var comparable = filter.comparable;

//     if (element is num && comparable is num) {
//       return compare(element, comparable) >= 0;
//     } else if (element is Comparable) {
//       return element.compareTo(comparable) >= 0;
//     } else if (element is Document) {
//       var docValue = element[filter.field];
//       if (docValue is Comparable) {
//         return docValue.compareTo(comparable) >= 0;
//       } else {
//         throw FilterException("${filter.field} is not comparable");
//       }
//     } else {
//       throw FilterException("$element is not comparable");
//     }
//   }

//   bool _matchLesserEqual(dynamic element, LesserEqualFilter filter) {
//     var comparable = filter.comparable;

//     if (element is num && comparable is num) {
//       return compare(element, comparable) <= 0;
//     } else if (element is Comparable) {
//       return element.compareTo(comparable) <= 0;
//     } else if (element is Document) {
//       var docValue = element[filter.field];
//       if (docValue is Comparable) {
//         return docValue.compareTo(comparable) <= 0;
//       } else {
//         throw FilterException("${filter.field} is not comparable");
//       }
//     } else {
//       throw FilterException("$element is not comparable");
//     }
//   }

//   bool _matchLesser(dynamic element, LesserThanFilter filter) {
//     var comparable = filter.comparable;

//     if (element is num && comparable is num) {
//       return compare(element, comparable) < 0;
//     } else if (element is Comparable) {
//       return element.compareTo(comparable) < 0;
//     } else if (element is Document) {
//       var docValue = element[filter.field];
//       if (docValue is Comparable) {
//         return docValue.compareTo(comparable) < 0;
//       } else {
//         throw FilterException("${filter.field} is not comparable");
//       }
//     } else {
//       throw FilterException("$element is not comparable");
//     }
//   }

//   bool _matchIn(dynamic element, InFilter filter) {
//     var values = filter._comparableSet;
//     if (element is Document) {
//       var docValue = element[filter.field];
//       if (docValue is Comparable) {
//         return values.contains(docValue);
//       }
//     } else if (element is Comparable) {
//       return values.contains(element);
//     }
//     return false;
//   }

//   bool _matchNotIn(dynamic element, NotInFilter filter) {
//     var values = filter._comparableSet;
//     if (element is Document) {
//       var docValue = element[filter.field];
//       if (docValue is Comparable) {
//         return !values.contains(docValue);
//       }
//     } else if (element is Comparable) {
//       return !values.contains(element);
//     }
//     return false;
//   }

//   bool _matchRegex(dynamic element, RegexFilter filter) {
//     var value = filter.value;
//     if (element is String) {
//       var regExp = RegExp(value);
//       return regExp.hasMatch(element);
//     } else if (element is Document) {
//       var docValue = element[filter.field];
//       if (docValue is String) {
//         var regExp = RegExp(value);
//         return regExp.hasMatch(docValue);
//       } else {
//         throw FilterException("${filter.field} is not a string");
//       }
//     } else {
//       throw FilterException("$element is not a string");
//     }
//   }
// }
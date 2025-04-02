import 'package:collql/abstractions/filters/filter.dart';

extension ListExt on List<Filter>? {
  void throwIfNullOrEmpty(String msg) => this?.isNotEmpty ?? false;
}

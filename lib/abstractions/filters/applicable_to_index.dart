import 'package:collql/collql.dart';

mixin ApplicableToIndex on Filter {
  Stream<dynamic> applyOnIndex(IndexMap indexMap);
}
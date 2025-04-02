extension StringExt on String? {
  bool get notNullOrEmpty => this?.isNotEmpty ?? false;
}
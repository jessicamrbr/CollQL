bool deepEquals(value, other) {
    if (value == other) return true;
  if (value is Map && other is Map) {
    if (value.length != other.length) return false;
    for (var key in value.keys) {
      if (!other.containsKey(key) || !deepEquals(value[key], other[key])) {
        return false;
      }
    }
    return true;
  }
  if (value is List && other is List) {
    if (value.length != other.length) return false;
    for (var i = 0; i < value.length; i++) {
      if (!deepEquals(value[i], other[i])) return false;
    }
    return true;
  }
  if (value is Set && other is Set) {
    return value.length == other.length &&
        value.every((element) => other.contains(element));
  }
  if (value is String && other is String) {
    return value == other;
  }
  if (value is num && other is num) {
    return value == other;
  }
  if (value is bool && other is bool) {
    return value == other;
  }
  // Add more checks for other types as needed
  return false;
}
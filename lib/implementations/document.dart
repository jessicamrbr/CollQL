class Document {
  final Map<String, dynamic> _data;

  Document(this._data);

  dynamic get(String key) {
    return _data[key];
  }

  void set(String key, dynamic value) {
    _data[key] = value;
  }

  @override
  String toString() {
    return _data.toString();
  }
}
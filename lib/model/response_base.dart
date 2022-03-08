class ResponseData<T> {
  ResponseData({required this.data, T Function(Map<String, dynamic> json)? decode})
      : code = data['code'] as int,
        _obj = _tryDecode(decode, data),
        msg = data['msg'] as String;

  static T? _tryDecode<T>(T Function(Map<String, dynamic> json)? decode, Map<String, dynamic> data) {
    if (decode != null) {
      try {
        return decode(data['data']);
      } on Error catch (e) {
        data['msg'] = 'local parse error($e);' + (data['msg'] ?? '');
        print(data['msg']);
        return null;
      } on Exception catch (e) {
        data['msg'] = 'local parse error($e);' + (data['msg'] ?? '');
        print(data['msg']);
        return null;
      }
    }
  }

  int code;
  Map<String, dynamic> data;
  T? _obj;

  T get obj {
    return _obj!; // if not decode , exception raise
  }

  String? msg;
}

List<T> getListFromJson<T>(Map<String, dynamic> json, String name, T Function(dynamic) fn) {
  final ret = <T>[];
  for (final jsonBid in json[name] as List) {
    ret.add(fn(jsonBid));
  }
  return ret;
}

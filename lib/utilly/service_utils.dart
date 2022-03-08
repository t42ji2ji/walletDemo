import 'package:crypto_wallet/config/config.dart';
import 'package:crypto_wallet/model/response_base.dart';
import 'package:dio/dio.dart';

Uri targetPath(String apiPath) {
  final host = Config().apiHost;
  final apiBasePath = Config().apiBasePath;
  final uri = '$host$apiBasePath$apiPath';
  print(uri);
  return Uri.parse(uri);
}

ResponseData<T> apiResponse<T>(Response response, T Function(Map<String, dynamic> json) objFromJson) {
  return ResponseData(
    data: {
      'code': response.statusCode!,
      'msg': response.statusMessage,
      'data': response.data,
    },
    decode: objFromJson,
  );
}

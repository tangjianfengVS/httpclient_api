

import 'dart:io';

enum URLMethod {
  GET,
  POST,
}

typedef APIWillRequestHandler = void Function(HttpClientRequest request);

typedef APISuccessResponseHandler = void Function(Map<String, dynamic> response);

typedef APIFailureResponseHandler = void Function(int code, String message, String rawResponseString);

/// url 错误 码
final int urlErrorCode = -111111;  

final String urlErrorMsg = '请求失败，请检查 Http或Https URL 地址配置参数';
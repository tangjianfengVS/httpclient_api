

import 'dart:io';

enum URLMethod {
  GET,
  POST,
}

typedef APIWillRequestHandler = void Function(HttpClientRequest request);

typedef APISuccessResponseHandler = void Function(Map<String, dynamic> response);

typedef APIFailureResponseHandler = void Function(int code, String message, String rawResponseString);

typedef APIWillUpLoaderHandler = void Function(HttpClientFileInfo fileInfo);

typedef APIWillUpLoaderListHandler = void Function(List<HttpClientFileInfo> fileInfoList);

/// url error code
final int urlErrorCode = -111111;  

final String urlErrorMsg = '无效的URL，请检查此 Http或Https URL配置的地址参数';

class HttpClientFileInfo{
  String path = '';
  String type = '';
}
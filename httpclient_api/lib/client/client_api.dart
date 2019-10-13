

import 'package:flutter/foundation.dart';
import 'client_config.dart';
import 'client_manager.dart';


class HttpClientAPI {

  /// 配置全局: RequestBaseUrl
  static setAPIRequestBaseUrl(String baseUrl){
    HttpClientManager.setRequestBaseUrl(baseUrl);
  }


  /// 配置全局: RequestTimeout
  static setAPIRequestTimeout({int timeout}){
    HttpClientManager.setRequestTimeout(timeout);
  }


  /// 获取全局: RequestTimeout
  static String getAPIRequestBaseUr(){
    return HttpClientManager.requestBaseUrl;
  }

  
  /// 获取全局: RequestTimeout
  static int getAPIRequestTimeout(){
    return HttpClientManager.requestTimeout;
  }


  /// Start Request
  static request({ 
    @required URLMethod urlMethod, 
    @required String urlPath, 
    @required APISuccessResponseHandler success, 
    @required APIFailureResponseHandler failure,
    String baseUrl,
    int timeout,
    Map<String, dynamic> parames,
    Map<String, dynamic> header,
    APIWillRequestHandler willRequest }) async {
      HttpClientManager.request(urlMethod:urlMethod, urlPath:urlPath, success:success, failure:failure, baseUrl:baseUrl, timeout:timeout, parames:parames, header:header, willRequest:willRequest);
  }
}
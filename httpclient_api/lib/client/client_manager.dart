

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'client_config.dart';
import 'client_error.dart';

//【1】: GET,POST,请求头,请求体,参数        ---------------- Finish
//【2】: BaseUrl（公共） 的实现             ---------------- Finish
//【3】: 请求超时时间设置  
//【4】:   

// String HttpClientBaseUrl;   /// 全局配置
//---------------------------------------------------------------

/// 请求对象
class HttpClientManager {

  static setRequestBaseUrl(String baseUrl){
    requestBaseUrl = baseUrl;
  }

  static setRequestTimeout(int timeout){
    requestTimeout = timeout;
  }

  static String requestBaseUrl; 

  static int requestTimeout;

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
      /// check URL
      URLError error = HttpClientError.checkURL(requestBaseUrl: requestBaseUrl, baseUrl:baseUrl, urlPath:urlPath);
      Uri url = error.url;
      if (url == null){
        failure(error.errCode, error.errMsg, error.responseData.toString());
        return;
      }

      /// 参数
      parames = parames == null?{}:parames;
      header = header == null?{}:header;
    
      HttpClient httpClient = new HttpClient();
      HttpClientRequest request;
      /// 设置支持解析数据类型 和 请求头                                                      
      Map<String, dynamic> headers = {HttpHeaders.contentTypeHeader: 'application/json'};
      headers.addAll(header);

      try{
        switch (urlMethod) {
        case URLMethod.GET: 
          request = await httpClient.getUrl(url);
          headers.addAll(parames);

          for (var key in headers.keys) {                   /// 设置公共请求头                  
            dynamic value = headers[key];
            request.headers.set(key, value);
          }
          break;
        case URLMethod.POST:
          request = await httpClient.postUrl(url);

          for (var key in headers.keys) {                  /// 设置公共请求头                  
            dynamic value = headers[key];
            request.headers.set(key, value);
          }

          request.add(utf8.encode(json.encode(parames)));  /// 请求体参数
          break;
        default:
        }
        
        if (willRequest != null){
          willRequest(request);
        }

        HttpClientResponse response = await request.close();
        String responseBody = await response.transform(utf8.decoder).join();
        Map<String, dynamic> responseData = json.decode(responseBody);
        httpClient.close();

        if (response.statusCode == HttpStatus.ok) {
          print(request.headers);
          print("$responseData");
          ResponseError error = HttpClientError.checkResponse(responseData: responseData, succeed: true);
          failure(error.errCode, error.errMsg, responseBody);
          if (error.data != null){
            success(error.data);
          }else{
            failure(error.errCode, error.errMsg, responseBody);
          }
        } else {
          ResponseError error = HttpClientError.checkResponse(responseData: responseData);
          failure(error.errCode, error.errMsg, responseBody);
        }
      }catch (e){
        httpClient.close();
        ResponseError error = HttpClientError.tryCatch(e);
        failure(error.errCode, error.errMsg, error.errBody);
      }
    }

  static String getBaseUrl(){
    return requestBaseUrl != null ? requestBaseUrl:'';
  }

  static int getTimeout(){
    return requestTimeout;
  }
}






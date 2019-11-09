

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'client_config.dart';
import 'client_error.dart';


/// HttpClientManager
class HttpClientManager {

  static setRequestBaseUrl(String baseUrl){
    requestBaseUrl = baseUrl;
  }

  static setRequestTimeout(int timeout){
    requestConnectTimeout = timeout;
  }

  static String requestBaseUrl; 

  static int requestConnectTimeout = -1;

  /// connect timeout, default: '35's
  static int connectTimeout = 35; 


  static postBytes({ 
    @required String urlPath,
    @required List<int> bytes,
    @required APISuccessResponseHandler success, 
    @required APIFailureResponseHandler failure,
    String baseUrl,
    Map<String, dynamic> headers}) async {
      // check URL
      URLError error = HttpClientError.checkURL(requestBaseUrl: requestBaseUrl, baseUrl:baseUrl, urlPath:urlPath);
      Uri url = error.url;
      if (url == null) {
        failure(error.errCode, error.errMsg, error.responseData.toString());
        return;
      }
      // set bytes 设置支持解析数据类型 和 公共请求头date 
      bytes = bytes == null?[]:bytes;
      headers = headers == null?{}:headers;                                       
      headers.addAll(headers);
    
      HttpClient httpClient = new HttpClient();
      httpClient.connectionTimeout = Duration(seconds: requestConnectTimeout < 0?connectTimeout:requestConnectTimeout);
      HttpClientRequest request = await httpClient.postUrl(url);

      try {
        for (var key in headers.keys) {                  /// 设置公共请求头                  
          dynamic value = headers[key];
          request.headers.set(key, value);
        }

        request.add(bytes);                              /// 请求体参数

        HttpClientResponse response = await request.close();
        String responseBody = await response.transform(utf8.decoder).join();
        httpClient.close();
        print(request.headers);
        responseJson(response:response, responseBody:responseBody, success: success, failure: failure);
      }catch (e){
        httpClient.close();
        ResponseError error = HttpClientError.tryCatch(e);
        failure(error.errCode, error.errMsg, error.errBody);
      }
    }


  static request({ 
    @required URLMethod urlMethod, 
    @required String urlPath,
    @required APISuccessResponseHandler success, 
    @required APIFailureResponseHandler failure,
    String baseUrl,
    Map<String, dynamic> parames, 
    Map<String, dynamic> header,
    APIWillRequestHandler willRequest }) async {
      // check URL
      URLError error = HttpClientError.checkURL(requestBaseUrl: requestBaseUrl, baseUrl:baseUrl, urlPath:urlPath);
      Uri url = error.url;
      if (url == null) {
        failure(error.errCode, error.errMsg, error.responseData.toString());
        return;
      }

      // set parames
      parames = parames == null?{}:parames;
      header = header == null?{}:header;
      // 设置支持解析数据类型 和 公共请求头date                                                      
      Map<String, dynamic> headers = { HttpHeaders.contentTypeHeader: 'application/json' };
      headers.addAll(header);
    
      HttpClient httpClient = new HttpClient();
      httpClient.connectionTimeout = Duration(seconds: requestConnectTimeout < 0?connectTimeout:requestConnectTimeout);
      HttpClientRequest request;

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
        httpClient.close();
        print(request.headers);
        responseJson(response:response, responseBody:responseBody, success: success, failure: failure);
      }catch (e){
        httpClient.close();
        ResponseError error = HttpClientError.tryCatch(e);
        failure(error.errCode, error.errMsg, error.errBody);
      }
  }


  static responseJson({
    @required HttpClientResponse response, 
    @required String responseBody,
    @required APISuccessResponseHandler success, 
    @required APIFailureResponseHandler failure}) {
      dynamic jsonData = json.decode(responseBody);
      Map<String, dynamic> responseData = {};
      if (jsonData is Map) {
        responseData = jsonData;
      } else if (jsonData is List) {
        responseData = {'data': jsonData};
      }
      print("$jsonData");

      if (response.statusCode == HttpStatus.ok) {
          ResponseError error = HttpClientError.checkResponse(responseData: responseData, succeed: true);
          if (error.data != null) {
            success(error.data);
          }else{
            failure(error.errCode, error.errMsg, responseBody);
          }
        } else {
          ResponseError error = HttpClientError.checkResponse(responseData: responseData);
          failure(error.errCode, error.errMsg, responseBody);
        }
   }


  static String getBaseUrl(){
    return requestBaseUrl != null ? requestBaseUrl:'';
  }


  static int getTimeout(){
    return requestConnectTimeout;
  }
}






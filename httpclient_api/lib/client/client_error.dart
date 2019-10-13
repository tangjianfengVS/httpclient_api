


import 'dart:io';

import 'package:flutter/foundation.dart';

import 'client_config.dart';

class URLError {
  Uri url;
  final int errCode = urlErrorCode;
  final String errMsg = urlErrorMsg;
  final Map<String, dynamic> responseData = {'errCode':urlErrorCode,'errMsg':urlErrorMsg};
}


class ResponseError {
  Map<String, dynamic> data;
  int errCode;
  String errMsg='';
  String errBody='';
}


/// 请求对象
class HttpClientError {
  
  static List<String> codeListKey = ['code','errCode'];
  static List<String> msgListKey = ['msg','errMsg'];

  /// checkURL
  static URLError checkURL({
    @required String requestBaseUrl,
    @required String baseUrl,
    @required String urlPath }) {
      URLError error = new URLError();

      if (baseUrl != null && baseUrl.contains('http')) {
        Uri url = Uri.parse(baseUrl + urlPath);
        if (url != null) {
          error.url = url;
        }
      } else if (requestBaseUrl != null && requestBaseUrl.contains('http')){
        Uri url = Uri.parse(requestBaseUrl + urlPath);
        if (url != null) {
          error.url = url;
        }
      }
      return error;
  }


  static ResponseError checkResponse({ @required Map<String,dynamic> responseData, bool succeed}){
    int code = 0;
    String msg = '';
    for (String value in codeListKey) {
      dynamic codeValue = responseData[value];
      if(codeValue != null && codeValue is int) {
        code = codeValue;
        break;
      }
    }

    for (String value in msgListKey) {
      dynamic msgValue = responseData[value];
      if(msgValue != null && msgValue is String) {
        msg = msgValue;
        break;
      }
    }

    ResponseError error = ResponseError();
    if(!succeed){
      error.errCode = code;
      error.errMsg = msg;
      return error;
    }

    Map<String, dynamic> data = responseData['data'];
    if (code < 0 && msg != null && msg.length > 0){
      error.errCode = code;
      error.errMsg = msg;
    }else{
      error.data = data != null ? data:[];
    }
    return error;
  }


  static ResponseError tryCatch(dynamic e){
    ResponseError error = ResponseError();
    if (e is SocketException){
      error.errCode = e.osError.errorCode;
      error.errMsg = e.message;
      error.errBody = e.toString();
    }
    return error;
  }
}
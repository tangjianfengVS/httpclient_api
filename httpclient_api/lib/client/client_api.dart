

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'client_config.dart';
import 'client_manager.dart';
import 'client_uploader.dart';


class HttpClientAPI {

  /// set global config: Request baseUrl
  static setAPIRequestBaseUrl(String baseUrl){
    HttpClientManager.setRequestBaseUrl(baseUrl);
  }


  /// set global config, Unit 's': Request connect timeout，default: '35's
  static setAPIRequestTimeout({int timeout}){
    HttpClientManager.setRequestTimeout(timeout);
  }


  /// get global config: Request baseUrl
  static String getAPIRequestBaseUr(){
    return HttpClientManager.requestBaseUrl;
  }

  
  /// get global config, Unit 's': Request connect timeout 
  static int getAPIRequestTimeout(){
    return HttpClientManager.requestConnectTimeout;
  }


  /// Start Request Use HttpClient
  /// required [urlMethod] to Request with type.
  /// required [urlPath] to Request url's path.
  /// required [success] to Response success results data.
  /// required [failure] to Response failure results data.
  ///
  /// [baseUrl] to Request url's baseUrl, if value 'null', using global config [setAPIRequestBaseUrl] value.
  /// [parames] to Request parameters.
  /// [header] to Request public parameters, on the Request header.
  /// [willRequest] to check will Request object data.
  static request({ 
    @required URLMethod urlMethod, 
    @required String urlPath, 
    @required APISuccessResponseHandler success, 
    @required APIFailureResponseHandler failure,
    String baseUrl,
    Map<String, dynamic> parames,
    Map<String, dynamic> header,
    APIWillRequestHandler willRequest }) async {
      HttpClientManager.request(urlMethod:urlMethod, urlPath:urlPath, success:success, failure:failure, baseUrl:baseUrl, parames:parames, header:header, willRequest:willRequest);
  }

  
  /// Start upLoadFile Use HttpClient
  /// upLoadFile [urlPath] to UpLoad url's path.
  /// upLoadFile [file] to UpLoad File.
  /// upLoadFile [success] to UpLoad success results data.
  /// upLoadFile [failure] to UpLoad failure results data.
  ///
  /// [baseUrl] to UpLoad url's baseUrl, if value 'null', using global config [setAPIRequestBaseUrl] value.
  /// [accept] to UpLoad headers Accept, if value 'null', default '*/*'.
  /// [token] to UpLoad headers Authorization, value = 'bearer' + [token].
  /// [willRequest] to check will Request object data.
  static upLoadFile({ 
    @required String urlPath, 
    @required File file, 
    @required APISuccessResponseHandler success, 
    @required APIFailureResponseHandler failure,
    String baseUrl,
    String accept,
    String token,
    APIWillUpLoaderHandler willFile }) async {
      HttpClientUpLoader.upLoadFile(urlPath:urlPath,file:file,success:success,failure:failure,baseUrl:baseUrl,accept:accept,token:token,willFile:willFile);
  }
  

  /// Start upLoadFile Use HttpClient
  /// upLoadFile [urlPath] to UpLoad url's path.
  /// upLoadFile [fileList] to UpLoad File Array.
  /// upLoadFile [success] to UpLoad success results data.
  /// upLoadFile [failure] to UpLoad failure results data.
  ///
  /// [baseUrl] to UpLoad url's baseUrl, if value 'null', using global config [setAPIRequestBaseUrl] value.
  /// [accept] to UpLoad headers Accept, if value 'null', default '*/*'.
  /// [token] to UpLoad headers Authorization, value = 'bearer' + [token].
  /// [willRequest] to check will Request object data.
  static upLoadFileList({ 
    @required String urlPath, 
    @required List <File> fileList, 
    @required APISuccessResponseHandler success, 
    @required APIFailureResponseHandler failure,
    String baseUrl,
    String accept, 
    String token,  
    APIWillUpLoaderListHandler willFileList }) async {
      HttpClientUpLoader.upLoadFileList(urlPath:urlPath, fileList:fileList,success:success,failure:failure,baseUrl:baseUrl,accept:accept,token:token,willFileList:willFileList);
  }
}
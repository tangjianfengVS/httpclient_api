
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import 'client_config.dart';
import 'client_error.dart';
import 'client_manager.dart';

class HttpClientUpLoader{

  /// set image Uint8List 
  static Future<Uint8List> bytesProvider({
    @required Uint8List bytes,
    @required String boundary,
    @required String filename,
    @required String fileType
  }) async {
    String field = fileType + '-upload';
    // 构造 FormData 文件字段数据
    String data = '--$boundary\r\nContent-Disposition: form-data; name="$field"; ' +
                      'filename="${getFileFullName(filename)}"\r\nContent-Type: ' +
                      '$fileType\r\n\r\n';
    print("$data");         

    var controller = new StreamController<List<int>>(sync: true);
    controller.add(data.codeUnits);
    controller.add(bytes);
    controller.add("\r\n--$boundary--\r\n".codeUnits);
    controller.close();

    var completer = new Completer<Uint8List>();
    var sink = new ByteConversionSink.withCallback(
                    (bytes) => completer.complete(new Uint8List.fromList(bytes))
                   );
    controller.stream.listen(sink.add, onError: completer.completeError, onDone: sink.close, cancelOnError: true);
    Uint8List bytesNew = await completer.future;
    return bytesNew;
  }


  /// start postImageBytes 
  static postImageBytes({ 
    @required String urlPath, 
    @required List<Uint8List> bytesList,
    @required List<Map> headersList,
    @required APISuccessResponseHandler success, 
    @required APIFailureResponseHandler failure,
    String baseUrl }) {
      int count = bytesList.length;
      bool responseFailure = false;
      List<dynamic> responsList = [];

      for (var i = 0; i < bytesList.length; i++) {
          List<int>bytes = bytesList[i];
          Map headers = headersList[i];

          HttpClientManager.postBytes(baseUrl: baseUrl, urlPath: urlPath, bytes: bytes, headers: headers, success: (Map<String,dynamic> response) {
            if (responseFailure){ return; }

            count = count - 1;
            dynamic data = response['data'];
            if (data != null) {
              responsList.add(data);
            }
            if(count == 0) {
              success({'data':responsList});
            }
          }, failure: (int code, String msg, String rawResponseString) {
            responseFailure = true;
            failure(code, msg, rawResponseString);
          });
        }
    }


  static upLoadImageList({ 
    @required String urlPath, 
    @required List<ImageProvider> imageProviderList,
    @required APISuccessResponseHandler success, 
    @required APIFailureResponseHandler failure,
    String baseUrl,
    String accept, 
    String token}) async {
      // check URL 
      URLError error = HttpClientError.checkURL(requestBaseUrl: HttpClientManager.getBaseUrl(), baseUrl:baseUrl, urlPath:urlPath);
      Uri url = error.url;
      if (url == null) {
        failure(error.errCode, error.errMsg, error.responseData.toString());
        return;
      }

      accept = accept == null ? "*/*":accept;
      List<Uint8List> bytesList = [];
      List<Map> headersList = [];
      
      try {
        for (ImageProvider imageProvider in imageProviderList) {
          Uint8List bytes = await loadImageByProvider(imageProvider, failure: failure);
          var boundary = _boundaryString();
          String filename = boundary+'png';
          String fileType = getMediaType(getFileExt(filename)).toLowerCase();  
          String contentType = 'multipart/form-data; boundary=$boundary'; 
          Map headers = _makeHttpHeaders(contentType, accept, token);
          headersList.add(headers);

          Uint8List bytesNew = await bytesProvider(bytes:bytes, boundary:boundary, filename:filename, fileType:fileType);      
          bytes = bytesNew;
          bytesList.add(bytes);
        }

        postImageBytes(urlPath:urlPath, bytesList:bytesList, headersList:headersList, success:success, failure:failure, baseUrl:baseUrl);
      } catch (e) {
        ResponseError error = HttpClientError.tryCatch(e);
        failure(error.errCode, error.errMsg, error.errBody);
      }
  }


  static upLoadImage({ 
    @required String urlPath, 
    @required ImageProvider imageProvider,
    @required APISuccessResponseHandler success, 
    @required APIFailureResponseHandler failure,
    String baseUrl,
    String accept, 
    String token}) async {
      // check URL 
      URLError error = HttpClientError.checkURL(requestBaseUrl: HttpClientManager.getBaseUrl(), baseUrl:baseUrl, urlPath:urlPath);
      Uri url = error.url;
      if (url == null) {
        failure(error.errCode, error.errMsg, error.responseData.toString());
        return;
      }
      
      try {
        Uint8List bytes = await loadImageByProvider(imageProvider, failure: failure);
        var boundary = _boundaryString();
        String filename = boundary+'png';
        String fileType = getMediaType(getFileExt(filename)).toLowerCase();  
        String contentType = 'multipart/form-data; boundary=$boundary';
        accept = accept == null ? "*/*":accept; 
        Map headers = _makeHttpHeaders(contentType, accept, token);

        Uint8List bytesNew = await bytesProvider(bytes:bytes, boundary:boundary, filename:filename, fileType:fileType);      
        bytes = bytesNew;

        HttpClientManager.postBytes(baseUrl: baseUrl, urlPath: urlPath, bytes: bytes, headers: headers, success: success, failure: failure);
      } catch (e) {
        ResponseError error = HttpClientError.tryCatch(e);
        failure(error.errCode, error.errMsg, error.errBody);
      }
  }

  
  static upLoadFile({ 
    @required String urlPath, 
    @required File file, 
    @required APISuccessResponseHandler success, 
    @required APIFailureResponseHandler failure,
    String baseUrl,
    String accept,
    String token,
    APIWillUpLoaderHandler willFile }) async {
      // check URL 
      URLError error = HttpClientError.checkURL(requestBaseUrl: HttpClientManager.getBaseUrl(), baseUrl:baseUrl, urlPath:urlPath);
      Uri url = error.url;
      if (url == null) {
        failure(error.errCode, error.errMsg, error.responseData.toString());
        return;
      }
      
      try {
        List<int> bytes = await file.readAsBytes(); /// file转二进制
        var boundary = _boundaryString();
        String contentType = 'multipart/form-data; boundary=$boundary';
        accept = accept == null ? "*/*":accept;
        Map headers = _makeHttpHeaders(contentType, accept, token); 

        String filename = file.path;
        String fileType = getMediaType(getFileExt(filename)).toLowerCase();
        
        Uint8List bytesNew = await bytesProvider(bytes:bytes, boundary:boundary, filename:filename, fileType:fileType);      
        bytes = bytesNew;

        if (willFile != null){
          HttpClientFileInfo file = HttpClientFileInfo();
          file.path = filename;
          file.type = fileType;
          willFile(file);
        }

        HttpClientManager.postBytes(baseUrl: baseUrl, urlPath: urlPath, bytes: bytes, headers: headers, success: success, failure: failure);
      } catch (e) {
        ResponseError error = HttpClientError.tryCatch(e);
        failure(error.errCode, error.errMsg, error.errBody);
      }
  }


  static upLoadFileList({ 
    @required String urlPath, 
    @required List<File> fileList, 
    @required APISuccessResponseHandler success, 
    @required APIFailureResponseHandler failure,
    String baseUrl,
    String accept,
    String token,
    APIWillUpLoaderListHandler willFileList }) async {
      // check URL 
      URLError error = HttpClientError.checkURL(requestBaseUrl: HttpClientManager.getBaseUrl(), baseUrl:baseUrl, urlPath:urlPath);
      Uri url = error.url;
      if (url == null) {
        failure(error.errCode, error.errMsg, error.responseData.toString());
        return;
      }
      
      try {
        accept = accept == null ? "*/*":accept;
        List<Uint8List> bytesList = [];
        List<Map> headersList = [];
        List<HttpClientFileInfo> fileInfo = [];

        for (File file in fileList) {
          Uint8List bytes = await file.readAsBytes(); /// file转二进制
          var boundary = _boundaryString();
          String contentType = 'multipart/form-data; boundary=$boundary';
          accept = accept == null ? "*/*":accept;
          Map headers = _makeHttpHeaders(contentType, accept, token);
          headersList.add(headers);

          String filename = file.path;
          String fileType = getMediaType(getFileExt(filename)).toLowerCase();

          Uint8List bytesNew = await bytesProvider(bytes:bytes, boundary:boundary, filename:filename, fileType:fileType);      
          bytes = bytesNew;
          bytesList.add(bytes);

          HttpClientFileInfo fileOBJ = HttpClientFileInfo();
          fileOBJ.path = filename;
          fileOBJ.type = fileType;
          fileInfo.add(fileOBJ);
        }

        if (willFileList != null){
          willFileList(fileInfo);
        }

        postImageBytes(urlPath:urlPath, bytesList:bytesList, headersList:headersList, success:success, failure:failure, baseUrl:baseUrl);
      } catch (e) {
        ResponseError error = HttpClientError.tryCatch(e);
        failure(error.errCode, error.errMsg, error.errBody);
      }
  }

  // /// 生成随机字符串
  // static String randomStr(
  //     [int len = 8, List<int> chars = _BOUNDARY_CHARACTERS]) {
  //   var list = new List<int>.generate(
  //       len, (index) => chars[_random.nextInt(chars.length)],
  //       growable: false);
  //   return new String.fromCharCodes(list);
  // }

  static Map _makeHttpHeaders([
    String contentType,
    String accept,
    String token,
    String xRequestWith,
    String xMethodOverride]) {
    Map headers = new Map<String, String>();
    int i = 0;

    if (contentType != null && contentType.isNotEmpty) {
      i++;
      headers["Content-Type"] = contentType;
    }

    if (accept != null && accept.isNotEmpty) {
      i++;
      headers["Accept"] = accept;
    }

    if (token != null && token.isNotEmpty) {  
      i++;
      headers["Authorization"] = "bearer " + token;
    }

    if (xRequestWith != null && xRequestWith.isNotEmpty) {    
      i++;
      headers["X-Requested-With"] = xRequestWith;
    }

    if (xMethodOverride != null && xMethodOverride.isNotEmpty) {  
      i++;
      headers["X-HTTP-Method-Override"] = xMethodOverride;
    }

    if (i == 0) return null;
    return headers;
  }


  static const int _BOUNDARY_LENGTH = 48;

  static final Random _random = new Random();

  static String _boundaryString() {
    var prefix = "---DartFormBoundary";
    var list = new List<int>.generate(
        _BOUNDARY_LENGTH - prefix.length,
        (index) =>
            _BOUNDARY_CHARACTERS[_random.nextInt(_BOUNDARY_CHARACTERS.length)],
        growable: false);
    return "$prefix${new String.fromCharCodes(list)}";
  }


  static getMediaType(final String fileExt) {
    switch (fileExt) {
      case "jpg":
      case "jpeg":
      case "jpe":
        return 'image/jpeg';
      case "png":
        return 'image/png';
      case "bmp":
        return 'image/bmp';
      case "gif":
        return 'image/gif';
      case "json":
        return 'application/json';
      case "svg":
      case "svgz":
        return 'image/svg+xml';
      case "mp3":
        return 'audio/mpeg';
      case "mp4":
        return 'video/mp4';
      case "htm":
      case "html":
        return 'text/html';
      case "css":
        return 'text/css';
      case "csv":
        return 'text/csv';
      case "txt":
      case "text":
      case "conf":
      case "def":
      case "log":
      case "in":
        return 'text/plain';
    }
    return 'text/plain';
  }


  /// 获取文件名
  static String getFileFullName(filename){
    var index1 = filename.toString().lastIndexOf("/");
    if(index1.toString().isEmpty){
      index1=0;
    }
    var name = filename.substring(index1+1);
    print(name);
    return name;
  }


  /// 获取扩展名
  static String getFileExt(filename){
    var index = filename.toString().lastIndexOf(".");
    var suffix = filename.toString().substring(index+1);
    print(suffix);
    return suffix;
  }


  static const List<int> _BOUNDARY_CHARACTERS = const <int>[
    0x30,0x31,0x32,0x33,0x34,0x35,0x36,0x37,0x38,0x39,
    0x41,0x42,0x43,0x44,0x45,0x46,0x47,0x48,0x49,
    0x4A,0x4B,0x4C,0x4D,0x4E,0x4F,
    0x50,0x51,0x52,0x53,0x54,0x55,0x56,0x57,0x58,0x59,0x5A,
    0x61,0x62,0x63,0x64,0x65,0x66,0x67,0x68,0x69,
    0x6A,0x6B,0x6C,0x6D,0x6E,0x6F,
    0x70,0x71,0x72,0x73,0x74,0x75,0x76,0x77,0x78,0x79,0x7A
  ];


  /// 通过ImageProvider获取图片流 
  static Future<Uint8List> loadImageByProvider(   
    ImageProvider provider, {
     @required APIFailureResponseHandler failure,  
     ImageConfiguration config = ImageConfiguration.empty}) async {  

       var completer = new Completer<Uint8List>();
       ImageStreamListener listener;   
       ImageStream stream = provider.resolve(config); 

       listener = ImageStreamListener((ImageInfo frame, bool sync) async {       
         ByteData byteData = await frame.image.toByteData(format: ui.ImageByteFormat.png);
         Uint8List data = byteData.buffer.asUint8List();
         completer.complete(data); 
         stream.removeListener(listener);  
       }, onError:(dynamic exception, StackTrace stackTrace) {
         String message = exception.toString();
         failure(imgaeErrorCode,message,exception.toString());
       });   
          
       stream.addListener(listener); 
       return completer.future; 
    } 

}
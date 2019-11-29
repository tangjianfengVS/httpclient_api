# httpclient_api
 【一】
    HttpClientAPI 是基于 Dart 的原生 HttpClient 库封装的一套高性能网络框架 API。
    HttpClientAPI 网络框架是致敬iOS和Android的网络封装实现的一套方案，其中主要对请求中的： 
    （1）全局URL设置 
    （2）请求超时时间设置
    （3）请求体参数设置 
    （4）请求头参数设置 
    （5）响应处理数据设置    
      ------------------进行了封装和容错处理，使得项目网络开发安全，简介方便，高效。

 【二】
    HttpClientAPI 框架通过将要发起请求前的 APIWillRequestHandler 回调数据，可以方便开发者对请求数据进行检查。
    HttpClientAPI 框架通过响应结果的 APISuccessResponseHandler 回调数据，返回给开发者成功的网络响应数据。
    HttpClientAPI 框架通过响应结果的 APIFailureResponseHandler 回调数据，返回给开发者失败的网络响应数据。

 【三】
    HttpClientAPI 支持本地 File 文件对象（包括同时多个File对象）上传服务器功能；
    HttpClientAPI 还支持 ImageProvider 对象（包括同时多个ImageProvider对象）上传服务器功能；
    HttpClientAPI Welcome to use.

  欢迎大家使用 HttpClientAPI。
  HttpClientAPI 是一位中国开发者编写的开源SDK，请支持。


【The synopsis of function】
 【一】
    The HttpClientAPI is a set of high-performance network framework apis encapsulated in the Dart native HttpClient library.
    The HttpClientAPI network framework is a set of solutions that pay tribute to the network encapsulation implementation of iOS and Android, mainly for requests:
    (1) global URL setting
    (2) request timeout setting
    (3) request body parameter setting
    (4) request header parameter setting
    (5) the response processing data Settings are encapsulated and fault-tolerant
    -------------------making the project network development safe, simple, convenient and efficient.

 【二】
    The HttpClientAPI framework makes it easy for developers to examine the request data by calling back the APIWillRequestHandler before the request is to be made.
    HttpClientAPI APISuccessResponseHandler callback data frame by response results, returned to the developer network response data of success.
    HttpClientAPI APIFailureResponseHandler callback data frame by response results, returned to the developer failed network response data.

 【三】
    The HttpClientAPI supports uploading of local File objects (including multiple File objects at the same time) to the server.
    The HttpClientAPI also supports uploading of ImageProvider objects (including multiple ImageProvider objects at the same time) to the server.

  You are welcome to use the HttpClientAPI.
  HttpClientAPI is an open source SDK written by a Chinese developer, please support.


## Post and Get 
    /// 全局 BaseUrl设置
    HttpClientAPI.setAPIRequestBaseUrl('https://api-test.saicmobility.com');

    /// 全局 请求超时设置
    HttpClientAPI.setAPIRequestTimeout(10);

    //// POST 请求，
    <!-- urlMethod： 请求方式枚举，urlPath：URL路径 -->
    <!-- urlPath：URL路径（BaseUrl不传默认使用全局配置的URL） -->
    HttpClientAPI.request(
          urlMethod: URLMethod.POST,
            urlPath: '/auth/v2/emergencycontact/passenger/checkhavecontact',
            success: (Map<String,dynamic> response) {
              <!-- 成功回调数据 -->
          },failure: (int code, String msg, String rawResponseString){
              <!-- 失败回调数据 -->
      },willRequest: (HttpClientRequest request){
              <!-- 将要发起请求，回调请求数据检查 -->
     });


### http post File or List<File>
    File f = File('/Users/a/Downloads/IMG_E3DD8D0B3C82-1.jpeg');

    /// 单个文件上传服务器
    <!-- urlPath：URL路径（BaseUrl不传默认使用全局配置的URL） -->
    HttpClientAPI.upLoadFile(baseUrl: 'http://fs.cshuljanyu.com',
                             urlPath: '/upload/logo?access_token=a
                                file: f,
                             success: (Map<String,dynamic> response) {
           <!-- 成功回调数据 -->
        },failure: (int code, String msg, String rawResponseString){
           <!-- 失败回调数据 -->
        },willFile: (HttpClientFileInfo fileInfo){
           <!-- 将要上传文件，回调上传文件信息检查 -->
     });

    
    File ftwo = File('/Users/a/Downloads/IMG_9E9EFA94A471-1.jpeg');

    /// 多个文件上传服务器
    <!-- urlPath：URL路径（BaseUrl不传默认使用全局配置的URL） -->
    HttpClientAPI.upLoadFile(baseUrl: 'http://fs.cshuanyu.com',
                             urlPath: '/upload/logo?access_token=a
                            fileList: [f,ftwo],
                             success: (Map<String,dynamic> response) {
           <!-- 成功回调数据 -->
     },failure: (int code, String msg, String rawResponseString){
           <!-- 失败回调数据 -->
     },willFile: (HttpClientFileInfo fileInfo){
           <!-- 将要上传文件，回调上传文件信息检查 -->
     });


#### http post ImageProvider or List<ImageProvider>
    Image icon = Image.asset('images/1.0X/232017s8826z6h822p76jm.jpg');
    
    /// Image UI 单张图片上传
    <!-- urlPath：URL路径（BaseUrl不传默认使用全局配置的URL） -->
    HttpClientAPI.upLoadImage(baseUrl: 'http://fs.cshusssu.com',
                              urlPath: '/upload/logo?access_to',
                        imageProvider: icon.image,
                              success: (Map<String,dynamic> response) {
           <!-- 成功回调数据 -->
    },failure: (int code, String msg, String rawResponseString){
           <!-- 失败回调数据 -->
    });


    Image iconTwo = Image.asset('images/1.0X/timg.jpeg');
    /// Image UI 图片数组上传
    <!-- urlPath：URL路径（BaseUrl不传默认使用全局配置的URL） -->
    HttpClientAPI.upLoadImageList(baseUrl: 'http://fs.shhshs.com',
                                  urlPath: '/upload/logo?access_to',
                        imageProviderList: [icon.image,iconTwo.image],
                                  success: (Map<String,dynamic> response) {
            <!-- 成功回调数据 -->
    },failure: (int code, String msg, String rawResponseString){
            <!-- 失败回调数据 -->
    });


##### Getting Started
    This project is a starting point for a Dart
    [package](https://flutter.dev/developing-packages/),
    a library module containing code that can be shared easily across
    multiple Flutter or Dart projects.

    For help getting started with Flutter, view our 
    [online documentation](https://flutter.dev/docs), which offers tutorials, 
    samples, guidance on mobile development, and a full API reference.
# HttpClientAPI
HttpClientAPI 是基于 Dart 的原生 HttpClient 库封装的一套高性能网络框架 API。
HttpClientAPI 网络框架是致敬iOS和Android的网络封装实现的一套方案，其中主要对请求中的： 
（1）全局URL设置 
（2）请求超时时间设置
（3）请求体参数设置 
（4）请求头参数设置 
（5）响应处理数据设置    
  ------------------进行了封装和容错处理，使得项目网络开发安全，简介方便，高效。

HttpClientAPI 框架通过将要发起请求前的 APIWillRequestHandler 回调数据，可以方便开发者对请求数据进行检查。
HttpClientAPI 框架通过响应结果的 APISuccessResponseHandler 回调数据，返回给开发者成功的网络响应数据。
HttpClientAPI 框架通过响应结果的 APIFailureResponseHandler 回调数据，返回给开发者失败的网络响应数据。

HttpClientAPI 支持本地 File 文件对象（包括同时多个File对象）上传服务器功能；
HttpClientAPI 还支持 ImageProvider 对象（包括同时多个ImageProvider对象）上传服务器功能；
HttpClientAPI Welcome to use.

欢迎大家使用 HttpClientAPI。


【The synopsis of function】

The HttpClientAPI is a set of high-performance network framework apis encapsulated in the Dart native HttpClient library.
The HttpClientAPI network framework is a set of solutions that pay tribute to the network encapsulation implementation of iOS and Android, mainly for requests:
(1) global URL setting
(2) request timeout setting
(3) request body parameter setting
(4) request header parameter setting
(5) the response processing data Settings are encapsulated and fault-tolerant
 -------------------making the project network development safe, simple, convenient and efficient.

The HttpClientAPI framework makes it easy for developers to examine the request data by calling back the APIWillRequestHandler before the request is to be made.
HttpClientAPI APISuccessResponseHandler callback data frame by response results, returned to the developer network response data of success.
HttpClientAPI APIFailureResponseHandler callback data frame by response results, returned to the developer failed network response data.

The HttpClientAPI supports uploading of local File objects (including multiple File objects at the same time) to the server.
The HttpClientAPI also supports uploading of ImageProvider objects (including multiple ImageProvider objects at the same time) to the server.

You are welcome to use the HttpClientAPI.

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:movie_sample/index/index.dart';

///网络请求工具类，单例处理
class HttpUtil {
  static const String _GET = "get";
  static const String _POST = "post";
  static const int _COMMON_REQUEST_ERROR = -1;

  Dio _dio;
  static HttpUtil _instance;

  static HttpUtil get instance => _getInstance();

  factory HttpUtil() => _getInstance();

  static HttpUtil _getInstance() {
    if (_instance == null) {
      _instance = HttpUtil._internal();
    }
    return _instance;
  }

  ///初始化
  HttpUtil._internal() {
    _dio = Dio(BaseOptions(
      //项目域名，如果传的 url 是以 http 开头的会忽略此域名
      baseUrl: "https://api.apiopen.top/",
      //请求头
      headers: {'platform': 'android', 'version': 11.0},
      connectTimeout: 15000,
      receiveTimeout: 20000,
    ));
    _addStartHttpInterceptor(_dio); //添加请求之前的拦截器
  }

  ///get请求
  ///如果 url 是以 http 开头的则忽略 baseUrl
  get(String url, {@required listener, params}) async {
    _requestHttp(url, listener, _GET, params);
  }

  ///post请求
  ///如果 url 是以 http 开头的则忽略 baseUrl
  post(String url, {@required listener, params}) async {
    _requestHttp(url, listener, _POST, params);
  }

  ///网络请求
  _requestHttp(String url, RequestListener requestListener, [String method, FormData params]) async {
    if (requestListener == null) return;
    try {
      Response<Map<String, dynamic>> response;
      if (method == _GET) {
        if (params != null && params.isNotEmpty) {
          response = await _dio.get<Map<String, dynamic>>(url, queryParameters: params);
        } else {
          response = await _dio.get<Map<String, dynamic>>(url);
        }
      } else if (method == _POST) {
        if (params != null && params.isNotEmpty) {
          response = await _dio.post<Map<String, dynamic>>(url, queryParameters: params);
        } else {
          response = await _dio.post<Map<String, dynamic>>(url);
        }
      }
      LogUtil.d(response.data);
      if (response.statusCode != 200) {
        requestListener.onError(BaseResponse(response.statusCode, "请求失败", Map()));
      } else {
        requestListener.onSuccess(BaseResponse(response.statusCode, "请求成功", response.data));
      }
    } catch (exception) {
      requestListener.onError(BaseResponse(_COMMON_REQUEST_ERROR, "请求失败", Map()));
    }
  }

  ///拦截处理
  _addStartHttpInterceptor(Dio dio) {
    dio.interceptors.add(InterceptorsWrapper(onRequest: (RequestOptions options) {
      // 在请求被发送之前做一些事情
      return options;
    }, onResponse: (Response response) {
      // 在返回响应数据之前做一些预处理
      return response;
    }, onError: (DioError e) {
      // 当请求失败时做一些预处理
      return e;
    }));
  }
}

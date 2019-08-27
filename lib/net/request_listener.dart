import 'package:flutter/material.dart';

import 'base_response.dart';

///网络请求监听
class RequestListener {
  RequestListener({@required this.success, @required this.error});

  //请求成功
  final ValueChanged<BaseResponse> success;

  //请求失败
  final ValueChanged<BaseResponse> error;

  void onSuccess(BaseResponse response) {
    if (success != null) success(response);
  }

  void onError(BaseResponse response) {
    if (error != null) error(response);
  }
}

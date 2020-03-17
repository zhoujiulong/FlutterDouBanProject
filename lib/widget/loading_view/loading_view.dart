import 'package:flutter/material.dart';

import 'loading_view_empty.dart';
import 'loading_view_error.dart';
import 'loading_view_intent_error.dart';
import 'loading_view_loading.dart';

///页面状态
enum LoadingState {
  //加载中，显示 loading 页面
  loading,
  //加载成功，显示传入的 contentWidget
  success,
  //显示空页面
  empty,
  //显示错误页面
  error,
  //网络错误页面
  intentError,
  //该状态显示传入的页面 customWidget
  custom
}

///状态控件，统一管理加载中、无数据等页面
class LoadingView extends StatelessWidget {
  //当前状态
  final LoadingState state;

  //加载成功显示的页面
  final Widget contentWidget;

  //传入的自定义布局，当 state 为 custom 时显示该控件
  final Widget customWidget;

  //所有页面点击重新加载回调，如果单个页面单独设置了则会调用单独设置的
  final GestureTapCallback allRetryListener;

  //空页面点击重新加载回调
  final GestureTapCallback emptyRetryListener;

  //错误页面点击重新加载回调
  final GestureTapCallback errorRetryListener;

  //网络错误页面点击重新加载回调
  final GestureTapCallback intentErrorRetryListener;

  //背景颜色
  final Color bgColor;

  LoadingView(
      {this.state = LoadingState.loading, this.contentWidget,
      this.customWidget,
      this.allRetryListener,
      this.emptyRetryListener,
      this.errorRetryListener,
      this.intentErrorRetryListener,
      this.bgColor});

  @override
  Widget build(BuildContext context) {
    Widget widget;
    switch (state) {
      case LoadingState.loading:
        widget = LoadingViewLoading();
        break;
      case LoadingState.success:
        widget = contentWidget;
        break;
      case LoadingState.empty:
        widget = LoadingViewEmpty(emptyRetryListener != null ? emptyRetryListener : allRetryListener);
        break;
      case LoadingState.error:
        widget = LoadingViewError(errorRetryListener != null ? errorRetryListener : allRetryListener);
        break;
      case LoadingState.intentError:
        widget = LoadingViewIntentError(intentErrorRetryListener != null ? intentErrorRetryListener : allRetryListener);
        break;
      case LoadingState.custom:
        widget = customWidget;
        break;
      default: //默认页面设置为错误页面，只有在 state 传入为 null 时候显示
        widget = LoadingViewError(errorRetryListener != null ? errorRetryListener : allRetryListener);
        break;
    }
    return ConstrainedBox(
      constraints: BoxConstraints.expand(),
      child: Container(
        child: widget,
        color: bgColor ?? Color.fromARGB(255, 248, 248, 248),
      ),
    );
  }
}

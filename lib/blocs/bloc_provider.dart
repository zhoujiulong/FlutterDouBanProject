import 'package:flutter/material.dart';
import 'package:movie_sample/index/index.dart';
import 'package:rxdart/rxdart.dart';

abstract class BlocBase {
  BehaviorSubject<LoadingState> _loadingSubject = BehaviorSubject<LoadingState>();

  Sink<LoadingState> get _loadingSink => _loadingSubject.sink;

  Stream<LoadingState> get loadingStream => _loadingSubject.stream;

  void setLoadingState(LoadingState state) {
    _loadingSink.add(state);
  }

  void disposeBase() {
    _loadingSubject.close();
    dispose();
  }

  void dispose();
}

///简单封装，使用 StatefulWidget 主要是在 dispose 对资源进行释放
class BlocProvider<T extends BlocBase> extends StatefulWidget {
  BlocProvider({
    Key key,
    @required this.bloc,
    @required this.child,
    this.userDispose: true,
  }) : super(key: key);

  final T bloc;
  final Widget child;
  final bool userDispose;

  @override
  _BlocProviderState<T> createState() => _BlocProviderState<T>();

  ///这个方法会从副控件的变量中进行查找，将最近的父控件中的 T 进行返回
  static T of<T extends BlocBase>(BuildContext context) {
    final type = _typeOf<BlocProvider<T>>();
    BlocProvider<T> provider = context.ancestorWidgetOfExactType(type);
    return provider.bloc;
  }

  static Type _typeOf<T>() => T;
}

class _BlocProviderState<T> extends State<BlocProvider<BlocBase>> {
  @override
  void dispose() {
    if (widget.userDispose) widget.bloc.disposeBase();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

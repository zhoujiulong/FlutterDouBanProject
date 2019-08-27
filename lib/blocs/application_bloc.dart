import 'package:rxdart/rxdart.dart';

import 'bloc_provider.dart';

class ApplicationBloc extends BlocBase {
  BehaviorSubject<int> _appEvent = BehaviorSubject();

  Sink<int> get _appEventSink => _appEvent.sink;

  Stream<int> get appEventStream => _appEvent.stream;

  BehaviorSubject<int> _mainIndexEvent = BehaviorSubject();

  Sink<int> get _mainIndexSink => _mainIndexEvent.sink;

  Stream<int> get mainIndexStream => _mainIndexEvent.stream;

  @override
  void dispose() {
    _appEvent.close();
    _mainIndexEvent.close();
  }

  void sendAppEvent(int type) {
    _appEventSink.add(type);
  }

  void sendMainIndexEvent(int index) {
    _mainIndexSink.add(index);
  }
}

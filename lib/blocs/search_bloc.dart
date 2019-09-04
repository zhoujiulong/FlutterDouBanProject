import 'package:movie_sample/index/index.dart';
import 'package:rxdart/rxdart.dart';

class SearchBloc extends BlocBase {
  BehaviorSubject<bool> _showClearTextSubject = BehaviorSubject<bool>();

  Sink<bool> get _showClearTextSink => _showClearTextSubject.sink;

  Stream<bool> get showClearTextStream => _showClearTextSubject.stream;

  void setClearTextShow(bool showClearText) {
    _showClearTextSink.add(showClearText);
  }

  @override
  void dispose() {
    _showClearTextSubject.close();
  }
}

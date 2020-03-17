import 'package:fluttertoast/fluttertoast.dart';
import 'package:movie_sample/index/index.dart';
import 'package:rxdart/rxdart.dart';

class SoonPlayBloc extends BlocBase {
  BehaviorSubject<MovieModel> _soonPlaySubject = BehaviorSubject<MovieModel>();

  Sink<MovieModel> get _soonPlaySink => _soonPlaySubject.sink;

  Stream<MovieModel> get soonPlayStream => _soonPlaySubject.stream;

  MovieModel movieModel;

  void getSoonPlayData() {
    Map<String, dynamic> params = Map();
//    params.add("start", "0");
//    params.add("count", "1");
    HttpUtil.instance.get(UrlConstant.SOON_PLAY,
        params: params,
        listener: RequestListener(
            success: _getHotPlayDataSuccess, error: _getHotPlayDataError));
  }

  _getHotPlayDataSuccess(BaseResponse response) {
    movieModel = MovieModel.fromJson(response.result);
    if (movieModel.subjects != null && movieModel.subjects.length > 0) {
      setLoadingState(LoadingState.success);
      _soonPlaySink.add(movieModel);
    } else {
      setLoadingState(LoadingState.empty);
    }
  }

  _getHotPlayDataError(BaseResponse response) {
    setLoadingState(LoadingState.intentError);
    Fluttertoast.showToast(msg: response.message);
  }

  @override
  void disposeBase() {}

  @override
  void dispose() {}
}

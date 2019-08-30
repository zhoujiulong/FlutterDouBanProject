import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:movie_sample/index/index.dart';
import 'package:rxdart/rxdart.dart';

class SoonPlayBloc extends BlocBase {
  BehaviorSubject<MusicModel> _soonPlaySubject = BehaviorSubject<MusicModel>();

  Sink<MusicModel> get _soonPlaySink => _soonPlaySubject.sink;

  Stream<MusicModel> get soonPlayStream => _soonPlaySubject.stream;

  MusicModel musicModel;

  void getSoonPlayData() {
    FormData params = FormData();
//    params.add("start", "0");
//    params.add("count", "1");
    HttpUtil.instance.get(UrlConstant.SOON_PLAY,
        params: params, listener: RequestListener(success: _getHotPlayDataSuccess, error: _getHotPlayDataError));
  }

  _getHotPlayDataSuccess(BaseResponse response) {
    musicModel = MusicModel.fromJson(response.result);
    if (musicModel.subjects != null && musicModel.subjects.length > 0) {
      setLoadingState(LoadingState.success);
      _soonPlaySink.add(musicModel);
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

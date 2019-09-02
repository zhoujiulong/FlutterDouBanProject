import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:movie_sample/index/index.dart';
import 'package:rxdart/rxdart.dart';

///正在热播
class HotPlayBloc extends BlocBase {


  BehaviorSubject<MovieModel> _hotPlayDataSubject = BehaviorSubject<MovieModel>();

  Sink<MovieModel> get _hotPlayDataSink => _hotPlayDataSubject.sink;

  Stream<MovieModel> get hotPlayDataStream => _hotPlayDataSubject.stream;

  MovieModel hotPlayModel;

  void getHotPlayData() {
    FormData params = FormData();
//    params.add("start", "0");
//    params.add("count", "1");
//    params.add("city", "深圳");
    HttpUtil.instance.get(UrlConstant.HOT_PLAY,
        params: params, listener: RequestListener(success: _getHotPlayDataSuccess, error: _getHotPlayDataError));
  }

  _getHotPlayDataSuccess(BaseResponse response) {
    hotPlayModel = MovieModel.fromJson(response.result);
    if (hotPlayModel.subjects != null && hotPlayModel.subjects.length > 0) {
      setLoadingState(LoadingState.success);
      _hotPlayDataSink.add(hotPlayModel);
    } else {
      setLoadingState(LoadingState.empty);
    }
  }

  _getHotPlayDataError(BaseResponse response) {
    setLoadingState(LoadingState.intentError);
    Fluttertoast.showToast(msg: response.message);
  }

  @override
  void disposeBase() {
  }

  @override
  void dispose() {
    //因为是一级页面，页面切换也会调用该方法，所以不进行关闭
  }
}

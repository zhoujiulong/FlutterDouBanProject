import 'package:dio/dio.dart';
import 'package:movie_sample/index/bloc_index.dart';
import 'package:movie_sample/index/constant_index.dart';
import 'package:movie_sample/index/model_index.dart';
import 'package:movie_sample/index/net_index.dart';
import 'package:movie_sample/index/widget_index.dart';
import 'package:rxdart/rxdart.dart';

///正在热播
class HotPlayBloc extends BlocBase {
  BehaviorSubject<LoadingState> _loadingSubject = BehaviorSubject<LoadingState>();

  Sink<LoadingState> get _loadingSink => _loadingSubject.sink;

  Stream<LoadingState> get loadingStream => _loadingSubject.stream;

  BehaviorSubject<HotPlayModel> _hotPlayDataSubject = BehaviorSubject<HotPlayModel>();

  Sink<HotPlayModel> get _hotPlayDataSink => _hotPlayDataSubject.sink;

  Stream<HotPlayModel> get hotPlayDataStream => _hotPlayDataSubject.stream;

  HotPlayModel hotPlayModel;

  void getHotPlayData() {
    FormData params = FormData();
//    params.add("start", "0");
//    params.add("count", "1");
//    params.add("city", "深圳");
    HttpUtil.instance.get(UrlConstant.HOT_PLAY,
        params: params, listener: RequestListener(success: _getHotPlayDataSuccess, error: _getHotPlayDataError));
  }

  void setLoadingState(LoadingState state) {
    _loadingSink.add(state);
  }

  _getHotPlayDataSuccess(BaseResponse response) {
    hotPlayModel = HotPlayModel.fromJson(response.result);
    if (hotPlayModel.subjects != null && hotPlayModel.subjects.length > 0) {
      _loadingSink.add(LoadingState.success);
      _hotPlayDataSink.add(hotPlayModel);
    } else {
      _loadingSink.add(LoadingState.empty);
    }
  }

  _getHotPlayDataError(BaseResponse response) {
    _loadingSink.add(LoadingState.intentError);
  }

  @override
  void dispose() {
    _loadingSubject.close();
    _hotPlayDataSubject.close();
  }
}

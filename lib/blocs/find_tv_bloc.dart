import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:movie_sample/index/index.dart';
import 'package:rxdart/rxdart.dart';

class FindTvBloc extends BlocBase {

  BehaviorSubject<MovieModel> _weekMovieListSubject = BehaviorSubject<MovieModel>();

  Sink<MovieModel> get _weeklyMovieListSink => _weekMovieListSubject.sink;

  Stream<MovieModel> get weekMovieListStream => _weekMovieListSubject.stream;

  BehaviorSubject<MovieModel> _usBoxMovieListSubject = BehaviorSubject<MovieModel>();

  Sink<MovieModel> get _usBoxMovieListSink => _usBoxMovieListSubject.sink;

  Stream<MovieModel> get usBoxMovieListStream => _usBoxMovieListSubject.stream;

  BehaviorSubject<MovieModel> _newMovieListSubject = BehaviorSubject<MovieModel>();

  Sink<MovieModel> get _newMovieListSink => _newMovieListSubject.sink;

  Stream<MovieModel> get newMovieListStream => _newMovieListSubject.stream;

  MovieModel weeklyListModel;
  MovieModel newMovieListModel;
  MovieModel usBoxListModel;

  void getData() {
    Map<String, dynamic> params = Map();
    params["apikey"] = "0df993c66c0c636e29ecbb5344252a4a";
    HttpUtil.instance.get(
      UrlConstant.NEW_MOVIE_LIST,
      listener: RequestListener(
        success: (BaseResponse response) {
          weeklyListModel = MovieModel.fromJson(response.result);
          if (weeklyListModel != null && weeklyListModel.subjects != null) {
            int length = weeklyListModel.subjects.length;
            if (length > 6) weeklyListModel.subjects = weeklyListModel.subjects.sublist(length - 6, length);
            _getUsBoxListMovies();
          } else {
            setLoadingState(LoadingState.empty);
          }
        },
        error: (BaseResponse response) {
          setLoadingState(LoadingState.error);
          Fluttertoast.showToast(msg: response.message);
        },
      ),
    );
  }

  void _getUsBoxListMovies() {
    Map<String, dynamic> params = Map();
    params["apikey"] = "0df993c66c0c636e29ecbb5344252a4a";
    HttpUtil.instance.get(
      UrlConstant.NEW_MOVIE_LIST,
      listener: RequestListener(
        success: (BaseResponse response) {
          usBoxListModel = MovieModel.fromJson(response.result);
          if (usBoxListModel != null && usBoxListModel.subjects != null) {
            int length = usBoxListModel.subjects.length;
            if (length > 3) usBoxListModel.subjects = usBoxListModel.subjects.sublist(length - 3, length);
            _getNewMovieListMovies();
          } else {
            setLoadingState(LoadingState.empty);
          }
        },
        error: (BaseResponse response) {
          setLoadingState(LoadingState.error);
          Fluttertoast.showToast(msg: response.message);
        },
      ),
    );
  }

  void _getNewMovieListMovies() {
    Map<String, dynamic> params = Map();
    params["apikey"] = "0df993c66c0c636e29ecbb5344252a4a";
    HttpUtil.instance.get(
      UrlConstant.NEW_MOVIE_LIST,
      listener: RequestListener(
        success: (BaseResponse response) {
          newMovieListModel = MovieModel.fromJson(response.result);
          if (newMovieListModel != null && newMovieListModel.subjects != null) {
            setLoadingState(LoadingState.success);
            _weeklyMovieListSink.add(weeklyListModel);
            _usBoxMovieListSink.add(usBoxListModel);
            _newMovieListSink.add(newMovieListModel);
          } else {
            setLoadingState(LoadingState.empty);
          }
        },
        error: (BaseResponse response) {
          setLoadingState(LoadingState.error);
          Fluttertoast.showToast(msg: response.message);
        },
      ),
    );
  }

  @override
  void disposeBase() {
  }
  
  @override
  void dispose() {
  }
  
}
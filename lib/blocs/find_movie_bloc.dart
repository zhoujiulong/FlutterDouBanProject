import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:movie_sample/index/index.dart';
import 'package:rxdart/rxdart.dart';

class FindMovieBloc extends BlocBase {
  BehaviorSubject<MovieModel> _newMovieListSubject = BehaviorSubject<MovieModel>();

  Sink<MovieModel> get _newMovieListSink => _newMovieListSubject.sink;

  Stream<MovieModel> get newMovieListStream => _newMovieListSubject.stream;

  MovieModel movieModel;

  void getNewMovieListMovies() {
    FormData params = FormData();
    params["apikey"] = "0df993c66c0c636e29ecbb5344252a4a";
    HttpUtil.instance.get(
      UrlConstant.NEW_MOVIE_LIST,
      listener: RequestListener(
        success: (BaseResponse response) {
          movieModel = MovieModel.fromJson(response.result);
          _newMovieListSink.add(movieModel);
        },
        error: (BaseResponse response) {
          Fluttertoast.showToast(msg: response.message);
        },
      ),
    );
  }

  @override
  void disposeBase() {}

  @override
  void dispose() {}
}



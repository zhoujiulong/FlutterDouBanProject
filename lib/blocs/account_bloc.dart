import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:movie_sample/index/index.dart';
import 'package:rxdart/rxdart.dart';

enum COLLECTION_TYPE { WANT_LOOK, LOOKING, SEEN }

class AccountBloc extends BlocBase {
  BehaviorSubject<AccountListEventModel> _collectionSubject =
      BehaviorSubject<AccountListEventModel>();

  Sink<AccountListEventModel> get _collectionSink => _collectionSubject.sink;

  Stream<AccountListEventModel> get collectionStream =>
      _collectionSubject.stream;

  BehaviorSubject<bool> _titleBgAlphaPercentSubject =
      BehaviorSubject<bool>();

  Sink<bool> get _titleBgAlphaPercentSink => _titleBgAlphaPercentSubject.sink;

  Stream<bool> get titleBgAlphaPercentStream =>
      _titleBgAlphaPercentSubject.stream;

  AccountListEventModel eventModel =
      AccountListEventModel(null, COLLECTION_TYPE.WANT_LOOK);
  bool _dialogDismiss = true;

  void setCollection(COLLECTION_TYPE type) {
    if (type == eventModel.collectionType) return;
    eventModel.collectionType = type;
    _collectionSink.add(eventModel);
  }

  void setScroll(double scrollY) {
    _titleBgAlphaPercentSink.add(scrollY >= Density.instance.dp(270));
  }

  void getDataByType(BuildContext context, COLLECTION_TYPE type,
      {bool isRefresh = false}) {
    //模拟一下数据
    int start = 5;
    if (type == COLLECTION_TYPE.LOOKING) {
      start += 7;
    } else if (type == COLLECTION_TYPE.SEEN) {
      start += 7;
    }
    Map<String, dynamic> params = Map();
    params["start"] = "$start";
    params["count"] = "8";
    params["city"] = "深圳";
    if (!isRefresh) {
      showDialog(
          context: context,
          builder: (_) {
            return LoadingDialog(
              dismissListener: () {
                _dialogDismiss = true;
              },
            );
          });
      _dialogDismiss = false;
    }
    HttpUtil.instance.get(UrlConstant.HOT_PLAY,
        params: params,
        listener: RequestListener(
          success: (BaseResponse response) {
            if (!_dialogDismiss) {
              _dialogDismiss = true;
              Navigator.pop(context);
            }
            if (isRefresh) setLoadingState(LoadingState.success);
            eventModel.movieModel = MovieModel.fromJson(response.result);
            if (eventModel.movieModel.subjects != null &&
                eventModel.movieModel.subjects.length > 0) {
              _collectionSink.add(eventModel);
            }
          },
          error: (BaseResponse response) {
            if (!_dialogDismiss) {
              _dialogDismiss = true;
              Navigator.pop(context);
            }
            if (isRefresh) setLoadingState(LoadingState.error);
            Fluttertoast.showToast(msg: response.message);
          },
        ));
  }

  String getTypeDesc(COLLECTION_TYPE type) {
    switch (type) {
      case COLLECTION_TYPE.WANT_LOOK:
        return "想看";
      case COLLECTION_TYPE.LOOKING:
        return "在看";
      case COLLECTION_TYPE.SEEN:
        return "看过";
    }
    return "想看";
  }

  @override
  void disposeBase() {}

  @override
  void dispose() {}
}

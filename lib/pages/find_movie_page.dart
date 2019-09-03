import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:movie_sample/index/index.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

///找片中的电影
class FindMoviePage extends StatelessWidget {
  FindMovieBloc _findMovieBloc;
  RefreshController _refreshController;

  @override
  Widget build(BuildContext context) {
    _findMovieBloc = BlocProvider.of<FindMovieBloc>(context);
    _refreshController = RefreshController();

    if (_findMovieBloc.newMovieListModel == null) {
      Timer(Duration(milliseconds: 50), () {
        _findMovieBloc.getData();
      });
    }

    List<Widget> widgets = <Widget>[];

    //顶部类型
    widgets.add(SliverToBoxAdapter(
      child: FindTabWidget(
        isTv: false,
        onTabClick: (FIND_TYPE type) {
          Fluttertoast.showToast(msg: type.toString());
        },
      ),
    ));
    //电影本周口碑榜
    widgets.add(_buildSubTitle("口碑榜"));
    widgets.add(_buildWeeklyList());
    //北美票房榜
    widgets.add(_buildSubTitle("北美票房"));
    widgets.add(_buildUsBoxList());
    //底部新片榜列表
    widgets.add(_buildSubTitle("新片榜"));
    widgets.add(_buildList());

    return StreamBuilder(
      initialData: _findMovieBloc.newMovieListModel == null ? LoadingState.loading : LoadingState.success,
      stream: _findMovieBloc.loadingStream,
      builder: (BuildContext context, AsyncSnapshot<LoadingState> snapshot) {
        if (snapshot.data == LoadingState.success) {
          _refreshController.refreshCompleted();
        } else {
          _refreshController.refreshFailed();
        }
        return LoadingView(
          state: snapshot.data,
          contentWidget: Container(
            color: Colors.white,
            child: SmartRefresher(
              controller: _refreshController,
              header: ClassicHeader(),
              onRefresh: () {
                _findMovieBloc.getData();
              },
              child: CustomScrollView(
                slivers: widgets,
              ),
            ),
          ),
          allRetryListener: () {
            _findMovieBloc.setLoadingState(LoadingState.loading);
            _findMovieBloc.getData();
          },
        );
      },
    );
  }

  //构建副标题
  Widget _buildSubTitle(String subTitle) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.only(
          left: Density.instance.dp(30),
          top: Density.instance.dp(40),
        ),
        child: Text(
          subTitle,
          style: TextStyle(color: ColorRes.TEXT_HAVY, fontSize: Density.instance.sp(36), fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildWeeklyList() {
    return StreamBuilder(
        initialData: _findMovieBloc.weeklyListModel,
        stream: _findMovieBloc.weekMovieListStream,
        builder: (BuildContext context, AsyncSnapshot<MovieModel> snapshot) {
          MovieModel model = snapshot.data;
          List<SubjectsModel> subjects = (model == null || model.subjects == null) ? <SubjectsModel>[] : model.subjects;
          return _buildWeeklyListWidget(subjects);
        });
  }

  Widget _buildUsBoxList() {
    return StreamBuilder(
        initialData: _findMovieBloc.usBoxListModel,
        stream: _findMovieBloc.usBoxMovieListStream,
        builder: (BuildContext context, AsyncSnapshot<MovieModel> snapshot) {
          MovieModel model = snapshot.data;
          List<SubjectsModel> subjects = (model == null || model.subjects == null) ? <SubjectsModel>[] : model.subjects;
          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Container(
                  color: Colors.white,
                  child: MovieCommonListItem(subjects[index]),
                );
              },
              childCount: subjects.length,
            ),
          );
        });
  }

  //构建底部列表
  Widget _buildList() {
    return StreamBuilder(
        initialData: _findMovieBloc.newMovieListModel,
        stream: _findMovieBloc.newMovieListStream,
        builder: (BuildContext context, AsyncSnapshot<MovieModel> snapshot) {
          MovieModel model = snapshot.data;
          List<SubjectsModel> subjects = (model == null || model.subjects == null) ? <SubjectsModel>[] : model.subjects;
          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Container(
                  color: Colors.white,
                  child: index < subjects.length ? MovieCommonListItem(subjects[index]) : NoMoreWidget(),
                );
              },
              childCount: subjects.length > 0 ? subjects.length + 1 : 0,
            ),
          );
        });
  }

  Widget _buildWeeklyListWidget(List<SubjectsModel> subjects) {
    return SliverPadding(
      padding: EdgeInsets.only(left: Density.instance.dp(30), right: Density.instance.dp(30)),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.49,
          crossAxisSpacing: Density.instance.dp(30),
        ),
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            SubjectsModel data = subjects[index];
            String imgSrc = data.images == null ? "" : data.images.small ?? "";
            String title = data.title != null ? data.title : "未知标题";

            return Container(
              width: double.infinity,
              padding: EdgeInsets.only(top: Density.instance.dp(30)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      _buildItemImg(imgSrc),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: Density.instance.dp(15)),
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: ColorRes.TEXT_HAVY, fontSize: Density.instance.sp(32)),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: Density.instance.dp(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        StaticRatingBar(
                          rate: data.rating == null ? 0 : data.rating.average / 2,
                          size: Density.instance.dp(24),
                          colorDark: ColorRes.TEXT_GRAY,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: Density.instance.dp(10)),
                          child: Text(
                            "${data.rating == null ? 0 : data.rating.average}",
                            style: TextStyle(color: ColorRes.TEXT_GRAY, fontSize: Density.instance.sp(26)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
          childCount: subjects.length,
          addAutomaticKeepAlives: true,
        ),
      ),
    );
  }

  //绘制 item 图片
  Widget _buildItemImg(String imgSrc) {
    return Container(
      width: double.infinity,
      height: Density.instance.dp(290),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Density.instance.dp(8)),
        child: CachedNetworkImage(
          imageUrl: imgSrc,
          placeholder: (context, url) => ImgPlaceHolder(),
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}

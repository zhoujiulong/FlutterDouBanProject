import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_sample/index/index.dart';

class MovieDetailPage extends StatelessWidget {
  final SubjectsModel _subjectsModel;
  MovieDetailBloc _detailBloc;

  MovieDetailPage(this._subjectsModel);

  @override
  Widget build(BuildContext context) {
    _detailBloc = MovieDetailBloc();
    return BlocProvider(
      bloc: _detailBloc,
      child: Scaffold(
        appBar: MYAppBar("电影"),
        body: Column(
          children: <Widget>[_buildTop()],
        ),
      ),
    );
  }

  Widget _buildTop() {
    return Padding(
      padding: EdgeInsets.only(
        left: Density.instance.dp(25),
        top: Density.instance.dp(30),
        right: Density.instance.dp(25),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildTopLeftImg(),
          Expanded(
            child: _buildTopRightWidget(),
          )
        ],
      ),
    );
  }

  Widget _buildTopLeftImg() {
    String imgSrc =
        _subjectsModel.images == null ? "" : _subjectsModel.images.small ?? "";
    return Container(
      width: Density.instance.dp(190),
      height: Density.instance.dp(265),
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

  Widget _buildTopRightWidget() {
    String title = _subjectsModel.title ?? "未知标题";
    String time = _subjectsModel.year ?? "未知年代";

    StringBuffer topMsg = StringBuffer();
    if (_subjectsModel.genres != null && _subjectsModel.genres.length > 0) {
      _subjectsModel.genres.forEach((item) {
        topMsg.write("$item ");
      });
    }
    if (_subjectsModel.pubdates != null && _subjectsModel.pubdates.length > 0) {
      if (topMsg.length > 0 && !topMsg.toString().endsWith("/"))
        topMsg.write("/ ");
      topMsg.write("上映时间:");
      _subjectsModel.pubdates.forEach((item) {
        topMsg.write("$item ");
      });
    }
    if (_subjectsModel.durations != null &&
        _subjectsModel.durations.length > 0) {
      if (topMsg.length > 0 && !topMsg.toString().endsWith("/"))
        topMsg.write("/ ");
      topMsg.write("片长:");
      _subjectsModel.durations.forEach((item) {
        topMsg.write("$item ");
      });
    }

    return Padding(
      padding: EdgeInsets.only(
          left: Density.instance.dp(26), right: Density.instance.dp(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: ColorRes.TEXT_HAVY,
              fontSize: Density.instance.sp(42),
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: Density.instance.dp(8)),
            child: Text(
              "年代：$time",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: ColorRes.TEXT_NORMAL,
                fontSize: Density.instance.sp(32),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: Density.instance.dp(20)),
            child: Container(
              height: Density.instance.dp(50),
              child: Text(
                topMsg.toString(),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: ColorRes.TEXT_NORMAL,
                  fontSize: Density.instance.sp(22),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: Density.instance.dp(30)),
            child: _buildTopBottomButton(),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBottomButton() {
    return Container(
      height: Density.instance.dp(68),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              height: Density.instance.dp(68),
              decoration: BoxDecoration(
                color: ColorRes.ACCOUNT_PAGE_TOP_BG_GRAY,
                borderRadius: BorderRadius.all(
                  Radius.circular(Density.instance.dp(6)),
                ),
              ),
              child: Center(
                child: Text(
                  "想看",
                  style: TextStyle(
                    fontSize: Density.instance.sp(30),
                    color: ColorRes.TEXT_RED,
                  ),
                ),
              ),
            ),
          ),
          Container(
            width: Density.instance.dp(30),
          ),
          Expanded(
            flex: 1,
            child: Container(
              height: Density.instance.dp(68),
              decoration: BoxDecoration(
                color: ColorRes.ACCOUNT_PAGE_TOP_BG_GRAY,
                borderRadius: BorderRadius.all(
                  Radius.circular(Density.instance.dp(6)),
                ),
              ),
              child: Center(
                child: Text(
                  "看过",
                  style: TextStyle(
                    fontSize: Density.instance.sp(30),
                    color: ColorRes.TEXT_RED,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_sample/index/index.dart';

class MovieCommonListItem extends StatelessWidget {
  final SubjectsModel data;
  BuildContext _context;

  MovieCommonListItem(this.data);

  @override
  Widget build(BuildContext context) {
    _context = context;
    return _buildItem();
  }

  //创建 item
  Widget _buildItem() {
    String title = data.title != null ? data.title : "未知标题";
    String imgSrc = data.images == null ? "" : data.images.small ?? "";

    StringBuffer msg = StringBuffer();
    msg.write(data.year != null ? "${data.year} / " : "");
    if (data.pubdates != null) {
      data.pubdates.forEach((value) {
        msg.write("$value ");
      });
      msg.write("/ ");
    }
    if (data.genres != null) {
      data.genres.forEach((value) {
        msg.write("$value ");
      });
      msg.write("/ ");
    }
    if (data.directors != null) {
      data.directors.forEach((value) {
        if (value.name != null) {
          msg.write("${value.name} /");
        }
      });
    }
    String msgStr = msg.toString();
    if (msgStr.endsWith("/")) {
      msgStr = msgStr.substring(0, msgStr.length - 1);
    }

    return _buildItemWidget(data, title, imgSrc, msgStr);
  }

  //构建 item 控件
  Widget _buildItemWidget(
      SubjectsModel data, String title, String imgSrc, String msgStr) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(
              left: Density.instance.dp(25),
              right: Density.instance.dp(25),
              top: Density.instance.dp(30),
              bottom: Density.instance.dp(30)),
          child: GestureDetector(
            onTap: () {
              Navigator.push(_context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return MovieDetailPage(data);
              }));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildItemLeftImg(imgSrc),
                Expanded(child: _buildItemCenterMsg(data, title, msgStr)),
              ],
            ),
          ),
        ),
        Container(
          color: ColorRes.LINE,
          height: Density.instance.dp(1),
        )
      ],
    );
  }

  //绘制 item 左边图片
  Widget _buildItemLeftImg(String imgSrc) {
    return Container(
      width: Density.instance.dp(160),
      height: Density.instance.dp(230),
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

  //构建 item 中间信息
  Widget _buildItemCenterMsg(SubjectsModel data, String title, String msgStr) {
    return Padding(
      padding: EdgeInsets.only(
          left: Density.instance.dp(26), right: Density.instance.dp(10)),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: ColorRes.TEXT_HAVY,
                  fontSize: Density.instance.sp(32),
                  fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: EdgeInsets.only(top: Density.instance.dp(20)),
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
                      style: TextStyle(
                          color: ColorRes.TEXT_GRAY,
                          fontSize: Density.instance.sp(26)),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: Density.instance.dp(20)),
              child: Text(
                msgStr,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: ColorRes.TEXT_GRAY,
                    fontSize: Density.instance.sp(22)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

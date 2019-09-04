import 'package:flutter/material.dart';
import 'package:movie_sample/index/index.dart';

class SearchPage extends StatelessWidget {
  SearchBloc _searchBloc;

  @override
  Widget build(BuildContext context) {
    _searchBloc = SearchBloc();

    return BlocProvider(
      bloc: _searchBloc,
      child: Scaffold(
        appBar: AppBarContainer(
          height: Density.instance.dp(88),
          backgroundColor: Colors.white,
          child: Container(
            width: double.infinity,
            height: Density.instance.dp(88),
            padding: EdgeInsets.only(left: Density.instance.dp(25), right: Density.instance.dp(25)),
            child: _SearchInputWidget(),
          ),
        ),
        body: Container(
          child: Text(""),
        ),
      ),
    );
  }
}

class _SearchInputWidget extends StatelessWidget {
  TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SearchBloc _searchBloc = BlocProvider.of<SearchBloc>(context);

    return Row(
      children: <Widget>[
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(Density.instance.dp(44)),
            child: Container(
              color: ColorRes.WINDOW_BG,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: Density.instance.dp(30)),
                    width: Density.instance.dp(70),
                    height: Density.instance.dp(40),
                    child: Image.asset(ImageUtil.getImagePath("ic_seach"), fit: BoxFit.fill),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: Density.instance.dp(10)),
                      child: TextField(
                        controller: _textController,
                        onChanged: (String value) {
                          _searchBloc.setClearTextShow(value != null && value.length > 0);
                        },
                        decoration: InputDecoration(
                          hintText: "电影/电视剧/影人",
                          hintStyle: TextStyle(color: ColorRes.TEXT_GRAY, fontSize: Density.instance.sp(30)),
                          border: InputBorder.none,
                        ),
                        style: TextStyle(color: ColorRes.TEXT_NORMAL, fontSize: Density.instance.sp(30)),
                        autofocus: true,
                      ),
                    ),
                  ),
                  StreamBuilder(
                    initialData: false,
                    stream: _searchBloc.showClearTextStream,
                    builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                      if (snapshot.data) {
                        return GestureDetector(
                          onTap: () {
                            _textController.clear();
                            _searchBloc.setClearTextShow(false);
                          },
                          child: Padding(
                            padding: EdgeInsets.only(left: Density.instance.dp(25), right: Density.instance.dp(25)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(Density.instance.dp(25)),
                              child: Container(
                                color: ColorRes.TEXT_NORMAL_TRANS,
                                width: Density.instance.dp(50),
                                height: Density.instance.dp(50),
                                child: Center(
                                  child: Container(
                                    width: Density.instance.dp(30),
                                    height: Density.instance.dp(30),
                                    child: Image.asset(
                                      ImageUtil.getImagePath("ic_close_x"),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      } else {
                        return Container(width: 0, height: 0);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Padding(
            padding: EdgeInsets.only(left: Density.instance.dp(30)),
            child: Text(
              "取消",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.green, fontSize: Density.instance.sp(30)),
            ),
          ),
        ),
      ],
    );
  }
}

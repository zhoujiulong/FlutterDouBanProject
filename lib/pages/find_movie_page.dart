import 'package:flutter/material.dart';
import 'package:movie_sample/index/index.dart';

///找片中的电影
class FindMoviePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FindMovieBloc _findMovieBloc = BlocProvider.of<FindMovieBloc>(context);

    return StreamBuilder(
      initialData: LoadingState.success,
      stream: _findMovieBloc.loadingStream,
      builder: (BuildContext context, AsyncSnapshot<LoadingState> snapshot) {
        return LoadingView(
          state: snapshot.data,
          contentWidget: Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                FindTabWidget(),
              ],
            ),
          ),
        );
      },
    );
  }
}

class FindTabWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        _buildItem("找电影", ""),
        _buildItem("豆瓣榜单", ""),
        _buildItem("豆瓣猜", ""),
        _buildItem("豆瓣片单", ""),
      ],
    );
  }

  Widget _buildItem(String msg, String icName) {
    return Text(msg);
  }
}

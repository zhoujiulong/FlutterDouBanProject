import 'package:flutter/material.dart';
import 'package:movie_sample/index/widget_index.dart';

class FindMoviePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MYAppBar(
        "找片",
        showBack: false,
      ),
      backgroundColor: Colors.white,
      body: LoadingView(
        contentWidget: Text("find movie"),
        state: LoadingState.success,
      ),
    );
  }
}

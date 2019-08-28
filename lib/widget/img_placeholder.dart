import 'package:flutter/material.dart';
import 'package:movie_sample/index/index.dart';

class ImgPlaceHolder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: SizedBox(
          width: Density.instance.dp(40),
          height: Density.instance.dp(40),
          child: CircularProgressIndicator(
            strokeWidth: Density.instance.dp(4),
          ),
        ),
      ),
    );
  }
}

import 'package:movie_sample/index/index.dart';

///我的主页列表消息实体类
class AccountListEventModel {
  AccountListEventModel(this.movieModel, this.collectionType);

  MovieModel movieModel;
  COLLECTION_TYPE collectionType;
}

import 'package:get_it/get_it.dart';
import '../details/post_details_bloc.dart';
import '../list/post_list_bloc.dart';
import '../network/api.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerFactory<PostsDataProvider>(() => Api());
  locator.registerSingleton(PostListBloc());
  locator.registerSingleton(PostDetailsBloc());
}

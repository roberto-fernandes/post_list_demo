import 'package:post_list_demo/list/post_list_bloc.dart';
import 'package:post_list_demo/models/post_list.dart';

const String MOCK_ERROR_MESSAGE = "mock error message";

//Mock Test Error Data
class MockPostDataProviderError implements PostsDataProvider {
  @override
  Future<PostsList> loadPosts() {
    return Future.value(PostsList(null, MOCK_ERROR_MESSAGE));
  }
}

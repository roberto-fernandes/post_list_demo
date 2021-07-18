import 'dart:async';

import 'package:post_list_demo/list/post_list_bloc.dart';
import 'package:post_list_demo/models/post.dart';
import 'package:post_list_demo/models/post_list.dart';

//Mock Sucess Test Data
class MockPostsDataProvider implements PostsDataProvider {
  @override
  Future<PostsList> loadPosts() async {
    List<Post> list = <Post>[];
    for (int i = 0; i < 20; i++) {
      list.add(
        Post(
          id: 1,
          title: "This is mock post title num $i",
          body: "This is mock post body num $i",
        ),
      );
    }

    return Future.value(PostsList(list, null));
  }
}

import 'dart:async';

import 'package:post_list_demo/models/post_list.dart';
import 'package:rxdart/rxdart.dart';

import '../di/dependency_injector.dart';

class PostListBloc {
  PostsDataProvider provider = locator<PostsDataProvider>();

  BehaviorSubject<PostsList> _itemsController = BehaviorSubject<PostsList>();
  Stream<PostsList> get outPosts => _itemsController.stream;

  Future loadItems() async {
    PostsList items = await provider.loadPosts();
    _itemsController.sink.add(items);
  }

  void dispose() {
    _itemsController.close();
  }

  void injectDataProviderForTest(PostsDataProvider provider) {
    this.provider = provider;
  }
}

abstract class PostsDataProvider {
  Future<PostsList> loadPosts();
}

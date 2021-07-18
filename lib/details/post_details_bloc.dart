import 'dart:async';
import 'package:post_list_demo/di/dependency_injector.dart';
import 'package:post_list_demo/list/post_list_bloc.dart';
import 'package:post_list_demo/models/post.dart';
import 'package:rxdart/rxdart.dart';

class PostDetailsBloc {
  var carsListBloc = locator<PostListBloc>();

  BehaviorSubject<Post?> _itemController = BehaviorSubject<Post?>();
  Stream<Post?> get outItem => _itemController.stream;
  StreamSubscription? _subscription;
  int? _currentId;

  void getItem(int id) async {
    _itemController.sink.add(null);

    _currentId = id;
    if (_subscription != null) {
      _subscription?.cancel();
    }

    _subscription = carsListBloc.outPosts.listen((listOfItems) async {
      if (listOfItems.items != null) {
        for (var item in listOfItems.items!) {
          if (item.id == _currentId) {
            _itemController.sink.add(item);
            break;
          }
        }
      }
    });
  }

  void dispose() {
    if (_subscription != null) {
      _subscription?.cancel();
    }
    _itemController.close();
  }
}

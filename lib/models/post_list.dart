import 'post.dart';

class PostsList {
  final List<Post>? items;

  final String? errorMessage;

  PostsList(this.items, this.errorMessage);

  @override
  String toString() {
    return 'items: $items errorMessage: $errorMessage';
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:post_list_demo/utils/constants.dart';
import 'package:post_list_demo/di/dependency_injector.dart';
import 'package:post_list_demo/list/post_list_bloc.dart';
import 'package:post_list_demo/list/post_list_page.dart';
import 'package:post_list_demo/models/post.dart';
import 'package:post_list_demo/models/post_list.dart';

import '../network/mock_post_data_provider.dart';
import '../network/mock_post_data_provider_error.dart';

void main() {
  setupLocator();
  var postListBloc = locator<PostListBloc>();

  testWidgets("Posts are displayed in a list", (WidgetTester tester) async {
    // Inject and Load Mock Data
    postListBloc.injectDataProviderForTest(MockPostsDataProvider());

    // Load Mock Data for Verification
    PostsList posts = await MockPostsDataProvider().loadPosts();
    print('test post list: $posts');

    // Load and render Widget
    await tester.pumpWidget(ListPageWrapper());
    await tester.pump(Duration.zero);

    //  Check Post List's component's existence via key
    final postListKey = find.byKey(Key(POSTS_LIST_KEY));
    expect(postListKey, findsOneWidget);

    // Call Verify Post Details function
    if (posts.items != null) {
      _verifyAllPostsDetails(posts.items!, tester);
    }
  });

  testWidgets(
      'After encountering an error, proper error message is shown when an error occurred',
      (WidgetTester tester) async {
    // Inject and Load Error Mock Data
    postListBloc.injectDataProviderForTest(MockPostDataProviderError());

    // Load and render Widget
    await tester.pumpWidget(ListPageWrapper());
    await tester.pump(Duration.zero);

    // Verify that Error Message is shown
    final errorFinder = find.text(MOCK_ERROR_MESSAGE);
    expect(errorFinder, findsOneWidget);
  });

  testWidgets(
      'After encountering an error, and stream is updated, Widget is also updated.',
      (WidgetTester tester) async {
    // Inject and Load Error Mock  Data
    postListBloc.injectDataProviderForTest(MockPostDataProviderError());

    // Load and render Widget
    await tester.pumpWidget(ListPageWrapper());
    await tester.pump(Duration.zero);

    // Verify that Error Message and Retry Button is shown
    final errorFinder = find.text(MOCK_ERROR_MESSAGE);
    final retryButtonFinder = find.text(RETRY_BUTTON);
    expect(errorFinder, findsOneWidget);
    expect(retryButtonFinder, findsOneWidget);

    // Inject and Load Mock Data
    postListBloc.injectDataProviderForTest(MockPostsDataProvider());
    await tester.tap(retryButtonFinder);

    // Reload Widget
    await tester.pump(Duration.zero);

    // Load and Verify Data
    PostsList posts = await MockPostsDataProvider().loadPosts();
    if (posts.items != null) {
      _verifyAllPostsDetails(posts.items!, tester);
    }
  });
}

// TODO 8: Create a function to verify list's existence
void _verifyAllPostsDetails(List<Post> postsList, WidgetTester tester) async {
  for (var post in postsList) {
    final postTitleFinder = find.text(post.title ?? "");
    await tester.ensureVisible(postTitleFinder);
    expect(postTitleFinder, findsOneWidget);
  }
}

class ListPageWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // key: Key(POSTS_LIST_KEY),
      home: ListPage(),
    );
  }
}

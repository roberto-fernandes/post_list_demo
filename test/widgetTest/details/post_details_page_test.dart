import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:post_list_demo/utils/constants.dart';
import 'package:post_list_demo/di/dependency_injector.dart';
import 'package:post_list_demo/details/post_details_page.dart';
import 'package:post_list_demo/list/post_list_bloc.dart';
import 'package:post_list_demo/models/post_list.dart';

import '../network/mock_post_data_provider.dart';

late PostsList postsList;

void main() {
  setupLocator();
  var postsList = locator<PostListBloc>();

  testWidgets('Details Page should be shown with Post Info',
      (WidgetTester tester) async {
    // Inject and Load Mock Car Data
    postsList.injectDataProviderForTest(MockPostsDataProvider());
    await postsList.loadItems();

    // Load & Sort Mock Data for Verification
    PostsList posts = await MockPostsDataProvider().loadPosts();

    // Load and render Widget
    await tester.pumpWidget(DetailsPageSelectedWrapper(1));
    await tester.pump(Duration.zero);

    // Verify Post Details
    final carDetailsKey = find.byKey(Key(POST_DETAILS_KEY));
    expect(carDetailsKey, findsOneWidget);
    var post = posts.items![0];

    print('test post detail: $post');

    final pageTitleFinder = find.textContaining(post.title!);
    expect(pageTitleFinder, findsOneWidget);

    final descriptionTextFinder = find.text(post.body!);
    expect(descriptionTextFinder, findsOneWidget);
  });
}

class DetailsPageSelectedWrapper extends StatelessWidget {
  final int id;

  DetailsPageSelectedWrapper(this.id);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PostDetailsPage(id: id),
    );
  }
}

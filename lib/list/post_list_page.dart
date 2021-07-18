import 'package:flutter/material.dart';
import 'package:post_list_demo/details/post_details_page.dart';
import 'package:post_list_demo/models/post.dart';
import 'package:post_list_demo/models/post_list.dart';

import '../utils/constants.dart';
import '../di/dependency_injector.dart';
import 'post_list_bloc.dart';

class ListPage extends StatefulWidget {
  ListPage({Key? key}) : super(key: key);

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  var listBloc = locator<PostListBloc>();

  @override
  void initState() {
    super.initState();
    listBloc.loadItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(LIST_PAGE_TITLE),
        ),
        body: StreamBuilder<PostsList>(
          stream: listBloc.outPosts,
          initialData: null,
          builder: (BuildContext context, AsyncSnapshot<PostsList> snapshot) {
            print(snapshot.data);
            if (snapshot.hasError) {
              return _displayErrorMessage(snapshot.error.toString());
            } else if (snapshot.data == null) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.data?.errorMessage != null) {
              return _displayErrorMessage(snapshot.data!.errorMessage!);
            } else {
              return SingleChildScrollView(
                child: ListView(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  key: Key(POSTS_LIST_KEY),
                  physics: NeverScrollableScrollPhysics(),
                  children: snapshot.data!.items?.map((Post value) {
                        return _buildListRow(value);
                      }).toList() ??
                      [],
                ),
              );
            }
          },
        ));
  }

  Widget _displayErrorMessage(String errorMessage) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          children: <Widget>[
            Spacer(),
            Text(errorMessage),
            SizedBox(
              height: 10.0,
            ),
            ElevatedButton(
              child: Text(RETRY_BUTTON),
              onPressed: () {
                listBloc.loadItems();
              },
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildListRow(Post post) {
    return Container(
        child: Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0))),
      child: ListTile(
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '${post.id}',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            post.title ?? "",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
          ),
        ),
        onTap: () {
          _displayDetails(post);
        },
      ),
    ));
  }

  void _displayDetails(Post post) async {
    await Navigator.of(context).push(new MaterialPageRoute<Null>(
      builder: (BuildContext context) {
        return PostDetailsPage(id: post.id);
      },
    ));
  }
}

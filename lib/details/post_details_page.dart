import 'package:flutter/material.dart';
import 'package:post_list_demo/list/post_list_bloc.dart';
import 'package:post_list_demo/models/post.dart';

import '../utils/constants.dart';
import '../di/dependency_injector.dart';
import 'post_details_bloc.dart';

class PostDetailsPage extends StatefulWidget {
  PostDetailsPage({Key? key, this.id}) : super(key: key);

  final int? id;

  @override
  _PostDetailsPageState createState() => _PostDetailsPageState();
}

class _PostDetailsPageState extends State<PostDetailsPage> {
  var postDetailsBloc = locator<PostDetailsBloc>();
  var postsListBloc = locator<PostListBloc>();

  @override
  void initState() {
    super.initState();
    if (widget.id != null) {
      postDetailsBloc.getItem(widget.id!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<Post?>(
          stream: postDetailsBloc.outItem,
          initialData: null,
          builder: (BuildContext context, AsyncSnapshot<Post?> snapshot) {
            if (snapshot.data == null) {
              return Center(child: CircularProgressIndicator());
            } else {
              return Text('${snapshot.data?.id ?? ""}');
            }
          },
        ),
      ),
      body: StreamBuilder<Post?>(
        key: Key(POST_DETAILS_KEY),
        stream: postDetailsBloc.outItem,
        initialData: null,
        builder: (BuildContext context, AsyncSnapshot<Post?> snapshot) {
          if (snapshot.data == null) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.data != null) {
              return _buildDetailsView(snapshot.data!);
            }
          }
          return Text(ERROR_MESSAGE);
        },
      ),
    );
  }

  Widget _buildDetailsView(Post item) {
    return Container(
      padding: EdgeInsets.all(24.0),
      child: ListView(
        children: <Widget>[
          SizedBox(
            height: 11.0,
          ),
          Text(
            item.title ?? "",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 33.0,
          ),
          Text(item.body ?? ""),
        ],
      ),
    );
  }
}

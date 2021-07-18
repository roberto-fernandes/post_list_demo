import 'package:flutter/material.dart';
import 'utils/constants.dart';
import 'di/dependency_injector.dart';
import 'details/post_details_bloc.dart';
import 'list/post_list_bloc.dart';
import 'list/post_list_page.dart';

void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var postsListBloc = locator<PostListBloc>();
  var postDetailsBloc = locator<PostDetailsBloc>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: APP_NAME,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ListPage(),
    );
  }

  @override
  void dispose() {
    postsListBloc.dispose();
    postDetailsBloc.dispose();
    super.dispose();
  }
}

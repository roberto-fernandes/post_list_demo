import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:post_list_demo/list/post_list_bloc.dart';
import 'package:post_list_demo/models/post.dart';
import 'package:post_list_demo/models/post_list.dart';

import '../utils/constants.dart';

class Api implements PostsDataProvider {
  static const endpoint = URL.ProductList;
  static final Api _instance = new Api._internal();
  var client = new http.Client();
  factory Api() {
    return _instance;
  }

  Api._internal();

  @override
  Future<PostsList> loadPosts() async {
    try {
      var response = await client.get(Uri.parse(endpoint));
      final parsed = List<dynamic>.from(json.decode(response.body));
      final list = parsed.map((json) => Post.fromJson(json)).toList();
      return PostsList(list, null);
    } catch (exception) {
      return PostsList(null, exception.toString());
    }
  }
}

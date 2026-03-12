import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:interntesting/datas/base_url.dart';
import 'package:interntesting/models/posts.dart';

class PostsController {
  
  Future<List<Posts>> getPosts() async {
    final url = Uri.parse(BaseUrl.postUrl);
    debugPrint('Fetching posts from: $url');
    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'User-Agent': 'flutter-app',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((x) => Posts.fromJson(x)).toList();
    } else {
      throw Exception('Failed to load Post (all): Status ${response.statusCode}');
    }
  }

  Future<List<Posts>> getPostsfromId(int id) async {
    final url = Uri.parse('${BaseUrl.postUrl}/$id');
    debugPrint('Fetching post from: $url');
    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'User-Agent': 'flutter-app',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((x) => Posts.fromJson(x)).toList();
    } else {
      throw Exception('Failed to load Post (id): Status ${response.statusCode}');
    }
  }
}
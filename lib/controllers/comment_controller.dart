import 'package:http/http.dart' as http;
import 'package:interntesting/datas/base_url.dart';
import 'package:interntesting/models/comment.dart';
import 'dart:convert';

class CommentController {
  
  Future<List<Comments>> getCommentsfromId(int id) async {
    final url = Uri.parse('${BaseUrl.postUrl}/$id/comments');
    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'User-Agent': 'flutter-app',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((x) => Comments.fromJson(x)).toList();
    } else {
      throw Exception('Failed to load comments');
    }
  }
//https://jsonplaceholder.typicode.com/comments?postId=1
  Future<List<Comments>> getCommentsfromPostId(int id) async {
    final url = Uri.parse('${BaseUrl.commentUrl}?postId=$id');
    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'User-Agent': 'flutter-app',
      },
    );
    
    if (response.statusCode == 200) {
      // ✅ ต้อง decode String เป็น List ก่อน
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((x) => Comments.fromJson(x)).toList();
    } else {
      throw Exception('Failed to load comments');
    }
  }
}
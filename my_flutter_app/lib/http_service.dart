import 'package:http/http.dart';
import 'package:my_flutter_app/post_model.dart';
import 'package:http/http.dart';
import 'dart:convert';

class HttpService {
    final String postUrl = 'http://127.0.0.1:8762/user/all';

    Future<Map<String, dynamic>> getPosts() async {
      Response res = await get(postUrl);
      //print("Resp: " + res.body['statusOperation'].toString());
      
      if(res.statusCode == 200){
        print("1");
        Map<String, dynamic> body = jsonDecode(res.body);
        print("2 " + body['statusOperation']['description'].toString());
        //List<Post> posts = body.map((dynamic item) => Post.fromJson(item)).toList();
        print('3');
        return body;
      } else {
        throw "Cant get posts";
      }
    }
}
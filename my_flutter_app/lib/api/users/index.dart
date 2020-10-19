import 'package:http/http.dart';
import 'package:my_flutter_app/constants.dart';
import 'dart:convert';


class HttpUserService {
  Future<Map<String, dynamic>> loginUser(body) async {
    Response res = await post(LOGIN_URL, body: body, headers: HEADER_JSON);
    try{
      Map<String, dynamic> body = jsonDecode(res.body);
      return body;
    } catch(e){
      print("Error on loginUser " + e);
      return e;
    }
  }

  Future<Map<String, dynamic>> processUser(body) async{
    Response res = await post(PROCESS_USER_URL, body: body, headers: HEADER_JSON);
    try{
      Map<String, dynamic> body = jsonDecode(res.body);
      return body;
    } catch(e){
      print("Error on processUser " + e);
      return e;
    }
  }
}
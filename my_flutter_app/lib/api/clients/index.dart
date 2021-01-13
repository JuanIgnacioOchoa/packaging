import 'package:http/http.dart';
import 'package:top_express/constants.dart';
import 'dart:convert';


class HttpClientService {
  Future<Map<String, dynamic>> loginClient(body) async {
    var _body = body;
    try{
      Response res = await post(LOGIN_URL, headers: HEADER_JSON, body: _body);
      Map<String, dynamic> body = jsonDecode(res.body);
      return body;
    } catch(e){
      print("Error on loginClient " + e.toString());
      return e;
    }
  }

  Future<Map<String, dynamic>> processClient(body) async{
    Response res = await post(PROCESS_CLIENT_URL, body: body, headers: HEADER_JSON);
    try{
      Map<String, dynamic> body = jsonDecode(res.body);
      return body;
    } catch(e){
      print("Error on processClient " + e);
      return e;
    }
  }
}
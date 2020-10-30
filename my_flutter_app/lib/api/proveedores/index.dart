
import 'package:http/http.dart';
import 'package:my_flutter_app/constants.dart';
import 'dart:convert';


class HttpSuppliersService {
  Future<Map<String, dynamic>> getPackages(body) async {
    Response res = await get(GET_SUPPLIERS, headers: HEADER_JSON);
    //Response res = await get(GET_SUPPLIERS, body: body, headers: HEADER_JSON);
    try{
      Map<String, dynamic> body = jsonDecode(res.body);
      return body;
    } catch(e){
      print("Error on getPackages " + e);
      return e;
    }
  }
}
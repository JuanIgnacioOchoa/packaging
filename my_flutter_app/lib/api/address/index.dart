import 'package:http/http.dart';
import 'package:my_flutter_app/constants.dart';
import 'dart:convert';


class HttpAddressService {

  Future<Map<String, dynamic>> processClient(body) async{
    Response res = await post(PROCESS_ADDRESS_URL, body: body, headers: HEADER_JSON);
    try{
      Map<String, dynamic> body = jsonDecode(res.body);
      return body;
    } catch(e){
      print("Error on processClient " + e);
      return e;
    }
  }
}
import 'dart:io';
import 'dart:typed_data';

import 'package:async/async.dart';
import 'package:flutter/services.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:http/http.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:my_flutter_app/constants.dart';
import 'dart:convert';
import 'package:http_parser/http_parser.dart';
//simport 'package:dio/dio.dart';


class HttpPackagesService {
  Future<Map<String, dynamic>> getPackages(body) async {
    Response res = await post(GET_PACKAGES_URL, body: body, headers: HEADER_JSON);
    try{
      Map<String, dynamic> body = jsonDecode(res.body);
      return body;
    } catch(e){
      print("Error on getPackages " + e);
      return e;
    }
  }

  Future<Response> postPackages(body, image) async {
    
    try{
      var req = MultipartRequest("POST", Uri.parse(PROCESS_PACKAGES_URL));
      if(image.length > 0){
        Asset a = image[0];
        var path = await FlutterAbsolutePath.getAbsolutePath(a.identifier);
        File file = File(path);
        var stream = new ByteStream(DelegatingStream.typed(file.openRead()));
        // get file length
        var length = await file.length();

        // multipart that takes file
        var multipartFile = new MultipartFile('file', stream, length,
            filename: 'file',
            contentType: new MediaType('image', 'jpeg')
          );
        req.files.add(multipartFile);
      }
      body.forEach((k, v) {
        req.fields[k] = v.toString();
      });
      
      req.headers.addAll(HEADER_JSON_MULTIFORM);
      var streamedResponse = await req.send();
      var response = Response.fromStream(streamedResponse);
      print(streamedResponse);
      return response;
      
      //return null;
    } on FileSystemException catch (exception) {
      print("FileSystemException Error on getPackages $exception");
      return null;
    } on MissingPluginException catch(exception){
      print("MissingPluginException Error on getPackages $exception");
      return null;
    } catch(e){
      print("Error on getPackages " + e);
      return null;
    }
  }
}
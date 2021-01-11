import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:async/async.dart';
import 'package:flutter/services.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:http/http.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:top_express/constants.dart';
import 'dart:convert';
import 'package:http_parser/http_parser.dart';
//simport 'package:dio/dio.dart';


class HttpPackagesService {
  Future<Map<String, dynamic>> getPackages(body) async {
    print('getPackages : $body}');
    Response res = await post(GET_PACKAGES_URL, body: body, headers: HEADER_JSON);
    try{
      Map<String, dynamic> body = jsonDecode(res.body);
      return body;
    } catch(e){
      print("Error on getPackages " + e);
      return e;
    }
  }

  Future<Map<String, dynamic>> postPackages(body, images) async {
    var bodyTmp = body;

    var imageArray = [];
    try{
      List<Asset> _images = images;
      for(var i = 0; i < _images.length; i++){
        Asset a = _images[i];
        var path = await FlutterAbsolutePath.getAbsolutePath(a.identifier);
        //File fileTmp = (File(path));
        File file = await compressFile(File(path));
        List<int> imageBytes = await file.readAsBytes();
        String base64Image = base64Encode(imageBytes);
        var imageMap = new Map<String, dynamic>();
        //print("Base64: " + base64Image);
        imageMap['name'] = file.path.split('/').last;
        imageMap['base64'] = base64Image;
        imageArray.add(imageMap);
      }
      
      bodyTmp['images'] = imageArray;
      var map = new Map<String, dynamic>();
      map['newPackage'] = 'true';
      map['packages'] = [bodyTmp];
      Response res = await post(PROCESS_PACKAGES_URL, body: json.encode(map), headers: HEADER_JSON);
      Map<String, dynamic> body = jsonDecode(res.body);
      return body;
    } catch(e){
      print("Error on loginClient " + e);
      return e;
    }
  }

Future<File> compressFile(File file) async {
  var filePath = file.absolute.path;
  filePath = filePath.substring(0, filePath.indexOf('.')) + '.jpeg';
  // Create output file path
  // eg:- "Volume/VM/abcd_out.jpeg"
  print('Comp: ' + file.absolute.path);
  final lastIndex = filePath.lastIndexOf(new RegExp(r'.jp'));
  final splitted = filePath.substring(0, (lastIndex));
  //final outPath = "/Users/juanochoa/Library/Developer/CoreSimulator/Devices/9D050230-F4F6-469F-B106-66621D8DD11E/data/Media/DCIM/100APPLE/IMG_0006_out.jpg";
  final outPath = "${splitted}_out${filePath.substring(lastIndex)}";
  var result = await FlutterImageCompress.compressAndGetFile(
    file.absolute.path, outPath,
    quality: 5,
  );
  return result;
 }
  Future<Map<String, dynamic>> postPackagesImage(body, image) async {
    try{
      
      var req = MultipartRequest("POST", Uri.parse(PROCESS_PACKAGES_IMAGE_URL));
      Asset a = image;
      var path = await FlutterAbsolutePath.getAbsolutePath(a.identifier);
      //File fileTmp = (File(path));
      File file = await compressFile(File(path));
      
      var stream = new ByteStream(DelegatingStream.typed(file.openRead()));
      // get file length
      var length = await file.length();

      // multipart that takes file
      var multipartFile = new MultipartFile('file', stream, length,
          filename: 'file',
          contentType: new MediaType('image', 'jpeg')
        );
      req.files.add(multipartFile);
      List<int> imageBytes = file.readAsBytesSync();
      String base64Image = base64Encode(imageBytes);
      //File comp = await compressFile((file));
      //List<int> imageBytes = await file.readAsBytesSync();
      body.forEach((k, v) {
        req.fields[k] = v.toString();
      });
      req.headers.addAll(HEADER_JSON_MULTIFORM);
      var streamedResponse = await req.send();
      var response = await Response.fromStream(streamedResponse);
      Map<String, dynamic> returnVal = jsonDecode(response.body);
      return returnVal;
      
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
import 'dart:convert';
import 'package:flutter/material.dart';

const URL = 'http://127.0.0.1:8762';
//const URL = 'http://topexpressqa-env.eba-dcnvmavd.us-east-2.elasticbeanstalk.com';

const LIGHT_GREEN = Color.fromRGBO(159, 185, 73, 1);
const DARK_GREEN = Color.fromRGBO(110, 165, 74, 1);

const USERNAME = "topexpress";
const PASSWORD = "kjaoisdu091n2,m9xu09123l";

final BASIC_AUTH = 'Basic ' + base64Encode(utf8.encode('$USERNAME:$PASSWORD'));
      
final HEADER_JSON = {
  'Content-type' : 'application/json', 
  'Accept': 'application/json',
  'authorization': BASIC_AUTH
};
      
final HEADER_JSON_MULTIFORM = {
  'Content-type' : 'multipart/form-data', 
  'authorization': BASIC_AUTH
};


const LOGIN_URL = URL + '/user/login';
const PROCESS_USER_URL = URL + '/user/process';
const PROCESS_ADDRESS_URL = URL + '/user/address/process';

const GET_PACKAGES_URL = URL + '/user/package';
const PROCESS_PACKAGES_URL = URL + '/package/process';

const GET_SUPPLIERS = URL + '/suppliers/all';



final INACTIVO_ID = 579537915;
final ACTIVO_ID = 670640726;
final PENDING_CONFIRMATION_ID = 117941731;


final TRANSCURSO_ID = 322132265;
final ENTREGADO_ID = 513742944;
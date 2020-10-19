import 'dart:convert';

const URL = 'http://127.0.0.1:8762';
//const URL = 'http://topexpressqa-env.eba-dcnvmavd.us-east-2.elasticbeanstalk.com';

const USERNAME = "topexpress";
const PASSWORD = "kjaoisdu091n2,m9xu09123l";

final BASIC_AUTH = 'Basic ' + base64Encode(utf8.encode('$USERNAME:$PASSWORD'));
      
final HEADER_JSON = {
  'Content-type' : 'application/json', 
  'Accept': 'application/json',
  'authorization': BASIC_AUTH
};


const LOGIN_URL = URL + '/user/login';
const PROCESS_USER_URL = URL + '/user/process';
const PROCESS_ADDRESS_URL = URL + '/user/address/process';



final INACTIVO_ID = 579537915;
final ACTIVO_ID = 670640726;
final PENDING_CONFIRMATION_ID = 117941731;
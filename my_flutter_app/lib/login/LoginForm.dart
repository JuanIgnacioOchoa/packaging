import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

typedef void StringCallback(String val);
class LoginForm extends StatelessWidget {
  final StringCallback callbackUsernameChange;
  final StringCallback callbackPasswordChange;
  LoginForm({this.callbackUsernameChange, this.callbackPasswordChange});
  @override
  Widget build(BuildContext context) {
    return new Container(
      width: double.infinity,
//      height: ScreenUtil.getInstance().setHeight(500),
      padding: EdgeInsets.only(bottom: 1),
      decoration: BoxDecoration(
          color: Color.fromRGBO(255, 255, 255, 0.39),
          
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
                color: Colors.black12,
                offset: Offset(0.0, 15.0),
                blurRadius: 15.0),
            BoxShadow(
                color: Colors.black12,
                offset: Offset(0.0, -10.0),
                blurRadius: 10.0),
          ]),
      child: Padding(
        padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: ScreenUtil().setHeight(30),
            ),
            TextField(
              decoration: InputDecoration(
                  hintText: "username",
                  hintStyle: TextStyle(color: Colors.white, fontSize: 12.0)),
                  onChanged: callbackUsernameChange,
            ),
            SizedBox(
              height: ScreenUtil().setHeight(30),
            ),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                  hintText: "Password",
                  hintStyle: TextStyle(color: Colors.white, fontSize: 12.0)),
                  onChanged: callbackPasswordChange,
            ),
            SizedBox(
              height: ScreenUtil().setHeight(35),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  "Forgot Password?",
                  style: TextStyle(
                      color: Colors.blue,
                      fontFamily: "Poppins-Medium",
                      fontSize: ScreenUtil().setSp(28)),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
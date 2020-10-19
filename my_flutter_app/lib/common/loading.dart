import 'package:flutter/material.dart';

class Loading extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(10),
          child: Stack(
            overflow: Overflow.visible,
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white
                ),
                padding: EdgeInsets.fromLTRB(20, 50, 20, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    new CircularProgressIndicator(),
                    Text("Loading", textAlign: TextAlign.center,),
                  ],
                ),
              ),
            ],
          )
        )
      )
    );
  }
}

/*

Dialog(
          
          child: new Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              new CircularProgressIndicator(),
              new Text("Loading"),
            ],
          ),
        )

*/
/*
Dialog(
  backgroundColor: Colors.transparent,
  insetPadding: EdgeInsets.all(10),
  child: Stack(
    overflow: Overflow.visible,
    alignment: Alignment.center,
    children: <Widget>[
      Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.lightBlue
        ),
        padding: EdgeInsets.fromLTRB(20, 50, 20, 20),
        child: Text("You can make cool stuff!",
          style: TextStyle(fontSize: 24),
          textAlign: TextAlign.center
        ),
      ),
      Positioned(
        top: -100,
        child: Image.network("https://i.imgur.com/2yaf2wb.png", width: 150, height: 150)
      )
    ],
  )
)
*/
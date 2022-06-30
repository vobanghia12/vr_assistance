import 'package:flutter/material.dart';
class ReturnPage extends StatelessWidget {
  
  @override
  Widget build (BuildContext context){
  return new Positioned(
    top: 0.0,
    left: 0.0,
    right: 0.0,
    child: AppBar(
                    title: Text(''),// You can add title here
                    leading: new IconButton(
                      icon: new Icon(Icons.arrow_back_ios, color: Colors.white,
                      size: 30),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    backgroundColor: Colors.transparent, //You can make this transparent
                    elevation: 0.0, //No shadow
                  ),);
         
}
  
}
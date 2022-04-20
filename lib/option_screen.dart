import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/user.dart';
import 'PrimaryData.dart';
import 'SingleUser.dart';
import 'UserUI.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blind Assistance'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 20, top: 100),
            child: Text(
              'Are you a user or helper ?',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
          ),
          GridView(
            padding: const EdgeInsets.all(25),
            shrinkWrap: true,
            children: DATA_TYPEUSER.map((usrData) {
              return SingleUser(usrData.id, usrData.title, usrData.color);
            }).toList(),
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
            ),
          ),
        ],
      ),
    );
  }
}

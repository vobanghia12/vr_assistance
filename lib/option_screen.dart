import 'package:flutter/material.dart';
import 'PrimaryData.dart';
import 'SingleUser.dart';


class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/images/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 20, top: 100),
              child: Text(
                'Are you a user or helper ?',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Colors.white
                ),
              ),
            ),
            ListView(
              padding: const EdgeInsets.all(25),
              shrinkWrap: true,
              children: DATA_TYPEUSER.map((usrData) {
                return SingleUser(usrData.id, usrData.title, usrData.color);
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

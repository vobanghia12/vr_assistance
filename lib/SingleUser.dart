import 'package:flutter/material.dart';
import 'user_login.dart';

class SingleUser extends StatelessWidget {
  final String id;
  final String title;
  final Color color;
  static const routeName = '/typeOfUser';
  SingleUser(this.id,this.title, this.color);

  void selectTypeOfUser(BuildContext ctx) {
    Navigator.of(ctx).pushNamed(routeName, arguments: {'id': id, 'title': title});
  }


  void selectHelper(BuildContext ctx) {
    Navigator.of(ctx).pushNamed('/helperUI', arguments: {'id': id, 'title': title});
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => title == 'User' ? selectTypeOfUser(context) : selectHelper(context), // have to use context
      borderRadius: BorderRadius.circular(15),
      child: Container(
        margin: EdgeInsets.fromLTRB(30, 0, 30, 40),
        height: 100,
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            title == 'User' ? Icon(Icons.accessible_forward,
            color: Colors.teal,
            size: 35,) : Icon(Icons.account_circle,
            color: Colors.purple,
            size: 35,),
            SizedBox(
              width: 30,
            ),
            Text(title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25,)),
          ],
        ),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [color.withOpacity(0.7), color],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(15),
            ),
      ),
    );
  }
}

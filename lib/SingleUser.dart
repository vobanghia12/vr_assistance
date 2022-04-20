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

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => selectTypeOfUser(context), // have to use context 
      splashColor: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Text(title,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,)),
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

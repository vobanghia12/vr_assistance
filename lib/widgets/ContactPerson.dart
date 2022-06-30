import 'package:flutter/material.dart';
class  ContactPerson extends StatelessWidget {
  final String id;
  final String name;
  final String phoneNumber;
  final String email;
  ContactPerson(this.id, this.name, this.phoneNumber, this.email);
  @override
  Widget build(BuildContext context) {
    return  ListTile(
              title: Text(
                name??'defaut value',
                style: TextStyle(color: Colors.pinkAccent),
              ),
              subtitle: Text(phoneNumber??'default value'),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () {
                Text('Another data');
              },

            );
  }
}
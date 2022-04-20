import 'package:flutter/material.dart';

class TypeUser {
  final String id;
  final String title;
  final Color color;

  const TypeUser(
      {@required this.id, @required this.title, this.color = Colors.orange});
}

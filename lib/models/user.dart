import 'helper.dart';
class User{
  final String id;
  final String name;
  final String phoneNumber;
  final String email;
  final List <Assister> helpers;
  bool isHelper;
  User({this.id, this.name, this.phoneNumber, this.email, this.helpers, this.isHelper});
}
import 'user.dart';
class Assister{
  final String id;
  final String name;
  final String phoneNumber;
  final String email;
  List<User> users;
  bool isHelper;
  Assister({this.id, this.name, this.phoneNumber, this.email, this.isHelper, this.users});
}
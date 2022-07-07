import 'user.dart';
class Assister{
  String id;
  String name;
  String phoneNumber;
  String email;
  List<User> users;
  bool isHelper;
  bool isSignal;
  Assister({this.id, this.name, this.phoneNumber, this.email, this.isHelper, this.users, this.isSignal = false});
}
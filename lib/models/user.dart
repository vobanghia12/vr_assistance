class User{
  final String id;
  final String name;
  final String phoneNumber;
  final String email;
  bool isHelper;
  User({this.id, this.name, this.phoneNumber, this.email, this.isHelper = true});
}
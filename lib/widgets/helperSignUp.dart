import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/user_login.dart';
import 'backwidget.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../provider/auth.dart';
import '../models/http_exception.dart';
import '../provider/helpers.dart';
import '../models/helper.dart';
class SignUpScreen extends StatefulWidget {
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final Map<String, String> _authData = {
    'email': '',
    'password': '',
    'name': '',
    'phone': '',
  };
  final GlobalKey<FormState> _formKey = GlobalKey();
  var _isLoading = false;
  List<Assister> previousHelpers = [];
  Helpers newHelper;

  Widget buildEmail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Email',
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                )
              ]),
          height: 60,
          child: TextFormField(
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(color: Colors.black87),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14),
              prefixIcon: Icon(
                Icons.email,
                color: Color(0xff5ac18e),
              ),
              hintText: 'Email',
              hintStyle: TextStyle(
                color: Color(0xff5ac18e),
              ),
            ),
            validator: (value) {
              if (value.isEmpty || !value.contains('@')) {
                return 'Invalid email!';
              }
              return null;
            },
            onSaved: (value) {
              _authData['email'] = value;
            },
          ),
        ),
      ],
    );
  }

  Widget buildPassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Password',
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                )
              ]),
          height: 60,
          child: TextFormField(
            obscureText: true,
            style: TextStyle(color: Colors.black87),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14),
              prefixIcon: Icon(
                Icons.email,
                color: Color(0xff5ac18e),
              ),
              hintText: 'Password',
              hintStyle: TextStyle(
                color: Color(0xff5ac18e),
              ),
            ),
            validator: (value) {
              if (value.isEmpty || value.length < 5) {
                return 'Invalid password!';
              }
              return null;
            },
            onSaved: (value) {
              _authData['password'] = value;
            },
          ),
        ),
      ],
    );
  }

  Widget buildName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Name',
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                )
              ]),
          height: 60,
          child: TextFormField(
            keyboardType: TextInputType.name,
            style: TextStyle(color: Colors.black87),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14),
              prefixIcon: Icon(
                Icons.perm_identity,
                color: Color(0xff5ac18e),
              ),
              hintText: 'Name',
              hintStyle: TextStyle(
                color: Color(0xff5ac18e),
              ),
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Invalid name!';
              }
              return null;
            },
            onSaved: (value) {
              _authData['name'] = value;
            },
          ),
        ),
      ],
    );
  }

  Widget buildPhone() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Phone Number',
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                )
              ]),
          height: 60,
          child: TextFormField(
            keyboardType: TextInputType.phone,
            style: TextStyle(color: Colors.black87),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14),
              prefixIcon: Icon(
                Icons.phone_android,
                color: Color(0xff5ac18e),
              ),
              hintText: 'Phone Number',
              hintStyle: TextStyle(
                color: Color(0xff5ac18e),
              ),
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Invalid email!';
              }
              return null;
            },
            onSaved: (value) {
              _authData['phone'] = value;
            },
          ),
        ),
      ],
    );
  }

  Widget buildSignUpBtn(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5,
        onPressed: () => _submit(context),
        padding: EdgeInsets.all(15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        color: Colors.white,
        child: Text(
          'SIGN UP',
          style: TextStyle(
              color: Color(0xff5ac18e),
              fontSize: 18,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void _showErrorDialog(String message, BuildContext context) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
                title: Text("An error occured"),
                content: Text(message),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Okay'),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                  )
                ]));
  }

  Future<void> _submit(BuildContext context) async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      // Sign user up
      await Provider.of<Auth>(context, listen: false).signup(_authData['email'], _authData['password'], title = 'Helper');
      final auth = Provider.of<Auth>(context, listen: false);
      Helpers helpers = new Helpers(auth.token, auth.UserId);
      helpers.addHelpers(Assister(id : auth.UserId, name: _authData['name'], phoneNumber: _authData['phone'], email: _authData['email'],isHelper: true));
     // print(_authData['email']);
      //print(_authData['password']);

      /*  var usersL = new Users(auth.token, auth.UserId);
        User trans = User(
            name: fullName,
            phoneNumber: phoneNumber,
            email: _authData['email'],
            isHelper: title == 'User' ? false : true);
        usersL.addUsers(trans);*/

    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        // those comments came from firebase
        errorMessage = "This email address is already in use";
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Cound not find the user with that email';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid Password';
      }
      _showErrorDialog(errorMessage, context);
    } catch (error) {
      const errorMessage = 'Cound not authencicate you. Please try again later';
      _showErrorDialog(errorMessage, context);
      print(previousHelpers);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: GestureDetector(
        child: Stack(children: <Widget>[
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                  Color(0xff5ac18e),
                  Color(0x995ac18e),
                  Color(0xcc5ac18e),
                  Color(0xff5ac18e),
                ])),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 120),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Sign up',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.bold),
                        ),
                        buildEmail(),
                        SizedBox(
                          height: 10,
                        ),
                        buildPassword(),
                        SizedBox(
                          height: 10,
                        ),
                        buildName(),
                        SizedBox(
                          height: 10,
                        ),
                        buildPhone(),
                        SizedBox(
                          height: 10,
                        ),
                        _isLoading
                            ? CircularProgressIndicator()
                            : buildSignUpBtn(context),
                      ])),
            ),
          ),
          ReturnPage(),
        ]),
      ),
    ));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_complete_guide/user_login.dart';
import 'widgets/helperSignUp.dart';
import "widgets/backwidget.dart";
import 'package:provider/provider.dart';
import '../provider/auth.dart';
import '../models/http_exception.dart';
import 'HelperUI.dart';

class HelperLogin extends StatefulWidget {
  @override
  State<HelperLogin> createState() => _HelperLoginState();
}
class _HelperLoginState extends State<HelperLogin> {
  bool isRememberMe = false;
  final Map<String, String> _authData = {
    'email': '',
    'password': '',
    'name': '',
    'phone': '',
  };
  final GlobalKey<FormState> _formKey = GlobalKey();
  var _isLoading = false;

  Widget buildRemeberCb() {
    return Container(
        height: 20,
        child: Row(
          children: <Widget>[
            Theme(
                data: ThemeData(unselectedWidgetColor: Colors.white),
                child: Checkbox(
                  value: isRememberMe,
                  checkColor: Colors.green,
                  activeColor: Colors.white,
                  onChanged: (value) {
                    setState(() {
                      isRememberMe = value;
                    });
                  },
                )),
            Text(
              'Remember me',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ));
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

  Widget buildForgotPassBtn() {
    return Container(
        alignment: Alignment.centerRight,
        child: FlatButton(
          onPressed: () => print("Forgot Password pressed"),
          padding: EdgeInsets.only(right: 0),
          child: Text(
            'Forgot Password?',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ));
  }

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

  Widget buildLoginBtn(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5,
        onPressed: () => {
          _submit(context),
         
        },
        padding: EdgeInsets.all(15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        color: Colors.white,
        child: Text(
          'SIGN IN',
          style: TextStyle(
              color: Color(0xff5ac18e),
              fontSize: 18,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget buildSignUpBtn() {
    return GestureDetector(
      onTap: () => {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return SignUpScreen();
        }))
      },
      child: RichText(
        text: TextSpan(children: [
          TextSpan(
            text: 'Don\' t have an Account? ',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          TextSpan(
            text: 'Sign Up',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ]),
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
      await Provider.of<Auth>(context, listen: false).login(_authData['email'], _authData['password'], title = 'User');
       Navigator.push(context, MaterialPageRoute(builder: (context) {
            return HelperUI();
          }));
      
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
                child: Stack(
              children: <Widget>[
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
                            padding: EdgeInsets.symmetric(
                                horizontal: 25, vertical: 120),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'Sign in',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 50,
                                  ),
                                  buildEmail(),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  buildPassword(),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  buildForgotPassBtn(),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  buildRemeberCb(),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  _isLoading
                                      ? CircularProgressIndicator()
                                      : buildLoginBtn(context),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  buildSignUpBtn(),
                                ])))),
                ReturnPage(),
              ],
            ))));
  }
}

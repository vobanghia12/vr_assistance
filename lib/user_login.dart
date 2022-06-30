import 'package:flutter/widgets.dart';
import 'package:flutter_complete_guide/UserUI.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'provider/auth.dart';
import 'models/http_exception.dart';
import 'provider/users.dart';
import 'models/user.dart';

String title;

enum AuthMode { Signup, Login }

class UserLogin extends StatelessWidget {
  static const routeName = "/douma";

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final routeArgs = ModalRoute.of(context).settings.arguments as Map<String, String>;
    final userTitle = routeArgs['title'];
    title = userTitle;
    // final transformConfig = Matrix4.rotationZ(-8 * pi / 180);
    // transformConfig.translate(-10.0);
    return Scaffold(
      appBar: userTitle == 'User'
          ? AppBar(
              backgroundColor: Colors.green[700],
              elevation: 0,
            )
          : AppBar(
              backgroundColor: Color.fromARGB(255, 57, 24, 128),
              elevation: 0,
            ),
      // resizeToAvoidBottomInset: false,
      body: Stack(
        children: userTitle == 'User'
            ? <Widget>[
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(255, 10, 234, 130).withOpacity(0.5),
                        Color.fromARGB(255, 16, 105, 41).withOpacity(0.9),
                      ],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      stops: [0, 1],
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: Container(
                    height: deviceSize.height,
                    width: deviceSize.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Flexible(
                          child: Container(
                            child: Text(
                              userTitle,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Flexible(
                          flex: deviceSize.width > 600 ? 2 : 1,
                          child: AuthCard(),
                        ),
                      ],
                    ),
                  ),
                ),
              ]
            : <Widget>[
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(255, 137, 10, 234).withOpacity(0.5),
                        Color.fromARGB(255, 49, 16, 105).withOpacity(0.9),
                      ],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      stops: [0, 1],
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: Container(
                    height: deviceSize.height,
                    width: deviceSize.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Flexible(
                          child: Container(
                            child: Text(
                              userTitle,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Flexible(
                          flex: deviceSize.width > 600 ? 2 : 1,
                          child: AuthCard(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
 
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>{
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();
  var fullName;
  var phoneNumber;
  
  void _showErrorDialog(String message) {
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

  Future<void> _submit() async {
    //var usersL = new Users();
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });

     User trans = User(
            name: fullName,
            phoneNumber: phoneNumber,
            email: _authData['email'],
            isHelper: title == 'User' ? false : true);
    try {
      if (_authMode == AuthMode.Login ) {
        // Log user in
        await Provider.of<Auth>(context, listen: false).login(_authData['email'], _authData['password'], title);
        final auth = Provider.of<Auth>(context, listen: false);
         var usersL = new Users(auth.token, auth.UserId);
         print(usersL.isUser(auth.UserId));
         if (await usersL.isUser(auth.UserId) == false) 
             Navigator.of(context).pushNamed("/douma", arguments: {'title': title});
        else 
        {_showErrorDialog("You are not user!");}
      } else {
        // Sign user up
        await Provider.of<Auth>(context, listen: false).signup(_authData['email'], _authData['password'], title);
        final auth = Provider.of<Auth>(context, listen: false);
        var usersL = new Users(auth.token, auth.UserId);
        usersL.addUsers(trans);

      }
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
      _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage = 'Cound not authencicate you. Please try again later';
      _showErrorDialog(errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
  }

  
  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: Container(
        height: _authMode == AuthMode.Signup ? 800 : 260,
        constraints:
            BoxConstraints(minHeight: _authMode == AuthMode.Signup ? 320 : 260),
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'E-Mail'),
                  keyboardType: TextInputType.emailAddress,
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
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value.isEmpty || value.length < 5) {
                      return 'Password is too short!';
                    }
                  },
                  onSaved: (value) {
                    _authData['password'] = value;
                  },
                ),
                if (_authMode == AuthMode.Signup)
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Full Name'),
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Invalid name';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      fullName = value;
                    },
                  ),
                if (_authMode == AuthMode.Signup)
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Phone Number'),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Invalid phone number';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      phoneNumber = value;
                    },
                  ),
                SizedBox(
                  height: 20,
                ),
                if (_isLoading)
                  CircularProgressIndicator()
                else
                  RaisedButton(
                    child:
                        Text(_authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP'),
                    onPressed: _submit,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                    color: Color.fromARGB(255, 10, 234, 130).withOpacity(0.5),
                    textColor: Colors.white,
                  ),
                FlatButton(
                  child: Text(
                      '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
                  onPressed: _switchAuthMode,
                  padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  textColor: Color.fromARGB(255, 16, 105, 41).withOpacity(0.9),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

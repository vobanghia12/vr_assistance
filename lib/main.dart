import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/SingleUser.dart';
import 'package:flutter_complete_guide/UserUI.dart';
import 'package:flutter_complete_guide/models/user.dart';
import 'option_screen.dart';
import 'user_login.dart';
import 'package:provider/provider.dart';
import './provider/users.dart';
import 'provider/auth.dart';
import 'UserUI.dart';
import 'provider/helpers.dart';
import 'widgets/videocall.dart';


void main() => runApp(MyApp());
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: Auth(),  
             // when auth update it will notify all of other widgets 
            // only rebuild widget it's listenning 
          ),
          ChangeNotifierProvider.value(
            value: Users(),
          ),
          ChangeNotifierProvider.value(
            value: Helpers(),
          )
        ],
        child: Consumer<Auth>(
            builder: (ctx, auth, _) => MaterialApp(
                  title: "Blind Assistance",
                  theme: ThemeData(
                    primarySwatch: Colors.pink,
                    accentColor: Colors.amber,
                  ),
                  home: HomePage() , //HomePage(),
                  // Manage all of routes 
                  routes: {
                    SingleUser.routeName: (ctx) => UserLogin(),
                    UserLogin.routeName: (ctx) => UserUI(),
                    "/hello": (ctx) => VideoCall(),
                  },
                )));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/SingleUser.dart';
import 'package:flutter_complete_guide/UserUI.dart';
import 'package:flutter_complete_guide/models/helper.dart';
import 'option_screen.dart';
import 'user_login.dart';
import 'package:provider/provider.dart';
import './provider/users.dart';
import 'provider/auth.dart';
import 'UserUI.dart';
import 'provider/helpers.dart';
import 'widgets/videocall.dart';
import 'helper_login.dart';

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
          ChangeNotifierProxyProvider<Auth, Users>(
            update: (ctx, auth, previousUsers ) => Users(auth.token, auth.UserId),
          ),
          ChangeNotifierProxyProvider<Auth, Helpers>(
            update: (ctx, auth, previousHelpers) => Helpers(auth.token, auth.UserId),
          ),
        ],
        child: Consumer<Auth>(
            builder: (ctx, auth, _) => MaterialApp(
                  title: "Blind Assistance",
                  home: HomePage(), //HomePage(),
                  // Manage all of routes
                  routes: {
                    SingleUser.routeName: (ctx) => UserLogin(),
                    UserLogin.routeName: (ctx) => AddingHelpers(),
                    "/helperUI": (ctx) => HelperLogin(),
                  },
                )));
  }
}

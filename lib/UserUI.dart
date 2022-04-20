import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/provider/helpers.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'models/user.dart';
import 'models/helper.dart';
import 'widgets/ContactPerson.dart';
import 'package:provider/provider.dart';
import 'provider/users.dart';
import 'widgets/videocall.dart';

class StatefulDialog extends StatefulWidget {
  @override
  StatefulDialogState createState() => StatefulDialogState();
}

class StatefulDialogState extends State<StatefulDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _phonenumber = TextEditingController();
  final TextEditingController _email = TextEditingController();
  Future<void> showInformationDialog(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            final users = Provider.of<Users>(
                context); //it will change the widget of current method
            void submitData() {
              User trans = User(
                  id: DateTime.now().toString(),
                  name: _name.text,
                  phoneNumber: _phonenumber.text,
                  email: _email.text);
              users.addUsers(trans).then((_) {
                Navigator.of(context).pop(context);
              }).catchError((error) {
                return showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                            title: Text('An error occured!'),
                            content: Text("Something went wrong!"),
                            actions: <Widget>[
                              FlatButton(
                                child: Text('Okay'),
                                onPressed: () {
                                  Navigator.of(ctx).pop();
                                },
                              )
                            ]));
              });
            }

            return AlertDialog(
              content: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        decoration: InputDecoration(labelText: 'Name'),
                        controller:
                            _name, //titlecontroller will listen to user input
                        onSubmitted: (_) => {
                          submitData()
                        }, // using this function to be able to click on the tick symbol on keyboard and we have to use () so the function will be submitted
                      ), //how to label
                      TextField(
                        decoration: InputDecoration(labelText: 'Phone Number'),
                        controller: _phonenumber,
                        keyboardType: TextInputType.number,
                        onSubmitted: (_) => {
                          submitData()
                        }, // fit the number on keyboard //onsubmitted require arguments
                      ),
                      TextField(
                        decoration: InputDecoration(labelText: 'Email'),
                        controller: _email,
                        keyboardType: TextInputType.number,
                        onSubmitted: (_) => {
                          submitData()
                        }, // fit the number on keyboard //onsubmitted require arguments
                      ),
                    ],
                  )),
              title: Text('Adding User'),
              actions: <Widget>[
                InkWell(
                  child: Container(
                      color: Colors.pinkAccent,
                      width: 120,
                      height: 40,
                      child: Center(
                          child: Text(
                        'Add User',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ))),
                  onTap: submitData,
                ),
              ],
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Container(
        height: 70,
        width: 70,
        child: FloatingActionButton(
          onPressed: () async {
            await showInformationDialog(context);
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.pink,
        ),
      ),
    );
  }
}

class UserUI extends StatefulWidget {
  @override
  State<UserUI> createState() => _UserUIState();
}

class _UserUIState extends State<UserUI> {
  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) {
      Provider.of<Users>(context, listen: false).fetchAndSetUsers();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final users = Provider.of<Users>(
        context); //it will change the widget of current method
    final helpers = Provider.of<Helpers>(context);
    final UserList = users.contacts;
    final HelperList = helpers.helperContacts;
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, String>;
    final userTitle = routeArgs['title'];

    return Scaffold(
        // Scafford is used to fill entire screen
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(userTitle),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(10.0),
                itemCount:
                    userTitle == "User" ? UserList.length : HelperList.length,
                itemBuilder: userTitle == "User"
                    ? (ctx, i) => ContactPerson(
                        UserList[i].id,
                        UserList[i].name,
                        UserList[i].phoneNumber,
                        UserList[i].email)
                    : (ctx, i) => ContactPerson(
                        HelperList[i].id,
                        HelperList[i].name,
                        HelperList[i].phoneNumber,
                        HelperList[i].email),
              ),
            ),
          ],
        ),
        floatingActionButton: SpeedDial(
          icon: Icons.share,
          backgroundColor: Colors.amber,
          children: [
            SpeedDialChild( child: const Icon(Icons.add),
              label: "Adding",
              backgroundColor: Colors.amberAccent,
              onTap: () async { await StatefulDialogState().showInformationDialog(context);},),
            SpeedDialChild(
              child: const Icon(Icons.call),
              label: "Calling",
              backgroundColor: Colors.amberAccent,
              onTap: () async {
                await Navigator.of(context).pushReplacementNamed("/hello");
              },
            )
          ]
        ),
        
        
        );
  }
}

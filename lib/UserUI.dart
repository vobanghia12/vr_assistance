import 'package:flutter/material.dart';
import 'searching.dart';
import 'provider/helpers.dart';
import 'package:provider/provider.dart';
import 'provider/users.dart';
import 'ContactList.dart';
import 'widgets/videocall.dart';

class AddingHelpers extends StatefulWidget {
  @override
  State<AddingHelpers> createState() => _AddingHelpersState();
}

class _AddingHelpersState extends State<AddingHelpers> {
  var _isInit = true;
  var _isLoading = false;
  @override
  void initState() {
    super.initState();
  }
  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Users>(context, listen: false).fetchAndSetUsers().then((_) {
        setState(() {
          _isLoading = false;
        });
        
      });
  }
  _isInit = false;
  }
  @override
  Widget build(BuildContext context) {
    final users = Provider.of<Users>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('User'),
          backgroundColor: Colors.green[700],
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 10.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return SearchingHelpers();
                    }));
                  },
                  child: Icon(
                    Icons.add,
                    size: 40.0,
                  ),
                ))
          ],
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: _isLoading ? CircularProgressIndicator() : RaisedButton(
                  onPressed: () => {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ContactList(users.userInfo.helpers);
                    }))
                  },
                  color: Colors.blue,
                  child: Container(
                    child: Center(
                      child: Icon(
                        Icons.contact_phone,
                        color: Colors.white,
                        size: 100,
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                fit: FlexFit.loose,
                child: RaisedButton(
                  onPressed: () => {
                    
                  
                  },
                  color: Colors.green,
                  child: Container(
                    child: Center(
                      child: Icon(
                        Icons.phone,
                        color: Colors.white,
                        size: 100,
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green,
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}






/*class StatefulDialog extends StatefulWidget {
  @override
  StatefulDialogState createState() => StatefulDialogState();
}

class StatefulDialogState extends State<StatefulDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _phonenumber = TextEditingController();
  final TextEditingController _email = TextEditingController();

  Future<void> showInformationDialog(BuildContext context) async {
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, String>;
    final userTitle = routeArgs['title'];
    return await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
           //it will change the widget of current method
            Future<void> submitData() async {
              Assister assist = Assister(
                  id: DateTime.now().toString(),
                  name: _name.text,
                  phoneNumber: _phonenumber.text,
                  email: _email.text);
              await Provider.of<Users>(context, listen: false).addAssister(assist).then((_) => {Navigator.of(context).pop(context)})
              .catchError((error) {
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
                  child: Container(
                    width: 300,
                    height: 300,
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
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
                      ),
                    ),
                  )),
              title: userTitle == "User"
                  ? Text("Adding Helper")
                  : Text("Adding User"),
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

User generalData = null;

class _UserUIState extends State<UserUI> {
  var _isInit = true;
  var _isLoading = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Users>(context, listen: false).fetchAndSetUsers().then((_) {
        // generalData =  Provider.of<Users>(context).userInfo;
      
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  User usr = null;
//rebuild
  @override
  Widget build(BuildContext context) {
    final users = Provider.of<Users>(context); //it will change the widget of current method
    final routeArgs = ModalRoute.of(context).settings.arguments as Map<String, String>;
    final userTitle = routeArgs['title'];
    final ui = users.userInfo;
    if (ui != null) {
      usr = ui;
    }    

    return Scaffold(
        // Scafford is used to fill entire screen
        appBar: AppBar(
          title: Text(userTitle),
          backgroundColor: userTitle == 'User'
              ? Colors.green[700]
              : Color.fromARGB(255, 57, 24, 128),
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 10.0),
                child: GestureDetector(
                  onTap: () async {
                   // await StatefulDialogState().showInformationDialog(context);
                  },
                  child: Icon(
                    Icons.add,
                    size: 40.0,
                  ),
                ))
          ],
        ),
       /* body: usr == null
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: usr.helpers.length,
                itemBuilder: (ctx, i) => ContactPerson(
                    usr.helpers[i].id,
                    usr.helpers[i].name,
                    usr.helpers[i].phoneNumber,
                    usr.helpers[i].email)),
        floatingActionButton: Container(
            margin: EdgeInsets.only(left: 30.0),
            width: double.infinity,
            height: 200,
            child: FlatButton(
              child: const Icon(Icons.call, size: 50),
              color: Colors.green,
              onPressed: () async {
                await Navigator.of(context).pushReplacementNamed("/hello");
              },
            ))*/);
  }
}*/

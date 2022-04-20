import 'package:flutter/material.dart';

class StatefulDialog extends StatefulWidget {
  @override
  StatefulDialogState createState() => StatefulDialogState();
}

class StatefulDialogState extends State<StatefulDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _phonenumber = TextEditingController();
  final TextEditingController _email = TextEditingController();
  void submitData(){
    final String name = _name.text;
    final String phone = _phonenumber.text;
    final String email = _email.text;
  }
  Future<void> showInformationDialog(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              content: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        decoration: InputDecoration(labelText: 'Name'),
                        controller: _name, //titlecontroller will listen to user input
                        onSubmitted: (_) =>
                            {}, // using this function to be able to click on the tick symbol on keyboard and we have to use () so the function will be submitted
                      ), //how to label
                      TextField(
                        decoration: InputDecoration(labelText: 'Phone Number'),
                        controller: _phonenumber,
                        keyboardType: TextInputType.number,
                        onSubmitted: (_) =>
                            {}, // fit the number on keyboard //onsubmitted require arguments
                      ),
                      TextField(
                        decoration: InputDecoration(labelText: 'Email'),
                        controller: _email,
                        keyboardType: TextInputType.number,
                        onSubmitted: (_) =>
                            {}, // fit the number on keyboard //onsubmitted require arguments
                      ),
                    ],
                  )),
              title: Text('Adding User'),
              actions: <Widget>[
                InkWell(
                  child: Text('Add User'),
                  onTap: () {
                    if (_formKey.currentState.validate()) {
                      // Do something like updating SharedPreferences or User Settings etc.
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await showInformationDialog(context);
        },
        label: const Text('Add Friend'),
        backgroundColor: Colors.pink,
      ),
    );

  }
}

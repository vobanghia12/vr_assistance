import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_complete_guide/models/helper.dart';
import 'models/user.dart';
import 'provider/users.dart';
import 'package:provider/provider.dart';
import './widgets/videocall.dart';

class HelperUI extends StatefulWidget {
  @override
  State<HelperUI> createState() => _HelperUIState();
}

class _HelperUIState extends State<HelperUI> {
   var _isInit = true;
  var _isLoading = false;
  String id;
  @override
  void initState() {
    getId();
    super.initState();
  }
  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Users>(context, listen: false).fetchAllUsers().then((_) {
        setState(() {
          _isLoading = false;
        });
        
      });
  }
 
  _isInit = false;
  }
   void getId(){
    String id = Provider.of<Users>(context, listen: false).UID;
  }
  @override
  Widget build(BuildContext context) {
    final users = Provider.of<Users>(context);
    if(_isLoading == false) 
      print(users.contacts);
    return Scaffold(
      appBar: AppBar(
        backgroundColor:  Color(0xff5ac18e),
      ),
      body: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(8),
        primary: false,
        shrinkWrap: true,
          itemCount: users.contacts.length,
          itemBuilder: (ctx, i) =>
          ListTile(
                title: Text( users.contacts[i].name ??'defaut value',
                  style: TextStyle(color: Colors.pinkAccent),
                ),
                subtitle: Text(users.contacts[i].email??'default value'),
                trailing: Icon(Icons.delete, color: Colors.red,),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {return VideoCall(id);}));
                },
        
              )
              ),

        floatingActionButton:  FloatingActionButton(
            onPressed: () => {},
            backgroundColor: Colors.green,
            child: const Icon(Icons.phone)),
    );
  }
}

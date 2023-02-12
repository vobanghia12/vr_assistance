import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_complete_guide/models/helper.dart';
import 'models/user.dart';
import 'provider/users.dart';
import 'package:provider/provider.dart';
import './widgets/videocall.dart';
import './provider/helpers.dart';
import 'package:firebase_database/firebase_database.dart';

class HelperUI extends StatefulWidget {
  @override
  State<HelperUI> createState() => _HelperUIState();
}

class _HelperUIState extends State<HelperUI> with SingleTickerProviderStateMixin{
   AnimationController _animationController;
   var _isInit = true;
  var _isLoading = false;
  Assister a;
  String id = null;
  bool check = null;
 


   void setUp() async{
      await Firebase.initializeApp();
  }
  @override
  void initState(){
     _animationController =
          new AnimationController(vsync: this, duration: Duration(seconds: 1));
      _animationController.repeat(reverse: true);
    setUp();
    Provider.of<Helpers>(context, listen: false).getCurrentHelperInfo().then((_)
      {
       
       id = Provider.of<Helpers>(context, listen: false).UID;

      });
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
   @override
    void dispose() {
      _animationController.dispose();
      super.dispose();
    }

  @override
  Widget build(BuildContext context) {
    final users = Provider.of<Users>(context);
    final helpers = Provider.of<Helpers>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Helper'),
        backgroundColor:  Color(0xff5ac18e),
      ),
      body: Stack(
        children: <Widget>[ListView.builder(
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
                  trailing: Icon(Icons.more_vert, color: Colors.red,),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {return VideoCall(id);}));
                  },
          
                )
                ),

          StreamBuilder
           (
              stream: FirebaseDatabase.instance.ref().child("/helpers/$id").onValue,
              // ignore: missing_return
              builder: (context, snapshot) {
                if (snapshot.hasData)
                 {  DatabaseEvent dataValues =  snapshot.data;
                 var valueFetch = dataValues.snapshot.value as Map<dynamic, dynamic>;
                 if (valueFetch != null)
                    check = valueFetch['isSignal'];
                 }

             
                 if(check == true)  return Align(alignment: Alignment.bottomCenter,
                 child: FadeTransition
                 (
                  opacity: _animationController,
                   child: ButtonTheme(
                    minWidth: 200,
                    height: 80,
                     child: MaterialButton(
                      shape: const CircleBorder(),
                      color: Colors.green,
                      child: Icon(Icons.call),
                      onPressed:() async {
                        await showDialog<String>(
                           context: context,
                           builder: (BuildContext context) => AlertDialog(
                             title: const Text('Do you want to pickup the call ?'),
                             actions: <Widget>[
                               TextButton(
                                 onPressed: () async { 
                                   DatabaseReference ref =
              FirebaseDatabase.instance.ref("helpers/${id}");
// Only update the name, leave the age and address!
          await ref.update({
            "isSignal": false,
          });
                                  
                                  Navigator.pop(context, 'Cancel');},
                                 child: const Text('No'),
                               ),
                               TextButton(
                                 onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                          
                            return VideoCall(id);
                          }));
                            
                                    
                                 },
                                 child: const Text('Yes'),
                               ),
                             ],
                           ),
                         );
                                    
                     } ,),
                   ),
                 ),
                 );

                 return Text('');
              
              }
          
            
                     
               
           ),],
      )

    );
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_complete_guide/models/helper.dart';
import 'package:flutter_complete_guide/provider/users.dart';
import 'provider/helpers.dart';
import 'package:provider/provider.dart';
import 'provider/helpers.dart';
import 'provider/auth.dart';
class SearchingHelpers extends StatefulWidget {
  //const SearchingHelpers({ Key? key }) : super(key: key);

  @override
  State<SearchingHelpers> createState() => _SearchingHelpersState();
}

class _SearchingHelpersState extends State<SearchingHelpers> {
  var _isInit = true;
  var _isLoading = false;
  var _isLoading2 = false;
  List<Assister> listofHelpers;
  int count = 0;
  int count2 = 0;
  var items = List<String>();
   void initState() {
    super.initState();
  }

  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
        _isLoading2 = true;
      });
      Provider.of<Helpers>(context, listen: false).fetchAllHelpers().then((_) {
        setState(() {
           _isLoading = false;
           listofHelpers = Provider.of<Helpers>(context, listen: false).HelperList;
        });
      });
      Provider.of<Users>(context, listen: false).fetchAndSetUsers().then((_) {
        setState(() {
          _isLoading2 = false;
        });
      });
       
    }
    _isInit = false;
    super.didChangeDependencies();
  }

   void filterSearchResults(String query) {
    List<String> dummySearchList = List<String>();
    print(_isLoading);
      listofHelpers.forEach((element) {
        dummySearchList.add(element.email);
      });
    
    if(query.isNotEmpty) {
      List<String> dummyListData = List<String>();
      dummySearchList.forEach((item) {
        if(item.contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        items.clear();
        items.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        items.clear();
        items = dummySearchList;
      });
    }

  }
   List<Assister> list = [];
  @override
  Widget build(BuildContext context) {
    Helpers listHelper = Provider.of<Helpers>(context);
    final users = Provider.of<Users>(context);
    list = listHelper.HelperList;
    if(_isLoading == false) 
    {print(list[0].name);
    print(items);
    }

    void addBaby(Assister baby1){
      if (_isLoading2 == false) 
        {
          print(baby1.id);
          users.addAssister(baby1);
          listHelper.addUsersToHelpers(users.userInfo, baby1.id, listHelper.authToken, users.userInfo.id);
          print(users.userInfo.helpers);
        }
    }
    /*if (listHelper.HelperList != null) 
    {
      list = listHelper.HelperList;
      print(list);
    }*/
    
      
   
    return Scaffold(
       appBar: new AppBar(
        title: new Text("Searching")),
     body: _isLoading ? CircularProgressIndicator() : Container(
        child: Column(
          children: <Widget>[
            Padding(padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                filterSearchResults(value);
                count++;
              },
              decoration: InputDecoration(
                labelText: "Search",
                hintText: "Search",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(25.0))),
              ),
            ),),
            Expanded(child: 
            ListView.builder(
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (context, index) {
                return /*count <= 1 ? RaisedButton(
                  child: ListTile(
                    title: Text(listofHelpers[index].email ?? 'default value'),
                   // subtitle: Text(listHelper.HelperList[index].phoneNumber ?? 'default value'),
                  ),
                  color: Colors.white,
                  onPressed: () {
                       Navigator.of(context).pop();
                  },
                ) : */RaisedButton(
                  child: ListTile(
                    title: Text(items[index] ?? 'default value'),
                   // subtitle: Text(listHelper.HelperList[index].phoneNumber ?? 'default value'),
                  ),
                  color: Colors.white,
                  onPressed: (){
                    addBaby(listofHelpers[index]);
                     Navigator.of(context).pop();
                  },
                );
              }
            ))
          ],
        ),
      ),
    );
  }
}
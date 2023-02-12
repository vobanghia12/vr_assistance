import 'package:flutter/material.dart';
import 'models/helper.dart';
import 'package:provider/provider.dart';
import 'provider/helpers.dart';
import 'provider/users.dart';
import 'widgets/videocall.dart';

class ContactList extends StatefulWidget {
  List<Assister> helpers;
  ContactList(this.helpers);
  @override
  State<ContactList> createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  bool click = false;
  var _isInit = true;
  var _isLoading = false;
  var _isLoading2 = false;
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
        _isLoading2 = true;
      });
      Provider.of<Helpers>(context, listen: false).fetchAllHelpers().then((_) {
        setState(() {
          _isLoading = false;
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

  @override
  Widget build(BuildContext context) {
    void deleteHelpers(Assister helperBaby) {
      if (_isLoading2 == false) {
        //listHelper.deleteHelper(helperBaby.id);
        print(helperBaby.id);
      }
      widget.helpers.remove(helperBaby);

      setState(() {
        click = true;
      });
    }

    void Calling(String id) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return VideoCall(id);
      }));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Contacts"),
        backgroundColor: Colors.blue,
      ),
      body: widget.helpers == null ? Text('Nghia Vo')
          : ListView.builder(
              itemCount: widget.helpers.length,
              itemBuilder: (ctx, i) => ListTile(
                    title: Text(
                      widget.helpers[i].name ?? 'defaut value',
                      style: TextStyle(color: Colors.pinkAccent),
                    ),
                    subtitle: Text(widget.helpers[i].email ?? 'default value'),
                    leading: IconButton(
                      icon: const Icon(Icons.call),
                      iconSize: 30,
                      color: Colors.green,
                      onPressed: () {
                        Calling(widget.helpers[i].id);
                      },
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.more_vert),
                      iconSize: 30,
                      color: Colors.red,
                      onPressed: () => showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Do you want to edit ?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'Update'),
                              child: const Text('Update'),
                            ),
                            TextButton(
                              onPressed: () {
                                deleteHelpers(widget.helpers[i]);
                                click = false;
                                Navigator.pop(context, 'Delete');
                              },
                              child: const Text('Delete'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )),
    );
  }
}

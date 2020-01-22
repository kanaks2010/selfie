import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

ChatScreenState pageState;

class Item {
  PermissionGroup group;
  PermissionStatus status;

  Item(this.group, this.status);
}

class ContactScreen extends StatefulWidget {
  @override
  ChatScreenState createState() {
    return new ChatScreenState();
  }
}

class ChatScreenState extends State<ContactScreen> {

  List<Item> list = List<Item>();
  List<Contact> contacts;

  @override
  void initState() {
    super.initState();
    getAllContactsFromDevice();
  }



  /*   getAllPermision() async {
      final PermissionHandler _permissionHandler = PermissionHandler();

    Map<PermissionGroup, PermissionStatus> permission = await PermissionHandler().requestPermissions([PermissionGroup.contacts]);

    PermissionStatus contactPermissionStatus = await PermissionHandler().checkPermissionStatus(PermissionGroup.contacts);

    bool isShown = await PermissionHandler().shouldShowRequestPermissionRationale(PermissionGroup.contacts);
      // var result = await _permissionHandler.requestPermissions(permission);


      if(isShown){
      print(isShown);
    }else{
      print(isShown);
    }
      // bool isOpened = await PermissionHandler().openAppSettings();

  }
*/

  Future<PermissionStatus> _getPermission() async {
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.contacts);
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.disabled) {
      Map<PermissionGroup, PermissionStatus> permisionStatus =
      await PermissionHandler()
          .requestPermissions([PermissionGroup.contacts]);
      return permisionStatus[PermissionGroup.contacts] ??
          PermissionStatus.unknown;
    } else {
      return permission;
    }
  }
  getAllContactsFromDevice() async {

    PermissionStatus permissionStatus = await _getPermission();
    if (permissionStatus == PermissionStatus.granted) {
      var con = await ContactsService.getContacts();
      setState(() {
        contacts = con;
      });
      print(contacts);
    } else {
      throw PlatformException(
        code: 'PERMISSION_DENIED',
        message: 'Access to location data denied',
        details: null,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: contacts?.length ?? 0,
        itemBuilder: (context, i) {
          Contact c = contacts?.elementAt(i);
          return new Column(
            children: <Widget>[
              new Divider(
                height: 10.0,
              ),
              new ListTile(
                onTap: () {},
                leading: (c.avatar != null && c.avatar.length > 0)
                    ? CircleAvatar(
                        backgroundImage: MemoryImage(c.avatar),
                      )
                    : CircleAvatar(child: Text(c.initials())),
                title: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Text(
                      c.displayName ?? '',
                      style: new TextStyle(fontWeight: FontWeight.bold),
                    ),
                    new Text(
                      'i',
                      style: new TextStyle(color: Colors.grey, fontSize: 14.0),
                    ),
                  ],
                ),
                subtitle: new Container(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: new Text('${c.familyName}',
                    style: new TextStyle(color: Colors.grey, fontSize: 15.0),
                  ),
                ),
              )
            ],
          );
        });

    /*contacts != null
        ? ListView.builder(
      itemCount: contacts?.length ?? 0,
      itemBuilder: (context, index) {
        Contact c = contacts?.elementAt(index);
        return ListTile(
          leading: (c.avatar != null && c.avatar.length > 0)
              ? CircleAvatar(
            backgroundImage: MemoryImage(c.avatar),
          )
              : CircleAvatar(child: Text(c.initials())),
          title: Text(c.displayName ?? ''),
        );
      },
    ) : CircularProgressIndicator();*/
    /*ListView.builder(
      itemCount: dummyData.length,
      itemBuilder: (context, i) => new Column(
        children: <Widget>[
          new Divider(
            height: 10.0,
          ),
          new ListTile(
            onTap: () {
              // getPermission();
            },
            leading: new CircleAvatar(
              foregroundColor: Theme.of(context).primaryColor,
              backgroundColor: Colors.grey,
              backgroundImage: new NetworkImage(dummyData[i].avatarUrl),
            ),
            title: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Text(
                  dummyData[i].name,
                  style: new TextStyle(fontWeight: FontWeight.bold),
                ),
                new Text(
                  dummyData[i].time,
                  style: new TextStyle(color: Colors.grey, fontSize: 14.0),
                ),
              ],
            ),
            subtitle: new Container(
              padding: const EdgeInsets.only(top: 5.0),
              child: new Text(
                dummyData[i].message,
                style: new TextStyle(color: Colors.grey, fontSize: 15.0),
              ),
            ),
          )
        ],
      ),
    );*/
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sms/sms.dart';

class MessageScreen extends StatefulWidget {
  @override
  ChatScreenState createState() {
    return new ChatScreenState();
  }
}

class ChatScreenState extends State<MessageScreen> {
  List<SmsMessage> _messages;
  SmsQuery query = new SmsQuery();

  Map<PermissionGroup, PermissionStatus> permissions;

  @override
  initState() {
    super.initState();
    getMessage();
    getPermission();

  }

  void getPermission() async {
    permissions = await PermissionHandler().requestPermissions([
      PermissionGroup.sms,
    ]);
  }

  Future<PermissionStatus> _getPermission() async {
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.sms);
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.disabled) {
      Map<PermissionGroup, PermissionStatus> permisionStatus =
      await PermissionHandler()
          .requestPermissions([PermissionGroup.sms]);
      return permisionStatus[PermissionGroup.sms] ??
          PermissionStatus.unknown;
    } else {
      return permission;
    }
  }

  getMessage() async {
    PermissionStatus permissionStatus = await _getPermission();
    if (permissionStatus == PermissionStatus.granted) {
      var sms = await query.getAllSms;

      var distinctIds = sms.toSet().toList();
      setState(() {
        _messages = distinctIds;
      });

    } else {
      throw PlatformException(
        code: 'PERMISSION_DENIED',
        message: 'Access to location data denied',
        details: null,
      );
      getPermission();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: _messages?.length ?? 0,
        itemBuilder: (context, i) {
          var c = _messages?.elementAt(i);
          return new Column(
            children: <Widget>[
              new Divider(
                height: 10.0,
              ),
              new ListTile(
                onTap: () {getPermission();},
                leading: CircleAvatar(child: Text(c.address)),
                title: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Text(
                      c.sender ?? '',
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
                  child: new Text('${c.body}',
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

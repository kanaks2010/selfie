import 'package:camera/camera.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:selfie/pages/camera_screen.dart';
import 'package:selfie/pages/contact_screen.dart';
import 'package:selfie/pages/gallery_screen.dart';
import 'package:selfie/pages/message_screen.dart';
import 'package:permission_handler/permission_handler.dart';

class SelfieAppHome extends StatefulWidget {
  final List<CameraDescription> cameras;
  SelfieAppHome({this.cameras});

  @override
  _SelfieAppHomeState createState() => _SelfieAppHomeState();
}

class _SelfieAppHomeState extends State<SelfieAppHome>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  bool showFab = true;
  Map<PermissionGroup, PermissionStatus> permissions;
  final _cameraKey = GlobalKey<CameraScreenState>();



  @override
  void initState() {
    super.initState();
    getPermission();
    _tabController = TabController(vsync: this, initialIndex: 1, length: 4);
    _tabController.addListener(() {
      if (_tabController.index == 1) {
        showFab = true;
      } else {
        showFab = false;
      }
      setState(() {});
    });

  }


  void getPermission() async {
    permissions = await PermissionHandler().requestPermissions([
      PermissionGroup.camera,
      PermissionGroup.phone,
      PermissionGroup.storage,
      PermissionGroup.contacts,
      PermissionGroup.sms,
    ]);
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Take a Selfie"),
        elevation: 0.7,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: <Widget>[
            Tab(icon: Icon(Icons.camera_alt)),
            Tab(text: "Gallery"),
            Tab(

              text: "Contact",
            ),
            Tab(
              text: "Message",
            ),
          ],
        ),
        actions: <Widget>[
          // Icon(Icons.search),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
          ),
          Icon(Icons.more_vert)
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          CameraScreen(),
          GalleryScreen(),
          ContactScreen(),
          MessageScreen(),
        ],
      ),
      floatingActionButton: showFab
          ? FloatingActionButton(
              backgroundColor: Theme.of(context).accentColor,
              child: Icon(
                Icons.message,
                color: Colors.white,
              ),
              onPressed: () => print("open chats"),
            )
          : null,
    );
  }
}

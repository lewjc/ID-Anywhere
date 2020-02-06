import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:id_anywhere/view/code.dart';
import 'package:id_anywhere/view/profile.dart';
import 'package:id_anywhere/view/upload.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  State createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: 3, vsync: this); // initialise it here
  }

  Future<bool> onBackPress() async {
    await SystemNavigator.pop();
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: onBackPress,
        child: Scaffold(
          appBar: AppBar(
            elevation: 10,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("ID Anywhere",
                    style: TextStyle(
                        fontFamily: "Open Sans",
                        fontSize: 28,
                        fontWeight: FontWeight.w600))
              ],
            ),
            bottom:
                TabBar(controller: _tabController, isScrollable: true, tabs: [
              Tab(text: "Profile", icon: Icon(Icons.account_circle)),
              Tab(
                text: "Upload",
                icon: Icon(Icons.cloud_upload),
              ),
              Tab(text: "QR Code", icon: Icon(Icons.remove_red_eye))
            ]),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              ProfilePage(),
              UploadPage(),
              CodePage()
              // these are your pages
            ],
          ),
          key: _scaffoldKey,
          backgroundColor: Colors.white,
        ));
  }
}

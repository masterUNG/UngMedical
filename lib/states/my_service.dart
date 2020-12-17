import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ungmedical/states/authen.dart';
import 'package:ungmedical/states/page2.dart';
import 'package:ungmedical/states/show_data.dart';
import 'package:ungmedical/utility/my_constant.dart';

class MyService extends StatefulWidget {
  @override
  _MyServiceState createState() => _MyServiceState();
}

class _MyServiceState extends State<MyService> {
  String name;
  Widget currentWidget = ShowData();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findName();
  }

  Future<Null> findName() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      name = preferences.getString(MyConstant().keyName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Service'),
      ),
      drawer: Drawer(
        child: Stack(
          children: [
            buildSignOut(context),
            Column(
              children: [
                buildUserAccountsDrawerHeader(),
                buildListTileShowData(),
                buildListTilePage2(),
              ],
            ),
          ],
        ),
      ),
      body: currentWidget,
    );
  }

  ListTile buildListTileShowData() => ListTile(
        leading: Icon(Icons.list),
        title: Text('Show List Data'),
        subtitle: Text('Display All Data and Add New Data'),
        onTap: () {
          Navigator.pop(context);
          setState(() {
            currentWidget = ShowData();
          });
        },
      );

  ListTile buildListTilePage2() => ListTile(
        leading: Icon(Icons.filter_2),
        title: Text('Show Page2'),
        subtitle: Text('Display Page2'),
        onTap: () {
          Navigator.pop(context);
          setState(() {
            currentWidget = Page2();
          });
        },
      );

  UserAccountsDrawerHeader buildUserAccountsDrawerHeader() {
    return UserAccountsDrawerHeader(
      otherAccountsPictures: [
        IconButton(
            icon: Icon(Icons.info, color: Colors.white), onPressed: () {})
      ],
      decoration: BoxDecoration(
        gradient: RadialGradient(
          radius: 0.8,
          center: Alignment(-0.7, -0.4),
          colors: [Colors.white, Colors.purple],
        ),
      ),
      currentAccountPicture: Image.asset('images/logo.png'),
      accountName: Text(name == null ? 'Name ?' : name),
      accountEmail: Text('Login'),
    );
  }

  Widget buildSignOut(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ListTile(
          onTap: () async {
            SharedPreferences preferences =
                await SharedPreferences.getInstance();
            preferences.clear();
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => Authen(),
                ),
                (route) => false);
          },
          tileColor: Colors.red.shade700,
          leading: Icon(
            Icons.exit_to_app,
            color: Colors.white,
            size: 36,
          ),
          title: Text(
            'Sign Out',
            style: TextStyle(color: Colors.white),
          ),
          subtitle: Text(
            'Sign Out and Back to Authen',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}

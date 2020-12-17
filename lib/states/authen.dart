import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ungmedical/models/user_model.dart';
import 'package:ungmedical/states/my_service.dart';
import 'package:ungmedical/utility/dialog.dart';
import 'package:ungmedical/utility/my_constant.dart';

// This is คือ Stateful ทำหน้าที่ สร้าง State ไปแสดงที่ main.dart
class Authen extends StatefulWidget {
  @override
  _AuthenState createState() => _AuthenState();
}

class _AuthenState extends State<Authen> {
  String user, password;
  bool statusRemember = false;
  bool status = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findStatus();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<Null> findStatus() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String name = preferences.getString(MyConstant().keyName);
    print('name = $name');

    if (name == null) {
      setState(() {
        status = false;
      });
    } else {
      routeToService();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          status ? Center(child: CircularProgressIndicator()) : buildContent(),
    );
  }

  Container buildContent() {
    return Container(
      // decoration: BoxDecoration(color: Colors.purple),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/wall.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(color: Colors.white54),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                buildLogo(),
                buildAppName(),
                buildTextFieldUser(),
                buildTextFieldPassword(),
                buildCheckboxListTile(),
                buildLogin()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container buildCheckboxListTile() => Container(
        width: 250,
        child: CheckboxListTile(
          controlAffinity: ListTileControlAffinity.leading,
          title: Text('Remember Me'),
          value: statusRemember,
          onChanged: (value) {
            setState(() {
              statusRemember = !statusRemember;
            });
          },
        ),
      );

  Container buildLogin() => Container(
        margin: EdgeInsets.only(top: 16),
        width: 250,
        child: ElevatedButton(
          onPressed: () {
            print('user = $user, password = $password');
            if ((user?.isEmpty ?? true) || (password?.isEmpty ?? true)) {
              print('Have Space');
              normalDialog(context, 'Have Space ? Please Fill Every Blank');
            } else {
              print('No Space');
              checkAuthen();
            }
          },
          child: Text('OK'),
        ),
      );

  Future<Null> checkAuthen() async {
    String path =
        '${MyConstant().domain}/TVdirect/getUserWhereUserUng.php?isAdd=true&User=$user';
    await Dio().get(path).then((value) async {
      print('value = $value');
      if (value.toString() == 'null') {
        normalDialog(context, 'No $user in my Database');
      } else {
        var result = json.decode(value.data);
        for (var json in result) {
          UserModel model = UserModel.fromJson(json);
          if (password == model.password) {
            if (statusRemember) {
              SharedPreferences preferences =
                  await SharedPreferences.getInstance();
              preferences.setString(MyConstant().keyName, model.name);
              routeToService();
            } else {
              routeToService();
            }
          } else {
            normalDialog(context, 'Password False ? Please Try Again');
          }
        }
      }
    });
  }

  void routeToService() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => MyService(),
        ),
        (route) => false);
  }

  Container buildTextFieldUser() => Container(
        margin: EdgeInsets.only(top: 16),
        width: 250,
        child: TextField(
          onChanged: (value) => user = value.trim(),
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'User :',
            prefixIcon: Icon(Icons.account_box),
          ),
        ),
      );

  Container buildTextFieldPassword() => Container(
        margin: EdgeInsets.only(top: 16),
        width: 250,
        child: TextField(
          onChanged: (value) => password = value.trim(),
          obscureText: true,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Password :',
            prefixIcon: Icon(Icons.lock),
          ),
        ),
      );

  Text buildAppName() => Text(
        'Ung Medical',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: Colors.green.shade900,
        ),
      );

  Container buildLogo() {
    return Container(
      width: 120,
      child: Image.asset('images/logo.png'),
    );
  }
}

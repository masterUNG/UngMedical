import 'package:flutter/material.dart';
import 'package:ungmedical/states/add_data.dart';

class ShowData extends StatefulWidget {
  @override
  _ShowDataState createState() => _ShowDataState();
}

class _ShowDataState extends State<ShowData> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('This is Show Data'),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddData(),
            )),
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }
}

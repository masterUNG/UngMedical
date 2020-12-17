import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:ungmedical/utility/dialog.dart';
import 'package:ungmedical/utility/my_constant.dart';

class AddData extends StatefulWidget {
  @override
  _AddDataState createState() => _AddDataState();
}

class _AddDataState extends State<AddData> {
  File file;
  String title, detail;
  double lat, lng;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findLatLng();
  }

  Future<Null> findLatLng() async {
    LocationData locationData = await findLocationData();
    setState(() {
      lat = locationData.latitude;
      lng = locationData.longitude;
      print('lat = $lat, lng = $lng');
    });
  }

  Future<LocationData> findLocationData() async {
    Location location = Location();
    try {
      return location.getLocation();
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Data'),
      ),
      body: Stack(
        children: [
          buildSingleChildScrollView(),
          buildElevatedButton(),
        ],
      ),
    );
  }

  Widget buildElevatedButton() => Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            child: ElevatedButton.icon(
                onPressed: () {
                  if (file == null) {
                    normalDialog(context, 'No Picture ? Please Choose Source');
                  } else if ((title?.isEmpty ?? true) ||
                      (detail?.isEmpty ?? true)) {
                    normalDialog(context, 'Have Space ? Please Fill All');
                  } else {
                    uploadImageAndInsertData();
                  }
                },
                icon: Icon(Icons.cloud_upload),
                label: Text('Save Data')),
          ),
        ],
      );

  Future<Null> uploadImageAndInsertData() async {
    String pathUpload = '${MyConstant().domain}/TVdirect/saveFile.php';
    int i = Random().nextInt(10000000);
    String namePic = 'pic$i.jpg';
    String urlPic = '/TVdirect/upload/$namePic';

    try {
      Map<String, dynamic> map = Map();
      map['file'] = await MultipartFile.fromFile(file.path, filename: namePic);
      FormData formData = FormData.fromMap(map);
      await Dio().post(pathUpload, data: formData).then((value) async {
        print('Upload Success at url = ${MyConstant().domain}$urlPic');
        String path =
            '${MyConstant().domain}/TVdirect/addProduct.php?isAdd=true&urlpic=$urlPic&title=$title&detail=$detail&lat=$lat&lng=$lng&qrcode=$namePic';
        await Dio().get(path).then((value) => Navigator.pop(context));
      });
    } catch (e) {}
  }

  SingleChildScrollView buildSingleChildScrollView() {
    return SingleChildScrollView(
      child: Column(
        children: [buildRowPicture(), buildTitle(), buildDetail(), buildMap()],
      ),
    );
  }

  Container buildMap() {
    return Container(
      padding: EdgeInsets.all(20),
      // decoration: BoxDecoration(color: Colors.grey),
      width: MediaQuery.of(context).size.width,
      height: 250,
      child: lat == null
          ? Center(child: CircularProgressIndicator())
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(lat, lng),
                zoom: 16,
              ),
              mapType: MapType.normal,
              onMapCreated: (controller) {},
              markers: setMarker(),
            ),
    );
  }

  Set<Marker> setMarker() {
    return <Marker>[
      Marker(
        markerId: MarkerId('idmarker'),
        position: LatLng(lat, lng),
        infoWindow:
            InfoWindow(title: 'You Here ?', snippet: 'lat =$lat, lng = $lng'),
      ),
    ].toSet();
  }

  Container buildTitle() {
    return Container(
      width: 250,
      child: TextField(
        onChanged: (value) => title = value.trim(),
        decoration: InputDecoration(labelText: 'Title'),
      ),
    );
  }

  Container buildDetail() {
    return Container(
      width: 250,
      child: TextField(
        onChanged: (value) => detail = value.trim(),
        decoration: InputDecoration(labelText: 'Detail'),
      ),
    );
  }

  Future<Null> chooseSourceImage(ImageSource source) async {
    try {
      var result = await ImagePicker()
          .getImage(source: source, maxWidth: 800, maxHeight: 800);
      setState(() {
        file = File(result.path);
      });
    } catch (e) {}
  }

  Row buildRowPicture() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: Icon(Icons.add_a_photo),
          onPressed: () => chooseSourceImage(ImageSource.camera),
        ),
        Container(
          width: 250,
          height: 250,
          child:
              file == null ? Image.asset('images/pic.png') : Image.file(file),
        ),
        IconButton(
          icon: Icon(Icons.add_photo_alternate),
          onPressed: () => chooseSourceImage(ImageSource.gallery),
        ),
      ],
    );
  }
}

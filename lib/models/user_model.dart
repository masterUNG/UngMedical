class UserModel {
  String id;
  String name;
  String user;
  String password;
  String lat;
  String lng;

  UserModel({this.id, this.name, this.user, this.password, this.lat, this.lng});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['Name'];
    user = json['User'];
    password = json['Password'];
    lat = json['Lat'];
    lng = json['Lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['Name'] = this.name;
    data['User'] = this.user;
    data['Password'] = this.password;
    data['Lat'] = this.lat;
    data['Lng'] = this.lng;
    return data;
  }
}


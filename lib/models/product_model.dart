import 'dart:convert';

class ProductModel {
  final String urlpic;
  final String title;
  final String detail;
  final double lat;
  final double lng;
  final String qrcode;
  ProductModel({
    this.urlpic,
    this.title,
    this.detail,
    this.lat,
    this.lng,
    this.qrcode,
  });

  ProductModel copyWith({
    String urlpic,
    String title,
    String detail,
    double lat,
    double lng,
    String qrcode,
  }) {
    return ProductModel(
      urlpic: urlpic ?? this.urlpic,
      title: title ?? this.title,
      detail: detail ?? this.detail,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      qrcode: qrcode ?? this.qrcode,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'urlpic': urlpic,
      'title': title,
      'detail': detail,
      'lat': lat,
      'lng': lng,
      'qrcode': qrcode,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return ProductModel(
      urlpic: map['urlpic'],
      title: map['title'],
      detail: map['detail'],
      lat: map['lat'],
      lng: map['lng'],
      qrcode: map['qrcode'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductModel.fromJson(String source) => ProductModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ProductModel(urlpic: $urlpic, title: $title, detail: $detail, lat: $lat, lng: $lng, qrcode: $qrcode)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is ProductModel &&
      o.urlpic == urlpic &&
      o.title == title &&
      o.detail == detail &&
      o.lat == lat &&
      o.lng == lng &&
      o.qrcode == qrcode;
  }

  @override
  int get hashCode {
    return urlpic.hashCode ^
      title.hashCode ^
      detail.hashCode ^
      lat.hashCode ^
      lng.hashCode ^
      qrcode.hashCode;
  }
}

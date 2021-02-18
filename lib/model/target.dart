class Target {
  var id;
  var name;
  var lat;
  var lng;
  var orderIndex;

  Target({this.id, this.name, this.lat, this.lng, this.orderIndex});

  factory Target.fromJson(Map<String, dynamic> json) => Target(
      id: json['id'],
      name: json['name'],
      lat: json['lat'],
      lng: json['lng'],
      orderIndex: json['order_index']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'lat': lat,
        'lng': lng,
        'order_index': orderIndex
      };
}

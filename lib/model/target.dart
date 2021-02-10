class Target {
  var id;
  var name;
  var lat;
  var lng;

  Target({this.id, this.name, this.lat, this.lng});

  factory Target.fromJson(Map<String, dynamic> json) => Target(
      id: json['id'], name: json['name'], lat: json['lat'], lng: json['lng']);

  Map<String, dynamic> toJson() =>
      {'id': id, 'name': name, 'lat': lat, 'lng': lng};
}

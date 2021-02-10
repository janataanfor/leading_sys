class OurLocations {
  var id;
  var name;
  var lat;
  var lng;
  var wType;
  var degStart;
  var degEnd;
  var disStart;
  var disEnd;
  var orderIndex;

  OurLocations(
      {this.id,
      this.name,
      this.lat,
      this.lng,
      this.wType,
      this.degStart,
      this.degEnd,
      this.disStart,
      this.disEnd,
      this.orderIndex});

  factory OurLocations.fromJson(Map<String, dynamic> json) => OurLocations(
      id: json['id'],
      name: json['name'],
      lat: json['lat'],
      lng: json['lng'],
      wType: json['w_type'],
      degStart: json['deg_start'],
      degEnd: json['deg_end'],
      disStart: json['dis_start'],
      disEnd: json['dis_end'],
      orderIndex: json['order_index']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'lat': lat,
        'lng': lng,
        'w_type': wType,
        'deg_start': degStart,
        'deg_end': degEnd,
        'dis_start': disStart,
        'dis_end': disEnd,
        'order_index': orderIndex
      };
}

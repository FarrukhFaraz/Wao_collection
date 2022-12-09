class AllCityModels {
  int? id;
  String? name;
  String? nameUrdu;
  String? image;
  String? lat;
  String? lng;
  String? famous;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;

  AllCityModels(
      {this.id,
      this.name,
      this.nameUrdu,
      this.image,
      this.lat,
      this.lng,
      this.famous,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  AllCityModels.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    nameUrdu = json['name_urdu'];
    image = json['image'];
    lat = json['lat'];
    lng = json['lng'];
    famous = json['famous'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['name_urdu'] = this.nameUrdu;
    data['image'] = this.image;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['famous'] = this.famous;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}

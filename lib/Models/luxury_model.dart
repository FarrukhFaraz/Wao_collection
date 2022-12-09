class LuxuryModel {
  int? id;
  String? name;
  String? category;
  String? price;
  String? soldItem;
  String? reviews;
  String? color;
  String? variety;
  String? video;
  String? createdAt;
  String? updatedAt;
  bool type = false;
  bool isplay = false;
  var quantity2 = 0;
  int? ordercount;

  LuxuryModel(
      {this.id,
      this.name,
      this.category,
      this.price,
      this.soldItem,
      this.reviews,
      this.color,
      this.variety,
      this.video,
      this.createdAt,
      this.updatedAt});

  LuxuryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    category = json['category'];
    price = json['price'];
    soldItem = json['soldItem'];
    reviews = json['reviews'];
    color = json['color'];
    variety = json['variety'];
    video = json['video'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['category'] = this.category;
    data['price'] = this.price;
    data['soldItem'] = this.soldItem;
    data['reviews'] = this.reviews;
    data['color'] = this.color;
    data['variety'] = this.variety;
    data['video'] = this.video;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

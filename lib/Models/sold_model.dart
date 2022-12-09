import 'package:wao_collection/Models/new_arrivals.dart';

class SoldModel {
  int? id;
  String? name;
  String? category;
  String? price;
  String? soldItem;
  String? soldAdm;
  String? reviews;
  String? color;
  String? variety;
  String? video;
  String? createdAt;
  String? updatedAt;
  List<ProdReviews>? prodReviews;
  bool isplay = false;
  bool type = false;

  SoldModel(
      {this.id,
      this.name,
      this.category,
      this.price,
      this.soldItem,
      this.soldAdm,
      this.reviews,
      this.color,
      this.variety,
      this.video,
      this.createdAt,
      this.updatedAt,
      this.prodReviews});

  SoldModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    category = json['category'];
    price = json['price'];
    soldItem = json['soldItem'];
    soldAdm = json['soldAdm'];
    reviews = json['reviews'];
    color = json['color'];
    variety = json['variety'];
    video = json['video'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (this.prodReviews != null) {
      json['prod_reviews'] = prodReviews!.map((v) => v.toString()).toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['category'] = this.category;
    data['price'] = this.price;
    data['soldItem'] = this.soldItem;
    data['soldAdm'] = this.soldAdm;
    data['reviews'] = this.reviews;
    data['color'] = this.color;
    data['variety'] = this.variety;
    data['video'] = this.video;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.prodReviews != null) {
      data['prod_reviews'] =
          this.prodReviews!.map((v) => v.toString()).toList();
    }
    return data;
  }
}

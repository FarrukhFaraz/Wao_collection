class NewArrivalsModel {
  int? id;
  String? name;
  String? category;
  String? price;
  String? soldItem;
  var soldAdm;
  String? reviews;
  String? color;
  String? variety;
  String? video;
  String? createdAt;
  String? updatedAt;
  List<ProdReviews>? prodReviews;
  List<SingProductRev>? singProductRev;
  bool type = false;
  bool isPlay = false;
  var quantity2 = 0;
  int? orderCount;

  NewArrivalsModel(
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
      this.prodReviews,
      this.singProductRev});

  NewArrivalsModel.fromJson(Map<String, dynamic> json) {
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
    if (json['prod_reviews'] != null) {
      prodReviews = <ProdReviews>[];
      json['prod_reviews'].forEach((v) {
        prodReviews!.add(new ProdReviews.fromJson(v));
      });
    }
    if (json['singproduct_rev'] != null) {
      singProductRev = <SingProductRev>[];
      json['singproduct_rev'].forEach((v) {
        singProductRev!.add(new SingProductRev.fromJson(v));
      });
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
      data['prod_reviews'] = this.prodReviews!.map((v) => v.toJson()).toList();
    }
    if (this.singProductRev != null) {
      data['singproduct_rev'] =
          this.singProductRev!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProdReviews {
  int? id;
  String? prodId;
  String? review;
  String? desc;
  String? cusName;
  String? createdAt;
  String? updatedAt;

  ProdReviews(
      {this.id,
      this.prodId,
      this.review,
      this.desc,
      this.cusName,
      this.createdAt,
      this.updatedAt});

  ProdReviews.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    prodId = json['prod_id'];
    review = json['review'];
    desc = json['desc'];
    cusName = json['cus_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['prod_id'] = this.prodId;
    data['review'] = this.review;
    data['desc'] = this.desc;
    data['cus_name'] = this.cusName;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class SingProductRev {
  int? id;
  String? prodId;
  String? name;
  String? address;
  String? createdAt;
  String? updatedAt;

  SingProductRev(
      {this.id,
      this.prodId,
      this.name,
      this.address,
      this.createdAt,
      this.updatedAt});

  SingProductRev.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    prodId = json['prod_id'];
    name = json['name'];
    address = json['address'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['prod_id'] = this.prodId;
    data['name'] = this.name;
    data['address'] = this.address;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

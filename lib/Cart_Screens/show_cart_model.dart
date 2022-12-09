class ItemsModel {
  int? id;
  String? userId;
  String? prodId;
  String? quantity;
  String? createdAt;
  String? updatedAt;
  Product? product;

  ItemsModel(
      {this.id,
      this.userId,
      this.prodId,
      this.quantity,
      this.createdAt,
      this.updatedAt,
      this.product});

  ItemsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    prodId = json['prod_id'];
    quantity = json['quantity'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    product =
        json['product'] != null ? new Product.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['prod_id'] = this.prodId;
    data['quantity'] = this.quantity;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.product != null) {
      data['product'] = this.product!.toJson();
    }
    return data;
  }
}

class Product {
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

  Product(
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

  Product.fromJson(Map<String, dynamic> json) {
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

class UserDet {
  int? id;
  String? name;
  String? cityName;
  String? country;
  String? phone;
  String? address;
  String? emailVerifiedAt;
  String? createdAt;
  String? updatedAt;

  UserDet(
      {this.id,
      this.name,
      this.cityName,
      this.country,
      this.phone,
      this.address,
      this.emailVerifiedAt,
      this.createdAt,
      this.updatedAt});

  UserDet.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    cityName = json['city_name'];
    country = json['country'];
    phone = json['phone'];
    address = json['address'];
    emailVerifiedAt = json['email_verified_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['city_name'] = this.cityName;
    data['country'] = this.country;
    data['phone'] = this.phone;
    data['address'] = this.address;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

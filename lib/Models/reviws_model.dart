class ReviwesModel {
  int? id;
  String? prodId;
  String? review;
  String? desc;
  String? cusName;
  String? createdAt;
  String? updatedAt;
  Product? product;

  ReviwesModel(
      {this.id,
      this.prodId,
      this.review,
      this.desc,
      this.cusName,
      this.createdAt,
      this.updatedAt,
      this.product});

  ReviwesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    prodId = json['prod_id'];
    review = json['review'];
    desc = json['desc'];
    cusName = json['cus_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    product =
        json['product'] != null ? new Product.fromJson(json['product']) : null;
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

  Product({this.id, this.name, this.category, this.price});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    category = json['category'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['category'] = this.category;
    data['price'] = this.price;
    return data;
  }
}

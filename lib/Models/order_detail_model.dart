class OrderDetailModel {
  int? id;
  String? userId;
  String? name;
  String? phone;
  String? country;
  String? city;
  String? address;
  String? note;
  String? status;
  String? cancelNote;
  String? charges;
  String? grandTotal;
  String? amount;
  String? slip;
  String? createdAt;
  String? updatedAt;
  String? time;
  String? date;
  Userdetail? userdetail;
  List<Orderitems>? orderitems;
  List<Notes>? notes;

  OrderDetailModel(
      {this.id,
      this.userId,
      this.name,
      this.phone,
      this.country,
      this.city,
      this.address,
      this.note,
      this.status,
      this.cancelNote,
      this.charges,
      this.grandTotal,
      this.amount,
      this.slip,
      this.createdAt,
      this.updatedAt,
      this.time,
      this.date,
      this.userdetail,
      this.orderitems,
      this.notes});

  OrderDetailModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    name = json['name'];
    phone = json['phone'];
    country = json['country'];
    city = json['city'];
    address = json['address'];
    note = json['note'];
    status = json['status'];
    cancelNote = json['cancel_note'];
    charges = json['charges'];
    grandTotal = json['grandTotal'];
    amount = json['amount'];
    slip = json['slip'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    time = json['time'];
    date = json['date'];
    userdetail = json['userdetail'] != null
        ? new Userdetail.fromJson(json['userdetail'])
        : null;
    if (json['orderitems'] != null) {
      orderitems = <Orderitems>[];
      json['orderitems'].forEach((v) {
        orderitems!.add(new Orderitems.fromJson(v));
      });
    }
    if (json['notes'] != null) {
      notes = <Notes>[];
      json['notes'].forEach((v) {
        notes!.add(new Notes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['country'] = this.country;
    data['city'] = this.city;
    data['address'] = this.address;
    data['note'] = this.note;
    data['status'] = this.status;
    data['cancel_note'] = this.cancelNote;
    data['charges'] = this.charges;
    data['grandTotal'] = this.grandTotal;
    data['amount'] = this.amount;
    data['slip'] = this.slip;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['time'] = this.time;
    data['date'] = this.date;
    if (this.userdetail != null) {
      data['userdetail'] = this.userdetail!.toJson();
    }
    if (this.orderitems != null) {
      data['orderitems'] = this.orderitems!.map((v) => v.toJson()).toList();
    }
    if (this.notes != null) {
      data['notes'] = this.notes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Userdetail {
  int? id;
  String? name;
  String? cityName;
  String? country;
  String? phone;
  String? whatsapp;
  String? address;
  Null? emailVerifiedAt;
  String? createdAt;
  String? updatedAt;

  Userdetail(
      {this.id,
      this.name,
      this.cityName,
      this.country,
      this.phone,
      this.whatsapp,
      this.address,
      this.emailVerifiedAt,
      this.createdAt,
      this.updatedAt});

  Userdetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    cityName = json['city_name'];
    country = json['country'];
    phone = json['phone'];
    whatsapp = json['whatsapp'];
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
    data['whatsapp'] = this.whatsapp;
    data['address'] = this.address;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Orderitems {
  int? id;
  String? orderId;
  String? prodId;
  String? qty;
  String? price;
  String? createdAt;
  String? updatedAt;
  Product? product;

  Orderitems(
      {this.id,
      this.orderId,
      this.prodId,
      this.qty,
      this.price,
      this.createdAt,
      this.updatedAt,
      this.product});

  Orderitems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    prodId = json['prod_id'];
    qty = json['qty'];
    price = json['price'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    product =
        json['product'] != null ? new Product.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_id'] = this.orderId;
    data['prod_id'] = this.prodId;
    data['qty'] = this.qty;
    data['price'] = this.price;
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
  String? soldAdm;
  String? increasePerMin;
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
      this.soldAdm,
      this.increasePerMin,
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
    soldAdm = json['soldAdm'];
    increasePerMin = json['increase_perMin'];
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
    data['soldAdm'] = this.soldAdm;
    data['increase_perMin'] = this.increasePerMin;
    data['reviews'] = this.reviews;
    data['color'] = this.color;
    data['variety'] = this.variety;
    data['video'] = this.video;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Notes {
  int? id;
  String? orderId;
  String? note;
  String? createdAt;
  String? updatedAt;

  Notes({this.id, this.orderId, this.note, this.createdAt, this.updatedAt});

  Notes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    note = json['note'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_id'] = this.orderId;
    data['note'] = this.note;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

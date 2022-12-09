class ViewAllOrderModel {
  int? id;
  String? userId;
  String? name;
  String? phone;
  String? country;
  String? city;
  String? address;
  String? note;
  String? status;
  String? charges;
  String? grandTotal;
  String? amount;
  String? createdAt;
  String? updatedAt;
  String? time;
  String? date;

  ViewAllOrderModel(
      {this.id,
      this.userId,
      this.name,
      this.phone,
      this.country,
      this.city,
      this.address,
      this.note,
      this.status,
      this.charges,
      this.grandTotal,
      this.amount,
      this.createdAt,
      this.updatedAt,
      this.time,
      this.date});

  ViewAllOrderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    name = json['name'];
    phone = json['phone'];
    country = json['country'];
    city = json['city'];
    address = json['address'];
    note = json['note'];
    status = json['status'];
    charges = json['charges'];
    grandTotal = json['grandTotal'];
    amount = json['amount'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    time = json['time'];
    date = json['date'];
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
    data['charges'] = this.charges;
    data['grandTotal'] = this.grandTotal;
    data['amount'] = this.amount;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['time'] = this.time;
    data['date'] = this.date;
    return data;
  }
}

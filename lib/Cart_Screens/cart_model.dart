class CartModel {
  String id;
  String productName;
  String productPrice;
  int itemCount = 1;

  CartModel(
    this.id,
    this.productName,
    this.productPrice,
    this.itemCount,
  );
}

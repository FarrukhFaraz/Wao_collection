import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:text_scroll/text_scroll.dart';
import 'package:toast/toast.dart';
import 'package:video_player/video_player.dart';
import 'package:wao_collection/Cart_Screens/cart_model.dart';
import 'package:wao_collection/Cart_Screens/cart_model_list.dart';
import 'package:wao_collection/Models/new_arrivals.dart';
import 'package:wao_collection/Utils/colors.dart';
import 'package:wao_collection/Utils/urls.dart';

import '../../../Splash_Screen/video_items.dart';
import '../../Bottom_Screens/place_order.dart';
import '../Reviews/review.dart';

var finalPrice = 0;
var quantity;
var checkCart = false;
List allProduct = [];
bool isAdded = false;
var userId;
int? sum;
var json;

class NewArrivalsScreen extends StatefulWidget {
  const NewArrivalsScreen({super.key});

  @override
  State<NewArrivalsScreen> createState() => _NewArrivalsScreenState();
}

class _NewArrivalsScreenState extends State<NewArrivalsScreen> {
  // DBHelper dbHelper = DBHelper();
  VideoPlayerController? controller;
  bool noData = false;
  var amount;
  bool loader = true;
  bool isLoadAllProduct = false;
  int discountAmount = 10;
  double _subTotal = 0.0;
  double totalAmount = 0.0;
  double grandTotal = 0.0;


  bool addToCartLoader= false;
  bool addToCart = false;

  List<String> productIds = [];
  int? jsonId;
  List<CartModel> cartItem = [];

  List<NewArrivalsModel> newArrivalsList = [];

  newArrivals() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      http.Response response = await http.get(
        Uri.parse(newarrrivals),
      );
      var jsonData = jsonDecode(response.body);
      print("newArrivals" + response.body);
      if (jsonData['statusCode'] == 200) {
        for (int i = 0; i < jsonData["data"].length; i++) {
          Map<String, dynamic> object = jsonData["data"][i];
          NewArrivalsModel _test = NewArrivalsModel();
          _test = NewArrivalsModel.fromJson(object);
          if (_test.soldAdm != '0') {
            var count = prefs.getInt('${_test.id}+quantity2');
            if (count != null) {
              setState(() {
                if (count > 0) {
                  cartItem.add(CartModel(_test.id.toString(),
                      _test.name.toString(), _test.price.toString(), count));
                }
                _test.quantity2 = count;
              });
            }
            newArrivalsList.add(_test);
          }
        }
        print('newArrivalsList length = ${newArrivalsList.length}');
        print('cartItem length = ${cartItem.length}');
        for (int i = 0; i < cartItem.length; i++) {
          print('cart id    ===== ==== ${cartItem[i].id}');
        }

        quantity = jsonData['data'][0]['soldItem'];
        print(quantity);

        setState(() {
          loader = false;
          noData = false;
        });
      } else {
        setState(() {
          loader = false;
          noData = true;
        });
        Toast.show("No Product Found");
      }
    } catch (e) {
      print(e);
    }

    setState(() {
      loader = false;
    });
  }

  getShare() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    userId = sharedPreferences.getString('userId');
    var a;
    a = sharedPreferences.getInt('${userId}+finalPrice');
    if (a == null) {
      finalPrice = 0;
    } else {
      finalPrice = a;
    }
    print('m==$userId');
    notificationArrivalApi(userId);
  }

  notificationArrivalApi(var id) async {
    Map body = {
      'user_id': id.toString(),
    };
    print("userId=====" + id);

    try {
      final response = await http.post(
        Uri.parse(
          hidearrivalurl,
        ),
        body: body,
      );
      Map jsonData = jsonDecode(response.body);
      print("notificationData=== " + response.body);

      if (jsonData['statusCode'] == 200) {
        print(jsonData['message']);
      }
    } catch (e) {
      print(e);
    }
  }

  subTotalAmount() {
    _subTotal = 0;
    setState(() {});
    print("myClicked");
    for (int i = 0; i < cartItems.length; i++) {
      print("total = ${_subTotal.toString()}");
      print("qty = ${cartItems[i].itemCount}");
      _subTotal = _subTotal +
          (double.parse(cartItems[i].productPrice.toString()) *
              cartItems[i].itemCount.toDouble());
      print("totalAmount1 ${_subTotal.toString()}");
    }
    setState(() {
      totalAmount = _subTotal;
      print("totalAmount2 ${_subTotal.toString()}");
    });

    isLoadAllProduct = false;
    setState(() {});
    getTotal();
  }

  getTotal() {
    _subTotal = 0;
    setState(() {});
    print("myClicked");
    for (int i = 0; i < cartItems.length; i++) {
      _subTotal = _subTotal +
          (double.parse(cartItems[i].productPrice.toString()) *
              cartItems[i].itemCount.toDouble());
    }

    setState(() {
      grandTotal = _subTotal - discountAmount;
      print("grandAmount1 ${_subTotal.toString()}");
      print("grandAmount1 ${grandTotal.toString()}");
    });

    isLoadAllProduct = false;
    setState(() {});
  }

  addToCartApi(String id, String quantity) async {
    setState(() {
      addToCartLoader = true;
    });
    Map body = {
      "user_id": userId.toString(),
      "prod_id": id,
      "quantity": quantity
    };

    try {
      http.Response response = await http.post(Uri.parse(addToCartURL), body: body);
      Map jsonData = jsonDecode(response.body);

      if (jsonData['statusCode'] == 200) {
        setState(() {
          addToCart = false;
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Add to cart successfully')));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Something went wrong!')));
      }
    } catch (e) {
      print(e);
    }

    setState(() {
      addToCartLoader = false;
    });
  }

  @override
  void initState() {
    super.initState();
    newArrivals();
    getShare();
  }

  @override
  Widget build(BuildContext context) {
    // final cart = Provider.of<CartProvider>(context);
    ToastContext().init(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: kBlack,
        bottomNavigationBar: finalPrice == 0 ? SizedBox() : bottomNavigator(),
        body: loader
            ? Center(
                child: CircularProgressIndicator(
                  color: kWhite,
                ),
              )
            : noData == true
                ? Center(
                    child: Text("No Data Found"),
                  )
                : SingleChildScrollView(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.01,
                      right: MediaQuery.of(context).size.width * 0.01,
                      left: MediaQuery.of(context).size.width * 0.01,
                    ),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.only(
                                  left:
                                      MediaQuery.of(context).size.width * 0.04,
                                ),
                                alignment: Alignment.centerLeft,
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  color: kWhite,
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.02,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: ((context) =>
                                              ReviewScreen())));
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical:
                                          MediaQuery.of(context).size.height *
                                              0.002),
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  alignment: Alignment.center,
                                  color: kWhite,
                                  child: Text("Reviews"),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),
                        itemWidget()
                      ],
                    ),
                  ),
      ),
    );
  }

  Widget itemWidget() {
    return ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: newArrivalsList.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Text(
                newArrivalsList[index].name.toString(),
                style: TextStyle(
                  color: kWhite,
                  fontSize: 30,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.8,
                child: Stack(
                  children: [
                    VideoItems(
                      videoPlayerController: VideoPlayerController.network(
                        newArrivalsList[index].video.toString(),
                      ),
                      looping: false,
                      autoplay: newArrivalsList[index].isPlay,
                    ),
                    Container(
                      padding: const EdgeInsets.all(6),
                      // decoration: BoxDecoration(
                      //     color: kWhite,
                      //     borderRadius: BorderRadius.circular(12)),
                      alignment: Alignment.center,
                      height: MediaQuery.of(context).size.height * 0.052,
                      child: TextScroll(
                        "Bilal Buy From Multan,Bashir Buy From Multan,Farrukh Buy From Multan,Bilal Buy From Multan,Bilal Buy From Multan,Bilal Buy From Multan,Bilal Buy From Multan,Bilal Buy From Multan,Bilal Buy From Multan,Bilal Buy From Multan,Bilal Buy From Multan,",
                        mode: TextScrollMode.bouncing,
                        velocity:
                            const Velocity(pixelsPerSecond: Offset(150, 0)),
                        delayBefore: const Duration(milliseconds: 50),
                        numberOfReps: 5,
                        pauseBetween: const Duration(milliseconds: 100),
                        style: TextStyle(color: kWhite),
                        textAlign: TextAlign.right,
                        selectable: true,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.48,
                        right: MediaQuery.of(context).size.width * 0.02,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Column(
                            // mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                newArrivalsList[index].price.toString(),
                                style: TextStyle(
                                  color: kWhite,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.006,
                              ),
                              Text(
                                newArrivalsList[index].name.toString(),
                                style: TextStyle(
                                  color: kWhite,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.006,
                              ),
                              RichText(
                                  text: TextSpan(
                                      text: "Sold Item   ",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      children: [
                                    TextSpan(
                                      text: newArrivalsList[index]
                                          .soldAdm
                                          .toString(),
                                    )
                                  ])),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.006,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: MediaQuery.of(context).size.width * 0.04,
                      top: MediaQuery.of(context).size.height * 0.6,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              print('111111111111111111');
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();

                              if (newArrivalsList[index].quantity2 == 0) {
                                setState(() {
                                  addToCart=true;
                                  newArrivalsList[index].type = true;
                                  newArrivalsList[index].quantity2++;
                                  finalPrice = finalPrice +
                                      int.parse(newArrivalsList[index]
                                          .price
                                          .toString());

                                  cartItem.add(CartModel(
                                    newArrivalsList[index].id.toString(),
                                    newArrivalsList[index].name.toString(),
                                    newArrivalsList[index].price.toString(),
                                    newArrivalsList[index].quantity2,
                                  ));
                                  prefs.setInt(
                                      '$userId+finalPrice', finalPrice);
                                  prefs.setInt(
                                    '${newArrivalsList[index].id}+quantity2',
                                    newArrivalsList[index].quantity2,
                                  );
                                });

                                setState(() {
                                  checkCart = true;
                                });

                                for (int i = 0; i < cartItem.length; i++) {
                                  print(
                                      'cartItem id ==== ${cartItem[i].id} \n cartitem quantity === ${cartItem[i].itemCount}');
                                }
                              }
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: MediaQuery.of(context).size.height * 0.08,
                              width: MediaQuery.of(context).size.width * 0.4,
                              decoration: BoxDecoration(
                                color: newArrivalsList[index].type == true ||
                                        newArrivalsList[index].quantity2 != 0
                                    ? kWhite
                                    : yellow800,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: newArrivalsList[index].type == true ||
                                      newArrivalsList[index].quantity2 != 0
                                  ? Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          GestureDetector(
                                            onTap: () async {
                                              setState(() {
                                                addToCart=true;
                                              });
                                              SharedPreferences prefs =
                                                  await SharedPreferences
                                                      .getInstance();
                                              if (newArrivalsList[index]
                                                      .quantity2 ==
                                                  1) {
                                                setState(() {
                                                  newArrivalsList[index]
                                                      .quantity2 = 0;

                                                  newArrivalsList[index].type =
                                                      false;

                                                  finalPrice = finalPrice -
                                                      int.parse(
                                                          newArrivalsList[index]
                                                              .price
                                                              .toString());
                                                  for (int i = 0;
                                                      i < cartItem.length;
                                                      i++) {
                                                    print(
                                                        'equality ${cartItem[i].id}= ${newArrivalsList[index].id}');
                                                    if (cartItem[i]
                                                            .id
                                                            .toString() ==
                                                        newArrivalsList[index]
                                                            .id
                                                            .toString()) {
                                                      cartItem.removeAt(i);
                                                      print(
                                                          'product successfully removed');
                                                      print(
                                                          'this is lenth  =${cartItem.length}');
                                                    }
                                                  }
                                                });
                                              } else {
                                                setState(() {
                                                  newArrivalsList[index]
                                                      .quantity2--;
                                                  finalPrice = finalPrice -
                                                      int.parse(
                                                          newArrivalsList[index]
                                                              .price
                                                              .toString());
                                                  for (int i = 0;
                                                      i < cartItem.length;
                                                      i++) {
                                                    if (cartItem[i]
                                                            .id
                                                            .toString() ==
                                                        newArrivalsList[index]
                                                            .id
                                                            .toString()) {
                                                      print(
                                                          'old quantity ${cartItem[i].itemCount}');
                                                      cartItem[i].itemCount =
                                                          newArrivalsList[index]
                                                              .quantity2;
                                                      print(
                                                          'new quantity ${cartItem[i].itemCount}');
                                                    }
                                                  }
                                                });
                                              }
                                              prefs.setInt(
                                                '${newArrivalsList[index].id}+quantity2',
                                                newArrivalsList[index]
                                                    .quantity2,
                                              );

                                              prefs.setInt('$userId+finalPrice',
                                                  finalPrice);

                                              print(
                                                  'CartItem List Length = ${cartItem.length}');

                                              for (int i = 0;
                                                  i < cartItem.length;
                                                  i++) {
                                                print(
                                                    'cartItem Id= ${cartItem[i].id} \ncartItem quantity = ${cartItem[i].itemCount}');
                                              }
                                            },
                                            child: Image.asset(
                                              "assets/images/minus.png",
                                              height: 30,
                                            ),
                                          ),
                                          Text(
                                            newArrivalsList[index]
                                                .quantity2
                                                .toString(),
                                            style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () async {
                                              setState(() {
                                               addToCart=true;
                                              });
                                              SharedPreferences prefs =
                                                  await SharedPreferences
                                                      .getInstance();

                                              if (newArrivalsList[index]
                                                      .quantity2 ==
                                                  int.parse(
                                                      newArrivalsList[index]
                                                          .soldItem
                                                          .toString())) {
                                                Toast.show(
                                                  "You Have Reached maximum",
                                                );
                                              } else {
                                                print('increased quantity');
                                                setState(() {
                                                  newArrivalsList[index]
                                                          .quantity2 =
                                                      newArrivalsList[index]
                                                              .quantity2 +
                                                          1;
                                                  finalPrice = finalPrice +
                                                      int.parse(
                                                          newArrivalsList[index]
                                                              .price
                                                              .toString());
                                                  print(newArrivalsList[index]
                                                      .quantity2);

                                                  for (int i = 0;
                                                      i < cartItem.length;
                                                      i++) {
                                                    if (cartItem[i]
                                                            .id
                                                            .toString() ==
                                                        newArrivalsList[index]
                                                            .id
                                                            .toString()) {
                                                      print(
                                                          'old quantity = ${cartItem[i].itemCount}');
                                                      cartItem[i].itemCount =
                                                          newArrivalsList[index]
                                                              .quantity2;

                                                      print(
                                                          'new quantity = ${cartItem[i].itemCount}');
                                                    }
                                                  }
                                                });
                                              }

                                              prefs.setInt(
                                                '${newArrivalsList[index].id}+quantity2',
                                                newArrivalsList[index]
                                                    .quantity2,
                                              );
                                              prefs.setInt('$userId+finalPrice',
                                                  finalPrice);
                                              print(
                                                  'CartItem List Length = ${cartItem.length}');
                                              for (int i = 0;
                                                  i < cartItem.length;
                                                  i++) {
                                                print(
                                                    'Id= ${cartItem[i].id} \nquantity = ${cartItem[i].itemCount}');
                                              }
                                            },
                                            child: Container(
                                              child: Image.asset(
                                                "assets/images/add.png",
                                                height: 30,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Text(
                                      "Done",
                                      style: TextStyle(
                                        color: kWhite,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.height * 0.02,
                          ),
                          addToCart
                              ? InkWell(
                                  onTap: () {
                                    addToCartApi(
                                        newArrivalsList[index].id.toString(),
                                        newArrivalsList[index]
                                            .quantity2
                                            .toString());
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: MediaQuery.of(context).size.height *
                                        0.08,
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: kWhite,
                                    ),
                                    child:
                                    addToCartLoader?Center(child: CircularProgressIndicator())
                                    :Text(
                                      'Add To Cart',
                                      style: TextStyle(
                                        color: kBlack,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                )
                              : SizedBox()
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                color: kWhite,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              )
            ],
          );
        });
  }

  Widget bottomNavigator() {
    return Container(
        height: MediaQuery.of(context).size.height * 0.1,
        color: kWhite,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          GestureDetector(
            onTap: () {
              print(cartItem.length);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: ((context) => PlaceOrderScreen(
                        cartList: cartItem,
                      )),
                ),
              );
            },
            child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: yellow800, borderRadius: BorderRadius.circular(16)),
                height: MediaQuery.of(context).size.height * 0.06,
                width: MediaQuery.of(context).size.width * 0.72,
                child: RichText(
                  text: TextSpan(
                      text: "Place Order    ",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        TextSpan(
                            text: "RS   ",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            children: [
                              TextSpan(
                                  text: finalPrice.toString(),
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ))
                            ]),
                      ]),
                )),
          ),
        ]));
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:video_player/video_player.dart';
import 'package:wao_collection/Cart_Screens/cart_model.dart';
import 'package:wao_collection/Models/bags_model.dart';
import 'package:wao_collection/Screens/Authentication/login_page.dart';
import 'package:wao_collection/Splash_Screen/video_items.dart';
import 'package:wao_collection/Utils/colors.dart';
import 'package:wao_collection/Utils/urls.dart';

import '../../Bottom_Screens/place_order.dart';
import '../Reviews/review.dart';

var quantity;
List allProduct = [];
bool checkCart = false;

class BagsScreen extends StatefulWidget {
  const BagsScreen({super.key});

  @override
  State<BagsScreen> createState() => _BagsScreenState();
}

class _BagsScreenState extends State<BagsScreen> {
  List<CartModel> cartItem = [];
  VideoPlayerController? controller;
  bool noData = false;
  var amount;
  var bagsFinalPrice;
  bool addToCartLoader = false;
  bool addToCart = false;
  bool loader = true;

  List<BagsModel> _bags = [];

  newArrivals() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await http.get(
      Uri.parse(newarrrivals),
    );
    var jsonData = jsonDecode(response.body);
    print("bags=====" + response.body);
    if (response.statusCode == 200) {
      for (int i = 0; i < jsonData["data"].length; i++) {
        Map<String, dynamic> object = jsonData["data"][i];
        BagsModel _test = BagsModel();
        _test = BagsModel.fromJson(object);

        var count = prefs.getInt('${_test.id}+bagsQuantity2');
        if (count != null) {
          setState(() {
            if (count > 0) {
              cartItem.add(CartModel(_test.id.toString(), _test.name.toString(),
                  _test.price.toString(), count));
            }
            _test.quantity2 = count;
          });
        }

        _bags.add(_test);
      }
      quantity = jsonData['data'][0]['soldItem'];
      print(quantity);
      setState(() {
        loader = false;
        noData = false;
      });
    } else if (response.statusCode == 404) {
      setState(() {
        loader = false;
        noData = true;
      });
      Toast.show("No Product Found");
    }
    setState(() {
      loader = false;
    });
  }

  getShare() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    userId = sharedPreferences.getString('userId');
    print('m==$userId');

    var val;
    val = sharedPreferences.getInt('${userId}bagsFinalPrice');
    print('aaaaaaaaaa=  $val');
    setState(() {
      if (val == null) {
        bagsFinalPrice = 0;
      } else {
        bagsFinalPrice = val;
      }
    });
  }

  notificationBagsApi(var id) async {
    Map body = {
      'user_id': id.toString(),
    };
    print(" mmm=======" + id);
    final response = await http.post(
      Uri.parse(
        hidebagsurl,
      ),
      body: body,
    );
    if (response.statusCode == 200) {
      print("nre bags=====" + response.body);
    }
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

    print(body.toString());

    try {
      http.Response response =
          await http.post(Uri.parse(addToCartURL), body: body);
      Map jsonData = jsonDecode(response.body);
      print(jsonData);

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
    ToastContext().init(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: kBlack,
        bottomNavigationBar:
            bagsFinalPrice == 0 ? SizedBox() : bottomNavigator(),
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
                            controller!.pause();
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

  Widget bottomNavigator() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.1,
      color: kWhite,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => PlaceOrderScreen(
                            cartList: cartItem,
                          ))));
            },
            child: Stack(
              children: [
                Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: yellow800,
                        borderRadius: BorderRadius.circular(16)),
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
                                      text: bagsFinalPrice.toString(),
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ))
                                ]),
                          ]),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget itemWidget() {
    return ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _bags.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Text(
                _bags[index].name.toString(),
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
                          _bags[index].video.toString()),
                      looping: false,
                      autoplay: _bags[index].isplay,
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
                                _bags[index].price.toString(),
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
                                _bags[index].name.toString(),
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
                                      text: _bags[index].soldItem.toString(),
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

                              if (_bags[index].quantity2 == 0) {
                                setState(() {
                                  addToCart = true;
                                });
                                setState(() {
                                  _bags[index].type = true;
                                  _bags[index].quantity2++;
                                  bagsFinalPrice = bagsFinalPrice +
                                      int.parse(_bags[index].price.toString());

                                  cartItem.add(CartModel(
                                    _bags[index].id.toString(),
                                    _bags[index].name.toString(),
                                    _bags[index].price.toString(),
                                    _bags[index].quantity2,
                                  ));
                                  prefs.setInt('${userId}bagsFinalPrice',
                                      bagsFinalPrice);
                                  prefs.setInt(
                                    '${_bags[index].id}+bagsQuantity2',
                                    _bags[index].quantity2,
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
                                color: _bags[index].type == true ||
                                        _bags[index].quantity2 != 0
                                    ? kWhite
                                    : yellow800,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: _bags[index].type == true ||
                                      _bags[index].quantity2 != 0
                                  ? Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          GestureDetector(
                                            onTap: () async {
                                              setState(() {
                                                addToCart = true;
                                              });
                                              SharedPreferences prefs =
                                                  await SharedPreferences
                                                      .getInstance();
                                              if (_bags[index].quantity2 == 1) {
                                                setState(() {
                                                  _bags[index].quantity2 = 0;

                                                  _bags[index].type = false;

                                                  bagsFinalPrice =
                                                      bagsFinalPrice -
                                                          int.parse(_bags[index]
                                                              .price
                                                              .toString());
                                                  for (int i = 0;
                                                      i < cartItem.length;
                                                      i++) {
                                                    print(
                                                        'equality ${cartItem[i].id}= ${_bags[index].id}');
                                                    if (cartItem[i]
                                                            .id
                                                            .toString() ==
                                                        _bags[index]
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
                                                  _bags[index].quantity2--;
                                                  bagsFinalPrice =
                                                      bagsFinalPrice -
                                                          int.parse(_bags[index]
                                                              .price
                                                              .toString());
                                                  for (int i = 0;
                                                      i < cartItem.length;
                                                      i++) {
                                                    if (cartItem[i]
                                                            .id
                                                            .toString() ==
                                                        _bags[index]
                                                            .id
                                                            .toString()) {
                                                      print(
                                                          'old quantity ${cartItem[i].itemCount}');
                                                      cartItem[i].itemCount =
                                                          _bags[index]
                                                              .quantity2;
                                                      print(
                                                          'new quantity ${cartItem[i].itemCount}');
                                                    }
                                                  }
                                                });
                                              }
                                              prefs.setInt(
                                                '${_bags[index].id}+bagsQuantity2',
                                                _bags[index].quantity2,
                                              );

                                              prefs.setInt(
                                                  '${userId}bagsFinalPrice',
                                                  bagsFinalPrice);

                                              print(
                                                  'total Amount = ${bagsFinalPrice}\nquantity = ${_bags[index].quantity2}');
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
                                            _bags[index].quantity2.toString(),
                                            style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () async {
                                              setState(() {
                                                addToCart = true;
                                              });
                                              SharedPreferences prefs =
                                                  await SharedPreferences
                                                      .getInstance();

                                              if (_bags[index].quantity2 ==
                                                  int.parse(_bags[index]
                                                      .soldItem
                                                      .toString())) {
                                                Toast.show(
                                                  "You Have Reached maximum",
                                                );
                                              } else {
                                                print('increased quantity');
                                                setState(() {
                                                  _bags[index].quantity2 =
                                                      _bags[index].quantity2 +
                                                          1;
                                                  bagsFinalPrice =
                                                      bagsFinalPrice +
                                                          int.parse(_bags[index]
                                                              .price
                                                              .toString());
                                                  print(_bags[index].quantity2);

                                                  for (int i = 0;
                                                      i < cartItem.length;
                                                      i++) {
                                                    if (cartItem[i]
                                                            .id
                                                            .toString() ==
                                                        _bags[index]
                                                            .id
                                                            .toString()) {
                                                      print(
                                                          'old quantity = ${cartItem[i].itemCount}');
                                                      cartItem[i].itemCount =
                                                          _bags[index]
                                                              .quantity2;

                                                      print(
                                                          'new quantity = ${cartItem[i].itemCount}');
                                                    }
                                                  }
                                                });
                                              }

                                              prefs.setInt(
                                                '${_bags[index].id}+bagsQuantity2',
                                                _bags[index].quantity2,
                                              );
                                              print('aaaaaaaaaaaaaa');
                                              print('${userId}');
                                              prefs.setInt(
                                                  '${userId}bagsFinalPrice',
                                                  bagsFinalPrice);
                                              print(
                                                  'luxuryFinalPrice = ${bagsFinalPrice}');
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
                          addToCart
                              ? InkWell(
                                  onTap: () {
                                    addToCartApi(_bags[index].id.toString(),
                                        _bags[index].quantity2.toString());
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
                                    child: addToCartLoader
                                        ? Center(
                                            child: CircularProgressIndicator())
                                        : Text(
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
                    )
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
}

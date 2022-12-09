import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'package:video_player/video_player.dart';
import 'package:wao_collection/Models/search_model.dart';
import 'package:wao_collection/Splash_Screen/video_items.dart';
import 'package:wao_collection/Utils/colors.dart';
import 'package:wao_collection/Utils/urls.dart';

import '../../Bottom_Screens/place_order.dart';
import '../Reviews/review.dart';

class SearchDetailScreen extends StatefulWidget {
  final String name;

  const SearchDetailScreen({super.key, required this.name});

  @override
  State<SearchDetailScreen> createState() => _SearchDetailScreenState();
}

class _SearchDetailScreenState extends State<SearchDetailScreen> {
  late VideoPlayerController controller;
  bool _onclicked = false;
  bool loader = true;
  var finalprice = 0;
  var quantity;
  var quantity2 = 1;
  List allProduct = [];
  bool nodata = false;
  var amount;
  bool text = false;

  List<SearchModel> _searchdetail = [];

  searchApi() async {
    final response = await http.get(
      Uri.parse(searchurl + widget.name),
    );
    var jsonData = jsonDecode(response.body);
    print("searchApi" + response.body);
    if (jsonData['message'] == "succes") {
      for (int i = 0; i < jsonData["data"].length; i++) {
        Map<String, dynamic> object = jsonData["data"][i];
        SearchModel _test = SearchModel();
        _test = SearchModel.fromJson(object);
        _searchdetail.add(_test);
      }

      setState(() {
        loader = false;
      });
    } else if (jsonData['message'] == "Not found") {
      setState(() {
        text = true;
        loader = false;
      });
      Toast.show("No Product Found", textStyle: TextStyle(color: kWhite));
    }
    setState(() {
      loader = false;
    });
  }

  @override
  void initState() {
    super.initState();
    searchApi();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kBlack,
        bottomNavigationBar: finalprice == 0 ? SizedBox() : bottomnavigator(),
        body: loader
            ? Center(
                child: CircularProgressIndicator(color: kWhite),
              )
            : text == true
                ? Center(
                    child: Text(
                      "No Product Found ",
                      style: TextStyle(
                        color: kWhite,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
                            controller.pause();
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
                        itemwidget()
                      ],
                    ),
                  ),
      ),
    );
  }

  Widget bottomnavigator() {
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
                            cartList: [],
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
                                      text: finalprice.toString(),
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ))
                                ]),
                          ]),
                    )),
                Container(
                  margin: EdgeInsets.only(
                    right: 50,
                  ),
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height * 0.052,
                  width: MediaQuery.of(context).size.width * 0.06,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: kLightRed,
                  ),
                  child: Text(
                    "1",
                    style: TextStyle(
                      color: kWhite,
                      fontSize: 20,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget itemwidget() {
    return ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _searchdetail.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Text(
                _searchdetail[index].name.toString(),
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
                          _searchdetail[index].video.toString()),
                      looping: false,
                      autoplay: _searchdetail[index].isplay,
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
                                _searchdetail[index].price.toString(),
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
                                _searchdetail[index].name.toString(),
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
                                      text: _searchdetail[index]
                                          .soldItem
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
                            onTap: () {
                              bottomnavigator();
                              setState(() {
                                _searchdetail[index].type == true
                                    ? _searchdetail[index].type = false
                                    : _searchdetail[index].type = true;
                              });
                              _searchdetail[index].type == true
                                  ? setState(() {
                                      allProduct.add(_searchdetail[index].id);
                                      //bottomnavigator();
                                      finalprice = finalprice +
                                          int.parse(_searchdetail[index]
                                              .price
                                              .toString());
                                    })
                                  : setState(() {
                                      allProduct.remove(_searchdetail[index]
                                          .id); //bottomnavigator();
                                      finalprice = finalprice -
                                          int.parse(_searchdetail[index]
                                              .price
                                              .toString());
                                    });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: MediaQuery.of(context).size.height * 0.08,
                              width: MediaQuery.of(context).size.width * 0.4,
                              decoration: BoxDecoration(
                                color: _searchdetail[index].type == true
                                    ? kWhite
                                    : yellow800,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: _searchdetail[index].type == true
                                  ? Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              if (quantity2 == 1) {
                                                setState(() {
                                                  _searchdetail[index].type =
                                                      false;

                                                  finalprice = finalprice -
                                                      int.parse(
                                                          _searchdetail[index]
                                                              .price
                                                              .toString());
                                                });
                                                print(
                                                    _searchdetail[index].type);
                                              } else {
                                                setState(() {
                                                  quantity2--;
                                                  finalprice = finalprice -
                                                      int.parse(
                                                          _searchdetail[index]
                                                              .price
                                                              .toString());
                                                });
                                              }
                                            },
                                            child: Image.asset(
                                              "assets/images/minus.png",
                                              height: 30,
                                            ),
                                          ),
                                          Text(
                                            quantity2.toString(),
                                            style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              if (quantity2 ==
                                                  int.parse(quantity)) {
                                                Toast.show(
                                                  "You Have Reached maximum",
                                                );
                                              } else {
                                                setState(() {
                                                  quantity2++;
                                                  print("quantyio22" +
                                                      quantity2.toString());
                                                  finalprice = finalprice +
                                                      int.parse(
                                                          _searchdetail[index]
                                                              .price
                                                              .toString());
                                                });
                                              }
                                            },
                                            child: Image.asset(
                                              "assets/images/add.png",
                                              height: 30,
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

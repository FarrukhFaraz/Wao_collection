import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:video_player/video_player.dart';
import 'package:wao_collection/Models/sold_model.dart';
import 'package:wao_collection/Splash_Screen/video_items.dart';
import 'package:wao_collection/Utils/colors.dart';
import 'package:wao_collection/Utils/urls.dart';

bool isAdded = false;

class SoldScreen extends StatefulWidget {
  const SoldScreen({super.key});

  @override
  State<SoldScreen> createState() => _SoldScreenState();
}

class _SoldScreenState extends State<SoldScreen> {
  bool noData = false;
  var amount;
  bool loader = true;

  List<SoldModel> _soldItem = [];

  soldItemApi() async {
    final response = await http.get(
      Uri.parse(soldItemurl),
    );
    var jsonData = jsonDecode(response.body);
    print("newArrivals" + response.body);
    if (jsonData['statusCode'] == 200) {
      for (int i = 0; i < jsonData["data"].length; i++) {
        Map<String, dynamic> object = jsonData["data"][i];
        SoldModel _test = SoldModel();
        _test = SoldModel.fromJson(object);

        _soldItem.add(_test);
      }

      setState(() {
        loader = false;
        noData = false;
      });
    } else if (jsonData['statusCode'] == 404) {
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

  var m;

  getShare() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    m = sharedPreferences.getString('userId');
    print('m==$m');
    soldItemApi();
  }

  @override
  void initState() {
    super.initState();

    getShare();
  }

  @override
  Widget build(BuildContext context) {
    // final cart = Provider.of<CartProvider>(context);
    ToastContext().init(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: kBlack,
        body: loader
            ? Center(
                child: CircularProgressIndicator(
                  color: kWhite,
                ),
              )
            : noData == true
                ? Center(
                    child: Text(
                      "No Data Found",
                      style: TextStyle(color: kWhite),
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
        itemCount: _soldItem.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Text(
                _soldItem[index].name.toString(),
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
                        _soldItem[index].video.toString(),
                      ),
                      looping: false,
                      autoplay: _soldItem[index].isplay,
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
                                _soldItem[index].price.toString(),
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
                                _soldItem[index].name.toString(),
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
                            child: Container(
                              alignment: Alignment.center,
                              height: MediaQuery.of(context).size.height * 0.08,
                              width: MediaQuery.of(context).size.width * 0.4,
                              decoration: BoxDecoration(
                                color: _soldItem[index].type == true
                                    ? kWhite
                                    : yellow800,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                "Sold In",
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

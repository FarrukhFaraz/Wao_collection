import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:text_scroll/text_scroll.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wao_collection/Screens/Home_Page/Home_Screens/bags.dart';
import 'package:wao_collection/Screens/Home_Page/Home_Screens/lucky_draw.dart';
import 'package:wao_collection/Screens/Home_Page/Home_Screens/luxury_collection.dart';
import 'package:wao_collection/Screens/Home_Page/Home_Screens/new_arrivals.dart';
import 'package:wao_collection/Screens/Home_Page/Home_Screens/profile.dart';
import 'package:wao_collection/Screens/Home_Page/Home_Screens/rate_us.dart';
import 'package:wao_collection/Screens/Home_Page/Home_Screens/report_problem.dart';
import 'package:wao_collection/Screens/Home_Page/Home_Screens/search_screen.dart';
import 'package:wao_collection/Screens/Home_Page/Home_Screens/sold.dart';
import 'package:wao_collection/Screens/Home_Page/Orders/my_order.dart';
import 'package:wao_collection/Utils/colors.dart';
import 'package:wao_collection/Utils/urls.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  var message;
  var userId;
  var data;
  var data1;
  var data2;
  bool loader = true;
  bool err = false;
  String msgErr = '';

  getshare() async {
    SharedPreferences _shareprefrense = await SharedPreferences.getInstance();
    userId = _shareprefrense.getString('userId');
    print('m==$userId');
    showtopmessageApi();
    shownewarrivalApi();
    shownewluxury();
    shownewbagsApi();
  }

  showtopmessageApi() async {
    setState(() {
      loader = true;
    });
    try {
      http.Response response = await http.get(
        Uri.parse(showtopmessageurl),
      );
      Map jsonData = jsonDecode(response.body);

      print("JSONDATA== $jsonData");

      if (jsonData["status"] == "1") {
        print('this is jsondata');
        setState(() {
          message = jsonData['message'];
        });
      } else {
        print('this is new message');
      }
      print('message = $message');
    } catch (e) {
      print(e);
    }
    setState(() {
      loader = false;
    });
  }

  shownewarrivalApi() async {
    try {
      final response = await http.get(
        Uri.parse(shownewarrivalurl + '?user_id=' + userId),
      );
      Map jsonData = jsonDecode(response.body);
      print("respoonse=" + response.body);
      print(jsonData);
      if (jsonData['statusCode'] == 200) {
        setState(() {
          data = jsonData['data'];
        });
        setState(() {
          loader = false;
        });
      }
    } catch (e) {
      print(e);
    }
    setState(() {
      loader = false;
    });
  }

  shownewluxury() async {
    try {
      final response = await http.get(
        Uri.parse(showluxuryurl + '?user_id=' + userId),
      );
      Map jsonData = jsonDecode(response.body);
      print("respoonse===" + response.body);
      print(jsonData);
      if (jsonData['statusCode'] == 200) {
        setState(() {
          data1 = jsonData['data'];
        });
        setState(() {
          loader = false;
        });
      }
    } catch (e) {
      print(e);
    }
    setState(() {
      loader = false;
    });
  }

  shownewbagsApi() async {
    try {
      final response = await http.get(
        Uri.parse(shownewbagsurl + '?user_id=' + userId),
      );
      Map jsonData = jsonDecode(response.body);
      print("respoonse===" + response.body);
      print(jsonData);
      if (jsonData['statusCode'] == 200) {
        setState(() {
          data2 = jsonData['data'];
        });
        setState(() {
          loader = false;
        });
      }
    } catch (e) {
      print(e);
    }
    setState(() {
      loader = false;
    });
  }

  openWhatsapp({required BuildContext context}) async {
    String whatsapp = '+923026241583';
    String whatsappURlAndroid =
        "whatsapp://send?phone=$whatsapp&text=Asslam_o_Alikum";
    String whatsappURLIos =
        "https://wa.me/$whatsapp?text=${Uri.parse("Asslam_o_Alikum")}";
    if (Platform.isIOS) {
      if (await canLaunchUrl(Uri.parse(whatsappURLIos))) {
        await launchUrl(Uri.parse(whatsappURLIos));
      } else {
        Toast.show(
          "whatsapp no installed",
          gravity: Toast.bottom,
          duration: Toast.lengthLong,
        );
      }
    } else {
      if (await canLaunchUrl(Uri.parse(whatsappURlAndroid))) {
        await launchUrl(Uri.parse(whatsappURlAndroid));
      } else {
        Toast.show("whatsapp no installed");
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getshare();
  }

  @override
  Widget build(BuildContext context) {
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
            : Container(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.04,
                  right: MediaQuery.of(context).size.width * 0.04,
                  top: MediaQuery.of(context).size.height * 0.04,
                ),
                child: SingleChildScrollView(
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "For HelpLine",
                                style: TextStyle(
                                  color: kWhite,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  openWhatsapp(context: context);
                                },
                                child: Image.asset(
                                  "assets/images/whatsapp.png",
                                  height:
                                      MediaQuery.of(context).size.height * 0.06,
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          RichText(
                            text: TextSpan(
                                text: "WAO   ",
                                style: TextStyle(
                                  color: kWhite,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                                children: [
                                  TextSpan(
                                      text: "Collection",
                                      style: TextStyle(
                                        color: yellow800,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w300,
                                      ))
                                ]),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                                color: kWhite,
                                borderRadius: BorderRadius.circular(12)),
                            alignment: Alignment.center,
                            height: MediaQuery.of(context).size.height * 0.052,
                            child: TextScroll(
                              message.toString(),
                              mode: TextScrollMode.bouncing,
                              velocity: const Velocity(
                                  pixelsPerSecond: Offset(150, 0)),
                              delayBefore: const Duration(milliseconds: 50),
                              numberOfReps: 5,
                              pauseBetween: const Duration(milliseconds: 100),
                              style: TextStyle(color: kBlack),
                              textAlign: TextAlign.right,
                              selectable: true,
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) =>
                                            NewArrivalsScreen())));
                              },
                              child: Stack(
                                children: [
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.072,
                                    decoration: BoxDecoration(
                                      color: yellow800,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Image.asset(
                                            "assets/images/new.png",
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.04,
                                          ),
                                          Text(
                                            "New Arrivals",
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  data == 0
                                      ? SizedBox()
                                      : Positioned(
                                          bottom: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.04,
                                          right: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.864,
                                          child: Container(
                                            alignment: Alignment.center,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.04,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.08,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.red,
                                            ),
                                            child: Text(data.toString()),
                                          ),
                                        )
                                ],
                              )),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) =>
                                            const LuxuryScreen())));
                              },
                              child: Stack(
                                children: [
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.072,
                                    decoration: BoxDecoration(
                                      color: yellow800,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Image.asset(
                                            "assets/images/diamond.png",
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.04,
                                          ),
                                          Text(
                                            "Luxury Collection",
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  data1 == 0
                                      ? SizedBox()
                                      : Positioned(
                                          bottom: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.04,
                                          right: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.864,
                                          child: Container(
                                            alignment: Alignment.center,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.04,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.08,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.red,
                                            ),
                                            child: Text(data1.toString()),
                                          ),
                                        )
                                ],
                              )),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) =>
                                            const BagsScreen())));
                              },
                              child: Stack(
                                children: [
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.072,
                                    decoration: BoxDecoration(
                                      color: yellow800,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Image.asset(
                                            "assets/images/shopping-bag.png",
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.04,
                                          ),
                                          Text(
                                            "Bags",
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  data2 == 0
                                      ? SizedBox()
                                      : Positioned(
                                          bottom: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.04,
                                          right: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.864,
                                          child: Container(
                                            alignment: Alignment.center,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.04,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.08,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.red,
                                            ),
                                            child: Text(data2.toString()),
                                          ),
                                        )
                                ],
                              )),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) =>
                                            const SoldScreen())));
                              },
                              child: collection(
                                  "Sold Items", "assets/images/sold.png")),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) =>
                                            SearchScreen())));
                              },
                              child: collection(
                                "Search",
                                "assets/images/search.png",
                              )),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) =>
                                            MyOrderScreen())));
                              },
                              child: collection("My Order",
                                  "assets/images/shopping-bag.png")),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) =>
                                            ProfileScreen())));
                              },
                              child: collection(
                                  "Profile", "assets/images/user.png")),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) =>
                                            ShareCollectionScreen())));
                              },
                              child: collection(
                                  "Report a Problem", "assets/images/bug.png")),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) =>
                                            LuckyDrawScreen())));
                              },
                              child: collection(
                                  "Lucky Draw", "assets/images/lottery.png")),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) =>
                                            RateUsScreen())));
                              },
                              child: collection(
                                  "Rate Us", "assets/images/rating.png")),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget collection(
    String text,
    String image,
  ) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.072,
      decoration: BoxDecoration(
        color: yellow800,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              image,
              height: MediaQuery.of(context).size.height * 0.04,
            ),
            Text(
              text,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }
}

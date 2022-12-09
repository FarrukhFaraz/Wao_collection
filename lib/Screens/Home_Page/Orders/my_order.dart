import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:wao_collection/Models/view_all_order_model.dart';
import 'package:wao_collection/Screens/Home_Page/Orders/order_detail.dart';
import 'package:wao_collection/Utils/colors.dart';
import 'package:wao_collection/Utils/urls.dart';

class MyOrderScreen extends StatefulWidget {
  const MyOrderScreen({super.key});

  @override
  State<MyOrderScreen> createState() => _MyOrderScreenState();
}

class _MyOrderScreenState extends State<MyOrderScreen> {
  bool loader = false;
  var m;
  bool text = false;

  getShare() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    m = sharedPreferences.getString('userId');
    print('m==$m');
    viewAllOrderApi(m.toString());
  }

  List<ViewAllOrderModel> _viewAllOrder = [];

  viewAllOrderApi(var m) async {
    print("m11111" + m);
    final response = await http.get(
      Uri.parse(viewallorder + '?user_id=' + m),
    );
    var jsonData = jsonDecode(response.body);
    print("myOrder" + response.body);
    if (jsonData['message'] == "succes") {
      for (int i = 0; i < jsonData["data"].length; i++) {
        Map<String, dynamic> object = jsonData["data"][i];
        ViewAllOrderModel _test = ViewAllOrderModel();
        _test = ViewAllOrderModel.fromJson(object);
        _viewAllOrder.add(_test);
      }
      print('lllllllllll');
      print(_viewAllOrder.length);
      setState(() {
        loader = false;
        text = false;
      });
    } else if (jsonData['message'] == "No found orders") {
      setState(() {
        text = true;
        loader = false;
      });
      Toast.show("No Product Found");
    }
    setState(() {
      loader = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getShare();
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: kBlack,
        body: loader
            ? Center(
                child: CircularProgressIndicator(color: kWhite),
              )
            : text == true
                ? Center(
                    child: Text(
                      "No Order Found ",
                      style: TextStyle(
                        color: kWhite,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : Container(
                    // alignment: Alignment.topLeft,
                    padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.06,
                      right: MediaQuery.of(context).size.width * 0.06,
                      top: MediaQuery.of(context).size.height * 0.02,
                    ),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: kWhite,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "My Order",
                            style: TextStyle(
                              color: kWhite,
                              fontSize: 26,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        myOrder()
                      ],
                    ),
                  ),
      ),
    );
  }

  Widget myOrder() {
    return Container(
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.height * 0.02,
      ),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: _viewAllOrder.length,
        itemBuilder: (context, index) {
          print(_viewAllOrder.length);
          // String h = DateFormat('h');
          // print("hhhh" + h);
          return Column(
            children: [
              Container(
                margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.02,
                ),
                decoration: BoxDecoration(
                    color: kWhite,
                    borderRadius: BorderRadius.circular(
                      18,
                    )),
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                                text: _viewAllOrder[index].date.toString(),
                                style: TextStyle(
                                  color: kBlack,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                children: [
                                  TextSpan(
                                      text: " / ",
                                      style: TextStyle(
                                        color: kBlack,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: _viewAllOrder[index]
                                              .time
                                              .toString(),
                                          style: TextStyle(
                                            color: kBlack,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ]),
                                ]),
                          ),
                          RichText(
                            text: TextSpan(
                                text: "Orderid: ",
                                style: TextStyle(
                                  color: kBlack,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                children: [
                                  TextSpan(
                                    text: "TGSFKK",
                                    style: TextStyle(
                                      color: kBlack,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ]),
                          ),
                          RichText(
                            text: TextSpan(
                                text: "Amount: ",
                                style: TextStyle(
                                  color: kBlack,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                children: [
                                  TextSpan(
                                    text:
                                        _viewAllOrder[index].amount.toString(),
                                    style: TextStyle(
                                      color: kBlack,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ]),
                          ),
                          RichText(
                            text: TextSpan(
                                text: "Status: ",
                                style: TextStyle(
                                  color: kBlack,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                children: [
                                  TextSpan(
                                    text:
                                        _viewAllOrder[index].status.toString(),
                                    style: TextStyle(
                                      color: kBlack,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ]),
                          ),
                          Container(
                            child: RichText(
                              text: TextSpan(
                                  text: "Phone: ",
                                  style: TextStyle(
                                    color: kBlack,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  children: [
                                    TextSpan(
                                      text:
                                          _viewAllOrder[index].phone.toString(),
                                      style: TextStyle(
                                        color: kBlack,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.048,
                    ),
                    GestureDetector(
                      onTap: () {
                        print("ddd" + _viewAllOrder[index].id.toString());
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => OrderDetailScreen(
                                      id: _viewAllOrder[index].id.toString(),
                                    ))));
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.056,
                        width: MediaQuery.of(context).size.width * 0.26,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: yellow800,
                        ),
                        child: Text(
                          "Detail",
                          style: TextStyle(
                              color: kWhite,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // SizedBox(
              //   height: MediaQuery.of(context).size.height,
              // )
            ],
          );
        },
      ),
    );
  }
}

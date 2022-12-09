import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'package:wao_collection/Models/reviws_model.dart';
import 'package:wao_collection/Utils/colors.dart';
import 'package:wao_collection/Utils/urls.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  var review;
  bool loader = true;
  List<ReviwesModel> _review = [];

  newArrivals() async {
    final response = await http.get(
      Uri.parse(reviewurl),
    );
    var jsonData = jsonDecode(response.body);
    print("review======" + response.body);
    if (jsonData['statusCode'] == 200) {
      for (int i = 0; i < jsonData["data"].length; i++) {
        Map<String, dynamic> object = jsonData["data"][i];
        ReviwesModel _test = ReviwesModel();
        _test = ReviwesModel.fromJson(object);

        _review.add(_test);
      }

      setState(() {
        loader = false;
      });
    } else {
      setState(() {
        loader = false;
      });
      Toast.show("No Reviews Found");
    }
    setState(() {
      loader = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    newArrivals();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                  top: MediaQuery.of(context).size.height * 0.02,
                  left: MediaQuery.of(context).size.width * 0.04,
                  right: MediaQuery.of(context).size.width * 0.04,
                ),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            Icons.arrow_back_ios,
                            color: kWhite,
                          ),
                          // Container(
                          //   height: MediaQuery.of(context).size.height * 0.06,
                          //   width: MediaQuery.of(context).size.width * 0.6,
                          //   decoration: BoxDecoration(
                          //     borderRadius: BorderRadius.circular(14),
                          //     color: yellow800,
                          //   ),
                          //   alignment: Alignment.center,
                          //   child: RichText(
                          //       text: TextSpan(
                          //           text: "Total Reviews  ",
                          //           children: [TextSpan(text: "20")])),
                          // ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.032,
                    ),
                    _review.isEmpty
                        ? Column(
                            children: [
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.43),
                              Text(
                                'No Reviews found',
                                style: TextStyle(fontSize: 16, color: kWhite),
                              ),
                            ],
                          )
                        : reviewsWidget(),
                  ],
                ),
              ),
      ),
    );
  }

  Widget reviewsWidget() {
    return ListView.builder(
        itemCount: _review.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.02,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: kWhite,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      _review[index].cusName.toString(),
                      style: TextStyle(
                        color: kBlack,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.012,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: yellow800,
                      ),
                      Icon(
                        Icons.star,
                        color: yellow800,
                      ),
                      Icon(
                        Icons.star,
                        color: yellow800,
                      ),
                      Icon(
                        Icons.star,
                        color: yellow800,
                      ),
                      Icon(
                        Icons.star,
                        color: kGrey,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Text(
                    _review[index].desc.toString(),
                    style: TextStyle(
                      color: kBlack,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                ],
              ),
            ),
          );
        });
  }
}

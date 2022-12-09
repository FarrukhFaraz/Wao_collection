import 'dart:convert';

import 'package:wao_collection/Utils/colors.dart';
import 'package:wao_collection/Utils/urls.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class ShareCollectionScreen extends StatefulWidget {
  const ShareCollectionScreen({super.key});

  @override
  State<ShareCollectionScreen> createState() => _ShareCollectionScreenState();
}

class _ShareCollectionScreenState extends State<ShareCollectionScreen> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _whatsappController = TextEditingController();
  TextEditingController _commentController = TextEditingController();
  bool loader = false;
  var m;
  bool number = false;
  getshare() async {
    SharedPreferences _shareprefrense = await SharedPreferences.getInstance();
    m = _shareprefrense.getString('userId');
    print('m==$m');
  }

  reportProblemApi() async {
    setState(() {
      loader = true;
    });
    Map body = {
      'user_id': m.toString(),
      'user_name': _usernameController.text,
      'whatsapp': _whatsappController.text,
      'comment': _commentController.text
    };
    print(m);
    print(_usernameController);

    final response = await http.post(Uri.parse(reportProblem), body: body);
    print(response.body);
    if (response.statusCode == 200) {
      Toast.show('Your Problem  have Submited');
      setState(() {
        loader = false;
      });
    }
    setState(() {
      loader = false;
    });
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
        body: Container(
          padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.06,
            right: MediaQuery.of(context).size.width * 0.06,
            top: MediaQuery.of(context).size.height * 0.02,
          ),
          // alignment: Alignment.centerLeft,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height * 0.1,
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
                  height: MediaQuery.of(context).size.height * 0.04,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Username:",
                    style: TextStyle(
                      color: kWhite,
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    isDense: true,
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.white, width: 2.0),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                    hintText: "Your Name",
                    filled: true,
                    fillColor: kWhite,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Phone:",
                    style: TextStyle(
                      color: kWhite,
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                TextFormField(
                  onFieldSubmitted: (value) {
                    if (value.length != 11) {
                      setState(() {
                        number = true;
                      });
                    }
                  },
                  keyboardType: TextInputType.number,
                  controller: _whatsappController,
                  decoration: InputDecoration(
                    isDense: true,
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.white, width: 2.0),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                    hintText: "Phone",
                    filled: true,
                    fillColor: kWhite,
                  ),
                ),
                Text(
                  number ? "Number must be 11 digit" : "",
                  style: TextStyle(color: kWhite),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Comment:",
                    style: TextStyle(
                      color: kWhite,
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                TextFormField(
                  controller: _commentController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.white, width: 2.0),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                    hintText: "Enter your query",
                    filled: true,
                    fillColor: kWhite,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                GestureDetector(
                  onTap: () {
                    if (_usernameController.text.isEmpty) {
                      Toast.show("Please enter your name",
                          textStyle: TextStyle(color: kWhite),
                          gravity: Toast.bottom,
                          duration: Toast.lengthLong);
                    } else if (_whatsappController.text.isEmpty) {
                      Toast.show("Please enter your Phone Number",
                          textStyle: TextStyle(color: kWhite),
                          gravity: Toast.bottom,
                          duration: Toast.lengthLong);
                    } else if (_commentController.text.isEmpty) {
                      Toast.show("Please enter your Comment ",
                          textStyle: TextStyle(color: kWhite),
                          gravity: Toast.bottom,
                          duration: Toast.lengthLong);
                    } else if (_whatsappController.text.length != 11) {
                      setState(() {
                        number = true;
                      });
                    } else {
                      reportProblemApi();
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: MediaQuery.of(context).size.height * 0.06,
                    decoration: BoxDecoration(
                        color: kLightGreen,
                        borderRadius: BorderRadius.circular(16)),
                    child: loader
                        ? Center(
                            child: CircularProgressIndicator(color: kWhite),
                          )
                        : Text(
                            "Send",
                            style: TextStyle(
                              color: kWhite,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

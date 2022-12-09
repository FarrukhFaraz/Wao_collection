import 'package:wao_collection/Screens/Authentication/login_page.dart';
import 'package:wao_collection/Utils/urls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Utils/colors.dart';
import 'package:toast/toast.dart';

class RateUsScreen extends StatefulWidget {
  const RateUsScreen({super.key});

  @override
  State<RateUsScreen> createState() => _RateUsScreenState();
}

class _RateUsScreenState extends State<RateUsScreen> {
  TextEditingController _usernameController = TextEditingController();
  bool color1 = false;
  bool color2 = false;
  bool color3 = false;
  bool color4 = false;
  bool color5 = false;
  int rateus = 0;
  var m;
  getshare() async {
    SharedPreferences _shareprefrense = await SharedPreferences.getInstance();
    m = _shareprefrense.getString('userId');
    print('m==$m');
  }

  bool loader = false;

  reteusApi() async {
    setState(() {
      loader = true;
    });
    Map body = {
      'user_id': m.toString(),
      'review_text': _usernameController.text,
      'review': rateus.toString(),
    };
    print(m);
    print(_usernameController);
    print(rateus);
    final response = await http.post(Uri.parse(rateusurl), body: body);
    print(response.body);
    if (response.statusCode == 200) {
      Toast.show('You have rated us successfully');
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
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        color1 = true;
                        color2 = false;
                        color3 = false;
                        color4 = false;
                        color5 = false;
                        rateus = 1;
                      });
                      print(rateus);
                    },
                    child: Icon(
                      Icons.star,
                      color: color1 == true ? yellow800 : kWhite,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        color1 = true;
                        color2 = true;
                        color3 = false;
                        color4 = false;
                        color5 = false;
                        rateus = 2;
                      });
                      print(rateus);
                    },
                    child: Icon(
                      Icons.star,
                      color: color2 == true ? yellow800 : kWhite,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        color1 = true;
                        color2 = true;
                        color3 = true;
                        color4 = false;
                        color5 = false;
                        rateus = 3;
                      });
                      print(rateus);
                    },
                    child: Icon(
                      Icons.star,
                      color: color3 == true ? yellow800 : kWhite,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        color1 = true;
                        color2 = true;
                        color3 = true;
                        color4 = true;
                        color5 = false;
                        rateus = 4;
                      });
                      print(rateus);
                    },
                    child: Icon(
                      Icons.star,
                      color: color4 == true ? yellow800 : kWhite,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        color1 = true;
                        color2 = true;
                        color3 = true;
                        color4 = true;
                        color5 = true;
                        rateus = 5;
                      });
                      print(rateus);
                    },
                    child: Icon(
                      Icons.star,
                      color: color5 == true ? yellow800 : kWhite,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
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
                  hintText: "User Name",
                  filled: true,
                  fillColor: kWhite,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
              ),
              GestureDetector(
                onTap: () {
                  if (rateus == 0) {
                    Toast.show("Please reviws us",
                        textStyle: TextStyle(color: kWhite),
                        gravity: Toast.bottom,
                        duration: Toast.lengthLong);
                  } else if (_usernameController.text.isEmpty) {
                    Toast.show("Please enter your name",
                        textStyle: TextStyle(color: kWhite),
                        gravity: Toast.bottom,
                        duration: Toast.lengthLong);
                  } else {
                    reteusApi();
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.06,
                  decoration: BoxDecoration(
                      color: yellow800,
                      borderRadius: BorderRadius.circular(16)),
                  child: loader == true
                      ? Center(
                          child: CircularProgressIndicator(
                            color: kWhite,
                          ),
                        )
                      : Text(
                          "Submit",
                          style: TextStyle(
                            color: kBlack,
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
    );
  }
}

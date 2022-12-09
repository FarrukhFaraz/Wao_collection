import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:wao_collection/Screens/Home_Page/home_page.dart';
import 'package:wao_collection/Utils/colors.dart';
import 'package:wao_collection/Utils/urls.dart';

var userId;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _whatsappController = TextEditingController();
  bool error = false;
  bool loader = false;

  String? dropDownValue;

  registerApi() async {
    setState(() {
      loader = true;
    });
    // if (_formKey.currentState!.validate()) {
    //   setState(() {
    //     error = false;
    //   });
    //   if (_phoneController.text == _phoneController.text) {
    //     setState(() {
    //       loader = true;
    //     });
    Map body = {
      'user_name': _usernameController.text,
      'phone': _phoneController.text,
      'country': 'pakistan',
      'city_name': _cityController.text,
      'whatsapp': _whatsappController.text,
    };

    try {
      http.Response response =
          await http.post(Uri.parse(create_user), body: body);
      debugPrint(response.body);

      var jsonData = jsonDecode(response.body);

      if (jsonData['statusCode'] == 200) {
        // ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text(jsonData['message'])));
        var jsonData = jsonDecode(response.body.toString());
        debugPrint("message is  ${jsonData['message']}");
        userId = (jsonData['data']['id']);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("userId", userId.toString());
        debugPrint("userId  $userId");

        setState(() {
          loader = false;
        });
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomePageScreen()));
      } else {
        setState(() {
          loader = false;
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(jsonData['message'])));
        debugPrint(jsonData['message']);
      }
    } catch (e) {
      print(e);
      setState(() {
        loader = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      backgroundColor: kBlack,
      body: Container(
        padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.06,
          right: MediaQuery.of(context).size.width * 0.06,
          top: MediaQuery.of(context).size.height * 0.1,
        ),
        alignment: Alignment.centerLeft,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height * 0.02,
          ),
          child: Column(
            children: [
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
              Container(
                // alignment: Alignment.center,
                // height: MediaQuery.of(context).size.height * 0.062,
                child: TextFormField(
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
              SizedBox(
                // height: MediaQuery.of(context).size.height * 0.062,
                child: TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    isDense: true,
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.white, width: 2.0),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                    hintText: "030001234567",
                    filled: true,
                    fillColor: kWhite,
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),

              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  "WhatsAPP:",
                  style: TextStyle(
                    color: kWhite,
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              SizedBox(
                // height: MediaQuery.of(context).size.height * 0.062,
                child: TextFormField(
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
                    hintText: "030001234567",
                    filled: true,
                    fillColor: kWhite,
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              // SizedBox(
              //   height: MediaQuery.of(context).size.height * 0.02,
              // ),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Country:",
                  style: TextStyle(
                    color: kWhite,
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              SizedBox(
                //height: MediaQuery.of(context).size.height * 0.062,
                child: TextFormField(
                  enabled: false,
                  decoration: InputDecoration(
                    isDense: true,
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.white, width: 2.0),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                    hintText: "Pakistan",
                    hintStyle: TextStyle(color: kBlack),
                    filled: true,
                    fillColor: kWhite,
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  "City:",
                  style: TextStyle(
                    color: kWhite,
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              SizedBox(
                //height: MediaQuery.of(context).size.height * 0.062,
                child: TextFormField(
                  controller: _cityController,
                  decoration: InputDecoration(
                    isDense: true,
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.white, width: 2.0),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                    hintText: "city",
                    filled: true,
                    fillColor: kWhite,
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: kWhite,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "This application uses cookies to ensure you get best experience. By using our application you agree to our use of cookies",
                    style: TextStyle(
                      color: kBlack,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.032,
              ),
              GestureDetector(
                onTap: () {
                  if (_usernameController.text.isEmpty) {
                    Toast.show("Please enter your name",
                        textStyle: TextStyle(color: kWhite),
                        gravity: Toast.bottom,
                        duration: Toast.lengthLong);
                  } else if (_phoneController.text.isEmpty) {
                    Toast.show("Please enter your Phone Number",
                        textStyle: TextStyle(color: kWhite),
                        gravity: Toast.bottom,
                        duration: Toast.lengthLong);
                  } else if (_cityController.text.isEmpty) {
                    Toast.show("Please enter your City Name ",
                        textStyle: TextStyle(color: kWhite),
                        gravity: Toast.bottom,
                        duration: Toast.lengthLong);
                  } else {
                    if (_phoneController.text.trim().length != 11) {
                      Toast.show("Phone Number must be 11 digits ",
                          textStyle: TextStyle(color: kWhite),
                          gravity: Toast.bottom,
                          duration: Toast.lengthLong);
                    } else if (_whatsappController.text.trim().length != 11) {
                      Toast.show("WhatsApp Number must be 11 digits ",
                          textStyle: TextStyle(color: kWhite),
                          gravity: Toast.bottom,
                          duration: Toast.lengthLong);
                    } else {
                      registerApi();
                    }
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height * 0.01),
                  //height: MediaQuery.of(context).size.height * 0.06,
                  decoration: BoxDecoration(
                      color: yellow800,
                      borderRadius: BorderRadius.circular(16)),
                  child: loader
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : Text(
                          "Accept",
                          style: TextStyle(
                            color: kBlack,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

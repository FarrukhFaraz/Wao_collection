import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wao_collection/Screens/Authentication/login_page.dart';
import 'package:wao_collection/Screens/Home_Page/home_page.dart';
import 'package:wao_collection/Utils/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  splash() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var m = sharedPreferences.getString("userId");

    Timer(Duration(milliseconds: 1600), (() {
      // Navigator.pushReplacement(
      //     context, MaterialPageRoute(builder: ((context) => HomePageScreen())));
      if (m == null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: ((context) => LoginScreen())));
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: ((context) => HomePageScreen())));
      }
    }));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    splash();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlack,
      body: Center(
        child: RichText(
            text: TextSpan(
                text: "WAO     ",
                style: TextStyle(color: kWhite, fontSize: 26),
                children: [
              TextSpan(
                  text: "Collection",
                  style: TextStyle(
                    color: yellow800,
                    fontSize: 16,
                  ))
            ])),
      ),
    );
  }
}

import 'dart:convert';

import 'package:wao_collection/Screens/Authentication/login_page.dart';
import 'package:wao_collection/Utils/colors.dart';
import 'package:wao_collection/Utils/urls.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _completeaddreController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _whatsappController = TextEditingController();
  var m;
  var name;
  var city_name;
  var phone;
  var address;
  var whatsapp;
  bool number = false;
  bool loader = false;
  bool loader2 = true;

  getshare() async {
    SharedPreferences _shareprefrense = await SharedPreferences.getInstance();
    m = _shareprefrense.getString('userId');
    print('m==$m');
    showprofileApi(m.toString());
  }

  profileApi() async {
    setState(() {
      loader = true;
    });
    print("mmmmm===" + m);
    Map body = {
      'id': m.toString(),
      'user_name':
          _usernameController.text.isEmpty ? name : _usernameController.text,
      'address': _completeaddreController.text.isEmpty
          ? address == null
              ? "adress"
              : address
          : _completeaddreController.text,
      'phone': _phoneController.text.isEmpty ? phone : _phoneController.text,
      'city_name':
          _cityController.text.isEmpty ? city_name : _cityController.text,
      'whatsapp':
          _whatsappController.text.isEmpty ? whatsapp : _whatsappController.text
    };
    print(m);
    print(_usernameController);

    final response = await http.post(Uri.parse(updateprofile), body: body);
    print(response.body);
    if (response.statusCode == 200) {
      Toast.show('Your Profile  has Updated');
      setState(() {
        loader = false;
      });
    }
    setState(() {
      loader = false;
    });
  }

  showprofileApi(var m) async {
    http.Response response = await http.get(
      Uri.parse(
        viewprofile + '?id=' + m.toString(),
      ),
    );
    print("rewrlk;lm===" + response.body.toString());
    print("m2===" + m);
    Map jsonData = jsonDecode(response.body);
    print(response.body);
    print(jsonData);
    if (response.statusCode == 200) {
      setState(() {
        name = jsonData['data']['name'];
        city_name = jsonData['data']['city_name'];
        phone = jsonData['data']['phone'];
        address = jsonData['data']['address'];
        whatsapp = jsonData['data']['whatsapp'];
        loader2 = false;
      });
    } else {
      setState(() {
        loader = false;
        loader2 = false;
      });

      print(jsonData['message']);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(jsonData['message'])));
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
        body: loader2
            ? Center(
                child: CircularProgressIndicator(
                  color: kWhite,
                ),
              )
            : Container(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.06,
                  right: MediaQuery.of(context).size.width * 0.06,
                  // bottom: MediaQuery.of(context).size.height * 0.14,
                ),
                // alignment: Alignment.centerLeft,
                child: SingleChildScrollView(
                  // padding: EdgeInsets.only(
                  //   bottom: MediaQuery.of(context).size.height * 0.02,
                  // ),
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
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          isDense: true,
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.white, width: 2.0),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)),
                          hintText: name ?? "name",
                          hintStyle: TextStyle(
                            color: kBlack,
                          ),
                          filled: true,
                          fillColor: kWhite,
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
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
                        controller: _phoneController,
                        decoration: InputDecoration(
                          isDense: true,
                          // errorStyle: TextStyle(color: kWhite),
                          // errorText: number ? "Number must be 11 digit" : "",
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.white, width: 2.0),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)),
                          hintText: phone ?? "phone",
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
                      TextFormField(
                        onFieldSubmitted: (value) {
                          if (value.length != 11) {
                            setState(() {
                              number = true;
                            });
                          }
                        },
                        controller: _whatsappController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          isDense: true,
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.white, width: 2.0),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)),
                          hintText: whatsapp,
                          filled: true,
                          fillColor: kWhite,
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      Text(
                        number ? "Number must be 11 digit" : "",
                        style: TextStyle(color: kWhite),
                      ),
                      TextFormField(
                        controller: _completeaddreController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.white, width: 2.0),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)),
                          hintText: address ?? "address",
                          filled: true,
                          fillColor: kWhite,
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          isDense: true,
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.white, width: 2.0),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)),
                          hintText: city_name ?? "city_name",
                          filled: true,
                          fillColor: kWhite,
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (_phoneController.text.length != 11) {
                            setState(() {
                              number = true;
                            });
                          } else {
                            profileApi();
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.06,
                          decoration: BoxDecoration(
                              color: yellow800,
                              borderRadius: BorderRadius.circular(16)),
                          child: loader
                              ? Center(
                                  child: CircularProgressIndicator(
                                    color: kWhite,
                                  ),
                                )
                              : Text(
                                  "Save",
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
      ),
    );
  }
}

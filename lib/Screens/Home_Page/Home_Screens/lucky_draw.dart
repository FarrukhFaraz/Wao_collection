import 'package:flutter/services.dart';
import 'package:wao_collection/Utils/colors.dart';
import 'package:wao_collection/Utils/urls.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

class LuckyDrawScreen extends StatefulWidget {
  const LuckyDrawScreen({super.key});

  @override
  State<LuckyDrawScreen> createState() => _LuckyDrawScreenState();
}

class _LuckyDrawScreenState extends State<LuckyDrawScreen> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _facebookController = TextEditingController();
  TextEditingController _whtsappController = TextEditingController();

  var m;
  getshare() async {
    SharedPreferences _shareprefrense = await SharedPreferences.getInstance();
    m = _shareprefrense.getString('userId');
    print('m==$m');
  }

  bool loader = false;
  bool number = false;

  lucjyDrawApi() async {
    setState(() {
      loader = true;
    });
    Map body = {
      'user_id': m.toString(),
      'user_name': _usernameController.text,
      'facebook_name': _facebookController.text,
      'whatsapp': _whtsappController.text
    };
    print(m);
    print(_usernameController);

    final response = await http.post(Uri.parse(luckydrweurl), body: body);
    print(response.body);
    if (response.statusCode == 200) {
      Toast.show('Your Lucky draw have Submited');
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
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height * 0.02,
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
                Container(
                  child: Text(
                    "Note: This lucky draw is only for our post shares. Show our Facebook post in groups and add your details here. We will choose winner in draw during any live session",
                    style: TextStyle(
                      color: kWhite,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
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
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                TextFormField(
                  controller: _facebookController,
                  decoration: InputDecoration(
                    isDense: true,
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.white, width: 2.0),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                    hintText: "Facebook Name",
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
                  controller: _whtsappController,
                  decoration: InputDecoration(
                    isDense: true,
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.white, width: 2.0),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                    hintText: "Whatsapp Number",
                    filled: true,
                    fillColor: kWhite,
                  ),
                ),
                Text(
                  number ? "Number must be 11 digit" : "",
                  style: TextStyle(color: kWhite),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
                GestureDetector(
                    onTap: () {
                      if (_usernameController.text.isEmpty) {
                        Toast.show("Please enter your name",
                            textStyle: TextStyle(color: kWhite),
                            gravity: Toast.bottom,
                            duration: Toast.lengthLong);
                      } else if (_facebookController.text.isEmpty) {
                        Toast.show("Please enter your Facebook name",
                            textStyle: TextStyle(color: kWhite),
                            gravity: Toast.bottom,
                            duration: Toast.lengthLong);
                      } else if (_whtsappController.text.isEmpty) {
                        Toast.show("Please enter your WhatsApp Number",
                            textStyle: TextStyle(color: kWhite),
                            gravity: Toast.bottom,
                            duration: Toast.lengthLong);
                      } else if (_whtsappController.text.length != 11) {
                        setState(() {
                          number = true;
                        });
                      } else {
                        lucjyDrawApi();
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.06,
                      decoration: BoxDecoration(
                          color: yellow800,
                          borderRadius: BorderRadius.circular(16)),
                      child: Text(
                        "Submit",
                        style: TextStyle(
                          color: kBlack,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )),
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

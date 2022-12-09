import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'package:wao_collection/Models/order_detail_model.dart';
import 'package:wao_collection/Utils/colors.dart';
import 'package:wao_collection/Utils/urls.dart';

class OrderDetailScreen extends StatefulWidget {
  final String id;

  const OrderDetailScreen({super.key, required this.id});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  TextEditingController _noteController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addresseController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  var status;
  var grandTotal;
  var year;
  var month;
  var day;
  var minutes = 0;
  var imageorder;
  bool loader = true;
  var checkStatus;
  List<Orderitems> _orderitems = [];
  List<Notes> notes = <Notes>[];

  // DateTime newdate = DateTime.now();
  // String h = DateFormat('hh').format(DateTime.now());
  // String m = DateFormat('mm').format(DateTime.now());
  // String s = DateFormat('ss').format(DateTime.now());
  // final inputformate = DateFormat('yyyy-mm-dd hh:mm');
  // var inputdate = inputformate.parse('23:59');

  odrderdetailApi() async {
    print('idddddddddddd ${widget.id}');
    final response =
        await http.get(Uri.parse(orderdetailurl + '?order_id=' + widget.id));
    var jsonData = jsonDecode(response.body);
    print("orderdetai=====" + response.body);
    if (response.statusCode == 200) {
      grandTotal = jsonData['data']['grandTotal'];
      status = jsonData['data']['status'];
      month = jsonData['month'];
      year = jsonData['year'];
      day = jsonData['day'];
      checkStatus = jsonData['data']['status'];
      minutes = jsonData['minutes'];
      imageorder = jsonData['data']['slip'];
      for (int i = 0; i < jsonData['data']['orderitems'].length; i++) {
        Map<String, dynamic> object = jsonData['data']['orderitems'][i];
        Orderitems _test = Orderitems();
        _test = Orderitems.fromJson(object);

        _orderitems.add(_test);
      }
      for (int i = 0; i < jsonData['data']['notes'].length; i++) {
        Map<String, dynamic> object = jsonData['data']['notes'][i];
        Notes _test = Notes();
        _test = Notes.fromJson(object);

        notes.add(_test);
      }
      setState(() {
        loader = false;
      });
    }
  }

  sendNotesApi() async {
    Map body = {
      'order_id': widget.id.toString(),
      'note': _noteController.text,
    };
    final response = await http.post(
      Uri.parse(notesurl + '?order_id=' + widget.id),
      body: body,
    );
    print(response.body);
    if (response.statusCode == 200) {
      Toast.show('Your Note have Submited');
      setState(() {
        loader = false;
      });
    }
    setState(() {
      loader = false;
    });
  }

  updateOrderApi() async {
    Map body = {
      'order_id': widget.id.toString(),
      'name': nameController.text,
      'country': addresseController.text,
      'city': cityController.text,
      'phone': phoneController.text,
    };
    setState(() {
      loader = true;
    });
    final response = await http.post(Uri.parse(updateorderurl), body: body);
    var jsonData = jsonDecode(response.body);
    print("updatreee===" + jsonData.toString());
    if (jsonData['statusCode'] == 200) {
      Toast.show(
        "Updated Succesfully",
        textStyle: TextStyle(color: kWhite),
        gravity: Toast.bottom,
        duration: Toast.lengthLong,
      );
      setState(() {
        loader = false;
      });
    } else {
      setState(() {
        loader = false;
      });
      Toast.show("Something Went Wrong",
          gravity: Toast.bottom, duration: Toast.lengthLong);
    }
  }

  cancelApi() async {
    setState(() {
      loader = true;
    });
    Map body = {
      'order_id': widget.id.toString(),
    };
    try {
      final response = await http.post(Uri.parse(cancelorderurl), body: body);
      var jsonData = jsonDecode(response.body);
      print("canbce===" + jsonData.toString());
      if (jsonData['statusCode'] == 200) {
        setState(() {
          loader = false;
        });
        Toast.show(
          "Cancel Succesfully",
          textStyle: TextStyle(color: kWhite),
          gravity: Toast.bottom,
          duration: Toast.lengthLong,
        );
      } else {
        setState(() {
          loader = false;
        });
        Toast.show(
          "Something went wrong",
          textStyle: TextStyle(color: kWhite),
          gravity: Toast.bottom,
          duration: Toast.lengthLong,
        );
      }
    } catch (e) {
      print(e.toString());
      setState(() {
        loader = false;
      });
      Toast.show(
        "Something went wrong",
        textStyle: TextStyle(color: kWhite),
        gravity: Toast.bottom,
        duration: Toast.lengthLong,
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    odrderdetailApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    print(" mlkjbkjb" + minutes.toString());
    return SafeArea(
      child: Scaffold(
        backgroundColor: kBlack,
        body: loader
            ? Center(
                child: CircularProgressIndicator(color: kWhite),
              )
            : Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.02,
                  left: MediaQuery.of(context).size.width * 0.04,
                  right: MediaQuery.of(context).size.width * 0.04,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: kWhite,
                            ),
                          ),
                          Text(
                            grandTotal.toString(),
                            style: TextStyle(
                              color: yellow800,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Order Details",
                          style: TextStyle(
                            color: kWhite,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      RichText(
                        text: TextSpan(
                          text: "Status: ",
                          style: TextStyle(
                            color: kWhite,
                            fontSize: 18,
                          ),
                          children: [
                            TextSpan(
                                text: status.toString(),
                                style: TextStyle(
                                  color: yellow800,
                                ))
                          ],
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.1,
                        decoration: BoxDecoration(
                          color: yellow800,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  day.toString(),
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  month.toString(),
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.01,
                            ),
                            Text(
                              year.toString(),
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: RichText(
                          text: TextSpan(
                            text: "Notes:  ",
                            children: [
                              TextSpan(
                                text: status.toString(),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      orderdetails(),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Delivery Charges",
                            style: TextStyle(color: kWhite),
                          ),
                          Text(
                            "250",
                            style: TextStyle(color: kWhite),
                          )
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Adjusment",
                            style: TextStyle(color: kWhite),
                          ),
                          Text(
                            "0",
                            style: TextStyle(color: kWhite),
                          )
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Total",
                              style: TextStyle(color: kWhite),
                            ),
                            Text(
                              "101,150",
                              style: TextStyle(
                                color: yellow800,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.04,
                      ),
                      notesWidget(),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.04,
                      ),
                      TextFormField(
                        controller: _noteController,
                        decoration: InputDecoration(
                            isDense: true,
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 2.0),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20)),
                            fillColor: kWhite,
                            filled: true,
                            hintText: "Enter your note here"),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              sendNotesApi();
                              setState(() {
                                Notes n = Notes();
                                n.note = _noteController.text;
                                notes.add(n);
                              });
                            },
                            child: loader
                                ? Center(
                                    child: CircularProgressIndicator(
                                      color: kBlack,
                                    ),
                                  )
                                : Container(
                                    alignment: Alignment.center,
                                    height: MediaQuery.of(context).size.height *
                                        0.06,
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    decoration: BoxDecoration(
                                        color: yellow800,
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: Text(
                                      "Send Notes",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.04,
                      ),
                      loader
                          ? Center(
                              child: CircularProgressIndicator(
                                color: kWhite,
                              ),
                            )
                          : checkStatus !="DISPATCHED"
                              ? update()
                              :SizedBox(),

                      imageorder==null?SizedBox():
                      Image.network('$imageorder'),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget orderdetails() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _orderitems.length,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.02,
          ),
          child: Column(
            children: [
              Row(children: [
                Expanded(
                  child: Text(
                    _orderitems[index].product == null
                        ? ""
                        : _orderitems[index].product!.name.toString(),
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
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "X" + "${_orderitems[index].qty}",
                        style: TextStyle(
                          color: yellow800,
                        ),
                      ),
                      Text(
                        _orderitems[index].price.toString(),
                        style: TextStyle(
                          color: kWhite,
                          fontSize: 30,
                        ),
                      )
                    ],
                  ),
                ),
              ]),
            ],
          ),
        );
      },
    );
  }

  Widget notesWidget() {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: notes.length,
      itemBuilder: (context, index) {
        print("notes==" + notes.length.toString());
        return Container(
          margin: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.02,
          ),
          alignment: Alignment.centerLeft,
          child: RichText(
            text: TextSpan(
              text: "Your Msg =>       ",
              style: TextStyle(
                color: kLightGreen,
                fontSize: 16,
              ),
              children: [
                TextSpan(
                    text: notes[index].note.toString(),
                    style: TextStyle(
                      color: kWhite,
                      fontSize: 18,
                    )),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget update() {
    return Column(
      children: [
        TextFormField(
          controller: nameController,
          decoration: InputDecoration(
              isDense: true,
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white, width: 2.0),
                borderRadius: BorderRadius.circular(20.0),
              ),
              enabledBorder:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              fillColor: kWhite,
              filled: true,
              hintText: "Enter your Name"),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
        ),
        TextFormField(
          keyboardType: TextInputType.number,
          controller: phoneController,
          decoration: InputDecoration(
              isDense: true,
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white, width: 2.0),
                borderRadius: BorderRadius.circular(20.0),
              ),
              enabledBorder:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              fillColor: kWhite,
              filled: true,
              hintText: "Phone Number"),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
        ),
        TextFormField(
          controller: addresseController,
          decoration: InputDecoration(
              isDense: true,
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white, width: 2.0),
                borderRadius: BorderRadius.circular(20.0),
              ),
              enabledBorder:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              fillColor: kWhite,
              filled: true,
              hintText: "Address"),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
        ),
        TextFormField(
          controller: cityController,
          decoration: InputDecoration(
              isDense: true,
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white, width: 2.0),
                borderRadius: BorderRadius.circular(20.0),
              ),
              enabledBorder:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              fillColor: kWhite,
              filled: true,
              hintText: "Enter your City"),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
        ),
        GestureDetector(
          onTap: () {
            updateOrderApi();
          },
          child: loader
              ? Center(
                  child: CircularProgressIndicator(
                    color: kBlack,
                  ),
                )
              : Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height * 0.06,
                  width: MediaQuery.of(context).size.width * 0.4,
                  decoration: BoxDecoration(
                      color: yellow800,
                      borderRadius: BorderRadius.circular(12)),
                  child: Text(
                    "Update",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
        ),
        GestureDetector(
          onTap: () {
            cancelApi();
          },
          child: loader
              ? Center(
                  child: CircularProgressIndicator(
                    color: kBlack,
                  ),
                )
              : Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height * 0.06,
                  width: MediaQuery.of(context).size.width * 0.4,
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12)),
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
        )
      ],
    );
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wao_collection/Cart_Screens/cart_model.dart';
import 'package:wao_collection/Cart_Screens/cart_model_list.dart';
import 'package:wao_collection/Cart_Screens/show_cart_model.dart';
import 'package:wao_collection/Utils/colors.dart';
import 'package:wao_collection/Utils/urls.dart';

class PlaceOrderScreen extends StatefulWidget {
 final List<CartModel> cartList;

  PlaceOrderScreen({super.key, required this.cartList});

  @override
  State<PlaceOrderScreen> createState() => _PlaceOrderScreenState();
}

class _PlaceOrderScreenState extends State<PlaceOrderScreen> {

  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  TextEditingController _noteController = TextEditingController();
  bool loader = true;
  var charges;
  var name;
  var city_name;
  var phone;
  var address;
  var country;
  var total;
  int? sum;
  int discountAmount = 10;
  double totalAmount = 0.0;
  double grandTotal = 0.0;
  List<String> productIds = [];
  List<ItemsModel> _showCart = [];
  int? jsonId;
  bool btnLoader=false;
  var id;

  loadData(){
    setState(() {
      _nameController.text=name.toString();
      _phoneController.text=phone.toString();
      _cityController.text=city_name.toString();
      _addressController.text=address.toString();
    });
  }
  getShare() async {
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    id = sharedPreference.getString('userId');
    print('m==$id');
    showCartApi(id.toString());
  }

  showCartApi(var m) async {
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    m = sharedPreference.getString('userId');
    print("m2222222=====" + m);
    print(showcarturl + '?user_id=' + m);
    try{http.Response response = await http.get(
      Uri.parse(showcarturl + '?user_id=' + m),
    );
    var jsonData = jsonDecode(response.body);
    print("arrivals" + response.body);
    if (jsonData['statusCode'] == 200) {
      name = jsonData['data']['user_det']['name'];
      phone = jsonData['data']['user_det']['phone'];
      city_name = jsonData['data']['user_det']['city_name'];
      country= jsonData['data']['user_det']['country'];
      address = jsonData['data']['user_det']['address'];
      charges = jsonData['data']['charges'];
      total = jsonData['data']['grandTotal'];
      for (int i = 0; i < jsonData["data"]["items"].length; i++) {
        Map<String, dynamic> object = jsonData["data"]["items"][i];
        ItemsModel _test = ItemsModel();
        _test = ItemsModel.fromJson(object);
        _showCart.add(_test);
      }
      setState(() {
        loader = false;
      });
    }
    setState(() {
      loader = false;
    });
    }catch(e){
      print(e);
    }
    loadData();
  }


  placeOrderApi()async{
    setState(() {
      btnLoader=true;
    });
    try{

      print(id);
      Map body = {
        'user_id': id,
        'charges':charges.toString(),
        'address':_addressController.text,
        'city': _cityController.text,
        'country': country.toString(),
        'phone': _phoneController.text,
        'name':_nameController.text,
        'note': _noteController.text
      };

      http.Response response = await http.post(Uri.parse(orderplaceurl), body: body);
      print("jsondatadddd"+response.body);
      Map jsonData = jsonDecode(response.body);
      if (jsonData['statusCode']== 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Order placed successfully')));
      }else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Something went wrong!')));
      }

    }catch(e){
      print('error');
      print(e);
    }
    setState(() {
      btnLoader=false;
    });
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();

    getShare();
    print("cartList===" + widget.cartList.toString());


  }

  double perItemTotal(double p, double q) {
    double cal = p * q;
    return cal;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kBlack,
        body: loader
            ? Center(
                child: CircularProgressIndicator(color: kWhite),
              )
            : widget.cartList.length < 1
                ? Center(
                    child: Text(
                      'No data found In Cart...',
                      style: TextStyle(fontWeight: FontWeight.bold , color: kWhite),
                    ),
                  )
                : Container(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.032,
                      left: MediaQuery.of(context).size.width * 0.06,
                      right: MediaQuery.of(context).size.width * 0.06,
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
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Delivery Details",
                              style: TextStyle(
                                color: kWhite,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
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
                            controller: _nameController,
                            decoration: InputDecoration(
                              isDense: true,
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.white, width: 2.0),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              hintText: name,
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
                            controller: _phoneController,
                            decoration: InputDecoration(
                              isDense: true,
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.white, width: 2.0),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              hintText: phone,
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
                              "Country:",
                              style: TextStyle(
                                color: kWhite,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.062,
                            decoration: BoxDecoration(
                              color: kWhite,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Pakistan"),
                                ),
                              ],
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
                          TextFormField(
                            controller: _cityController,
                            decoration: InputDecoration(
                              isDense: true,
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.white, width: 2.0),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              hintText: city_name,
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
                              "Address:",
                              style: TextStyle(
                                color: kWhite,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                          TextFormField(
                            controller: _addressController,
                            maxLines: 5,
                            decoration: InputDecoration(
                              isDense: true,
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.white, width: 2.0),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              hintText: address,
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
                              "Notes (Optional):",
                              style: TextStyle(
                                color: kWhite,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                          TextFormField(
                            maxLines: 5,
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
                              hintText: "Enter here",
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
                              "Cart",
                              style: TextStyle(
                                color: kWhite,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          Container(
                            child: orderDetail(),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Delivery Charges",
                                style: TextStyle(
                                  color: kWhite,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'RS ${charges}',
                                style: TextStyle(
                                  color: kWhite,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  "Current Order Total",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: kWhite,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Text(
                                "RS ${total}",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: yellow800,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.01,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          GestureDetector(
                            onTap: () {
                              placeOrderApi();
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.08,
                              decoration: BoxDecoration(
                                  color: yellow800,
                                  borderRadius: BorderRadius.circular(16)),
                              child: btnLoader
                                  ? Center(
                                      child: CircularProgressIndicator(
                                          color: kBlack),
                                    )
                                  : Text(
                                      "Confirm Order",
                                      style: TextStyle(
                                        color: kBlack,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }

  Widget orderDetail() {
    return Container(
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: widget.cartList.length,
        itemBuilder: (context, index) {
          return Container(
            // height: 200,

            child: Column(
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          widget.cartList.remove(widget.cartList[index]);
                        });
                      },
                      child: Icon(
                        Icons.cancel,
                        color: kLightRed,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.02,
                    ),
                    Text(
                      widget.cartList[index].productName,
                      style: TextStyle(
                        color: kWhite,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(child: Text('')),
                    Text(
                      "X" + '${widget.cartList[index].itemCount}   ',
                      style: TextStyle(
                        color: yellow800,
                      ),
                    ),
                    Text(
                      '${(double.parse(widget.cartList[index].productPrice))*(double.parse(widget.cartList[index].itemCount.toString()))}',
                      style: TextStyle(
                        color: kWhite,
                        fontSize: 30,
                      ),
                    )
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

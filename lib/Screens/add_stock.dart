import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:inventory_system/home.dart';
import '../constants.dart';

class AddStock extends StatefulWidget {
  const AddStock({Key? key}) : super(key: key);

  @override
  State<AddStock> createState() => _AddStockState();
}

class _AddStockState extends State<AddStock> {
  TextEditingController id = TextEditingController();
  TextEditingController itemName = TextEditingController();
  TextEditingController pricePerUnit = TextEditingController();
  TextEditingController totalItems = TextEditingController();

  int pp = 0;
  int items = 0;
  String name = '';
  String uid = '';
  String date = DateFormat('dd-MM-yyyy').format(DateTime.now());
  String error = '';

  bool load = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(15, 0, 0, 10),
          decoration: BoxDecoration(color: Colors.blue.withOpacity(0.15)),
          width: size.width * 0.85,
          height: size.height * 0.2,
          alignment: Alignment.bottomLeft,
          child: Text(
            'Add New Stock',
            style: TextStyle(fontWeight: bold, fontSize: size.width * 0.02),
          ),
        ),
        Form(
          child: SizedBox(
            width: size.width * 0.6,
            height: size.height * 0.7,
            child: Padding(
              padding: EdgeInsets.all(size.width * 0.05),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    date,
                    style: TextStyle(fontSize: fsize20),
                  ),
                  SizedBox(
                    // width: size.width * 0.4,
                    child: TextFormField(
                      controller: id,
                      decoration: InputDecoration(
                        label: Text(
                          'ID of Item',
                          style: TextStyle(color: black),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: darkgrey,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: darkgrey,
                            width: 2.0,
                          ),
                        ),
                      ),
                      onChanged: (val) {
                        setState(() {
                          uid = id.text;
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    // width: size.width * 0.5,
                    child: TextFormField(
                      controller: itemName,
                      decoration: InputDecoration(
                        label: Text(
                          'Name of Item',
                          style: TextStyle(color: black),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: darkgrey,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: darkgrey,
                            width: 2.0,
                          ),
                        ),
                      ),
                      onChanged: (val) {
                        setState(() {
                          name = itemName.text;
                        });
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: size.width * 0.23,
                        child: TextFormField(
                          controller: totalItems,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                            label: Text(
                              'No. of Items',
                              style: TextStyle(color: black),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: darkgrey,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: darkgrey,
                                width: 2.0,
                              ),
                            ),
                          ),
                          onChanged: (val) {
                            setState(() {
                              items = int.parse(val.trim());
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        width: size.width * 0.26,
                        child: TextFormField(
                          controller: pricePerUnit,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                            label: Text(
                              'Price per peice',
                              style: TextStyle(color: black),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: darkgrey,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: darkgrey,
                                width: 2.0,
                              ),
                            ),
                          ),
                          onChanged: (val) {
                            setState(() {
                              pp = int.parse(val.trim());
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: size.width * 0.8,
                    child: Text('Total Price: Rs. ${pp * items}',
                        style: TextStyle(fontSize: fsize20),
                        textAlign: TextAlign.end),
                  ),
                  SizedBox(
                    width: size.width * 0.8,
                    child: Text(error,
                        style: TextStyle(color: Colors.red, fontWeight: bold),
                        textAlign: TextAlign.center),
                  ),
                  SizedBox(
                    width: size.width * 0.8,
                    height: size.height * 0.05,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (name != '' && uid != '' && pp != 0 && items != 0) {
                          setState(() {
                            load = true;
                          });
                          ref
                              .add({
                            'id': uid,
                            'name': name,
                            'pricePerPiece': pp,
                            'totalItems': items,
                            'price': pp * items,
                            'date': date,
                          }).then((value) {
                            setState(() {
                              load = false;
                              index = 0;
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const HomeScreen(cname: '', cr: 0, id: '')));
                            });
                          });
                          setState(() {
                            error = '';
                          });
                        } else {
                          setState(() {
                            error = 'Please fill all details carefully!';
                          });
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          load
                              ? SpinKitWave(
                                  size: size.height * 0.035,
                                  color: white,
                                )
                              : const Text("Enter"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

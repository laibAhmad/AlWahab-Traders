import 'package:firedart/firestore/firestore.dart';
import 'package:firedart/firestore/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import '../constants.dart';
import '../home.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({Key? key}) : super(key: key);

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  CollectionReference pos = Firestore.instance
      .collection("AWT")
      .document('inventory')
      .collection('POS');

  TextEditingController expenseName = TextEditingController();
  TextEditingController price = TextEditingController();

  String expense = '';
  int spend = 0;

  int pp = 0;
  int items = 0;
  String name = '';
  String uid = '';
  String date = DateFormat('dd-MM-yyyy').format(DateTime.now());
  String error = '';

  bool load = false;

  String search = 'Cash';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(15, 0, 0, 10),
          decoration: BoxDecoration(color: Colors.pink.withOpacity(0.15)),
          width: size.width * 0.85,
          height: size.height * 0.22,
          alignment: Alignment.bottomLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your Expense                   $date',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: size.width * 0.7,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: size.width * 0.23,
                      child: TextFormField(
                        controller: expenseName,
                        decoration: InputDecoration(
                          label: Text(
                            'Expense...',
                            style: TextStyle(color: black),
                          ),
                        ),
                        onChanged: (val) {
                          setState(() {
                            expense = val;
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.2,
                      child: TextFormField(
                        controller: price,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                          label: Text(
                            'Rs. Spent',
                            style: TextStyle(color: black),
                          ),
                        ),
                        onChanged: (val) {
                          setState(() {
                            spend = int.parse(val.trim());
                          });
                        },
                      ),
                    ),
                    Row(
                      children: [
                        const Text('Spent From:   ',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold)),
                        DropdownButton<String>(
                          value: search,
                          icon: const Icon(Icons.keyboard_arrow_down_rounded),
                          elevation: 16,
                          style: TextStyle(color: black),
                          underline: Container(
                            height: 2,
                            color: black,
                          ),
                          onChanged: (String? newValue) {
                            setState(() {
                              search = newValue!;
                            });
                          },
                          items: <String>[
                            'Cash',
                            'Bank',
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: size.width * 0.07,
                      height: size.height * 0.05,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (expense != '' && spend != 0) {
                            setState(() {
                              load = true;
                            });
                            Firestore.instance
                                .collection("AWT")
                                .document('inventory')
                                .collection('expenses')
                                .add({
                              'expense': expense,
                              'date': date,
                              'spent': spend,
                              'spentFrom': search,
                            }).then((value) {
                              if (search == 'Cash') {
                                
                                pos
                                    .document('Cash Rs')
                                    .set({'cash': (cashRs - spend)});
                              } else {
                                pos
                                    .document('Bank Rs')
                                    .set({'bank': (bankRs - spend)});
                              }
                              setState(() {
                                load = false;
                                index = 6;
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const HomeScreen()));
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
                                    size: size.height * 0.02, color: white)
                                : const Text("Save"),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Text(error),
            ],
          ),
        ),
        SizedBox(
          width: size.width * 0.84,
          // height: size.height * 0.65,
          child: Padding(
            padding: EdgeInsets.all(size.width * 0.01),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Your Expenses'),
                Container(height: size.height * 0.6, color: Colors.red),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

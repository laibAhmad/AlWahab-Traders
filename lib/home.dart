import 'package:flutter/material.dart';
import 'package:inventory_system/Screens/add_stock.dart';
import 'package:inventory_system/Screens/customer_details.dart';
import 'package:inventory_system/Screens/monthly_repo.dart';

import 'package:inventory_system/Screens/return.dart';
import 'package:inventory_system/Screens/stock.dart';
import 'package:inventory_system/Screens/cash_receive.dart';

import 'Models/data.dart';
import 'Screens/customer.dart';
import 'Screens/dashboard.dart';
import 'Screens/expenses.dart';
import 'Screens/invoice.dart';
import 'Screens/new_sale.dart';
import 'Screens/china_payment.dart';
import 'constants.dart';

class HomeScreen extends StatefulWidget {
  final String cname, id;
  final int cr;

  const HomeScreen(
      {Key? key, required this.cname, required this.id, required this.cr})
      : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<InStockData> itemsList = [];

  @override
  void initState() {
    getData();
    // getAlertItems();

    super.initState();
  }

  Future<List<InStockData>> getData() async {
    indexList = indexList - 1;
    await ref.get().asStream().forEach((element) {
      itemsList1.clear();
      for (var element in element) {
        InStockData list = InStockData(
            uid: element['id'],
            date: element['date'],
            name: element['name'],
            total: element['price'],
            pp: element['pricePerPiece'],
            items: element['totalItems'],
            index: indexList + 1,
            id: element.id);

        indexList = indexList + 1;
        itemsList.add(list);
        itemsList1.add(list);
        getSortList();
        setState(() {});
      }
    });
    return itemsList;
  }

  bool n = false;

  getSortList() {
    itemsList1.sort((a, b) {
      return a.name
          .toString()
          .toLowerCase()
          .compareTo(b.name.toString().toLowerCase());
    });
  }

  bool getAlertItems() {
    for (int i = 0; i < itemsList.length; i++) {
      if (itemsList[i].total > 30) {
        setState(() {
          n = true;
        });
        break;
        
      }
      break;
    }

    return n;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final List<Widget> pages = [
      const Dashboard(),
      const NewSale(),
      const InvoiceScreen(),
      const AddStock(),
      const InStock(),
      const Return(),
      const ExpensesScreen(),
      const CustomerScreen(),
      CustomerDetails(cname: widget.cname, cr: widget.cr, id: widget.id),
      const ChinaPayment(),
      const MonthlyRepo(),
      const CashReceive(),
      
    ];

    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/img/logo.png',
          width: 60,
        ),
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () async {
                setState(() {
                  index = 10;
                });
              },
              icon: const Icon(Icons.date_range)),
          // n
          //     ? IconButton(
          //         onPressed: () async {
          //           setState(() {
          //             index = 10;
          //           });
          //         },
          //         icon: Icon(Icons.add_alert, color: red))
          //     : Container(),
          // IconButton(
          //     onPressed: () async {
          //       setState(() {
          //         index = 0;
          //       });

          //       SharedPreferences prefs = await SharedPreferences.getInstance();
          //       prefs.setString("user", '');

          //       // ignore: use_build_context_synchronously
          //       Navigator.pushAndRemoveUntil(
          //           context,
          //           MaterialPageRoute(
          //               builder: (context) => const LoginScreen()),
          //           (route) => false);
          //     },
          //     icon: const Icon(Icons.logout_rounded)),
          const SizedBox(width: 10),
        ],
      ),
      body: Row(
        children: [
          Container(
            color: grey,
            width: size.width * 0.15,
            height: size.height,
            child: Column(
              children: [
                const SizedBox(height: 20),
                SizedBox(
                  height: size.height * 0.5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            index = 0;
                          });
                        },
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: index == 0
                                ? Colors.red.withOpacity(0.2)
                                : Colors.transparent,
                            border: Border(
                              right: BorderSide(
                                  width: 5.0,
                                  color: index == 0
                                      ? Colors.red
                                      : Colors.transparent),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                right: 8, left: 16, top: 8, bottom: 8),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Dashboard',
                                  style: TextStyle(
                                    color: index == 0
                                        ? Colors.red.shade700
                                        : black,
                                    fontSize: size.width * 0.01,
                                  )),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            index = 1;
                          });
                        },
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: index == 1
                                ? Colors.amber.withOpacity(0.2)
                                : Colors.transparent,
                            border: Border(
                              right: BorderSide(
                                  width: 5.0,
                                  color: index == 1
                                      ? Colors.amber
                                      : Colors.transparent),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                right: 8, left: 16, top: 8, bottom: 8),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text('New Sale',
                                  style: TextStyle(
                                    color: index == 1
                                        ? Colors.amber.shade900
                                        : black,
                                    fontSize: size.width * 0.01,
                                  )),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            index = 2;
                          });
                        },
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: index == 2
                                ? Colors.green.withOpacity(0.2)
                                : Colors.transparent,
                            border: Border(
                              right: BorderSide(
                                  width: 5.0,
                                  color: index == 2
                                      ? Colors.green
                                      : Colors.transparent),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                right: 8, left: 16, top: 8, bottom: 8),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Invoices',
                                  style: TextStyle(
                                    color: index == 2
                                        ? Colors.green.shade700
                                        : black,
                                    fontSize: size.width * 0.01,
                                  )),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            index = 3;
                          });
                        },
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: index == 3
                                ? Colors.blue.withOpacity(0.17)
                                : Colors.transparent,
                            border: Border(
                              right: BorderSide(
                                  width: 5.0,
                                  color: index == 3
                                      ? Colors.blue
                                      : Colors.transparent),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                right: 8, left: 16, top: 8, bottom: 8),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Stock Entry',
                                  style: TextStyle(
                                    color: index == 3
                                        ? Colors.blue.shade700
                                        : black,
                                    fontSize: size.width * 0.01,
                                  )),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            index = 4;
                          });
                        },
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: index == 4
                                ? Colors.purple.withOpacity(0.2)
                                : Colors.transparent,
                            border: Border(
                              right: BorderSide(
                                  width: 5.0,
                                  color: index == 4
                                      ? Colors.purple
                                      : Colors.transparent),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                right: 8, left: 16, top: 8, bottom: 8),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'In-Stock',
                                style: TextStyle(
                                  color: index == 4
                                      ? Colors.purple.shade700
                                      : black,
                                  fontSize: size.width * 0.01,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            index = 5;
                          });
                        },
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: index == 5
                                ? Colors.orange.withOpacity(0.2)
                                : Colors.transparent,
                            border: Border(
                              right: BorderSide(
                                  width: 5.0,
                                  color: index == 5
                                      ? Colors.orange
                                      : Colors.transparent),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                right: 8, left: 16, top: 8, bottom: 8),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Return',
                                style: TextStyle(
                                  color: index == 5
                                      ? Colors.orange.shade700
                                      : black,
                                  fontSize: size.width * 0.01,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            index = 6;
                          });
                        },
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: index == 6
                                ? Colors.pink.withOpacity(0.2)
                                : Colors.transparent,
                            border: Border(
                              right: BorderSide(
                                  width: 5.0,
                                  color: index == 6
                                      ? Colors.pink
                                      : Colors.transparent),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                right: 8, left: 16, top: 8, bottom: 8),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Expenses',
                                  style: TextStyle(
                                    color: index == 6
                                        ? Colors.pink.shade700
                                        : black,
                                    fontSize: size.width * 0.01,
                                  )),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            index = 7;
                          });
                        },
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: index == 7 || index == 8
                                ? Colors.deepPurple.withOpacity(0.2)
                                : Colors.transparent,
                            border: Border(
                              right: BorderSide(
                                  width: 5.0,
                                  color: index == 7 || index == 8
                                      ? Colors.deepPurple
                                      : Colors.transparent),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                right: 8, left: 16, top: 8, bottom: 8),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Customers',
                                  style: TextStyle(
                                    color: index == 7 || index == 8
                                        ? Colors.deepPurple.shade900
                                        : black,
                                    fontSize: size.width * 0.01,
                                  )),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            index = 9;
                          });
                        },
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: index == 9
                                ? Colors.brown.withOpacity(0.2)
                                : Colors.transparent,
                            border: Border(
                              right: BorderSide(
                                  width: 5.0,
                                  color: index == 9
                                      ? Colors.brown
                                      : Colors.transparent),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                right: 8, left: 16, top: 8, bottom: 8),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Cash Pay',
                                  style: TextStyle(
                                    color: index == 9
                                        ? Colors.brown.shade900
                                        : black,
                                    fontSize: size.width * 0.01,
                                  )),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            index = 11;
                          });
                        },
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: index == 11
                                ? Colors.blueGrey.withOpacity(0.2)
                                : Colors.transparent,
                            border: Border(
                              right: BorderSide(
                                  width: 5.0,
                                  color: index == 11
                                      ? Colors.blueGrey
                                      : Colors.transparent),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                right: 8, left: 16, top: 8, bottom: 8),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Cash Receive',
                                  style: TextStyle(
                                    color: index == 11
                                        ? Colors.blueGrey.shade900
                                        : black,
                                    fontSize: size.width * 0.01,
                                  )),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          pages.elementAt(index),
        ],
      ),
    );
  }
}

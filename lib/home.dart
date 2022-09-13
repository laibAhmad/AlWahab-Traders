import 'package:flutter/material.dart';
import 'package:inventory_system/Screens/add_stock.dart';

import 'package:inventory_system/Screens/return.dart';
import 'package:inventory_system/Screens/stock.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Models/data.dart';
import 'Screens/dashboard.dart';
import 'Screens/expenses.dart';
import 'Screens/new_sale.dart';
import 'constants.dart';
import 'login.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<InStockData> itemsList = [];

  @override
  void initState() {
    getData();

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

  getSortList() {
    itemsList1.sort((a, b) {
      return a.name
          .toString()
          .toLowerCase()
          .compareTo(b.name.toString().toLowerCase());
    });
  }

  getAlertItems() {
    itemsList1.any((element) {
      return element.total < 50;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final List<Widget> pages = [
      const Dashboard(),
      const NewSale(),
      const NewSale(),
      const AddStock(),
      const InStock(),
      const Return(),
      const ExpensesScreen(),
      const Icon(Icons.visibility),
      const Icon(Icons.bolt),
      const Icon(Icons.home),
      const Icon(Icons.visibility),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/img/logo.png',
          width: 60,
        ),
        elevation: 0,
        actions: [
          // getAlertItems()
          //     ?
          IconButton(
              onPressed: () async {
                setState(() {
                  index = 8;
                });
              },
              icon: Icon(Icons.add_alert, color: red)),
          //     : Container(),
          IconButton(
              onPressed: () async {
                setState(() {
                  index = 0;
                });

                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString("user", '');

                // ignore: use_build_context_synchronously
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
                    (route) => false);
              },
              icon: const Icon(Icons.logout_rounded)),
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
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Row(
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     SizedBox(
                //       height: size.height * 0.2,
                //       child: Center(
                //         child: Image.asset(
                //           'assets/img/logo.png',
                //           width: size.width * 0.1,
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
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
                    ],
                  ),
                ),
                // Column(
                //   children: [
                //     Padding(
                //       padding: const EdgeInsets.all(8.0),
                //       child: InkWell(
                //         onTap: () async {
                //           setState(() {
                //             index = 0;
                //           });

                //           SharedPreferences prefs =
                //               await SharedPreferences.getInstance();
                //           prefs.setString("user", '');

                //           // ignore: use_build_context_synchronously
                //           Navigator.pushAndRemoveUntil(
                //               context,
                //               MaterialPageRoute(
                //                   builder: (context) => const LoginScreen()),
                //               (route) => false);
                //         },
                //         child: Container(
                //           decoration: BoxDecoration(
                //               borderRadius: BorderRadius.circular(5),
                //               border: Border.all(color: grey)),
                //           child: Padding(
                //             padding: EdgeInsets.symmetric(
                //                 horizontal: size.height * 0.01,
                //                 vertical: size.height * 0.01),
                //             child: Row(
                //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //               children: [
                //                 Row(
                //                   children: [
                //                     CircleAvatar(
                //                         radius: 15,
                //                         backgroundColor: grey,
                //                         foregroundColor: black,
                //                         child: Icon(Icons.logout_rounded,
                //                             color: black)),
                //                     Padding(
                //                       padding: EdgeInsets.only(
                //                           left: size.width * 0.01),
                //                       child: Text(
                //                         ' Logout',
                //                         style: TextStyle(
                //                           color: black,
                //                           fontSize: size.width * 0.01,
                //                         ),
                //                       ),
                //                     ),
                //                   ],
                //                 ),
                //                 Icon(
                //                   Icons.arrow_forward_ios_rounded,
                //                   color: black,
                //                   size: size.width * 0.01,
                //                 ),
                //               ],
                //             ),
                //           ),
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
          pages.elementAt(index),
        ],
      ),
    );
  }
}

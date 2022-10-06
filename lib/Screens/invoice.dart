import 'package:expandable/expandable.dart';
import 'package:firedart/firestore/firestore.dart';
import 'package:firedart/firestore/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

import '../Models/data.dart';
import '../constants.dart';
import '../home.dart';

class InvoiceScreen extends StatefulWidget {
  const InvoiceScreen({Key? key}) : super(key: key);

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
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

  List<Invoices> ivoices = [];

  Future<List<Invoices>> getInvoices() async {
    int index=-1;
    await invoiceRef.get().asStream().forEach((element) {
      for (var element in element) {
        index=index+1;
        Invoices list = Invoices(
            date: element['date'],
            id: element.id,
            bank: element['bankRs'],
            cash: element['cashRs'],
            cr: element['crRs'],
            netTotal: element['netTotal'],
            profit: element['profit'],
            cname: element['customer'],
            invo: element['inovno'],
            paytype: element['payType'],
            totalitems: element['totalItems'],
            invoiceitems: [], index: index);

        ivoices.add(list);

        setState(() {});
      }
    });
    getInvoiceItems();
    return ivoices;
  }

  getInvoiceItems() async {
    for (var i = 0; i < ivoices.length; i++) {
      await invoiceRef
          .document(ivoices[i].id)
          .collection('items')
          .get()
          .asStream()
          .forEach((doc) {
        for (var d in doc) {
          InvoiceItems l = InvoiceItems(
              iPrice: d['inewP'],
              id: d.id,
              iname: d['iName'],
              ino: d['iNo'],
              isold: d['iSaleItems'],
              totalsold: d['total']);

          ivoices[i].invoiceitems.add(l);
          setState(() {});
          
        }
      });
      for (var j = 0; j < ivoices[i].invoiceitems.length; j++) {
        print(ivoices[i].invoiceitems[j].iname);
      }
    }
  }

  @override
  void initState() {
    getInvoices();

    // getInvoiceItems();

    super.initState();
  }

  static const loremIpsum =
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";

  getSortList() {
    ivoices.sort((a, b) {
      return a.date
          .toString()
          .toLowerCase()
          .compareTo(b.date.toString().toLowerCase());
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(15, 0, 0, 10),
            decoration: BoxDecoration(color: Colors.green.withOpacity(0.15)),
            width: size.width * 0.85,
            height: size.height * 0.15,
            alignment: Alignment.bottomLeft,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                            // if (expense != '' && spend != 0) {
                            //   setState(() {
                            //     load = true;
                            //   });
                            //   Firestore.instance
                            //       .collection("AWT")
                            //       .document('inventory')
                            //       .collection('expenses')
                            //       .add({
                            //     'expense': expense,
                            //     'date': date,
                            //     'spent': spend,
                            //     'spentFrom': search,
                            //   }).then((value) {
                            //     if (search == 'Cash') {
                            //       pos
                            //           .document('Cash Rs')
                            //           .set({'cash': (cashRs - spend)});
                            //     } else {
                            //       pos
                            //           .document('Bank Rs')
                            //           .set({'bank': (bankRs - spend)});
                            //     }
                            //     setState(() {
                            //       load = false;
                            //       index = 6;
                            //       Navigator.pushReplacement(
                            //           context,
                            //           MaterialPageRoute(
                            //               builder: (context) =>
                            //                   const HomeScreen()));
                            //     });
                            //   });
                            //   setState(() {
                            //     error = '';
                            //   });
                            // } else {
                            //   setState(() {
                            //     error = 'Please fill all details carefully!';
                            //   });
                            // }
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
              width: size.width * 0.85,
              height: size.height * 0.75,
              child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Your Expenses'),
                      ivoices.isEmpty
                          ? error != ''
                              ? Center(child: Text(error))
                              : Center(
                                  child: SpinKitWave(
                                    size: size.height * 0.035,
                                    color: black,
                                  ),
                                )
                          : SizedBox(
                              width: size.width * 0.85,
                              height: size.height * 0.65,
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: ivoices.length,
                                itemBuilder: (BuildContext context, int index) {return ExpandableNotifier(
                                      child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Card(
                                      clipBehavior: Clip.antiAlias,
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            color: Colors.grey.shade200,
                                            height: 50,
                                            child:
                                            // Row(
                                            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            //   children: [
                                            //   Text(ivoices[index].date),
                                            //   Text('${ivoices[index].invo}'),
                                            //   Text(ivoices[index].cname),
                                            //   Text(ivoices[index].paytype),
                                            //   Text('${ivoices[index].netTotal}'),
                                            //   Text('${ivoices[index].totalitems}'),
                                            //   Text(ivoices[index].date),
                                            // ],)
                                             DataTable(
                                      columns: const [
                                        DataColumn(
                                            label: Flexible(
                                                fit: FlexFit.loose,
                                                child: Text(
                                                  'Date',
                                                  softWrap: false,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ))),
                                        DataColumn(
                                            label: Flexible(
                                                fit: FlexFit.loose,
                                                child: Text(
                                                  'Expense',
                                                  softWrap: false,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ))),
                                        DataColumn(
                                            label: Flexible(
                                                fit: FlexFit.loose,
                                                child: Text(
                                                  'Spent Rs',
                                                  softWrap: false,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ))),
                                        DataColumn(
                                            label: Flexible(
                                                fit: FlexFit.loose,
                                                child: Text(
                                                  'Spent From',
                                                  softWrap: false,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ))),
                                      ],
                                      rows: 
                                      ivoices
                                          .map((item) =>const DataRow(cells: [
                                                 DataCell(Text('')),
                                                DataCell( Text('')),
                                                DataCell(
                                                    Text('')),
                                                DataCell( Text(
                                                  '',
                                                )),
                                              ]))
                                          .toList())
                                          ),
                                          ScrollOnExpand(
                                            scrollOnExpand: true,
                                            scrollOnCollapse: false,
                                            child: ExpandablePanel(
                                              theme: const ExpandableThemeData(
                                                headerAlignment:
                                                    ExpandablePanelHeaderAlignment
                                                        .center,
                                                tapBodyToCollapse: true,
                                              ),
                                              header: Padding(
                                                  padding: EdgeInsets.all(10),
                                                  child: Text(
                                                    "ExpandablePanel",
                                                    // style: Theme.of(context).textTheme.body2,
                                                  )),
                                              collapsed: Text(
                                                loremIpsum,
                                                softWrap: true,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              expanded: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  for (var _
                                                      in Iterable.generate(5))
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                bottom: 10),
                                                        child: Text(
                                                          loremIpsum,
                                                          softWrap: true,
                                                          overflow:
                                                              TextOverflow.fade,
                                                        )),
                                                ],
                                              ),
                                              builder:
                                                  (_, collapsed, expanded) {
                                                return Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 10,
                                                      right: 10,
                                                      bottom: 10),
                                                  child: Expandable(
                                                    collapsed: collapsed,
                                                    expanded: expanded,
                                                    theme:
                                                        const ExpandableThemeData(
                                                            crossFadePoint: 0),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )); },
                                // children: [
                                  // ExpandableNotifier(
                                  //     child: Padding(
                                  //   padding: const EdgeInsets.all(10),
                                  //   child: Card(
                                  //     clipBehavior: Clip.antiAlias,
                                  //     child: Column(
                                  //       children: <Widget>[
                                  //         SizedBox(
                                  //           height: 150,
                                  //           child: Container(
                                  //             decoration: BoxDecoration(
                                  //               color: Colors.orange,
                                  //               shape: BoxShape.rectangle,
                                  //             ),
                                  //           ),
                                  //         ),
                                  //         ScrollOnExpand(
                                  //           scrollOnExpand: true,
                                  //           scrollOnCollapse: false,
                                  //           child: ExpandablePanel(
                                  //             theme: const ExpandableThemeData(
                                  //               headerAlignment:
                                  //                   ExpandablePanelHeaderAlignment
                                  //                       .center,
                                  //               tapBodyToCollapse: true,
                                  //             ),
                                  //             header: Padding(
                                  //                 padding: EdgeInsets.all(10),
                                  //                 child: Text(
                                  //                   "ExpandablePanel",
                                  //                   // style: Theme.of(context).textTheme.body2,
                                  //                 )),
                                  //             collapsed: Text(
                                  //               loremIpsum,
                                  //               softWrap: true,
                                  //               maxLines: 2,
                                  //               overflow: TextOverflow.ellipsis,
                                  //             ),
                                  //             expanded: Column(
                                  //               crossAxisAlignment:
                                  //                   CrossAxisAlignment.start,
                                  //               children: <Widget>[
                                  //                 for (var _
                                  //                     in Iterable.generate(5))
                                  //                   Padding(
                                  //                       padding:
                                  //                           EdgeInsets.only(
                                  //                               bottom: 10),
                                  //                       child: Text(
                                  //                         loremIpsum,
                                  //                         softWrap: true,
                                  //                         overflow:
                                  //                             TextOverflow.fade,
                                  //                       )),
                                  //               ],
                                  //             ),
                                  //             builder:
                                  //                 (_, collapsed, expanded) {
                                  //               return Padding(
                                  //                 padding: EdgeInsets.only(
                                  //                     left: 10,
                                  //                     right: 10,
                                  //                     bottom: 10),
                                  //                 child: Expandable(
                                  //                   collapsed: collapsed,
                                  //                   expanded: expanded,
                                  //                   theme:
                                  //                       const ExpandableThemeData(
                                  //                           crossFadePoint: 0),
                                  //                 ),
                                  //               );
                                  //             },
                                  //           ),
                                  //         ),
                                  //       ],
                                  //     ),
                                  //   ),
                                  // )),
                                //   DataTable(
                                //       columns: const [
                                //         DataColumn(
                                //             label: Flexible(
                                //                 fit: FlexFit.loose,
                                //                 child: Text(
                                //                   'Date',
                                //                   softWrap: false,
                                //                   overflow:
                                //                       TextOverflow.ellipsis,
                                //                 ))),
                                //         DataColumn(
                                //             label: Flexible(
                                //                 fit: FlexFit.loose,
                                //                 child: Text(
                                //                   'Expense',
                                //                   softWrap: false,
                                //                   overflow:
                                //                       TextOverflow.ellipsis,
                                //                 ))),
                                //         DataColumn(
                                //             label: Flexible(
                                //                 fit: FlexFit.loose,
                                //                 child: Text(
                                //                   'Spent Rs',
                                //                   softWrap: false,
                                //                   overflow:
                                //                       TextOverflow.ellipsis,
                                //                 ))),
                                //         DataColumn(
                                //             label: Flexible(
                                //                 fit: FlexFit.loose,
                                //                 child: Text(
                                //                   'Spent From',
                                //                   softWrap: false,
                                //                   overflow:
                                //                       TextOverflow.ellipsis,
                                //                 ))),
                                //       ],
                                //       rows: ivoices
                                //           .map((item) => DataRow(cells: [
                                //                 DataCell(Text(item.date)),
                                //                 DataCell(Text('item.invoiceitems[item.index].iname')),
                                //                 DataCell(
                                //                     Text('${item.totalitems}')),
                                //                 DataCell(Text(
                                //                   item.cname,
                                //                 )),
                                //               ]))
                                //           .toList()),
                                // ]
                              ),
                            ),
                    ],
                  )))
        ]);
  }
}

import 'package:firedart/firestore/firestore.dart';
import 'package:firedart/firestore/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';

import '../Models/data.dart';
import '../constants.dart';

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

  NumberFormat myFormat = NumberFormat.decimalPattern('en_us');

  String expense = '';
  int spend = 0;

  int pp = 0;
  int items = 0;
  String name = '';
  String uid = '';

  String date = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String invoiceDate = 'Select Month';
  // DateFormat('yMMM').format(DateTime.now());
  String invoiceMonthNum = DateFormat('y-MM').format(DateTime.now());

  String error = '';

  bool load = false;

  String search = 'Cash';

  List<Invoices> ivoices = [];

  Future<List<Invoices>> getInvoices(int n) async {
    ivoices.clear();
    int index = -1;
    if (n == 0) {
      await invoiceRef.get().asStream().forEach((element) {
        for (var element in element) {
          index = index + 1;
          if ((element['date']).toString().contains(invoiceMonthNum)) {
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
                invoiceitems: [],
                index: index);

            ivoices.add(list);

            setState(() {});
          }
        }
      }).whenComplete(() {
        if (ivoices.isEmpty) {
          setState(() {
            error = 'No Invoices yet';
          });
        }
      });
    } else if (n == 2) {
      await invoiceRef.get().asStream().forEach((element) {
        for (var element in element) {
          index = index + 1;
          if ((element['date']).toString().contains(date)) {
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
                invoiceitems: [],
                index: index);

            ivoices.add(list);

            setState(() {});
          }
        }
      }).whenComplete(() {
        if (ivoices.isEmpty) {
          setState(() {
            error = 'No Invoices yet';
          });
        }
      });
    } else if(n==1) {
      await invoiceRef.get().asStream().forEach((element) {
        for (var element in element) {
          index = index + 1;
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
              invoiceitems: [],
              index: index);

          ivoices.add(list);

          setState(() {});
        }
      }).whenComplete(() {
        if (ivoices.isEmpty) {
          setState(() {
            error = 'No Invoices yet';
          });
        }
      });
    }
    getInvoiceItems();
    getSortList();
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
    }
  }

  @override
  void initState() {
    getInvoices(2);

    // getInvoiceItems();

    super.initState();
  }

  getSortList() {
    ivoices.sort((a, b) {
      return b.invo
          .toString()
          .toLowerCase()
          .compareTo(a.invo.toString().toLowerCase());
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              width: size.width * 0.85,
              height: size.height * 0.9,
              child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Text('Invoices of - '),
                              InkWell(
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2022),
                                      lastDate: DateTime.now());

                                  if (pickedDate != null) {
                                    String formattedDate =
                                        DateFormat('yyyy-MM-dd')
                                            .format(pickedDate);
                                    getInvoices(2);
                                    setState(() {
                                      date =
                                          formattedDate; //set output date to TextField value.
                                    });
                                  } else {}
                                },
                                child: Text(
                                  date,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              InkWell(
                                onTap: () async {
                                  DateTime? pickedDate =
                                      await showMonthYearPicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2022),
                                    lastDate: DateTime.now()
                                        .add(const Duration(days: 1)),
                                  );

                                  if (pickedDate != null) {
                                    String formattedDate =
                                        DateFormat('yMMM').format(pickedDate);

                                    String numM =
                                        DateFormat('y-MM').format(pickedDate);
                                    setState(() {
                                      invoiceDate = formattedDate;
                                      invoiceMonthNum = numM;
                                      error = '';
                                      date='Select Date';
                                      getInvoices(0);
                                    });
                                  } else {}
                                },
                                child: Text(
                                  '$invoiceDate     ',
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    invoiceDate = 'Select Month';
                                    date='Select Date';
                                    getInvoices(1);
                                  });
                                },
                                child: const Text(
                                  'Want to see ALL Invoices? Click here...',
                                  style: TextStyle(fontSize: 11),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Text('Invoices:   ${ivoices.length}'),
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
                              height: size.height * 0.75,
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: ivoices.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Card(
                                    clipBehavior: Clip.antiAlias,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              RichText(
                                                text: TextSpan(
                                                  text: '',
                                                  style: DefaultTextStyle.of(
                                                          context)
                                                      .style,
                                                  children: <TextSpan>[
                                                    const TextSpan(
                                                        text: 'Invoice # :  ',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600)),
                                                    TextSpan(
                                                        text:
                                                            '${ivoices[index].invo}'),
                                                  ],
                                                ),
                                              ),
                                              RichText(
                                                text: TextSpan(
                                                  text: '',
                                                  style: DefaultTextStyle.of(
                                                          context)
                                                      .style,
                                                  children: <TextSpan>[
                                                    const TextSpan(
                                                        text: 'Date :  ',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600)),
                                                    TextSpan(
                                                        text: ivoices[index]
                                                            .date),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              RichText(
                                                text: TextSpan(
                                                  text: '',
                                                  style: DefaultTextStyle.of(
                                                          context)
                                                      .style,
                                                  children: <TextSpan>[
                                                    const TextSpan(
                                                        text: 'Cust. Name :  ',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600)),
                                                    TextSpan(
                                                        text: ivoices[index]
                                                            .cname),
                                                  ],
                                                ),
                                              ),
                                              RichText(
                                                text: TextSpan(
                                                  text: '',
                                                  style: DefaultTextStyle.of(
                                                          context)
                                                      .style,
                                                  children: <TextSpan>[
                                                    const TextSpan(
                                                        text: 'Net Total :  ',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600)),
                                                    TextSpan(
                                                        text:
                                                            'Rs. ${myFormat.format(ivoices[index].netTotal)}'),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              RichText(
                                                text: TextSpan(
                                                  text: '',
                                                  style: DefaultTextStyle.of(
                                                          context)
                                                      .style,
                                                  children: <TextSpan>[
                                                    const TextSpan(
                                                        text: 'T. Items :  ',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600)),
                                                    TextSpan(
                                                        text:
                                                            '${ivoices[index].totalitems}'),
                                                  ],
                                                ),
                                              ),
                                              RichText(
                                                text: TextSpan(
                                                  text: '',
                                                  style: DefaultTextStyle.of(
                                                          context)
                                                      .style,
                                                  children: <TextSpan>[
                                                    const TextSpan(
                                                        text: 'Pay Type :  ',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600)),
                                                    TextSpan(
                                                        text: ivoices[index]
                                                            .paytype),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                              height: 20, child: Divider()),
                                          Row(
                                            children: [
                                              SizedBox(
                                                  width: size.width * 0.03,
                                                  child: const Text('#',
                                                      style: TextStyle(
                                                          fontWeight: FontWeight
                                                              .w600))),
                                              SizedBox(
                                                  width: size.width * 0.07,
                                                  child: const Text('Inv. #',
                                                      style: TextStyle(
                                                          fontWeight: FontWeight
                                                              .w600))),
                                              SizedBox(
                                                  width: size.width * 0.22,
                                                  child: const Text('Items',
                                                      style: TextStyle(
                                                          fontWeight: FontWeight
                                                              .w600))),
                                              SizedBox(
                                                  width: size.width * 0.1,
                                                  child: const Text('Qty',
                                                      textAlign: TextAlign.end,
                                                      style: TextStyle(
                                                          fontWeight: FontWeight
                                                              .w600))),
                                              SizedBox(
                                                  width: size.width * 0.18,
                                                  child: const Text('Per Price',
                                                      textAlign: TextAlign.end,
                                                      style: TextStyle(
                                                          fontWeight: FontWeight
                                                              .w600))),
                                              SizedBox(
                                                  width: size.width * 0.2,
                                                  child: const Text('Total',
                                                      textAlign: TextAlign.end,
                                                      style: TextStyle(
                                                          fontWeight: FontWeight
                                                              .w600))),
                                            ],
                                          ),
                                          const SizedBox(height: 6),
                                          for (int i = 0;
                                              i <
                                                  ivoices[index]
                                                      .invoiceitems
                                                      .length;
                                              i++)
                                            Row(
                                              children: [
                                                SizedBox(
                                                    width: size.width * 0.03,
                                                    child: Text('${i + 1}')),
                                                SizedBox(
                                                    width: size.width * 0.07,
                                                    child: Text(ivoices[index]
                                                        .invoiceitems[i]
                                                        .ino)),
                                                SizedBox(
                                                    width: size.width * 0.22,
                                                    child: Text(ivoices[index]
                                                        .invoiceitems[i]
                                                        .iname)),
                                                SizedBox(
                                                    width: size.width * 0.1,
                                                    child: Text(
                                                        '${ivoices[index].invoiceitems[i].isold}',
                                                        textAlign:
                                                            TextAlign.end)),
                                                SizedBox(
                                                    width: size.width * 0.18,
                                                    child: Text(
                                                        '${ivoices[index].invoiceitems[i].iPrice}',
                                                        textAlign:
                                                            TextAlign.end)),
                                                SizedBox(
                                                    width: size.width * 0.2,
                                                    child: Text(
                                                        'Rs. ${myFormat.format(ivoices[index].invoiceitems[i].totalsold)}',
                                                        textAlign:
                                                            TextAlign.end)),
                                              ],
                                            ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                    ],
                  )))
        ]);
  }
}

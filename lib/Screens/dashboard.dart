import 'package:firedart/firestore/firestore.dart';
import 'package:firedart/firestore/models.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:inventory_system/constants.dart';

import '../Models/data.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  CollectionReference pos = Firestore.instance
      .collection("AWT")
      .document('inventory')
      .collection('POS');

  NumberFormat myFormat = NumberFormat.decimalPattern('en_us');

  int today = 0;
  int week = 0;
  int month = 0;
  int year = 0;

  List<Invoices> invoiceList = [];

  @override
  void initState() {
    getInvoices();

    getPOSdate();

    super.initState();
  }

  Future<List<Invoices>> getInvoices() async {
    await Firestore.instance
        .collection("AWT")
        .document('inventory')
        .collection('invoices')
        .get()
        .asStream()
        .forEach((element) {
      for (var element in element) {
        Invoices list = Invoices(
            date: element['date'],
            id: element.id,
            bank: element['bankRs'],
            cash: element['cashRs'],
            cr: element['crRs'],
            netTotal: element['netTotal']);

        invoiceList.add(list);

        setState(() {});
      }
    });
    getSalesActivity();
    return invoiceList;
  }

  getSalesActivity() {
    for (var i = 0; i < invoiceList.length; i++) {
      //today

      if (DateTime.now()
              .difference(DateFormat.yMd().parse(invoiceList[i].date))
              .inDays <=
          1) {
        setState(() {
          today = today + invoiceList[i].netTotal;
        });
      }

//week
      if (DateTime.now()
              .difference(DateFormat.yMd().parse(invoiceList[i].date))
              .inDays <=
          7) {
        setState(() {
          week = week + invoiceList[i].netTotal;
        });
      }

      //month
      if (DateTime.now()
              .difference(DateFormat.yMd().parse(invoiceList[i].date))
              .inDays <=
          30) {
        setState(() {
          month = month + invoiceList[i].netTotal;
        });
      }

      //year
      if (DateTime.now()
              .difference(DateFormat.yMd().parse(invoiceList[i].date))
              .inDays <=
          365) {
        setState(() {
          year = year + invoiceList[i].netTotal;
        });
      }
    }
  }

  getPOSdate() async {
    await pos.document('Bank Rs').get().asStream().forEach((element) {
      bankRs = element['bank'];
    });

    await pos.document('CR Rs').get().asStream().forEach((element) {
      crRs = element['cr'];
    });

    await pos.document('Cash Rs').get().asStream().forEach((element) {
      cashRs = element['cash'];
    });

    await pos.document('Profit').get().asStream().forEach((element) {
      profit = element['Profit'];
    });

    await pos.document('Total Sales').get().asStream().forEach((element) {
      totalRs = element['Total'];
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: SizedBox(
        width: size.width * 0.85,
        height: size.height * 0.9,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Sales Activity',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: size.width * 0.2,
                    height: 130,
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          myFormat.format(today),
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: size.width * 0.032,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          'Today',
                          style: TextStyle(fontSize: size.width * 0.015),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: size.width * 0.2,
                    height: 130,
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.2),
                      // border: Border.all(
                      //   color: grey,
                      // ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          myFormat.format(week),
                          style: TextStyle(
                              color: Colors.green,
                              fontSize: size.width * 0.032,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          'This Week',
                          style: TextStyle(fontSize: size.width * 0.015),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: size.width * 0.2,
                    height: 130,
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.2),
                      // border: Border.all(
                      //   color: grey,
                      // ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          myFormat.format(month),
                          style: TextStyle(
                              color: red,
                              fontSize: size.width * 0.032,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          'This Month',
                          style: TextStyle(fontSize: size.width * 0.015),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: size.width * 0.2,
                    height: 130,
                    decoration: BoxDecoration(
                      color: Colors.purple.withOpacity(0.2),
                      // border: Border.all(
                      //   color: grey,
                      // ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(myFormat.format(year),
                            style: TextStyle(
                                color: Colors.purple,
                                fontSize: size.width * 0.032,
                                fontWeight: FontWeight.w500)),
                        Text(
                          'This Year',
                          style: TextStyle(fontSize: size.width * 0.015),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Container(
                    width: size.width * 0.5,
                    height: size.height * 0.5,
                    decoration: BoxDecoration(
                      color: grey,
                      border: Border.all(
                        color: grey,
                      ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

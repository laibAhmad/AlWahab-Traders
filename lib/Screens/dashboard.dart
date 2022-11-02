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

  String date = DateFormat('yyyy-MM-dd').format(DateTime.now());

  int today = 0;
  int week = 0;
  int month = 0;
  int year = 0;

  int expenseRs=0;

  int todaySalesT = 0;
  int cashSalesT = 0;
  int crSalesT = 0;
  int totalPcsT = 0;

  int todayPro = 0;
  int weekPro = 0;
  int monthPro = 0;
  int yearPro = 0;

  int todayNo = 0;
  int weekNo = 0;
  int monthNo = 0;
  int yearno = 0;

  int todayCr = 0;
  int weekCr = 0;
  int monthCr = 0;
  int yearCr = 0;

  int cash = 0;
  int cr = 0;

  List<Invoices> invoiceList = [];

  @override
  void initState() {
    getInvoices();
    getcash();
    getCR();
    getExpnses();

    super.initState();
  }

  Future<List<Invoices>> getInvoices() async {
    await invoiceRef.get().asStream().forEach((element) {
      for (var element in element) {
        if ((element['date']).toString().contains(date)) {
          {
            Invoices list = Invoices(
                date: element['date'],
                id: element.id,
                bank: element['bankRs'],
                cash: element['cashRs'],
                cr: element['crRs'],
                netTotal: element['netTotal'],
                profit: element['profit'],
                cname: '',
                invo: 0,
                paytype: '',
                totalitems: element['totalItems'],
                invoiceitems: [],
                index: 0);

            invoiceList.add(list);

            setState(() {});
          }
        }
      }
    });
    getsalesiconActivity();
    return invoiceList;
  }

  getsalesiconActivity() {
    for (var i = 0; i < invoiceList.length; i++) {
      //today
      todaySalesT = todaySalesT + invoiceList[i].netTotal;
      cashSalesT = cashSalesT + invoiceList[i].cash + invoiceList[i].bank;
      crSalesT = crSalesT + invoiceList[i].cr;
      totalPcsT = totalPcsT + invoiceList[i].totalitems;
      todaySales = todaySalesT;
      cashSales = cashSalesT;
      crSales = crSalesT;
      totalPcs = totalPcsT;
    }
  }

  Future<int> getCR() async {
    await pos.document('CR Rs').get().asStream().forEach((element) {
      cr = element['cr'];
      setState(() {
        crRs = cr;
      });
    });
    return crRs;
  }

  Future<int> getcash() async {
    await pos.document('Cash Rs').get().asStream().forEach((element) {
      cash = element['cash'];
      setState(() {
        cashRs = cash;
      });
    });
    return cashRs;
  }

  Future<int> getExpnses() async{
    await expenseRef.get().asStream().forEach((element) {
        for (var element in element) {
          if ((element['date']).toString().compareTo(date)==0) {
            Expenses list = Expenses(
                date: element['date'],
                expenseName: element['expense'],
                spentRs: element['spent'],
                spendfrom: element['spentFrom'],
                id: element.id);

            setState(() {
              expenseRs=expenseRs+ list.spentRs;
            });
          }
        }
      });

      return expenseRs;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SizedBox(
        width: size.width * 0.85,
        height: size.height * 0.9,
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(shrinkWrap: true, children: [
              const Text('Sales Overview',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 10),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                Container(
                    width: size.width * 0.412,
                    height: size.height * 0.35,
                    decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(5.0)),
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                    SizedBox(
                                        width: (size.width * 0.41) - 20,
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text('Today',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15)),
                                           
                                               Text(date,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 15)),
                                            ])),
                                    Row(children: [
                                      Container(
                                          height: 45,
                                          width: 45,
                                          decoration: BoxDecoration(
                                              color:
                                                  Colors.blue.withOpacity(0.15),
                                              borderRadius:
                                                  BorderRadius.circular(5.0)),
                                          child: Center(
                                              child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Icon(earnicon,
                                                      color: Colors
                                                          .blue.shade400)))),
                                      const SizedBox(width: 10),
                                      Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text('Total Sales',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w400)),
                                            Text(
                                                'Rs. ${myFormat.format(todaySales)}',
                                                style: TextStyle(
                                                    fontSize:
                                                        size.width * 0.016,
                                                    fontWeight:
                                                        FontWeight.w700))
                                          ])
                                    ]),
                                    Row(children: [
                                      Container(
                                          height: 45,
                                          width: 45,
                                          decoration: BoxDecoration(
                                              color:
                                                  Colors.blue.withOpacity(0.15),
                                              borderRadius:
                                                  BorderRadius.circular(5.0)),
                                          child: Center(
                                              child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Icon(salesicon,
                                                      color: Colors
                                                          .blue.shade400)))),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text('Cash Sales',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w400)),
                                            Text(
                                                'Rs. ${myFormat.format(cashSales)}',
                                                style: TextStyle(
                                                    fontSize:
                                                        size.width * 0.016,
                                                    fontWeight:
                                                        FontWeight.w700))
                                          ])
                                    ]),
                                    Row(children: [
                                      Container(
                                          height: 45,
                                          width: 45,
                                          decoration: BoxDecoration(
                                              color:
                                                  Colors.blue.withOpacity(0.15),
                                              borderRadius:
                                                  BorderRadius.circular(5.0)),
                                          child: Center(
                                              child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Icon(earnicon,
                                                      color: Colors
                                                          .blue.shade400)))),
                                      const SizedBox(width: 10),
                                      Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text('CR',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w400)),
                                            Text(
                                                'Rs. ${myFormat.format(crSales)}',
                                                style: TextStyle(
                                                    fontSize:
                                                        size.width * 0.016,
                                                    fontWeight:
                                                        FontWeight.w700))
                                          ])
                                    ]),
                                    Row(children: [
                                      Container(
                                          height: 45,
                                          width: 45,
                                          decoration: BoxDecoration(
                                              color:
                                                  Colors.blue.withOpacity(0.15),
                                              borderRadius:
                                                  BorderRadius.circular(5.0)),
                                          child: Center(
                                              child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Icon(profiticon,
                                                      color: Colors
                                                          .blue.shade400)))),
                                      const SizedBox(width: 10),
                                      Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text('Total Pcs.',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w400)),
                                            Text('$totalPcs',
                                                style: TextStyle(
                                                    fontSize:
                                                        size.width * 0.016,
                                                    fontWeight:
                                                        FontWeight.w700))
                                          ])
                                    ])
                                  ]))
                            ]))),
                const SizedBox(width: 5),
                Container(
                    width: size.width * 0.412,
                    height: size.height * 0.35,
                    decoration: BoxDecoration(
                        color: Colors.pink.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(5.0)),
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                            // width: size.width * 0.2,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                              const Text('POS',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15)),
                              Row(children: [
                                Container(
                                    height: 45,
                                    width: 45,
                                    decoration: BoxDecoration(
                                        color:
                                            Colors.pinkAccent.withOpacity(0.15),
                                        borderRadius:
                                            BorderRadius.circular(5.0)),
                                    child: Center(
                                        child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Icon(
                                              Icons.attach_money,
                                              color: Colors.pinkAccent.shade400,
                                            )))),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('Cash',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400)),
                                      Text('Rs. ${myFormat.format(cashRs)}',
                                          style: TextStyle(
                                              fontSize: size.width * 0.016,
                                              fontWeight: FontWeight.w700)),
                                    ])
                              ]),
                              Row(children: [
                                Container(
                                    height: 45,
                                    width: 45,
                                    decoration: BoxDecoration(
                                      color:
                                          Colors.pinkAccent.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    child: Center(
                                        child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Icon(
                                              Icons.credit_score,
                                              color: Colors.pinkAccent.shade400,
                                            )))),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('CR',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400)),
                                      Text('Rs. ${myFormat.format(crRs)}',
                                          style: TextStyle(
                                              fontSize: size.width * 0.016,
                                              fontWeight: FontWeight.w700))
                                    ])
                              ]),
                              Row(children: [
                                      Container(
                                          height: 45,
                                          width: 45,
                                          decoration: BoxDecoration(
                                              color:
                                                  Colors.orange.withOpacity(0.15),
                                              borderRadius:
                                                  BorderRadius.circular(5.0)),
                                          child: Center(
                                              child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Icon(earnicon,
                                                      color: Colors
                                                          .orange.shade400)))),
                                      const SizedBox(width: 10),
                                      Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text('Today Expense',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w400)),
                                            Text(
                                                'Rs. ${myFormat.format(expenseRs)}',
                                                style: TextStyle(
                                                    fontSize:
                                                        size.width * 0.016,
                                                    fontWeight:
                                                        FontWeight.w700))
                                          ])
                                    ]),
                            ]))))
              ]),
               const SizedBox(height: 10),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                Container(
                    width: size.width * 0.412,
                    decoration: BoxDecoration(
                        color: Colors.purple.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(5.0)),
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                    
                                    Row(children: [
                                      Container(
                                          height: 45,
                                          width: 45,
                                          decoration: BoxDecoration(
                                              color:
                                                  Colors.purple.withOpacity(0.15),
                                              borderRadius:
                                                  BorderRadius.circular(5.0)),
                                          child: Center(
                                              child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Icon(earnicon,
                                                      color: Colors
                                                          .purple.shade400)))),
                                      const SizedBox(width: 10),
                                      Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text('Collected CR',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w400)),
                                            Text(
                                                'Rs. ${myFormat.format(todaySales)}',
                                                style: TextStyle(
                                                    fontSize:
                                                        size.width * 0.016,
                                                    fontWeight:
                                                        FontWeight.w700))
                                          ])
                                    ]),
                                    
                                  ]))
                            ]))),
                const SizedBox(width: 8),
                Container(
                    width: size.width * 0.412,
                    decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(5.0)),
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                    
                                    Row(children: [
                                      Container(
                                          height: 45,
                                          width: 45,
                                          decoration: BoxDecoration(
                                              color:
                                                  Colors.orange.withOpacity(0.15),
                                              borderRadius:
                                                  BorderRadius.circular(5.0)),
                                          child: Center(
                                              child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Icon(earnicon,
                                                      color: Colors
                                                          .orange.shade400)))),
                                      const SizedBox(width: 10),
                                      Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text('Today Expense',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w400)),
                                            Text(
                                                'Rs. ${myFormat.format(expenseRs)}',
                                                style: TextStyle(
                                                    fontSize:
                                                        size.width * 0.016,
                                                    fontWeight:
                                                        FontWeight.w700))
                                          ])
                                    ]),
                                    
                                  ]))
                            ]))),
              ]),
            ])));
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:inventory_system/constants.dart';

import '../Models/data.dart';
import '../Models/text_loading.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  NumberFormat myFormat = NumberFormat.decimalPattern('en_us');

  String date = DateFormat('yyyy-MM-dd').format(DateTime.now());

  int today = 0;
  int week = 0;
  int month = 0;
  int year = 0;

  int expenseRs = 0;

  int todaySalesT = 0;
  int cashSalesT = 0;
  int crSalesT = 0;
  int totalPcsT = 0;

  bool textLoading = false;
  bool crtextLoading = false;

  bool tcrtextLoading = false;
  bool tcashloading = false;
  bool expense = false;

  int cash = 0;
  int cr = 0;

  int collectedCR = 0;

  List<Invoices> invoiceList = [];

  List<CustomerList> crList = [];

  List<CashList> cashListTrue = [];
  List<CashList> cashListFalse = [];
  int cashListTotal = 0;
  
  List<int> remaingCRs = [];

  int remainedCR = 0;

  Future<List<CashList>>  getAllCashList() async {
    cashListTrue.clear();
    await pos.get().asStream().forEach((element) async {
      for (var s in element) {
              if ((s['status']) == true) {
                CashList l = CashList(
                    cr: s['cash'], date: s['date'], status: s['status']);

                cashListTrue.add(l);
                setState(() {});
              }
      }
      getCollectedCash();
    });
    return cashListTrue;
  }

   getCollectedCash() {
    for (int i = 0; i < cashListTrue.length; i++) {
      setState(() {
        cashListTotal = cashListTotal + cashListTrue[i].cr;
      });
    }
    getFalseCashList();
  }

 Future<List<CashList>>  getFalseCashList() async {
    cashListFalse.clear();
    await pos.get().asStream().forEach((element) async {
      for (var s in element) {
              if ((s['status']) == false) {
                CashList l = CashList(
                    cr: s['cash'], date: s['date'], status: s['status']);

                cashListFalse.add(l);
                setState(() {});
              }
      }
      getFasleCash();
    });
    return cashListFalse;
  }

     getFasleCash() {
    for (int i = 0; i < cashListFalse.length; i++) {
      setState(() {
        cashListTotal = cashListTotal - cashListFalse[i].cr;
      });
    }
    setState(() {
      tCash = (cashListTotal).abs();
      tcashloading = false;
    });
  }

  Future<List<CustomerList>> getCollectedCRList() async {
    crList.clear();
    await customerRef.get().asStream().forEach((element) async {
      for (var e in element) {
        await customerRef
            .document(e.id)
            .collection('cr')
            .get()
            .asStream()
            .forEach((elements) {
          for (var s in elements) {
            if ((s['date']).toString().compareTo(date) == 0) {
              if ((s['status']) == false) {
                CustomerList l = CustomerList(
                    cr: s['cr'], date: s['date'], status: s['status']);

                crList.add(l);
                setState(() {});
              }
            }
          }
        });
      }
      getCollectedCR();
    });
    return crList;
  }

  getCollectedCR() {
    for (int i = 0; i < crList.length; i++) {
      setState(() {
        collectedCR = collectedCR + crList[i].cr;
      });
    }
    setState(() {
      ccR = collectedCR;
      crtextLoading = false;
    });
  }

  @override
  void initState() {
    textLoading = true;
    crtextLoading = true;
    tcrtextLoading = true;
    tcashloading = true;
    expense = true;
    getInvoices();
    getCollectedCRList();
    getAllCashList();
    getCR();
    getExpnses();

    super.initState();
  }

  Future<List<Invoices>> getInvoices() async {
    invoiceList.clear();
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
                paytype: element['payType'],
                totalitems: element['totalItems'],
                invoiceitems: [],
                index: 0);

            invoiceList.add(list);

            setState(() {});
          }
        }
      }
    }).then((value) {
      setState(() {
        textLoading = false;
      });
    });
    getsalesiconActivity();
    return invoiceList;
  }

  getsalesiconActivity() {
    for (var i = 0; i < invoiceList.length; i++) {
      setState(() {
        todaySalesT = todaySalesT + invoiceList[i].netTotal;
      });
      if ((invoiceList[i].paytype).contains('Cash')) {
        setState(() {
          cashSalesT = cashSalesT + invoiceList[i].netTotal;
        });
      } else if ((invoiceList[i].paytype).contains('CR')) {
        setState(() {
          crSalesT = crSalesT + invoiceList[i].netTotal;
        });
      }
      setState(() {
        totalPcsT = totalPcsT + invoiceList[i].totalitems;
        todaySales = todaySalesT;
        cashSales = cashSalesT;
        crSales = (crSalesT).abs();
        totalPcs = totalPcsT;
      });
    }
  }

  Future<List<int>> getCR() async {
    remaingCRs.clear();
    await customerRef.get().asStream().forEach((element) async {
      for (var e in element) {
        remaingCRs.add(e['cr']);

        setState(() {});
      }
      getTotalCR();
    }).then((value) {
      setState(() {
        tcrtextLoading = false;
      });
    });
    return remaingCRs;
  }

  getTotalCR() {
    for (var i = 0; i < remaingCRs.length; i++) {
      setState(() {
        remainedCR = remainedCR + remaingCRs[i];
      });
    }
  }

  Future<int> getExpnses() async {
    await expenseRef.get().asStream().forEach((element) {
      for (var element in element) {
        if ((element['date']).toString().compareTo(date) == 0) {
          Expenses list = Expenses(
              date: element['date'],
              expenseName: element['expense'],
              spentRs: element['spent'],
              spendfrom: element['spentFrom'],
              id: element.id);

          setState(() {
            expenseRs = expenseRs + list.spentRs;
          });
        }
      }
    }).then((value) {
      setState(() {
        expense = false;
      });
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
                                              const Text(
                                                'Today',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15),
                                              ),
                                              InkWell(
                                                onTap: () async {
                                                  DateTime? pickedDate =
                                                      await showDatePicker(
                                                          context: context,
                                                          initialDate:
                                                              DateTime.now(),
                                                          firstDate:
                                                              DateTime(2022),
                                                          lastDate:
                                                              DateTime.now());

                                                  if (pickedDate != null) {
                                                    String formattedDate =
                                                        DateFormat('yyyy-MM-dd')
                                                            .format(pickedDate);

                                                    setState(() {
                                                      date = formattedDate;
                                                      textLoading = true;
                                                      crtextLoading = true;
                                                      expense = true;
                                                      expenseRs = 0;
                                                      todaySalesT = 0;
                                                      cashSalesT = 0;
                                                      crSalesT = 0;
                                                      totalPcsT = 0;
                                                      todaySales = 0;
                                                      cashSales = 0;
                                                      crSales = 0;
                                                      totalPcs = 0;
                                                      collectedCR = 0;
                                                      ccR = 0;
                                                      getInvoices();
                                                      getCollectedCRList();
                                                      getExpnses();
                                                    });
                                                  } else {}
                                                },
                                                child: Text(
                                                  date,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15),
                                                ),
                                              ),
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
                                            textLoading
                                                ? const TextLoading()
                                                : Text(
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
                                            textLoading
                                                ? const TextLoading()
                                                : Text(
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
                                            textLoading
                                                ? const TextLoading()
                                                : Text(
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
                                            textLoading
                                                ? const TextLoading()
                                                : Text('$totalPcs',
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
                                      tcashloading
                                          ? const TextLoading()
                                          : Text(
                                              'Rs. ${myFormat.format(tCash)}',
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
                                      tcrtextLoading
                                          ? const TextLoading()
                                          : Text(
                                              'Rs. ${myFormat.format(remainedCR)}',
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
                                        borderRadius:
                                            BorderRadius.circular(5.0)),
                                    child: Center(
                                        child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Icon(earnicon,
                                                color: Colors.transparent)))),
                                const SizedBox(width: 10),
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400)),
                                      Text('',
                                          style: TextStyle(
                                              fontSize: size.width * 0.016,
                                              fontWeight: FontWeight.w700))
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
                                              color: Colors.purple
                                                  .withOpacity(0.15),
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
                                            crtextLoading
                                                ? const TextLoading()
                                                : Text(
                                                    'Rs. ${myFormat.format(ccR)}',
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
                                              color: Colors.orange
                                                  .withOpacity(0.15),
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
                                            expense
                                                ? const TextLoading()
                                                : Text(
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

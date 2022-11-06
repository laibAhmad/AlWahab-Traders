import 'package:firedart/firestore/firestore.dart';
import 'package:firedart/firestore/models.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:inventory_system/Models/text_loading.dart';

import 'package:inventory_system/constants.dart';
import 'package:month_year_picker/month_year_picker.dart';

import '../Models/data.dart';

class MonthlyRepo extends StatefulWidget {
  const MonthlyRepo({Key? key}) : super(key: key);

  @override
  State<MonthlyRepo> createState() => _MonthlyRepoState();
}

class _MonthlyRepoState extends State<MonthlyRepo> {
  CollectionReference pos = Firestore.instance
      .collection("AWT")
      .document('inventory')
      .collection('POS');

  NumberFormat myFormat = NumberFormat.decimalPattern('en_us');

  String date = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String invoiceDate = DateFormat('yMMM').format(DateTime.now());
  String invoiceMonthNum = DateFormat('y-MM').format(DateTime.now());

  String yearNum = DateFormat('yyyy').format(DateTime.now());

//month
  int todaySalesM = 0;
  int cashSalesM = 0;
  int crSalesM = 0;
  int totalPcsM = 0;
  int profitM = 0;
  int expenseM = 0;

//year
  int todaySalesY = 0;
  int cashSalesY = 0;
  int crSalesY = 0;
  int totalPcsY = 0;
  int profitY = 0;
  int expenseY = 0;

  int expenseRs = 0;

  int todaySalesT = 0;
  int cashSalesT = 0;
  int crSalesT = 0;
  int totalPcsT = 0;

  int cash = 0;
  int cr = 0;
  int profit = 0;

  int collectedCR = 0;

  bool profitloadingYr = false;
  bool expenseloadingYr = false;

  bool profitloadingMo = false;
  bool expenseloadingMo = false;

  List<Invoices> invoiceListM = [];
  List<Invoices> invoiceListY = [];

  List<CustomerList> crList = [];

  @override
  void initState() {
    profitloadingYr = true;
    expenseloadingYr = true;
    profitloadingMo = true;
    expenseloadingMo = true;
    getMonthInvoices();
    getYearInvoices();
    getMonthExpnses();
    getYearExpnses();

    super.initState();
  }

  Future<List<Invoices>> getMonthInvoices() async {
    invoiceListM.clear();
    await invoiceRef.get().asStream().forEach((element) {
      for (var element in element) {
        if ((element['date']).toString().contains(invoiceMonthNum)) {
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

            invoiceListM.add(list);

            setState(() {});
          }
        }
      }
    }).then((value) {
      setState(() {
        profitloadingMo=false;
      });
    });
    getsalesiconActivity();
    return invoiceListM;
  }

  Future<List<Invoices>> getYearInvoices() async {
    invoiceListY.clear();
    await invoiceRef.get().asStream().forEach((element) {
      for (var element in element) {
        if ((element['date']).toString().contains(yearNum)) {
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

            invoiceListY.add(list);

            setState(() {});
          }
        }
      }
    }).then((value) {
      setState(() {
        profitloadingYr=false;
      });
    });
    getsalesiconActivityYear();
    return invoiceListY;
  }

  getsalesiconActivity() {
    for (var i = 0; i < invoiceListM.length; i++) {
      setState(() {
        todaySalesM = todaySalesM + invoiceListM[i].netTotal;
        profitM = profitM + invoiceListM[i].profit;

      });

      if ((invoiceListM[i].paytype).contains('Cash')) {
        setState(() {
          cashSalesM = cashSalesM + invoiceListM[i].netTotal;
        });
      } else if ((invoiceListM[i].paytype).contains('CR')) {
        setState(() {
          crSalesM = crSalesM + invoiceListM[i].netTotal;
        });
      }
      setState(() {
        totalPcsM = totalPcsM + invoiceListM[i].totalitems;
        todaySalesMo = todaySalesM;
        cashSalesMo = cashSalesM;
        crSalesMo = crSalesM;
        totalPcsMo = totalPcsM;
        profitMo = profitM;
      });
    }
  }

  getsalesiconActivityYear() {
    for (var i = 0; i < invoiceListY.length; i++) {
      setState(() {
        todaySalesY = todaySalesY + invoiceListY[i].netTotal;
        profitY = profitY + invoiceListY[i].profit;
      });
      if ((invoiceListY[i].paytype).contains('Cash')) {
        setState(() {
          cashSalesY = cashSalesY + invoiceListY[i].netTotal;
        });
      } else if ((invoiceListY[i].paytype).contains('CR')) {
        setState(() {
          crSalesY = crSalesY + invoiceListY[i].netTotal;
        });
      }
      setState(() {
        totalPcsY = totalPcsY + invoiceListY[i].totalitems;
        todaySalesYr = todaySalesY;
        cashSalesYr = cashSalesY;
        crSalesYr = crSalesY;
        totalPcsYr = totalPcsY;
        profitYr = profitY;
      });
    }
  }

  Future<int> getMonthExpnses() async {
    await expenseRef.get().asStream().forEach((element) {
      for (var element in element) {
        if ((element['date']).toString().contains(invoiceMonthNum)) {
          Expenses list = Expenses(
              date: element['date'],
              expenseName: element['expense'],
              spentRs: element['spent'],
              spendfrom: element['spentFrom'],
              id: element.id);

          setState(() {
            expenseM = expenseM + list.spentRs;
          });
        }
      }
    }).then((value) {
      setState(() {
        expenseMo = expenseM;
        expenseloadingMo = false;
      });
    });

    return expenseRs;
  }

  Future<int> getYearExpnses() async {
    await expenseRef.get().asStream().forEach((element) {
      for (var element in element) {
        if ((element['date']).toString().contains(yearNum)) {
          Expenses list = Expenses(
              date: element['date'],
              expenseName: element['expense'],
              spentRs: element['spent'],
              spendfrom: element['spentFrom'],
              id: element.id);

          setState(() {
            expenseY = expenseY + list.spentRs;
          });
        }
      }
    }).then((value) {
      setState(() {
        expenseYr = expenseY;
        expenseloadingYr = false;
      });
    });

    return expenseYr;
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: size.width * 0.412,
                    height: size.height * 0.55,
                    decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(5.0)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: (size.width * 0.41) - 20,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Monthly',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15)),
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
                                                DateFormat('yMMM')
                                                    .format(pickedDate);

                                            String numM = DateFormat('y-MM')
                                                .format(pickedDate);
                                            setState(() {
                                              expenseloadingMo=true;
                                              profitloadingMo=true;
                                              invoiceDate = formattedDate;
                                              invoiceMonthNum = numM;
                                              todaySalesM = 0;
                                              cashSalesM = 0;
                                              crSalesM = 0;
                                              totalPcsM = 0;
                                              todaySalesMo = 0;
                                              cashSalesMo = 0;
                                              crSalesMo = 0;
                                              totalPcsMo = 0;
                                              expenseM=0;
                                              expenseMo=0;
                                              profitM=0;
                                              profitMo=0;
                                              getMonthInvoices();
                                              getMonthExpnses();
                                            });
                                          } else {}
                                        },
                                        child: Text(
                                          '$invoiceDate     ',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    Container(
                                      height: 45,
                                      width: 45,
                                      decoration: BoxDecoration(
                                          color: Colors.green.withOpacity(0.15),
                                          borderRadius:
                                              BorderRadius.circular(5.0)),
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Icon(earnicon,
                                              color: Colors.green.shade400),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text('Total Sales',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400)),
                                        profitloadingMo?const TextLoading(): Text(
                                            'Rs. ${myFormat.format(todaySalesMo)}',
                                            style: TextStyle(
                                                fontSize: size.width * 0.016,
                                                fontWeight: FontWeight.w700)),
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                      height: 45,
                                      width: 45,
                                      decoration: BoxDecoration(
                                          color: Colors.green.withOpacity(0.15),
                                          borderRadius:
                                              BorderRadius.circular(5.0)),
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Icon(salesicon,
                                              color: Colors.green.shade400),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text('Cash Sales',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400)),
                                        profitloadingMo?const TextLoading():Text(
                                            'Rs. ${myFormat.format(cashSalesMo)}',
                                            style: TextStyle(
                                                fontSize: size.width * 0.016,
                                                fontWeight: FontWeight.w700)),
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                      height: 45,
                                      width: 45,
                                      decoration: BoxDecoration(
                                          color: Colors.green.withOpacity(0.15),
                                          borderRadius:
                                              BorderRadius.circular(5.0)),
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Icon(earnicon,
                                              color: Colors.green.shade400),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text('CR',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400)),
                                        profitloadingMo?const TextLoading():Text(
                                            'Rs. ${myFormat.format(crSalesMo)}',
                                            style: TextStyle(
                                                fontSize: size.width * 0.016,
                                                fontWeight: FontWeight.w700)),
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                      height: 45,
                                      width: 45,
                                      decoration: BoxDecoration(
                                          color: Colors.green.withOpacity(0.15),
                                          borderRadius:
                                              BorderRadius.circular(5.0)),
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Icon(profiticon,
                                              color: Colors.green.shade400),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text('Total Pcs.',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400)),
                                        profitloadingMo?const TextLoading():Text('$totalPcsMo',
                                            style: TextStyle(
                                                fontSize: size.width * 0.016,
                                                fontWeight: FontWeight.w700)),
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                      height: 45,
                                      width: 45,
                                      decoration: BoxDecoration(
                                          color: Colors.green.withOpacity(0.15),
                                          borderRadius:
                                              BorderRadius.circular(5.0)),
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Icon(earnicon,
                                              color: Colors.green.shade400),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text('Profit',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400)),
                                        profitloadingMo
                                            ? const TextLoading()
                                            : Text(
                                                'Rs. ${myFormat.format(profitMo)}',
                                                style: TextStyle(
                                                    fontSize:
                                                        size.width * 0.016,
                                                    fontWeight:
                                                        FontWeight.w700)),
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                      height: 45,
                                      width: 45,
                                      decoration: BoxDecoration(
                                          color: Colors.green.withOpacity(0.15),
                                          borderRadius:
                                              BorderRadius.circular(5.0)),
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Icon(earnicon,
                                              color: Colors.green.shade400),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text('Expenses',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400)),
                                        expenseloadingMo?const TextLoading():Text(
                                            'Rs. ${myFormat.format(expenseMo)}',
                                            style: TextStyle(
                                                fontSize: size.width * 0.016,
                                                fontWeight: FontWeight.w700)),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Container(
                    width: size.width * 0.412,
                    height: size.height * 0.55,
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: (size.width * 0.41) - 20,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Yearly',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
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
                                                DateFormat('yMMM')
                                                    .format(pickedDate);

                                            String numM = DateFormat('y-MM')
                                                .format(pickedDate);
                                            setState(() {
                                              expenseloadingYr=true;
                                              profitloadingYr=true;
                                              invoiceDate = formattedDate;
                                              invoiceMonthNum = numM;
                                              todaySalesY = 0;
                                              cashSalesY = 0;
                                              crSalesY = 0;
                                              totalPcsY = 0;
                                              todaySalesYr = 0;
                                              cashSalesYr = 0;
                                              crSalesYr = 0;
                                              totalPcsYr = 0;
                                              profitY=0;
                                              profitYr=0;
                                              expenseY=0;
                                              expenseYr=0;
                                              getYearInvoices();
                                              getYearExpnses();
                                            });
                                          } else {}
                                        },
                                        child: Text(
                                          '$yearNum  ',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
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
                                          padding: const EdgeInsets.all(8.0),
                                          child: Icon(earnicon,
                                              color: Colors.purple.shade400),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text('Total Sales',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400)),
                                        profitloadingYr
                                            ? const TextLoading()
                                            : Text(
                                                'Rs. ${myFormat.format(todaySalesYr)}',
                                                style: TextStyle(
                                                    fontSize:
                                                        size.width * 0.016,
                                                    fontWeight:
                                                        FontWeight.w700)),
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
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
                                          padding: const EdgeInsets.all(10.0),
                                          child: Icon(salesicon,
                                              color: Colors.purple.shade400),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text('Cash Sales',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400)),
                                        profitloadingYr
                                            ? const TextLoading()
                                            : Text(
                                                'Rs. ${myFormat.format(cashSalesYr)}',
                                                style: TextStyle(
                                                    fontSize:
                                                        size.width * 0.016,
                                                    fontWeight:
                                                        FontWeight.w700)),
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
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
                                          padding: const EdgeInsets.all(8.0),
                                          child: Icon(earnicon,
                                              color: Colors.purple.shade400),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text('CR',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400)),
                                        profitloadingYr
                                            ? const TextLoading()
                                            : Text(
                                                'Rs. ${myFormat.format(crSalesYr)}',
                                                style: TextStyle(
                                                    fontSize:
                                                        size.width * 0.016,
                                                    fontWeight:
                                                        FontWeight.w700)),
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
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
                                          padding: const EdgeInsets.all(8.0),
                                          child: Icon(profiticon,
                                              color: Colors.purple.shade400),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text('Total Pcs.',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400)),
                                        profitloadingYr
                                            ? const TextLoading()
                                            : Text('$totalPcsYr',
                                                style: TextStyle(
                                                    fontSize:
                                                        size.width * 0.016,
                                                    fontWeight:
                                                        FontWeight.w700)),
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
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
                                          padding: const EdgeInsets.all(8.0),
                                          child: Icon(earnicon,
                                              color: Colors.purple.shade400),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text('Profit',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400)),
                                        profitloadingYr
                                            ? const TextLoading()
                                            : Text(
                                                'Rs. ${myFormat.format(profitYr)}',
                                                style: TextStyle(
                                                    fontSize:
                                                        size.width * 0.016,
                                                    fontWeight:
                                                        FontWeight.w700)),
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
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
                                          padding: const EdgeInsets.all(8.0),
                                          child: Icon(earnicon,
                                              color: Colors.purple.shade400),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text('Expense',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400)),
                                        expenseloadingYr
                                            ? const TextLoading()
                                            : Text(
                                                'Rs. ${myFormat.format(expenseYr)}',
                                                style: TextStyle(
                                                    fontSize:
                                                        size.width * 0.016,
                                                    fontWeight:
                                                        FontWeight.w700)),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ])));
  }
}

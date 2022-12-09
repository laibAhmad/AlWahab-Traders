import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';
import '../Models/data.dart';
import '../constants.dart';

class Return extends StatefulWidget {
  const Return({Key? key}) : super(key: key);

  @override
  State<Return> createState() => _ReturnState();
}

class _ReturnState extends State<Return> {
  TextEditingController expenseName = TextEditingController();
  TextEditingController invController = TextEditingController();

  TextEditingController controller = TextEditingController();
  TextEditingController searchName = TextEditingController();

  TextEditingController cnameText = TextEditingController();
  TextEditingController cr = TextEditingController();

  NumberFormat myFormat = NumberFormat.decimalPattern('en_us');

  String expense = '';
  int spend = 0;

  int pp = 0;
  int items = 0;
  String name = '';
  String uid = '';

  dynamic returnItems;

  int totalItemPrice = 0;
  int minusProfit = 0;

  int perviousCR = 0;
  // int pervItemCR = 0;

  String date = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String invoiceDate = 'Select Month';
  String invoiceMonthNum = DateFormat('y-MM').format(DateTime.now());

  String returnDate = 'Enter Date';
  String returnInvoNo = 'Enter Invoice No.';
  String error = '';
  String returnerror = 'Enter Details';

  int pervItems = 0;
  int purchasePrice = 0;

  bool load = false;
  bool returnShow = false;

  String search = 'Cash';

  List<Invoices> ivoices = [];
  List<ReturnInvoices> returnivoices = [];

  List<int> returnItemsList = [];

  Future<List<Invoices>> getInvoices(int n) async {
    ivoices.clear();
    if (n == 0) {
      ivoices.clear();
      await returnRef.get().asStream().forEach((element) {
        for (var element in element) {
          if ((element['date']).toString().contains(invoiceMonthNum)) {
            Invoices list = Invoices(
                date: element['date'],
                id: element.id,
                bank: 0,
                cash: 0,
                cr: 0,
                netTotal: 0,
                profit: 0,
                cname: element['customer'],
                invo: element['inovno'],
                paytype: '0',
                totalitems: element['returnItems'],
                invoiceitems: [],
                index: index);

            ivoices.add(list);

            setState(() {});
          }
        }
        getSortList();
        getInvoiceItems();
      }).whenComplete(() {
        if (ivoices.isEmpty) {
          setState(() {
            error = 'No Return Invoices yet';
          });
        }
      });
    } else if (n == 2) {
      ivoices.clear();

      await returnRef.get().asStream().forEach((element) {
        for (var element in element) {
          if ((element['date']).toString().contains(date)) {
            Invoices list = Invoices(
                date: element['date'],
                id: element.id,
                bank: 0,
                cash: 0,
                cr: 0,
                netTotal: 0,
                profit: 0,
                cname: element['customer'],
                invo: element['inovno'],
                paytype: '0',
                totalitems: element['returnItems'],
                invoiceitems: [],
                index: index);

            ivoices.add(list);

            setState(() {});
          }
        }
        getSortList();
        getInvoiceItems();
      }).whenComplete(() {
        if (ivoices.isEmpty) {
          setState(() {
            error = 'No Return Invoices yet';
          });
        }
      });
    } else if (n == 1) {
      ivoices.clear();
      await returnRef.get().asStream().forEach((element) {
        for (var element in element) {
          Invoices list = Invoices(
              date: element['date'],
              id: element.id,
              bank: 0,
              cash: 0,
              cr: 0,
              netTotal: 0,
              profit: 0,
              cname: element['customer'],
              invo: element['inovno'],
              paytype: '0',
              totalitems: element['returnItems'],
              invoiceitems: [],
              index: index);

          ivoices.add(list);

          setState(() {});
        }
        getSortList();
        getInvoiceItems();
      }).whenComplete(() {
        if (ivoices.isEmpty) {
          setState(() {
            error = 'No Return Invoices yet';
          });
        }
      });
    } else if (n == 3) {
      ivoices.clear();
      await returnRef.get().asStream().forEach((element) {
        for (var element in element) {
          if ((element['inovno']).toString().compareTo(controller.text) == 0) {
            Invoices list = Invoices(
                date: element['date'],
                id: element.id,
                bank: 0,
                cash: 0,
                cr: 0,
                netTotal: 0,
                profit: 0,
                cname: element['customer'],
                invo: element['inovno'],
                paytype: '0',
                totalitems: element['returnItems'],
                invoiceitems: [],
                index: index);

            ivoices.add(list);

            setState(() {});
          }
        }
        getSortList();
        getInvoiceItems();
      }).whenComplete(() {
        if (ivoices.isEmpty) {
          setState(() {
            error = 'No Return Invoices yet';
          });
        }
      });
    } else if (n == 4) {
      ivoices.clear();
      await returnRef.get().asStream().forEach((element) {
        for (var element in element) {
          if (((element['customer']).toLowerCase())
              .toString()
              .contains((searchName.text).toLowerCase())) {
            Invoices list = Invoices(
                date: element['date'],
                id: element.id,
                bank: 0,
                cash: 0,
                cr: 0,
                netTotal: 0,
                profit: 0,
                cname: element['customer'],
                invo: element['inovno'],
                paytype: '0',
                totalitems: element['returnItems'],
                invoiceitems: [],
                index: index);

            ivoices.add(list);

            setState(() {});
          }
        }
        getSortList();
        getInvoiceItems();
      }).whenComplete(() {
        if (ivoices.isEmpty) {
          setState(() {
            error = 'No Return Invoices yet';
          });
        }
      });
    }
    return ivoices;
  }

  Future<List<ReturnInvoices>> getReturnInvoices(
      String date, String invNo) async {
    returnivoices.clear();

    await invoiceRef
        .document('$date $invNo')
        .get()
        .asStream()
        .forEach((element) {
      ReturnInvoices list = ReturnInvoices(
        id: element.id,
        netTotal: element['netTotal'],
        cname: element['customer'],
        paytype: element['payType'],
        totalitems: element['totalItems'],
        invoiceitems: [],
      );

      returnivoices.add(list);

      setState(() {});
      getReturnInvoiceItems();
    }).then((value) {
      if (returnivoices.isEmpty) {
        setState(() {
          returnerror = 'No Items';
        });
      }
    });

    return returnivoices;
  }

  getInvoiceItems() async {
    for (var i = 0; i < ivoices.length; i++) {
      await returnRef
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

          setState(() {
            totalItemPrice = l.iPrice;
          });
        }
      });
    }
  }

  getReturnInvoiceItems() async {
    for (var i = 0; i < returnivoices.length; i++) {
      await invoiceRef
          .document(returnivoices[i].id)
          .collection('items')
          .get()
          .asStream()
          .forEach((doc) {
        for (var d in doc) {
          InvoiceReturnItems l = InvoiceReturnItems(
              iPrice: d['inewP'],
              id: d.id,
              iname: d['iName'],
              ino: d['iNo'],
              isold: d['iSaleItems'],
              totalsold: d['total']);

          returnivoices[i].invoiceitems.add(l);
          returnItemsList.add(l.isold);
          setState(() {});
        }
      });
    }
  }

  @override
  void initState() {
    getInvoices(2);
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
                              Row(children: [
                                const Text('Return Invoices of - '),
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
                                        date = formattedDate;
                                      });
                                    } else {}
                                  },
                                  child: Text(date,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                )
                              ]),
                              Row(children: [
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
                                          invoiceDate = formattedDate;
                                          invoiceMonthNum = numM;
                                          error = '';
                                          date = 'Select Date';
                                          getInvoices(0);
                                        });
                                      } else {}
                                    },
                                    child: Text('$invoiceDate     ',
                                        style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold))),
                                InkWell(
                                    onTap: () {
                                      setState(() {
                                        invoiceDate = 'Select Month';
                                        date = 'Select Date';
                                        getInvoices(1);
                                      });
                                    },
                                    child: const Text(
                                        'Want to see ALL Invoices? Click here...',
                                        style: TextStyle(fontSize: 11)))
                              ])
                            ]),
                        Text('Invoices:   ${ivoices.length}'),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(children: [
                                SizedBox(
                                    width: size.width * 0.1,
                                    height: size.height * 0.05,
                                    child: TextFormField(
                                        controller: controller,
                                        decoration: const InputDecoration(
                                            hintText: 'Search by Invoice No.'),
                                        onChanged: (val) {
                                          if (controller.text.isNotEmpty) {
                                            setState(() {
                                              error = '';
                                            });
                                            getInvoices(3);
                                          }
                                        })),
                                TextButton(
                                    onPressed: () {
                                      if (controller.text.isNotEmpty) {
                                        setState(() {
                                          error = '';
                                        });
                                        getInvoices(3);
                                      }
                                    },
                                    child: const Text('Search')),
                                const SizedBox(width: 40),
                                SizedBox(
                                    width: size.width * 0.15,
                                    height: size.height * 0.05,
                                    child: TextFormField(
                                        controller: searchName,
                                        decoration: const InputDecoration(
                                          hintText: 'Search by Name',
                                        ),
                                        onChanged: (val) {
                                          if (searchName.text.isNotEmpty) {
                                            setState(() {
                                              error = '';
                                            });
                                            getInvoices(4);
                                          }
                                        })),
                                TextButton(
                                    onPressed: () {
                                      if (searchName.text.isNotEmpty) {
                                        setState(() {
                                          error = '';
                                        });
                                        getInvoices(4);
                                      }
                                    },
                                    child: const Text('Search'))
                              ]),
                              ElevatedButton(
                                  child: const Text('Return Item'),
                                  onPressed: () {
                                    setState(() {
                                      returnItems = 0;
                                      returnShow = true;
                                      returnDate = 'Enter Date';
                                    });
                                  })
                            ]),
                        Row(children: [
                          SizedBox(
                              width: size.width * 0.46,
                              height: size.height * 0.7,
                              child: Card(
                                  child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text('Returned Invoices',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                            ivoices.isEmpty
                                                ? error != ''
                                                    ? Expanded(
                                                        child: Center(
                                                            child: Text(error)))
                                                    : Expanded(
                                                        child: Center(
                                                            child: SpinKitWave(
                                                                size:
                                                                    size.height *
                                                                        0.035,
                                                                color: black)))
                                                : Expanded(
                                                    child: ListView.builder(
                                                        controller:
                                                            ScrollController(),
                                                        shrinkWrap: true,
                                                        itemCount:
                                                            ivoices.length,
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context,
                                                                int j) {
                                                          return Column(
                                                              children: [
                                                                Card(
                                                                    child: Padding(
                                                                        padding: const EdgeInsets.all(8.0),
                                                                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                                          Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                RichText(
                                                                                    text: TextSpan(text: '', style: DefaultTextStyle.of(context).style, children: <TextSpan>[
                                                                                  const TextSpan(text: 'Invoice # :  ', style: TextStyle(fontWeight: FontWeight.w600)),
                                                                                  TextSpan(text: '${ivoices[j].invo}')
                                                                                ])),
                                                                                RichText(
                                                                                    text: TextSpan(text: '', style: DefaultTextStyle.of(context).style, children: <TextSpan>[
                                                                                  const TextSpan(text: 'Date :  ', style: TextStyle(fontWeight: FontWeight.w600)),
                                                                                  TextSpan(text: ivoices[j].date)
                                                                                ]))
                                                                              ]),
                                                                          Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                RichText(
                                                                                    text: TextSpan(text: '', style: DefaultTextStyle.of(context).style, children: <TextSpan>[
                                                                                  const TextSpan(text: 'Cust. Name :  ', style: TextStyle(fontWeight: FontWeight.w600)),
                                                                                  TextSpan(text: ivoices[j].cname)
                                                                                ])),
                                                                                RichText(
                                                                                    text: TextSpan(text: '', style: DefaultTextStyle.of(context).style, children: <TextSpan>[
                                                                                  const TextSpan(text: 'Returned Items :  ', style: TextStyle(fontWeight: FontWeight.w600)),
                                                                                  TextSpan(text: '${ivoices[j].totalitems}')
                                                                                ])),
                                                                              ]),
                                                                          const SizedBox(
                                                                              height: 20,
                                                                              child: Divider()),
                                                                          Row(children: [
                                                                            SizedBox(
                                                                                width: size.width * 0.013,
                                                                                child: const Text('#', style: TextStyle(fontWeight: FontWeight.w600))),
                                                                            SizedBox(
                                                                                width: size.width * 0.04,
                                                                                child: const Text('Inv. #', style: TextStyle(fontWeight: FontWeight.w600))),
                                                                            SizedBox(
                                                                                width: size.width * 0.09,
                                                                                child: const Text('Items', style: TextStyle(fontWeight: FontWeight.w600))),
                                                                            SizedBox(
                                                                                width: size.width * 0.07,
                                                                                child: const Text('Qty', textAlign: TextAlign.end, style: TextStyle(fontWeight: FontWeight.w600))),
                                                                            SizedBox(
                                                                                width: size.width * 0.07,
                                                                                child: const Text('Per Price', textAlign: TextAlign.end, style: TextStyle(fontWeight: FontWeight.w600))),
                                                                            SizedBox(
                                                                                width: size.width * 0.12,
                                                                                child: const Text('Total', textAlign: TextAlign.end, style: TextStyle(fontWeight: FontWeight.w600)))
                                                                          ]),
                                                                          const SizedBox(
                                                                              height: 6),
                                                                          for (int i = 0;
                                                                              i < ivoices[j].invoiceitems.length;
                                                                              i++)
                                                                            Row(children: [
                                                                              SizedBox(width: size.width * 0.013, child: Text('${i + 1}')),
                                                                              SizedBox(width: size.width * 0.04, child: Text(ivoices[j].invoiceitems[i].ino)),
                                                                              SizedBox(width: size.width * 0.09, child: Text(ivoices[j].invoiceitems[i].iname)),
                                                                              SizedBox(width: size.width * 0.07, child: Text('${ivoices[j].invoiceitems[i].isold}', textAlign: TextAlign.end)),
                                                                              SizedBox(width: size.width * 0.07, child: Text('${ivoices[j].invoiceitems[i].iPrice}', textAlign: TextAlign.end)),
                                                                              SizedBox(width: size.width * 0.12, child: Text('Rs. ${myFormat.format(ivoices[j].invoiceitems[i].totalsold)}', textAlign: TextAlign.end)),
                                                                            ])
                                                                        ]))),
                                                                const SizedBox(
                                                                    height: 20,
                                                                    child:
                                                                        Divider(
                                                                      thickness:
                                                                          5,
                                                                    ))
                                                              ]);
                                                        }))
                                          ])))),
                          SizedBox(
                            width: size.width * 0.35,
                            height: size.height * 0.7,
                            child: returnShow
                                ? Card(
                                    child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text('Return Item',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w600)),
                                              Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    InkWell(
                                                      onTap: () async {
                                                        DateTime? pickedDate =
                                                            await showDatePicker(
                                                                context:
                                                                    context,
                                                                initialDate:
                                                                    DateTime
                                                                        .now(),
                                                                firstDate:
                                                                    DateTime(
                                                                        2022),
                                                                lastDate:
                                                                    DateTime
                                                                        .now());

                                                        if (pickedDate !=
                                                            null) {
                                                          String formattedDate =
                                                              DateFormat(
                                                                      'yyyy-MM-dd')
                                                                  .format(
                                                                      pickedDate);
                                                          setState(() {
                                                            returnDate =
                                                                formattedDate;
                                                          });
                                                        } else {}
                                                      },
                                                      child: Text(returnDate),
                                                    ),
                                                    Row(children: [
                                                      SizedBox(
                                                          width:
                                                              size.width * 0.05,
                                                          height: size.height *
                                                              0.05,
                                                          child: TextFormField(
                                                              controller:
                                                                  invController,
                                                              decoration:
                                                                  const InputDecoration(
                                                                hintText:
                                                                    'Inv No.',
                                                              ),
                                                              onChanged: (val) {
                                                                if (invController
                                                                    .text
                                                                    .isNotEmpty) {
                                                                  setState(() {
                                                                    returnInvoNo =
                                                                        invController
                                                                            .text
                                                                            .trim();
                                                                  });
                                                                }
                                                              })),
                                                      TextButton(
                                                          onPressed: () async {
                                                            setState(() {
                                                              returnItems = 0;
                                                            });
                                                            if (invController
                                                                .text
                                                                .isNotEmpty) {
                                                              await getReturnInvoices(
                                                                  returnDate,
                                                                  returnInvoNo);
                                                            }
                                                          },
                                                          child: const Text(
                                                              'Enter')),
                                                    ])
                                                  ]),
                                              SizedBox(
                                                  height: size.height * 0.55,
                                                  width: size.width * 0.35,
                                                  child: Column(children: [
                                                    returnivoices.isEmpty
                                                        ? returnerror != ''
                                                            ? Expanded(
                                                                child: Center(
                                                                    child: Text(
                                                                        returnerror)))
                                                            : Expanded(
                                                                child: Center(
                                                                  child:
                                                                      SpinKitWave(
                                                                    size: size
                                                                            .height *
                                                                        0.035,
                                                                    color:
                                                                        black,
                                                                  ),
                                                                ),
                                                              )
                                                        : Expanded(
                                                            child: ListView
                                                                .builder(
                                                                    controller:
                                                                        ScrollController(),
                                                                    shrinkWrap:
                                                                        true,
                                                                    itemCount:
                                                                        returnivoices
                                                                            .length,
                                                                    itemBuilder:
                                                                        (BuildContext
                                                                                context,
                                                                            int j) {
                                                                      return Column(
                                                                          children: [
                                                                            Padding(
                                                                                padding: const EdgeInsets.all(8.0),
                                                                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                                                  RichText(
                                                                                      text: TextSpan(text: '', style: DefaultTextStyle.of(context).style, children: <TextSpan>[
                                                                                    const TextSpan(text: 'Cust. Name :  ', style: TextStyle(fontWeight: FontWeight.w600)),
                                                                                    TextSpan(text: returnivoices[j].cname),
                                                                                  ])),
                                                                                  RichText(
                                                                                      text: TextSpan(text: '', style: DefaultTextStyle.of(context).style, children: <TextSpan>[
                                                                                    const TextSpan(text: 'Net Total :  ', style: TextStyle(fontWeight: FontWeight.w600)),
                                                                                    TextSpan(text: 'Rs. ${myFormat.format(returnivoices[j].netTotal)} - ${returnivoices[j].paytype} Sales'),
                                                                                  ])),
                                                                                  Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                    children: [
                                                                                      RichText(
                                                                                        text: TextSpan(
                                                                                          text: '',
                                                                                          style: DefaultTextStyle.of(context).style,
                                                                                          children: <TextSpan>[
                                                                                            const TextSpan(text: 'T. Items :  ', style: TextStyle(fontWeight: FontWeight.w600)),
                                                                                            TextSpan(text: '${returnivoices[j].totalitems}'),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                  const SizedBox(height: 20, child: Divider()),
                                                                                  Row(
                                                                                    children: [
                                                                                      SizedBox(width: size.width * 0.015, child: const Text('#', style: TextStyle(fontWeight: FontWeight.bold))),
                                                                                      SizedBox(width: size.width * 0.04, child: const Text('in. #', style: TextStyle(fontWeight: FontWeight.bold))),
                                                                                      SizedBox(width: size.width * 0.06, child: const Text('Items', style: TextStyle(fontWeight: FontWeight.bold))),
                                                                                      SizedBox(width: size.width * 0.02, child: const Text('Qty', textAlign: TextAlign.end, style: TextStyle(fontWeight: FontWeight.bold))),
                                                                                      SizedBox(width: size.width * 0.05, child: const Text('Per', textAlign: TextAlign.end, style: TextStyle(fontWeight: FontWeight.bold))),
                                                                                      SizedBox(width: size.width * 0.06, child: const Text('Total', textAlign: TextAlign.end, style: TextStyle(fontWeight: FontWeight.bold))),
                                                                                      SizedBox(width: size.width * 0.06, child: const Text('Remove', textAlign: TextAlign.end, style: TextStyle(fontWeight: FontWeight.bold))),
                                                                                    ],
                                                                                  ),
                                                                                  const SizedBox(height: 6),
                                                                                  for (int i = 0; i < returnivoices[j].invoiceitems.length; i++)
                                                                                    Row(children: [
                                                                                      SizedBox(width: size.width * 0.015, child: Text('${i + 1}-')),
                                                                                      SizedBox(width: size.width * 0.04, child: Text(returnivoices[j].invoiceitems[i].ino)),
                                                                                      SizedBox(width: size.width * 0.06, child: Text(returnivoices[j].invoiceitems[i].iname)),
                                                                                      SizedBox(
                                                                                          width: size.width * 0.02,
                                                                                          child: TextFormField(
                                                                                              decoration: const InputDecoration(
                                                                                                enabledBorder: UnderlineInputBorder(
                                                                                                  borderSide: BorderSide(color: Colors.black),
                                                                                                ),
                                                                                                focusedBorder: UnderlineInputBorder(
                                                                                                  borderSide: BorderSide(color: Colors.black),
                                                                                                ),
                                                                                                border: UnderlineInputBorder(
                                                                                                  borderSide: BorderSide(color: Colors.black),
                                                                                                ),
                                                                                              ),
                                                                                              initialValue: '${returnivoices[j].invoiceitems[i].isold}',
                                                                                              onChanged: (val) {
                                                                                                setState(() {
                                                                                                  returnItemsList[i] = int.parse(val);
                                                                                                });
                                                                                              })),
                                                                                      SizedBox(width: size.width * 0.05, child: Text('${returnivoices[j].invoiceitems[i].iPrice}', textAlign: TextAlign.end)),
                                                                                      SizedBox(width: size.width * 0.06, child: Text('Rs. ${returnivoices[j].invoiceitems[i].totalsold}', textAlign: TextAlign.end)),
                                                                                      SizedBox(
                                                                                        width: size.width * 0.06,
                                                                                        child: IconButton(
                                                                                            onPressed: () async {
                                                                                              dynamic id;

                                                                                              await returnRef.add({
                                                                                                'inovno': int.parse(returnInvoNo),
                                                                                                'customer': returnivoices[j].cname,
                                                                                                'date': date,
                                                                                                'returnItems': returnItemsList[i],
                                                                                              }).then((value) async {
                                                                                                returnRef.document(value.id).collection('items').add({
                                                                                                  'iNo': returnivoices[j].invoiceitems[i].ino,
                                                                                                  'iName': returnivoices[j].invoiceitems[i].iname,
                                                                                                  'inewP': returnivoices[j].invoiceitems[i].iPrice,
                                                                                                  'iSaleItems': returnItemsList[i],
                                                                                                  'total': returnItemsList[i] * returnivoices[j].invoiceitems[i].iPrice,
                                                                                                }).then((value) {
                                                                                                  invoiceRef.document('$returnDate $returnInvoNo').update({
                                                                                                    'netTotal': (returnivoices[j].netTotal - (returnItemsList[i] * returnivoices[j].invoiceitems[i].iPrice)).abs()
                                                                                                  });
                                                                                                });

                                                                                                await ref.get().asStream().forEach((doc) {
                                                                                                  for (var d in doc) {
                                                                                                    if (d['id'] == returnivoices[j].invoiceitems[i].ino) {
                                                                                                      setState(() {
                                                                                                        pervItems = d['totalItems'];
                                                                                                        purchasePrice = d['pricePerPiece'];
                                                                                                        id = d.id;
                                                                                                      });
                                                                                                    }
                                                                                                  }
                                                                                                }).then((value) {
                                                                                                  ref.document(id).update({
                                                                                                    'totalItems': pervItems + returnItemsList[i]
                                                                                                  });
                                                                                                });
                                                                                                ////////////cash new coding
                                                                                                if (returnivoices[j].paytype == 'Cash') {
                                                                                                  pos.document(DateTime.now().toString()).set({
                                                                                                    'date': '$date - return inv $returnInvoNo',
                                                                                                    'cash': (returnItemsList[i] * returnivoices[j].invoiceitems[i].iPrice).abs(),
                                                                                                    'status': false,
                                                                                                  });
                                                                                                } else if (returnivoices[j].paytype == 'CR') {
                                                                                                  await customerRef.get().asStream().forEach((element) async {
                                                                                                    for (var e in element) {
                                                                                                      if ((returnivoices[j].cname).toString().toLowerCase() == (e['customer']).toString().toLowerCase()) {
                                                                                                        setState(() {
                                                                                                          perviousCR = e['cr'];
                                                                                                        });

                                                                                                        ////cr minus
                                                                                                        customerRef.document(e.id).update({
                                                                                                          'cr': (perviousCR - returnItemsList[i] * returnivoices[j].invoiceitems[i].iPrice).abs()
                                                                                                        });

                                                                                                        await customerRef.document(e.id).collection('cr').add({
                                                                                                          'date': date,
                                                                                                          'cr': returnItemsList[i] * returnivoices[j].invoiceitems[i].iPrice,
                                                                                                          'status': true,
                                                                                                        });
                                                                                                      }
                                                                                                    }
                                                                                                  });
                                                                                                }

                                                                                                setState(() {
                                                                                                  minusProfit = (returnItemsList[i] * returnivoices[j].invoiceitems[i].iPrice) - (returnItemsList[i] * purchasePrice);
                                                                                                });
                                                                                                /////////profit minus
                                                                                                profitRef.add({
                                                                                                  'date': date,
                                                                                                  'invo': int.parse(returnInvoNo),
                                                                                                  'profit': minusProfit,
                                                                                                  'status': false,
                                                                                                });
                                                                                              });
                                                                                              setState(() {
                                                                                                returnShow = false;
                                                                                                returnivoices.clear();
                                                                                                error = '';
                                                                                                getInvoices(2);
                                                                                              });
                                                                                            },
                                                                                            icon: Icon(
                                                                                              Icons.delete,
                                                                                              color: red,
                                                                                            )),
                                                                                      )
                                                                                    ])
                                                                                ]))
                                                                          ]);
                                                                    }))
                                                  ]))
                                            ])))
                                : Container(),
                          )
                        ])
                      ])))
        ]);
  }
}

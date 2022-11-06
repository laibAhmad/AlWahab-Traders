import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';

import '../Models/data.dart';
import '../constants.dart';
import '../home.dart';

class CustomerDetails extends StatefulWidget {
  final String cname, id;
  final int cr;

  const CustomerDetails(
      {Key? key, required this.cname, required this.cr, required this.id})
      : super(key: key);

  @override
  State<CustomerDetails> createState() => _CustomerDetailsState();
}

class _CustomerDetailsState extends State<CustomerDetails> {
  String error = '';
  String crerror = '';

  NumberFormat myFormat = NumberFormat.decimalPattern('en_us');

  String date = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String chooseDate = 'by Date';
  String invoiceDate = 'by Month';
  String invoiceMonthNum = DateFormat('y-MM').format(DateTime.now());

  int paymentTotal = 0;

  TextEditingController id = TextEditingController();
  TextEditingController itemName = TextEditingController();

  TextEditingController cnameText = TextEditingController();
  TextEditingController cr = TextEditingController();

  String cnameDialog = '';
  int crDialog = 0;

  List<Invoices> ivoices = [];

  List<CustomerList> custDetails = [];

  Future<List<CustomerList>> getDetails(int n) async {
    custDetails.clear();
    if (n == 0) {
      await customerRef
          .document(widget.id)
          .collection('cr')
          .get()
          .asStream()
          .forEach((element) {
        for (var element in element) {
          CustomerList l = CustomerList(
            cr: element['cr'],
            date: element['date'],
            status: element['status'],
          );
          custDetails.add(l);
        }
        getSortList();
      }).whenComplete(() {
        if (ivoices.isEmpty) {
          setState(() {
            crerror = 'No Remaining Balance :)';
          });
        }
      });
    }
    //by date
    else if (n == 1) {
      await customerRef
          .document(widget.id)
          .collection('cr')
          .get()
          .asStream()
          .forEach((element) {
        for (var element in element) {
          if ((element['date']).toString().contains(chooseDate)) {
            CustomerList l = CustomerList(
              cr: element['cr'],
              date: element['date'],
              status: element['status'],
            );
            custDetails.add(l);
          }
          getSortList();
        }
      }).whenComplete(() {
        if (ivoices.isEmpty) {
          setState(() {
            crerror = 'No Remaining Balance :)';
          });
        }
      });
    }

    // by month
    else if (n == 2) {
      await customerRef
          .document(widget.id)
          .collection('cr')
          .get()
          .asStream()
          .forEach((element) {
        for (var element in element) {
          if ((element['date']).toString().contains(invoiceMonthNum)) {
            CustomerList l = CustomerList(
              cr: element['cr'],
              date: element['date'],
              status: element['status'],
            );
            custDetails.add(l);
          }
        }
        getSortList();
      }).whenComplete(() {
        if (ivoices.isEmpty) {
          setState(() {
            crerror = 'No Remaining Balance :)';
          });
        }
      });
    }

    return custDetails;
  }

  Future<List<Invoices>> getInvoices(int n) async {
    ivoices.clear();
    if (n == 0) {
      await invoiceRef.get().asStream().forEach((element) {
        for (var element in element) {
          if (((element['customer']).toLowerCase())
              .toString()
              .contains((widget.cname).toLowerCase())) {
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
        getSortListInv();
        getInvoiceItems();
        getTotalPayment();
      }).whenComplete(() {
        if (ivoices.isEmpty) {
          setState(() {
            error = 'No Invoices yet';
          });
        }
      });
    }
    //by date
    else if (n == 1) {
      await invoiceRef.get().asStream().forEach((element) {
        for (var element in element) {
          if (((element['customer']).toLowerCase())
              .toString()
              .contains((widget.cname).toLowerCase())) {
            if ((element['date']).toString().contains(chooseDate)) {
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
        }
        getSortListInv();
        getInvoiceItems();
        getTotalPayment();
      }).whenComplete(() {
        if (ivoices.isEmpty) {
          setState(() {
            error = 'No Invoices yet';
          });
        }
      });
    }

    //by month
    else if (n == 2) {
      await invoiceRef.get().asStream().forEach((element) {
        for (var element in element) {
          if (((element['customer']).toLowerCase())
              .toString()
              .contains((widget.cname).toLowerCase())) {
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
        }
        getSortListInv();
        getInvoiceItems();
        getTotalPayment();
      }).whenComplete(() {
        if (ivoices.isEmpty) {
          setState(() {
            error = 'No Invoices yet';
          });
        }
      });
    }
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

  getSortListInv() {
    ivoices.sort((a, b) {
      return b.invo
          .toString()
          .toLowerCase()
          .compareTo(a.invo.toString().toLowerCase());
    });
  }

  @override
  void initState() {
    getDetails(0);
    ivoices.clear();
    custDetails.clear();
    getInvoices(0);
    getcash();

    super.initState();
  }

  int cash=0;
  Future<int> getcash() async {
    await pos.document('Cash Rs').get().asStream().forEach((element) {
      cash = element['cash'];
      setState(() {
        cashRs = cash;
      });
    }).then((value) {
      setState(() {
      });
    });
    return cashRs;
  }

  getSortList() {
    custDetails.sort((a, b) {
      return b.date
          .toString()
          .toLowerCase()
          .compareTo(a.date.toString().toLowerCase());
    });
  }

  getTotalPayment() {
 
    for (int i = 0; i < ivoices.length; i++) {
      setState(() {
        paymentTotal=paymentTotal+ivoices[i].netTotal;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SizedBox(
      height: size.height * 0.98,
      width: size.width * 0.85,
      child: Padding(
        padding: EdgeInsets.all(size.width * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text('Search:   '),
                    InkWell(
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2022),
                            lastDate: DateTime.now());

                        if (pickedDate != null) {
                          String formattedDate =
                              DateFormat('yyyy-MM-dd').format(pickedDate);
                          getInvoices(1);
                          getDetails(1);
                          setState(() {
                            chooseDate = formattedDate;
                            invoiceDate = 'by Month';
                            crerror = '';
                            error = '';
                            paymentTotal=0;
                          });
                        } else {}
                      },
                      child: Text(
                        '$chooseDate        ',
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        DateTime? pickedDate = await showMonthYearPicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2022),
                          lastDate: DateTime.now().add(const Duration(days: 1)),
                        );

                        if (pickedDate != null) {
                          String formattedDate =
                              DateFormat('yMMM').format(pickedDate);

                          String numM = DateFormat('y-MM').format(pickedDate);
                          setState(() {
                            invoiceDate = formattedDate;
                            invoiceMonthNum = numM;
                            crerror = '';
                            error = '';
                            chooseDate = 'by Date';
                            paymentTotal=0;
                            getInvoices(2);
                            getDetails(2);
                          });
                        } else {}
                      },
                      child: Text(
                        '$invoiceDate        ',
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          invoiceDate = 'by Month';
                          chooseDate = 'by Date';
                          getInvoices(0);
                          getDetails(0);
                          crerror = '';
                          error = '';
                          paymentTotal=0;
                        });
                      },
                      child: const Text(
                        'Want to see ALL Data? Click here...',
                        style: TextStyle(fontSize: 11),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    ElevatedButton(
                      child: const Text('Add New CR'),
                      onPressed: () {
                        showDialog<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('New CR'),
                              content: SizedBox(
                                width: size.width * 0.3,
                                height: size.height * 0.25,
                                child: Form(
                                  child: TextFormField(
                                    controller: cr,
                                    decoration: const InputDecoration(
                                      hintText: 'CR',
                                    ),
                                    onChanged: (val) {
                                      setState(() {
                                        crDialog = int.parse(val.trim());
                                      });
                                    },
                                  ),
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                    child: const Text('Cancel',
                                        style: TextStyle(color: Colors.red)),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    }),
                                TextButton(
                                  child: const Text('Save'),
                                  onPressed: () async {
                                    if (cr.text.isNotEmpty) {
                                      customerRef
                                          .document(widget.id)
                                          .collection('cr')
                                          .add({
                                        'date': date,
                                        'cr': crDialog,
                                        'status': true,
                                      }).then((value) {
                                        customerRef
                                          .document(widget.id).update({'cr': widget.cr +crDialog});
                                      });

                                      setState(() {
                                        crerror='';
                                        getDetails(0);
                                        getInvoices(0);
                                      });
                                    }
                                    cr.clear();
                                    
                                    Navigator.of(context).pop();
                                    setState(() {
                                  index = 8;
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                               HomeScreen(
                                                  cname: widget.cname, cr: widget.cr+crDialog, id: widget.id)));
                                });
                                  },
                                )
                              ],
                            );
                          },
                        );
                      },
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      child: const Text('Credit Returned'),
                      onPressed: () {
                        
                        showDialog<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Return CR'),
                              content: SizedBox(
                                width: size.width * 0.3,
                                height: size.height * 0.25,
                                child: Form(
                                  child: TextFormField(
                                    controller: cr,
                                    decoration: const InputDecoration(
                                      hintText: 'CR',
                                    ),
                                    onChanged: (val) {
                                      setState(() {
                                        crDialog = int.parse(val.trim());
                                      });
                                    },
                                  ),
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                    child: const Text('Cancel',
                                        style: TextStyle(color: Colors.red)),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    }),
                                TextButton(
                                  child: const Text('Save'),
                                  onPressed: () async {
                                    if (cr.text.isNotEmpty) {
                                      customerRef
                                          .document(widget.id)
                                          .collection('cr')
                                          .add({
                                        'date': date,
                                        'cr': crDialog,
                                        'status': false,
                                      }).then((value) {
                                        customerRef
                                          .document(widget.id).update({'cr': (widget.cr -crDialog).abs()});
                                           pos
                                    .document('Cash Rs')
                                    .set({'cash': (cashRs + crDialog)});
                                      });

                                      setState(() {
                                        crerror='';
                                        getDetails(0);
                                        getInvoices(0);
                                      });
                                    }
                                    cr.clear();
                                    Navigator.of(context).pop();
                                    setState(() {
                                      
                                  index = 8;
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                               HomeScreen(
                                                  cname: widget.cname, cr: (widget.cr-crDialog).abs(), id: widget.id)));
                                });
                                  },
                                )
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.cname,
                      style: TextStyle(
                          fontSize: fsize20, fontWeight: FontWeight.w600),
                    ),
                    RichText(
                      text: TextSpan(
                        text: '',
                        style: DefaultTextStyle.of(context).style,
                        children: <TextSpan>[
                          const TextSpan(text: 'You will get: '),
                          TextSpan(
                              text: 'Rs. ${widget.cr}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.red,
                                  fontSize: 16)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                SizedBox(
                  width: size.width * 0.35,
                  height: size.height * 0.68,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('CR',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w600)),
                          custDetails.isEmpty
                              ? crerror != ''
                                  ? Expanded(
                                      child: Center(child: Text(crerror)))
                                  : Expanded(
                                      child: Center(
                                        child: SpinKitWave(
                                          size: size.height * 0.035,
                                          color: black,
                                        ),
                                      ),
                                    )
                              : Expanded(
                                  child: ListView(
                                    controller: ScrollController(),
                                    shrinkWrap: true,
                                    children: [
                                      DataTable(
                                          columns: const [
                                            DataColumn(
                                                label: Flexible(
                                                    fit: FlexFit.loose,
                                                    child: Text('Date',
                                                        softWrap: false,
                                                        overflow: TextOverflow
                                                            .ellipsis))),
                                            DataColumn(
                                                label: Flexible(
                                                    fit: FlexFit.loose,
                                                    child: Text('Remaining',
                                                        softWrap: false,
                                                        overflow: TextOverflow
                                                            .ellipsis))),
                                            DataColumn(
                                                label: Flexible(
                                                    fit: FlexFit.loose,
                                                    child: Text('You Got',
                                                        softWrap: false,
                                                        overflow: TextOverflow
                                                            .ellipsis))),
                                          ],
                                          rows: custDetails
                                              .map((item) => DataRow(cells: [
                                                    DataCell(Text(item.date)),
                                                    DataCell(item.status
                                                        ? Text('Rs. ${item.cr}',
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .red))
                                                        : const Text('-')),
                                                    DataCell(item.status ==
                                                            false
                                                        ? Text('Rs. ${item.cr}',
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .green))
                                                        : const Text('-'))
                                                  ]))
                                              .toList())
                                    ],
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: size.width * 0.46,
                  height: size.height * 0.68,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Invoices',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w600)),
                          ivoices.isEmpty
                              ? error != ''
                                  ? Expanded(child: Center(child: Text(error)))
                                  : Expanded(
                                      child: Center(
                                        child: SpinKitWave(
                                          size: size.height * 0.035,
                                          color: black,
                                        ),
                                      ),
                                    )
                              : Expanded(
                                  child: ListView.builder(
                                    controller: ScrollController(),
                                    shrinkWrap: true,
                                    itemCount: ivoices.length,
                                    itemBuilder: (BuildContext context, int j) {
                                      return Column(
                                        children: [
                                          Card(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      RichText(
                                                        text: TextSpan(
                                                          text: '',
                                                          style: DefaultTextStyle
                                                                  .of(context)
                                                              .style,
                                                          children: <TextSpan>[
                                                            const TextSpan(
                                                                text:
                                                                    'Invoice # :  ',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600)),
                                                            TextSpan(
                                                                text:
                                                                    '${ivoices[j].invo}'),
                                                          ],
                                                        ),
                                                      ),
                                                      RichText(
                                                        text: TextSpan(
                                                          text: '',
                                                          style: DefaultTextStyle
                                                                  .of(context)
                                                              .style,
                                                          children: <TextSpan>[
                                                            const TextSpan(
                                                                text:
                                                                    'Date :  ',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600)),
                                                            TextSpan(
                                                                text: ivoices[j]
                                                                    .date),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      RichText(
                                                        text: TextSpan(
                                                          text: '',
                                                          style: DefaultTextStyle
                                                                  .of(context)
                                                              .style,
                                                          children: <TextSpan>[
                                                            const TextSpan(
                                                                text:
                                                                    'Cust. Name :  ',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600)),
                                                            TextSpan(
                                                                text: ivoices[j]
                                                                    .cname),
                                                          ],
                                                        ),
                                                      ),
                                                      RichText(
                                                        text: TextSpan(
                                                          text: '',
                                                          style: DefaultTextStyle
                                                                  .of(context)
                                                              .style,
                                                          children: <TextSpan>[
                                                            const TextSpan(
                                                                text:
                                                                    'Net Total :  ',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600)),
                                                            TextSpan(
                                                                text:
                                                                    'Rs. ${myFormat.format(ivoices[j].netTotal)}'),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      RichText(
                                                        text: TextSpan(
                                                          text: '',
                                                          style: DefaultTextStyle
                                                                  .of(context)
                                                              .style,
                                                          children: <TextSpan>[
                                                            const TextSpan(
                                                                text:
                                                                    'T. Items :  ',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600)),
                                                            TextSpan(
                                                                text:
                                                                    '${ivoices[j].totalitems}'),
                                                          ],
                                                        ),
                                                      ),
                                                      Row(
                                                        children: [
                                                          RichText(
                                                            text: TextSpan(
                                                              text: '',
                                                              style: DefaultTextStyle
                                                                      .of(context)
                                                                  .style,
                                                              children: <
                                                                  TextSpan>[
                                                                const TextSpan(
                                                                    text:
                                                                        'Cash :  ',
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.w600)),
                                                                TextSpan(
                                                                    text:
                                                                        '${ivoices[j].cash}'),
                                                              ],
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width: 20),
                                                          RichText(
                                                            text: TextSpan(
                                                              text: '',
                                                              style: DefaultTextStyle
                                                                      .of(context)
                                                                  .style,
                                                              children: <
                                                                  TextSpan>[
                                                                const TextSpan(
                                                                    text:
                                                                        'CR :  ',
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.w600)),
                                                                TextSpan(
                                                                    text:
                                                                        '${ivoices[j].cr}'),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                      height: 20,
                                                      child: Divider()),
                                                  Row(
                                                    children: [
                                                      SizedBox(
                                                          width: size.width *
                                                              0.013,
                                                          child: const Text('#',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600))),
                                                      SizedBox(
                                                          width:
                                                              size.width * 0.04,
                                                          child: const Text(
                                                              'Inv. #',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600))),
                                                      SizedBox(
                                                          width:
                                                              size.width * 0.09,
                                                          child: const Text(
                                                              'Items',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600))),
                                                      SizedBox(
                                                          width:
                                                              size.width * 0.07,
                                                          child: const Text(
                                                              'Qty',
                                                              textAlign:
                                                                  TextAlign.end,
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600))),
                                                      SizedBox(
                                                          width:
                                                              size.width * 0.07,
                                                          child: const Text(
                                                              'Per Price',
                                                              textAlign:
                                                                  TextAlign.end,
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600))),
                                                      SizedBox(
                                                          width:
                                                              size.width * 0.12,
                                                          child: const Text(
                                                              'Total',
                                                              textAlign:
                                                                  TextAlign.end,
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600))),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 6),
                                                  for (int i = 0;
                                                      i <
                                                          ivoices[j]
                                                              .invoiceitems
                                                              .length;
                                                      i++)
                                                    Row(
                                                      children: [
                                                        SizedBox(
                                                            width: size.width *
                                                                0.013,
                                                            child: Text(
                                                                '${i + 1}')),
                                                        SizedBox(
                                                            width: size.width *
                                                                0.04,
                                                            child: Text(ivoices[
                                                                    j]
                                                                .invoiceitems[i]
                                                                .ino)),
                                                        SizedBox(
                                                            width: size.width *
                                                                0.09,
                                                            child: Text(ivoices[
                                                                    j]
                                                                .invoiceitems[i]
                                                                .iname)),
                                                        SizedBox(
                                                            width: size.width *
                                                                0.07,
                                                            child: Text(
                                                                '${ivoices[j].invoiceitems[i].isold}',
                                                                textAlign:
                                                                    TextAlign
                                                                        .end)),
                                                        SizedBox(
                                                            width: size.width *
                                                                0.07,
                                                            child: Text(
                                                                '${ivoices[j].invoiceitems[i].iPrice}',
                                                                textAlign:
                                                                    TextAlign
                                                                        .end)),
                                                        SizedBox(
                                                            width: size.width *
                                                                0.12,
                                                            child: Text(
                                                                'Rs. ${myFormat.format(ivoices[j].invoiceitems[i].totalsold)}',
                                                                textAlign:
                                                                    TextAlign
                                                                        .end)),
                                                      ],
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                            child: Divider(
                                              thickness: 5,
                                            ),
                                          )
                                        ],
                                      );
                                    },
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                ),

              ],
            ),
            Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: SizedBox(
              width: size.width * 0.75,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  RichText(
                    text: TextSpan(
                      text: '',
                      style: DefaultTextStyle.of(context).style,
                      children: <TextSpan>[
                        const TextSpan(
                            text: 'Total Payment:  ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: ' Rs. ${myFormat.format(paymentTotal)}'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          ],
        ),
      ),
    );
  }
}

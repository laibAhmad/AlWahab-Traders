import 'dart:async';
import 'package:firedart/firestore/firestore.dart';
import 'package:firedart/firestore/models.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:inventory_system/constants.dart';
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Models/data.dart';
import '../home.dart';

class NewSale extends StatefulWidget {
  const NewSale({Key? key}) : super(key: key);

  @override
  State<NewSale> createState() => _NewSaleState();
}

class _NewSaleState extends State<NewSale> {
  TextEditingController id = TextEditingController();
  TextEditingController cn = TextEditingController();
  TextEditingController inText = TextEditingController();
  TextEditingController pricePerUnit = TextEditingController();
  TextEditingController totalItems = TextEditingController();

  TextEditingController dis = TextEditingController();
  TextEditingController cash = TextEditingController();
  TextEditingController bank = TextEditingController();
  TextEditingController cr = TextEditingController();
  TextEditingController bankcr = TextEditingController();
  TextEditingController cashbank = TextEditingController();
  TextEditingController cashcr = TextEditingController();

  String selected = '';
  int serial = 0;

  bool showCart = false;

  List<InStockData> itemsList = [];
  List<InStockData> typeText = [];
  List<InStockData> selectedItems = [];
  List<CartList> cartItems = [];

  int newp = 0;
  int discount = 0;
  int saleitems = 0;
  String name = '';
  int inStock = 0;
  String uid = '';
  String date = DateFormat('dd-MM-yyyy').format(DateTime.now());
  String error = '';

  String custname = '';

  String cname = '';
  int selectedIndex = -1;

  int qty = 0;
  int netTotal = 0;
  bool select = false;

  int cashRs = 0;
  int crRs = 0;
  int bankRs = 0;
  String pay = 'Cash';

  String search = 'Choose search by';

  String dropdownValue = 'One';

  getInvoice() {
    if (invoiceNo == null) {
      setState(() {
        invoiceNo = 1;
      });
    } else if (invoiceNo != null && invoiceNo! < 101) {
      setState(() {
        invoiceNo = invoiceNo!;
      });
    } else if (invoiceNo! == 100) {
      setState(() {
        invoiceNo = 1;
      });
    }
    return invoiceNo;
  }

  getTotalQty() {
    qty = 0;
    for (var i = 0; i < cartItems.length; i++) {
      setState(() {
        qty = qty + cartItems[i].saleItems;
      });
    }
    return qty;
  }

  getTotalPrice() {
    netTotal = 0;
    for (var i = 0; i < cartItems.length; i++) {
      setState(() {
        netTotal = netTotal + cartItems[i].totalP;
      });
    }
    return netTotal;
  }

  Future<List<Printer>> findPrinters() async {
    var v = await Printing.listPrinters();

    await Printing.listPrinters().asStream().forEach((element) {
      for (var e in element) {
        if (e.model!.contains('SGT-88IVENG')) {
          l = e;
        }
      }
    });
    return v;
  }

  bool load = false;

  @override
  void initState() {
    findPrinters();
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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Container(
        //   padding: const EdgeInsets.fromLTRB(15, 0, 0, 10),
        //   decoration: BoxDecoration(color: grey),
        //   width: size.width * 0.85,
        //   height: size.height * 0.1,
        //   alignment: Alignment.bottomLeft,
        //   child: Text(
        //     'New Sale',
        //     style: TextStyle(fontWeight: bold, fontSize: size.width * 0.02),
        //   ),
        // ),
        Row(
          children: [
            SizedBox(
              width: size.width * 0.5,
              height: size.height * 0.9,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: size.height * 0.05,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Invoice #  00${getInvoice() + 1}',
                            style: TextStyle(fontSize: fsize15),
                          ),
                          Text(
                            date,
                            style: TextStyle(fontSize: fsize15),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.17,
                      height: size.height * 0.08,
                      child: TextFormField(
                        controller: cn,
                        decoration: InputDecoration(
                          label: Text(
                            'Customer Name',
                            style: TextStyle(color: black),
                          ),
                        ),
                        onChanged: (val) {
                          setState(() {
                            custname = val;
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.6,
                      height: size.height * 0.07,
                      child: Row(
                        children: [
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
                                pricePerUnit.clear();
                                totalItems.clear();
                                inText.clear();

                                search = newValue!;
                              });
                            },
                            items: <String>[
                              'Choose search by',
                              'ID of items',
                              'Name of Item'
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                          SizedBox(
                            width: size.width * 0.05,
                          ),
                          search == 'Choose search by'
                              ? Container()
                              : search == 'ID of items'
                                  ? SizedBox(
                                      width: size.width * 0.17,
                                      child: TextFormField(
                                        controller: inText,
                                        decoration: InputDecoration(
                                          label: Text(
                                            'Search by ID',
                                            style: TextStyle(color: black),
                                          ),
                                        ),
                                        onChanged: (val) {
                                          typeText.clear();

                                          setState(() {
                                            cname = val;
                                            select = false;

                                            for (var i = 0;
                                                i < itemsList1.length;
                                                i++) {
                                              if (itemsList1[i]
                                                  .uid
                                                  .toLowerCase()
                                                  .contains(
                                                      val.toLowerCase())) {
                                                InStockData list = InStockData(
                                                    uid: itemsList1[i].uid,
                                                    date: itemsList1[i].date,
                                                    name: itemsList1[i].name,
                                                    total: itemsList1[i].total,
                                                    pp: itemsList1[i].pp,
                                                    items: itemsList1[i].items,
                                                    index: itemsList1[i].index,
                                                    id: itemsList1[i].id);

                                                typeText.add(list);
                                                typeText.sort((a, b) {
                                                  return a.name
                                                      .toString()
                                                      .toLowerCase()
                                                      .compareTo(b.name
                                                          .toString()
                                                          .toLowerCase());
                                                });
                                              }
                                            }
                                          });
                                        },
                                      ),
                                    )
                                  : SizedBox(
                                      width: size.width * 0.17,
                                      child: TextFormField(
                                        controller: inText,
                                        decoration: InputDecoration(
                                          label: Text(
                                            'Search by Name',
                                            style: TextStyle(color: black),
                                          ),
                                        ),
                                        onChanged: (val) {
                                          // typeText.clear();

                                          setState(() {
                                            typeText.clear();
                                            cname = val;
                                            select = false;
                                            for (var i = 0;
                                                i < itemsList1.length;
                                                i++) {
                                              if (itemsList1[i]
                                                  .name
                                                  .toLowerCase()
                                                  .contains(
                                                      val.toLowerCase())) {
                                                InStockData list = InStockData(
                                                    uid: itemsList1[i].uid,
                                                    date: itemsList1[i].date,
                                                    name: itemsList1[i].name,
                                                    total: itemsList1[i].total,
                                                    pp: itemsList1[i].pp,
                                                    items: itemsList1[i].items,
                                                    index: itemsList1[i].index,
                                                    id: itemsList1[i].id);

                                                typeText.add(list);

                                                typeText.sort((a, b) {
                                                  return a.name
                                                      .toString()
                                                      .toLowerCase()
                                                      .compareTo(b.name
                                                          .toString()
                                                          .toLowerCase());
                                                });
                                              }
                                            }
                                          });
                                        },
                                      ),
                                    ),
                        ],
                      ),
                    ),
                    inText.text.isEmpty
                        ? SizedBox(
                            height: size.height * 0.6,
                          )
                        : !select
                            ? SizedBox(
                                height: size.height * 0.6,
                                child: ListView.builder(
                                    itemCount: typeText.length,
                                    itemBuilder: (BuildContext context, int i) {
                                      return InkWell(
                                        onTap: () {
                                          InStockData list = InStockData(
                                              uid: typeText[i].uid,
                                              date: typeText[i].date,
                                              name: typeText[i].name,
                                              total: typeText[i].total,
                                              pp: typeText[i].pp,
                                              items: typeText[i].items,
                                              index: typeText[i].index,
                                              id: typeText[i].id);

                                          selectedItems.add(list);

                                          setState(() {
                                            select = true;
                                            name = typeText[i].name;
                                            inStock = typeText[i].items;
                                          });
                                        },
                                        child: Column(
                                          children: [
                                            ListTile(
                                                leading: Text(typeText[i].uid),
                                                trailing: Text(
                                                  '${typeText[i].items} items In Stock',
                                                  style: TextStyle(
                                                      color: black,
                                                      fontSize: 15),
                                                ),
                                                title: Text(typeText[i].name)),
                                            const Divider(),
                                          ],
                                        ),
                                      );
                                    }),
                              )
                            : SizedBox(
                                height: size.height * 0.53,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: size.width * 0.01,
                                      vertical: size.height * 0.03),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: size.height * 0.04,
                                            child: RichText(
                                              text: TextSpan(
                                                text: '',
                                                style:
                                                    DefaultTextStyle.of(context)
                                                        .style,
                                                children: <TextSpan>[
                                                  const TextSpan(
                                                      text: 'Name of Item:  ',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  TextSpan(text: '   $name'),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(
                                                width: size.width * 0.25,
                                                child: TextFormField(
                                                  controller: totalItems,
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter
                                                        .digitsOnly
                                                  ],
                                                  decoration: InputDecoration(
                                                    label: Text(
                                                      'No. of Items',
                                                      style: TextStyle(
                                                          color: black),
                                                    ),
                                                  ),
                                                  onChanged: (val) {
                                                    if (int.parse(val) >
                                                        inStock) {
                                                      setState(() {
                                                        error =
                                                            'Only $inStock items are in-Stock. Please change the number.';
                                                      });
                                                    } else {
                                                      setState(() {
                                                        error = '';
                                                      });
                                                    }
                                                    setState(() {
                                                      saleitems =
                                                          int.parse(val.trim());
                                                    });
                                                  },
                                                ),
                                              ),
                                              SizedBox(
                                                width: size.width * 0.17,
                                                child: TextFormField(
                                                  controller: pricePerUnit,
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter
                                                        .digitsOnly
                                                  ],
                                                  decoration: InputDecoration(
                                                    label: Text(
                                                      'Price per peice',
                                                      style: TextStyle(
                                                          color: black),
                                                    ),
                                                  ),
                                                  onChanged: (val) {
                                                    setState(() {
                                                      newp =
                                                          int.parse(val.trim());
                                                    });
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          SizedBox(
                                            width: size.width * 0.8,
                                            child: Text(
                                                'Total Price: Rs. ${newp * saleitems}',
                                                style: TextStyle(
                                                    fontSize: fsize20),
                                                textAlign: TextAlign.end),
                                          ),
                                          SizedBox(
                                            width: size.width * 0.8,
                                            child: Text(error,
                                                style: const TextStyle(
                                                    color: Colors.red,
                                                    fontWeight:
                                                        FontWeight.w500),
                                                textAlign: TextAlign.center),
                                          ),
                                          const SizedBox(height: 10),
                                          SizedBox(
                                            width: size.width * 0.8,
                                            height: size.height * 0.05,
                                            child: ElevatedButton(
                                              onPressed: () async {
                                                if (newp != 0 &&
                                                    saleitems != 0 &&
                                                    cname != '' &&
                                                    int.parse(
                                                            totalItems.text) <=
                                                        inStock) {
                                                  setState(() {
                                                    serial = serial + 1;
                                                  });
                                                  CartList clist = CartList(
                                                      uid: selectedItems[0].uid,
                                                      date: DateTime.now()
                                                          .toString(),
                                                      cname: cname.trim(),
                                                      nameofItem:
                                                          selectedItems[0].name,
                                                      pp: selectedItems[0].pp,
                                                      totalP: newp * saleitems,
                                                      items: selectedItems[0]
                                                          .items,
                                                      newPrice: newp,
                                                      saleItems: saleitems,
                                                      payType: '',
                                                      cpay: 0,
                                                      cr: 0,
                                                      bpay: 0,
                                                      id: selectedItems[0].id);

                                                  cartItems.add(clist);
                                                  selectedItems.clear();

                                                  setState(() {
                                                    error = '';
                                                    pricePerUnit.clear();
                                                    totalItems.clear();
                                                    inText.clear();
                                                    showCart = true;
                                                  });
                                                  getTotalQty();
                                                  getTotalPrice();
                                                  pricePerUnit.clear();
                                                  totalItems.clear();
                                                } else {
                                                  setState(() {
                                                    error =
                                                        'Please fill all details carefully!';
                                                  });
                                                }
                                              },
                                              child: const Text("Enter"),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                  ],
                ),
              ),
            ),

            //cart section
            showCart
                ? Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        left: BorderSide(
                          width: 1.0,
                        ),
                      ),
                    ),
                    width: size.width * 0.35,
                    height: size.height * 0.9,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Cart',
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                DateFormat.yMMMEd().format(DateTime.now()),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: size.width * 0.33,
                            height: size.height * 0.4,
                            child: ListView(
                              children: [
                                DataTable(
                                    columnSpacing: size.width * 0.02,
                                    columns: const [
                                      DataColumn(
                                          label: Flexible(
                                              fit: FlexFit.loose,
                                              child: Text(
                                                'S#',
                                                softWrap: false,
                                                overflow: TextOverflow.ellipsis,
                                              ))),
                                      DataColumn(
                                          label: Flexible(
                                              fit: FlexFit.loose,
                                              child: Text(
                                                'Item',
                                                softWrap: false,
                                                overflow: TextOverflow.ellipsis,
                                              ))),
                                      DataColumn(
                                          label: Flexible(
                                              fit: FlexFit.loose,
                                              child: Text(
                                                'Qty',
                                                softWrap: false,
                                                overflow: TextOverflow.ellipsis,
                                              ))),
                                      DataColumn(
                                          label: Flexible(
                                              fit: FlexFit.loose,
                                              child: Text(
                                                'Rate',
                                                softWrap: false,
                                                overflow: TextOverflow.ellipsis,
                                              ))),
                                      DataColumn(
                                          label: Flexible(
                                              fit: FlexFit.loose,
                                              child: Text(
                                                'In Total',
                                                softWrap: false,
                                                overflow: TextOverflow.ellipsis,
                                              ))),
                                      DataColumn(label: Text(' ')),
                                    ],
                                    rows: cartItems
                                        .map((item) => DataRow(cells: [
                                              DataCell(Text(
                                                  '${cartItems.indexOf(item) + 1}')),
                                              DataCell(Text(item.nameofItem)),
                                              DataCell(
                                                TextFormField(
                                                  decoration:
                                                      const InputDecoration(
                                                    enabledBorder:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors
                                                              .transparent),
                                                    ),
                                                    focusedBorder:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors
                                                              .transparent),
                                                    ),
                                                    border:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors
                                                              .transparent),
                                                    ),
                                                  ),
                                                  initialValue:
                                                      item.saleItems.toString(),
                                                  onFieldSubmitted: (val) {
                                                    setState(() {
                                                      item.saleItems =
                                                          int.parse(val);

                                                      item.totalP =
                                                          int.parse(val) *
                                                              item.newPrice;
                                                    });
                                                    getTotalQty();
                                                    getTotalPrice();
                                                  },
                                                ),
                                              ),
                                              DataCell(
                                                TextFormField(
                                                  decoration:
                                                      const InputDecoration(
                                                    enabledBorder:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors
                                                              .transparent),
                                                    ),
                                                    focusedBorder:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors
                                                              .transparent),
                                                    ),
                                                    border:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors
                                                              .transparent),
                                                    ),
                                                  ),
                                                  initialValue:
                                                      item.newPrice.toString(),
                                                  onFieldSubmitted: (val) {
                                                    setState(() {
                                                      item.newPrice =
                                                          int.parse(val);
                                                      item.totalP =
                                                          int.parse(val) *
                                                              item.saleItems;
                                                    });
                                                    getTotalPrice();
                                                    // getTotalQty();
                                                  },
                                                ),
                                              ),
                                              DataCell(
                                                Text('${item.totalP}'),
                                              ),
                                              // DataCell(Text('${item.totalP}')),
                                              DataCell(IconButton(
                                                icon: Icon(
                                                  Icons.delete,
                                                  color: red,
                                                ),
                                                onPressed: () {
                                                  cartItems.remove(item);
                                                  setState(() {
                                                    showCart = true;
                                                  });
                                                  getTotalPrice();
                                                  getTotalQty();
                                                },
                                              )),
                                            ]))
                                        .toList())
                              ],
                            ),
                          ),
                          SizedBox(
                            width: size.width * 0.33,
                            height: size.height * 0.05,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    text: '',
                                    style: DefaultTextStyle.of(context).style,
                                    children: <TextSpan>[
                                      const TextSpan(
                                          text: 'T Qty: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      TextSpan(text: ' $qty'),
                                    ],
                                  ),
                                ),
                                RichText(
                                  text: TextSpan(
                                    text: '',
                                    style: DefaultTextStyle.of(context).style,
                                    children: <TextSpan>[
                                      const TextSpan(
                                          text: 'G Total: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      TextSpan(text: ' $netTotal'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: size.width * 0.33,
                            height: size.height * 0.05,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const SizedBox(width: 2),
                                Row(
                                  children: [
                                    Text(
                                      'Discount: ',
                                      style: TextStyle(fontWeight: bold),
                                    ),
                                    SizedBox(
                                      width: size.width * 0.1,
                                      // height: 40,
                                      child: TextFormField(
                                        controller: dis,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        onChanged: (val) {
                                          setState(() {
                                            discount = int.parse(val);
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: size.width * 0.33,
                            height: size.height * 0.05,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const SizedBox(width: 2),
                                Row(
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        text: '',
                                        style:
                                            DefaultTextStyle.of(context).style,
                                        children: <TextSpan>[
                                          const TextSpan(
                                              text: 'Net Total: ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          TextSpan(
                                              text: ' ${netTotal - discount}'),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: size.width * 0.33,
                            height: size.height * 0.25,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Type: ',
                                      style: TextStyle(fontWeight: bold),
                                    ),
                                    DropdownButton<String>(
                                      value: pay,
                                      icon: const Icon(
                                          Icons.keyboard_arrow_down_rounded),
                                      style: TextStyle(color: black),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          pay = newValue!;
                                          bank.clear();
                                          bankcr.clear();
                                          bankRs = 0;
                                          cash.clear();
                                          cashbank.clear();
                                          cashcr.clear();
                                          cashRs = 0;
                                          cr.clear();
                                          crRs = 0;
                                        });
                                      },
                                      items: <String>[
                                        'Cash',
                                        'Bank',
                                        'CR',
                                        'Cash + Bank',
                                        'CR + Bank',
                                        'Cash + CR',
                                      ].map<DropdownMenuItem<String>>(
                                          (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                                Visibility(
                                  visible: pay == 'Cash' ? true : false,
                                  child: Row(
                                    children: [
                                      Text(
                                        'Cash: ',
                                        style: TextStyle(fontWeight: bold),
                                      ),
                                      SizedBox(
                                        width: size.width * 0.05,
                                        height: 40,
                                        child: TextFormField(
                                          controller: cash,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ],
                                          onChanged: (val) {
                                            setState(() {
                                              cashRs = int.parse(val);
                                              crRs = crRs;
                                              bankRs = bankRs;
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Visibility(
                                  visible: pay == 'Bank' ? true : false,
                                  child: Row(
                                    children: [
                                      Text(
                                        'In Bank: ',
                                        style: TextStyle(fontWeight: bold),
                                      ),
                                      SizedBox(
                                        width: size.width * 0.05,
                                        height: 40,
                                        child: TextFormField(
                                          controller: bank,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ],
                                          onChanged: (val) {
                                            setState(() {
                                              bankRs = int.parse(val);
                                              crRs = crRs;
                                              cashRs = cashRs;
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Visibility(
                                  visible: pay == 'CR' ? true : false,
                                  child: Row(
                                    children: [
                                      Text(
                                        'CR: ',
                                        style: TextStyle(fontWeight: bold),
                                      ),
                                      SizedBox(
                                        width: size.width * 0.05,
                                        height: 40,
                                        child: TextFormField(
                                          controller: cr,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ],
                                          onChanged: (val) {
                                            setState(() {
                                              crRs = int.parse(val);
                                              cashRs = cashRs;
                                              bankRs = bankRs;
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Visibility(
                                  visible: pay == 'Cash + Bank' ? true : false,
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            'Cash: ',
                                            style: TextStyle(fontWeight: bold),
                                          ),
                                          SizedBox(
                                            width: size.width * 0.05,
                                            height: 40,
                                            child: TextFormField(
                                              controller: cash,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .digitsOnly
                                              ],
                                              onChanged: (val) {
                                                setState(() {
                                                  cashRs = int.parse(val);
                                                  crRs = crRs;
                                                  bankRs = bankRs;
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'In Bank: ',
                                            style: TextStyle(fontWeight: bold),
                                          ),
                                          SizedBox(
                                            width: size.width * 0.05,
                                            height: 40,
                                            child: TextFormField(
                                              controller: bank,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .digitsOnly
                                              ],
                                              onChanged: (val) {
                                                setState(() {
                                                  bankRs = int.parse(val);
                                                  crRs = crRs;
                                                  cashRs = cashRs;
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Visibility(
                                  visible: pay == 'CR + Bank' ? true : false,
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            'CR: ',
                                            style: TextStyle(fontWeight: bold),
                                          ),
                                          SizedBox(
                                            width: size.width * 0.05,
                                            height: 40,
                                            child: TextFormField(
                                              controller: cr,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .digitsOnly
                                              ],
                                              onChanged: (val) {
                                                setState(() {
                                                  crRs = int.parse(val);
                                                  cashRs = cashRs;
                                                  bankRs = bankRs;
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'In Bank: ',
                                            style: TextStyle(fontWeight: bold),
                                          ),
                                          SizedBox(
                                            width: size.width * 0.05,
                                            height: 40,
                                            child: TextFormField(
                                              controller: bank,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .digitsOnly
                                              ],
                                              onChanged: (val) {
                                                setState(() {
                                                  bankRs = int.parse(val);
                                                  crRs = crRs;
                                                  cashRs = cashRs;
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Visibility(
                                  visible: pay == 'Cash + CR' ? true : false,
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            'Cash: ',
                                            style: TextStyle(fontWeight: bold),
                                          ),
                                          SizedBox(
                                            width: size.width * 0.05,
                                            height: 40,
                                            child: TextFormField(
                                              controller: cash,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .digitsOnly
                                              ],
                                              onChanged: (val) {
                                                setState(() {
                                                  cashRs = int.parse(val);
                                                  crRs = crRs;
                                                  bankRs = bankRs;
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'CR: ',
                                            style: TextStyle(fontWeight: bold),
                                          ),
                                          SizedBox(
                                            width: size.width * 0.05,
                                            height: 40,
                                            child: TextFormField(
                                              controller: cr,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .digitsOnly
                                              ],
                                              onChanged: (val) {
                                                setState(() {
                                                  crRs = int.parse(val);
                                                  cashRs = cashRs;
                                                  bankRs = bankRs;
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: size.width * 0.33,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  children: [
                                    ElevatedButton.icon(
                                        style: TextButton.styleFrom(
                                          backgroundColor: Colors.indigo[900],
                                          primary: Colors.white,
                                        ),
                                        onPressed: () {
                                          prints(
                                              l,
                                              context,
                                              invoiceNo!,
                                              cartItems,
                                              pay, //cash, cr , bank
                                              qty, //total q of items
                                              netTotal, //total amount
                                              discount,
                                              cashRs,
                                              crRs,
                                              bankRs,
                                              custname,
                                              false);
                                        },
                                        icon: const Icon(Icons.save_rounded),
                                        label: const Text('Save')),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    ElevatedButton.icon(
                                        style: TextButton.styleFrom(
                                          backgroundColor:
                                              Colors.lightGreen[900],
                                          primary: Colors.white,
                                        ),
                                        onPressed: () {
                                          prints(
                                              l,
                                              context,
                                              invoiceNo!,
                                              cartItems,
                                              pay, //cash, cr , bank
                                              qty, //total q of items
                                              netTotal, //total amount
                                              discount,
                                              cashRs,
                                              crRs,
                                              bankRs,
                                              custname,
                                              true);
                                        },
                                        icon: const Icon(Icons.print_rounded),
                                        label: const Text('Save & Print')),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                : SizedBox(
                    width: size.width * 0.25,
                    height: size.height * 0.8,
                  )
          ],
        ),
      ],
    );
  }
}

Future<void> prints(
  Printer? printer,
  BuildContext context,
  int invoice,
  List<CartList> cart,
  String pay,
  int qty,
  int netTotal,
  int discount,
  int cash,
  int cr,
  int bank,
  String cname,
  bool print,
) async {
  String? docId;

  int totalProfit = 0;
  //save to DataBase

  CollectionReference invo = Firestore.instance
      .collection("AWT")
      .document('inventory')
      .collection('invoices');

  CollectionReference pos = Firestore.instance
      .collection("AWT")
      .document('inventory')
      .collection('POS');

  await invo.add({
    'inovno': invoice,
    'customer': cname,
    'date': DateFormat.yMd().format(DateTime.now()),
    'netTotal': netTotal,
    'totalItems': qty,
    'payType': pay,
    'cashRs': cash,
    'crRs': cr,
    'bankRs': bank
  }).then((value) {
    docId = value.id;

    for (var i = 0; i < cart.length; i++) {
      invo.document(docId!).collection('items').add({
        'iNo': cart[i].uid,
        'iName': cart[i].nameofItem,
        'inewP': cart[i].newPrice,
        'iSaleItems': cart[i].saleItems,
        'total': cart[i].totalP,
      });

      ///minus number of items
      Firestore.instance
          .collection("AWT")
          .document('inventory')
          .collection('stock')
          .document(cart[i].id)
          .update({'totalItems': cart[i].items - cart[i].saleItems});

      totalProfit =
          cart[i].totalP - (cart[i].saleItems * cart[i].pp) - discount;
    }
    pos.document('Bank Rs').set({'bank': (bankRs + bank)});
    pos.document('Cash Rs').set({'cash': (cashRs + cash)});
    pos.document('CR Rs').set({'cr': (crRs + cr)});
    pos.document('Total Sales').set({'Total': (totalRs + netTotal)});
    pos.document('Profit').set({'Profit': (profit + totalProfit)});

    index = 0;
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const HomeScreen()));
  });

  final image = await imageFromAssetBundle('assets/img/black.png');

  NumberFormat myFormat = NumberFormat.decimalPattern('en_us');

  if (printer == null) return;

  final doc = pw.Document();
  const width = 2.83 * PdfPageFormat.inch;
  const height = 300.0 * PdfPageFormat.mm;
  const pageFormat = PdfPageFormat(width, height);

  final textStyle9 = pw.TextStyle(
    fontSize: 8.5,
    color: PdfColor.fromHex("#000000"),
  );

  final bold9 = pw.TextStyle(
    fontSize: 9.0,
    fontWeight: pw.FontWeight.bold,
    color: PdfColor.fromHex("#000000"),
  );

  final bold10 = pw.TextStyle(
    fontSize: 10.0,
    fontWeight: pw.FontWeight.bold,
    color: PdfColor.fromHex("#000000"),
  );

  final textStyle10 = pw.TextStyle(
    fontSize: 10.0,
    color: PdfColor.fromHex("#000000"),
  );

  final textStyle12 = pw.TextStyle(
    fontSize: 11.5,
    color: PdfColor.fromHex("#000000"),
  );

  final textStyle14 = pw.TextStyle(
    fontSize: 14.0,
    fontWeight: pw.FontWeight.bold,
    color: PdfColor.fromHex("#000000"),
  );

  if (print) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("invoiceNo", invoice);
    printReceipt(
        doc,
        pageFormat,
        image,
        textStyle14,
        textStyle10,
        textStyle12,
        bold10,
        invoice,
        cash,
        cr,
        bank,
        discount,
        pay,
        cname,
        bold9,
        cart,
        textStyle9,
        myFormat,
        qty,
        netTotal);

    var res = await Printing.directPrintPdf(
      printer: printer,
      onLayout: (_) => doc.save(),
      format: pageFormat,
      usePrinterSettings: true,
    );

    if (res) {
      debugPrint('Printed');
    } else {
      debugPrint('Error');
    }
  }
}

void printReceipt(
    pw.Document doc,
    PdfPageFormat pageFormat,
    pw.ImageProvider image,
    pw.TextStyle textStyle14,
    pw.TextStyle textStyle10,
    pw.TextStyle textStyle12,
    pw.TextStyle bold10,
    int invoice,
    int cash,
    int cr,
    int bank,
    int discount,
    String pay,
    String cname,
    pw.TextStyle bold9,
    List<CartList> cart,
    pw.TextStyle textStyle9,
    NumberFormat myFormat,
    int qty,
    int netTotal) {
  return doc.addPage(
    pw.Page(
      pageFormat: pageFormat,
      build: (pw.Context context) {
        return pw.Expanded(
          child: pw.Column(
            children: [
              pw.Center(child: pw.Image(image, height: 60)),
              pw.Center(child: pw.Text('AL-WAHAB TRADERS', style: textStyle14)),
              pw.Center(
                  child: pw.Text('Deals in Mobile Phone Pouch and Protector',
                      style: textStyle10)),
              pw.Center(child: pw.Text('\n', style: textStyle10)),
              pw.SizedBox(height: 5),
              pw.Center(
                  child: pw.Text('Shop#37,38 4th Floor Hassan Center,',
                      style: textStyle12)),
              pw.Center(
                  child: pw.Text('Hall Road, Lahore', style: textStyle12)),
              pw.Center(
                  child: pw.Text('0307-4506627 , 0307-4506662',
                      style: textStyle12)),
              pw.SizedBox(height: 3),
              pw.Center(child: pw.Text('SALE', style: textStyle12)),
              pw.Divider(),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text('Inv#:  ', style: bold10),
                          pw.Text('$invoice',
                              style: pw.TextStyle(
                                fontSize: 10.0,
                                color: PdfColor.fromHex("#000000"),
                              )),
                        ]),
                    pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text('Date:  ', style: bold10),
                          pw.Text(DateFormat('d/MMM/y').format(DateTime.now()),
                              style: textStyle10),
                        ]),
                  ]),
              pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Type:  ', style: bold10),
                    pw.Text('  ${pay.toUpperCase()}',
                        style: pw.TextStyle(
                          fontSize: 10.0,
                          background: pw.BoxDecoration(
                              color: PdfColor.fromHex('#FED000')),
                          color: PdfColor.fromHex("#000000"),
                        ))
                  ]),
              pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Customer:  ', style: bold10),
                    pw.Text('  $cname',
                        style: pw.TextStyle(
                          fontSize: 10.0,
                          color: PdfColor.fromHex("#000000"),
                        ))
                  ]),
              pw.SizedBox(height: 5),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.SizedBox(
                        width: 0.3 * PdfPageFormat.inch,
                        child: pw.Text('S#', style: bold9)),
                    pw.SizedBox(
                        width: 1.2 * PdfPageFormat.inch,
                        child: pw.Text('Item', style: bold9)),
                    pw.SizedBox(
                        width: 0.4 * PdfPageFormat.inch,
                        child: pw.Text('Qty', style: bold9)),
                    pw.SizedBox(
                        width: 0.3 * PdfPageFormat.inch,
                        child: pw.Text('Rate',
                            style: bold9, textAlign: pw.TextAlign.right)),
                    pw.SizedBox(
                        width: 0.5 * PdfPageFormat.inch,
                        child: pw.Text('Total',
                            style: bold9, textAlign: pw.TextAlign.right))
                  ]),
              pw.SizedBox(height: 3),
              pw.Divider(),
              pw.ListView.separated(
                  itemCount: cart.length,
                  itemBuilder: (context, int i) {
                    return pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.SizedBox(
                              width: 0.3 * PdfPageFormat.inch,
                              child: pw.Text('${i + 1}', style: textStyle9)),
                          pw.SizedBox(
                              width: 1.2 * PdfPageFormat.inch,
                              child: pw.Text(cart[i].nameofItem.toUpperCase(),
                                  style: textStyle9)),
                          pw.SizedBox(
                              width: 0.4 * PdfPageFormat.inch,
                              child: pw.Text(' ${cart[i].saleItems}',
                                  style: textStyle9)),
                          pw.SizedBox(
                              width: 0.3 * PdfPageFormat.inch,
                              child: pw.Text(myFormat.format(cart[i].newPrice),
                                  style: textStyle9,
                                  textAlign: pw.TextAlign.right)),
                          pw.SizedBox(
                              width: 0.5 * PdfPageFormat.inch,
                              child: pw.Text(myFormat.format(cart[i].totalP),
                                  textAlign: pw.TextAlign.right,
                                  style: textStyle9)),
                        ]);
                  },
                  separatorBuilder: (context, int index) {
                    return pw.Divider(thickness: 0.2);
                  }),
              pw.Divider(thickness: 0.2),
              pw.SizedBox(height: 5),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('T Qty:  $qty', style: textStyle10),
                    pw.Text('G Total:  ${myFormat.format(netTotal)}',
                        style: textStyle10)
                  ]),

              pw.Align(
                  alignment: pw.Alignment.centerRight,
                  child: pw.Text('Discount:  ${myFormat.format(discount)}',
                      textAlign: pw.TextAlign.right, style: textStyle9)),

              pw.SizedBox(height: 5),
              pw.Align(
                  alignment: pw.Alignment.centerRight,
                  child: pw.Container(
                      decoration: pw.BoxDecoration(
                          border: pw.Border.all(
                              color: PdfColor.fromHex("#000000"))),
                      child: pw.Padding(
                          padding: const pw.EdgeInsets.all(4),
                          child: pw.Text('Net Total:  ${netTotal - discount}',
                              textAlign: pw.TextAlign.right,
                              style: textStyle9)))),

              ////////
              pw.SizedBox(height: 7),

              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Table(children: [
                  pw.TableRow(
                    children: [
                      pw.Text('Perivous Balance:      ',
                          textAlign: pw.TextAlign.right, style: bold9),
                      pw.Text(myFormat.format(0),
                          textAlign: pw.TextAlign.right, style: textStyle10)
                    ],
                  ),
                  pay.contains('Cash')
                      ? pw.TableRow(
                          children: [
                            pw.Text('Cash Received:     ',
                                textAlign: pw.TextAlign.right, style: bold9),
                            pw.Text(myFormat.format(cash),
                                textAlign: pw.TextAlign.right,
                                style: textStyle10)
                          ],
                        )
                      : const pw.TableRow(children: []),
                  pay.contains('Bank')
                      ? pw.TableRow(
                          children: [
                            pw.Text('Amount In Bank:     ',
                                textAlign: pw.TextAlign.right, style: bold9),
                            pw.Text(myFormat.format(bank),
                                textAlign: pw.TextAlign.right,
                                style: textStyle10)
                          ],
                        )
                      : const pw.TableRow(children: []),
                  pay.contains('CR')
                      ? pw.TableRow(
                          children: [
                            pw.Text('Credit:     ',
                                textAlign: pw.TextAlign.right, style: bold9),
                            pw.Text(myFormat.format(cr),
                                textAlign: pw.TextAlign.right,
                                style: textStyle10)
                          ],
                        )
                      : const pw.TableRow(children: []),
                  pw.TableRow(
                    children: [
                      pw.Text('Current Balance:     ',
                          textAlign: pw.TextAlign.right, style: bold9),
                      pw.Text('${netTotal - discount}',
                          textAlign: pw.TextAlign.right, style: textStyle10)
                    ],
                  ),
                ]),
              )
            ],
          ),
        );
      },
    ),
  );
}

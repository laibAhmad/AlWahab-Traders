import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../Models/data.dart';
import '../constants.dart';
import '../home.dart';

class InStock extends StatefulWidget {
  const InStock({Key? key}) : super(key: key);

  @override
  State<InStock> createState() => _InStockState();
}

class _InStockState extends State<InStock> {
  String error = '';

  bool load = false;
  String op = 'edit';

  List<InStockData> itemsList = [];

  TextEditingController id = TextEditingController();
  TextEditingController itemName = TextEditingController();
  TextEditingController pricePerUnit = TextEditingController();
  TextEditingController totalItems = TextEditingController();

  // Future<List<Printer>> findPrinters() async {
  //   var l = await Printing.listPrinters();

  //   print(l.first);
  //   prints(l.first);
  //   return l;
  // }

  @override
  void initState() {
    itemsList1.clear();
    // findPrinters();

    getData();

    super.initState();
  }

  Future<List<InStockData>> getData() async {
    indexList = indexList - 1;
    await ref.get().asStream().forEach((element) {
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

    return SizedBox(
      height: size.height * 0.98,
      width: size.width * 0.85,
      child: Padding(
        padding: EdgeInsets.all(size.width * 0.02),
        child: itemsList.isEmpty
            ? error != ''
                ? Center(child: Text(error))
                : Center(
                    child: SpinKitWave(
                      size: size.height * 0.035,
                      color: black,
                    ),
                  )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Categories: ${itemsList1.length}',
                        style: TextStyle(
                            fontSize: fsize20, fontWeight: FontWeight.w600),
                      ),
                      load
                          ? Row(
                              children: const [
                                Text('Deleting'),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: SpinKitCircle(
                                      size: 30, color: Colors.blue),
                                )
                              ],
                            )
                          : op != 'edit'
                              ? Row(
                                  children: const [
                                    Text('Edited'),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 8),
                                      child: Icon(
                                        Icons.check_circle,
                                        color: Colors.green,
                                      ),
                                    )
                                  ],
                                )
                              : Container()
                    ],
                  ),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        // createDataTable()
                        DataTable(
                            columns: const [
                              DataColumn(
                                  label: Flexible(
                                      fit: FlexFit.loose,
                                      child: Text(
                                        'Date',
                                        softWrap: false,
                                        overflow: TextOverflow.ellipsis,
                                      ))),
                              DataColumn(
                                  label: Flexible(
                                      fit: FlexFit.loose,
                                      child: Text(
                                        'ID',
                                        softWrap: false,
                                        overflow: TextOverflow.ellipsis,
                                      ))),
                              DataColumn(
                                  label: Flexible(
                                      fit: FlexFit.loose,
                                      child: Text(
                                        'Name',
                                        softWrap: false,
                                        overflow: TextOverflow.ellipsis,
                                      ))),
                              DataColumn(
                                  label: Flexible(
                                      fit: FlexFit.loose,
                                      child: Text(
                                        'Purchasing Price',
                                        softWrap: false,
                                        overflow: TextOverflow.ellipsis,
                                      ))),
                              DataColumn(
                                  label: Flexible(
                                      fit: FlexFit.loose,
                                      child: Text(
                                        'In Stock',
                                        softWrap: false,
                                        overflow: TextOverflow.ellipsis,
                                      ))),
                              DataColumn(
                                  label: Flexible(
                                      fit: FlexFit.loose,
                                      child: Text(
                                        'Total Price',
                                        softWrap: false,
                                        overflow: TextOverflow.ellipsis,
                                      ))),
                              DataColumn(
                                  label: Flexible(
                                      fit: FlexFit.loose,
                                      child: Text(
                                        'Delete',
                                        softWrap: false,
                                        overflow: TextOverflow.ellipsis,
                                      ))),
                            ],
                            rows: itemsList1
                                .map((item) => DataRow(cells: [
                                      DataCell(Text(item.date)),
                                      DataCell(
                                        TextFormField(
                                          decoration: const InputDecoration(
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.transparent),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.transparent),
                                            ),
                                            border: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.transparent),
                                            ),
                                          ),
                                          initialValue: item.uid,
                                          onFieldSubmitted: (val) {
                                            setState(() {
                                              op = '';
                                            });
                                            ref.document(item.id).update({
                                              'id': val,
                                            });
                                            Timer(const Duration(seconds: 3),
                                                () {
                                              setState(() {
                                                op = 'edit';
                                              });
                                            });
                                          },
                                        ),
                                      ),
                                      DataCell(
                                        TextFormField(
                                          decoration: const InputDecoration(
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.transparent),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.transparent),
                                            ),
                                            border: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.transparent),
                                            ),
                                          ),
                                          initialValue: item.name,
                                          onFieldSubmitted: (val) {
                                            setState(() {
                                              op = '';
                                            });
                                            ref.document(item.id).update({
                                              'name': val,
                                            });
                                            Timer(const Duration(seconds: 3),
                                                () {
                                              setState(() {
                                                op = 'edit';
                                              });
                                            });
                                          },
                                        ),
                                      ),
                                      DataCell(
                                        TextFormField(
                                          decoration: const InputDecoration(
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.transparent),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.transparent),
                                            ),
                                            border: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.transparent),
                                            ),
                                          ),
                                          initialValue: item.pp.toString(),
                                          onFieldSubmitted: (val) {
                                            setState(() {
                                              op = '';
                                            });
                                            ref.document(item.id).update({
                                              'pricePerPiece':
                                                  int.parse(val.trim()),
                                              'price': item.items *
                                                  int.parse(val.trim())
                                            }).then((value) {
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const HomeScreen()));
                                            });
                                            Timer(const Duration(seconds: 3),
                                                () {
                                              setState(() {
                                                op = 'edit';
                                              });
                                            });
                                          },
                                        ),
                                      ),
                                      DataCell(
                                        TextFormField(
                                          decoration: const InputDecoration(
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.transparent),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.transparent),
                                            ),
                                            border: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.transparent),
                                            ),
                                          ),
                                          initialValue: item.items.toString(),
                                          onFieldSubmitted: (val) {
                                            setState(() {
                                              op = '';
                                            });
                                            ref.document(item.id).update({
                                              'totalItems':
                                                  int.parse(val.trim()),
                                              'price': item.pp *
                                                  int.parse(val.trim())
                                            }).then((value) {
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const HomeScreen()));
                                            });
                                            Timer(const Duration(seconds: 3),
                                                () {
                                              setState(() {
                                                op = 'edit';
                                              });
                                            });
                                          },
                                        ),
                                      ),
                                      DataCell(Text('Rs. ${item.total}')),
                                      DataCell(Row(
                                        children: [
                                          IconButton(
                                              onPressed: () async {
                                                setState(() {
                                                  load = true;
                                                });
                                                await ref
                                                    .document(item.id)
                                                    .delete()
                                                    .then((value) {
                                                  setState(() {
                                                    load = false;

                                                    Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                const HomeScreen()));
                                                  });
                                                });
                                              },
                                              icon: Icon(
                                                Icons.delete,
                                                color: red,
                                              )),
                                        ],
                                      )),
                                    ]))
                                .toList())
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

Future<void> prints(Printer? printer) async {
  final image = await imageFromAssetBundle('assets/img/black.png');

  if (printer == null) return;

  final doc = pw.Document();
  const width = 2.83 * PdfPageFormat.inch;
  const height = 300.0 * PdfPageFormat.mm;
  const pageFormat = PdfPageFormat(width, height);

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
    color: PdfColor.fromHex("#000000"),
  );

  doc.addPage(
    pw.Page(
      pageFormat: pageFormat,
      build: (pw.Context context) {
        return pw.Expanded(
          child: pw.Column(
            children: [
              pw.Center(child: pw.Image(image)),
              pw.Center(child: pw.Text('AL-WAHAB TRADERS', style: textStyle14)),
              pw.Center(
                  child: pw.Text('Deals in Mobile Phone Pouch and Protector',
                      style: textStyle10)),
              pw.Center(child: pw.Text('\n', style: textStyle10)),
              pw.Center(
                  child: pw.Text('Shop#37,38 4th Floor Hassan Center,',
                      style: textStyle12)),

              pw.Center(
                  child: pw.Text('Hall Road, Lahore', style: textStyle12)),
              // pw.Center(child: pw.Text('Lahore', style: textStyle)),
              pw.Center(
                  child: pw.Text('0307-4506627 , 0307-4506662',
                      style: textStyle12)),
              pw.Center(child: pw.Text('SALE', style: textStyle12)),
              pw.Center(
                  child:
                      pw.Text('--------------------------------------------')),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Inv#: 001', style: textStyle10),
                    pw.Text('Date:  ${DateFormat.yMd().format(DateTime.now())}',
                        style: textStyle10),
                  ]),
              pw.Text('Type:  CASH', style: textStyle10),
              pw.Text('Testing', style: textStyle10),
            ],
          ),
        );
      },
    ),
  );

  await Printing.directPrintPdf(
    printer: printer,
    onLayout: (_) => doc.save(),
    format: pageFormat,
    usePrinterSettings: true,
  );

  // if (res) {
  //   Logger().i("Printed!");
  // } else {
  //   Logger().i("Error");
  // }
}

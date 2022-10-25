import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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

  @override
  void initState() {
    itemsList1.clear();

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
                                      DataCell(Text('${item.pp}')),
                                      DataCell(Text('${item.items}')),

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
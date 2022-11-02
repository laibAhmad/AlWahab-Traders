import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../Models/data.dart';
import '../constants.dart';

class CustomerDetails extends StatefulWidget {
  final String cname,id;
  final int cr;
  
  const CustomerDetails({Key? key,required this.cname,required this.cr,required this.id}) : super(key: key);

  @override
  State<CustomerDetails> createState() => _CustomerDetailsState();
}

class _CustomerDetailsState extends State<CustomerDetails> {
  
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
                        widget.cname,
                        style: TextStyle(
                            fontSize: fsize20, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        'Rs. ${widget.cr}',
                        style: TextStyle(
                            fontSize: fsize20, fontWeight: FontWeight.w600),
                      ),
                      
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
                                        'S#.',
                                        softWrap: false,
                                        overflow: TextOverflow.ellipsis,
                                      ))),
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
                                        'You Gave',
                                        softWrap: false,
                                        overflow: TextOverflow.ellipsis,
                                      ))),
                              DataColumn(
                                  label: Flexible(
                                      fit: FlexFit.loose,
                                      child: Text(
                                        'You Got',
                                        softWrap: false,
                                        overflow: TextOverflow.ellipsis,
                                      ))),
                            ],
                            rows: itemsList1
                                .map((item) => DataRow(cells: [
                                      DataCell(Text('${item.index+1}')),
                                      DataCell(Text(item.date)),
                                      DataCell(Text('${item.pp}')),
                                      DataCell(Text('${item.items}')),
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
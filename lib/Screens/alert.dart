import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../Models/data.dart';
import '../constants.dart';
import '../home.dart';

class AlertStock extends StatefulWidget {
  const AlertStock({Key? key}) : super(key: key);

  @override
  State<AlertStock> createState() => _AlertStockState();
}

class _AlertStockState extends State<AlertStock> {
 String error = '';

  bool load = false;
  String op = 'edit';

  List<InStockData> alertItems = [];

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
        if(element['totalItems']<=20){
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
        alertItems.add(list);
               getSortList();
        setState(() {});
        debugPrint('added');
     
        }
    
      }
    });
    return alertItems;
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
        child: alertItems.isEmpty
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
                        'Low in Stock',
                        style: TextStyle(
                            fontSize: fsize20, fontWeight: FontWeight.w600)
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
                            
                            ],
                            rows: alertItems
                                .map((item) => DataRow(cells: [
                                      DataCell(Text(item.date)),
                                      DataCell(Text(item.uid)),
                                      DataCell(Text(item.name)),
                                      DataCell(Text('${item.pp}')),
                                      DataCell(Text('${item.items}',style: TextStyle(fontSize: 18,fontWeight: bold),)),
                                      DataCell(Text('Rs. ${item.total}')),
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
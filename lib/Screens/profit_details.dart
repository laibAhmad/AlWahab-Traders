
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:inventory_system/constants.dart';

// import '../Models/data.dart';

// class ProfitDetails extends StatefulWidget {
//   const ProfitDetails({Key? key}) : super(key: key);

//   @override
//   State<ProfitDetails> createState() => _ProfitDetailsState();
// }


// class _ProfitDetailsState extends State<ProfitDetails> {
//   NumberFormat myFormat = NumberFormat.decimalPattern('en_us');

//   @override
//   void initState() {

//     getData();

//     super.initState();
//   }

//   List<ProfitData> profitList = [];

//   Future<List<InStockData>> getData() async {
//     await profitRef.get().asStream().forEach((element) {
//       for (var element in element) {
//         InStockData list = InStockData(
//             uid: element['id'],
//             date: element['date'],
//             name: element['name'],
//             total: element['price'],
//             pp: element['pricePerPiece'],
//             items: element['totalItems'],
//             index: indexList + 1,
//             id: element.id);

//         indexList = indexList + 1;
//         profitList.add(list);
//         getSortList();
//         setState(() {});
//       }
//     }).then((value) {
//       setState(() {
//         error='Nothing In-Stock';
//       });
//     });
//     getTotalExpense();

//     return itemsList;
//   }

//       int getTotalExpense() {
//     for (var i = 0; i < itemsList1.length; i++) {
//       setState(() {
//         totalExpense = totalExpense + (itemsList1[i].pp * itemsList1[i].items);
//       });
//     }
//     return totalExpense;
//   }

//   getSortList() {
//     itemsList1.sort((a, b) {
//       return a.name
//           .toString()
//           .toLowerCase()
//           .compareTo(b.name.toString().toLowerCase());
//     });
//   }


//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;


//     return SizedBox(
//       height: size.height * 0.98,
//       width: size.width * 0.85,
//       child: ListView.builder(itemBuilder: ),
//     );
//   }
// }
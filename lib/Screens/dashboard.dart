import 'package:firedart/firestore/firestore.dart';
import 'package:firedart/firestore/models.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:inventory_system/constants.dart';

import '../Models/data.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  CollectionReference pos = Firestore.instance
      .collection("AWT")
      .document('inventory')
      .collection('POS');

  NumberFormat myFormat = NumberFormat.decimalPattern('en_us');

  int today = 0;
  int week = 0;
  int month = 0;
  int year = 0;

  int todayPro = 0;
  int weekPro = 0;
  int monthPro = 0;
  int yearPro = 0;

  int todayNo = 0;
  int weekNo = 0;
  int monthNo = 0;
  int yearNo = 0;

  List<Invoices> invoiceList = [];

  @override
  void initState() {
    getInvoices();

    getPOSdate();

    super.initState();
  }

  Future<List<Invoices>> getInvoices() async {
    await Firestore.instance
        .collection("AWT")
        .document('inventory')
        .collection('invoices')
        .get()
        .asStream()
        .forEach((element) {
      for (var element in element) {
        Invoices list = Invoices(
            date: element['date'],
            id: element.id,
            bank: element['bankRs'],
            cash: element['cashRs'],
            cr: element['crRs'],
            netTotal: element['netTotal'],
            profit: element['profit']);

        invoiceList.add(list);

        setState(() {});
      }
    });
    getSalesActivity();
    return invoiceList;
  }

  getSalesActivity() {
    for (var i = 0; i < invoiceList.length; i++) {
      //today

      if (DateTime.now()
              .difference(DateFormat.yMd().parse(invoiceList[i].date))
              .inDays <=
          1) {
        setState(() {
          today = today + invoiceList[i].netTotal;
          todayPro=todayPro+invoiceList[i].profit;
          todayNo=todayNo+1;
        });
      }

//week
      if (DateTime.now()
              .difference(DateFormat.yMd().parse(invoiceList[i].date))
              .inDays <=
          7) {
        setState(() {
          week = week + invoiceList[i].netTotal;
          weekPro=weekPro+invoiceList[i].profit;
          weekNo=weekNo+1;
        });
      }

      //month
      if (DateTime.now()
              .difference(DateFormat.yMd().parse(invoiceList[i].date))
              .inDays <=
          30) {
        setState(() {
          month = month + invoiceList[i].netTotal;
          monthPro=monthPro+invoiceList[i].profit;
          monthNo=monthNo+1;
        });
      }

      //year
      if (DateTime.now()
              .difference(DateFormat.yMd().parse(invoiceList[i].date))
              .inDays <=
          365) {
        setState(() {
          year = year + invoiceList[i].netTotal;
          yearPro=yearPro+invoiceList[i].profit;
          yearNo=yearNo+1;
        });
      }
    }
  }

  getPOSdate() async {
    await pos.document('Bank Rs').get().asStream().forEach((element) {
      bankRs = element['bank'];
    });

    await pos.document('CR Rs').get().asStream().forEach((element) {
      crRs = element['cr'];
    });

    await pos.document('Cash Rs').get().asStream().forEach((element) {
      cashRs = element['cash'];
    });

    await pos.document('Profit').get().asStream().forEach((element) {
      profit = element['Profit'];
    });

    await pos.document('Total Sales').get().asStream().forEach((element) {
      totalRs = element['Total'];
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SizedBox(
      width: size.width * 0.85,
      height: size.height * 0.9,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
            shrinkWrap: true,
          children: [
            const Text(
              'Sales Overview',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            
            Container(
              width: size.width * 0.83,
              height: size.height * 0.3,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                border: Border.all(
                  color: Colors.grey.shade100,
                ),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                     SizedBox(
              width: size.width * 0.2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Today',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                          Row(children: [
                            Container(height: 45,
                            width: 45,
                            decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.15),
            
                  borderRadius: BorderRadius.circular(5.0),
                ),child: Center(child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.asset(sales,color: Colors.blue.shade400,),
                )),),const SizedBox(width: 10,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:   [
               const  Text('Total Sales',style: TextStyle(fontWeight: FontWeight.w400)),
                  Text('$todayNo',style: TextStyle(fontSize: size.width*0.02, fontWeight: FontWeight.w700)),
                ],)
                          ],),Row(children: [
                            Container(height: 45,
                            width: 45,
                            decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.15),
            
                  borderRadius: BorderRadius.circular(5.0),
                ),child: Center(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(earn,color: Colors.blue.shade400,),
                ))),const SizedBox(width: 10,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:   [
               const  Text('Earned',style: TextStyle(fontWeight: FontWeight.w400)),
                  Text('Rs. $today',style:  TextStyle(fontSize: size.width*0.02, fontWeight: FontWeight.w700)),
                ],)
                          ],),Row(children: [
                            Container(height: 45,
                            width: 45,
                            decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.15),
            
                  borderRadius: BorderRadius.circular(5.0),
                ),child: Center(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(profitimg,color: Colors.blue.shade400,),
                ))),const SizedBox(width: 10,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:   [
                const Text('Profit',style: TextStyle(fontWeight: FontWeight.w400)),
                  Text('Rs.$todayPro',style: TextStyle(fontSize: size.width*0.02, fontWeight: FontWeight.w700)),
                ],)
                          ],)
                        ],
                      ),
                    ),SizedBox(
              width: size.width * 0.2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('This Week',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                          Row(children: [
                            Container(height: 45,
                            width: 45,
                            decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.15),
            
                  borderRadius: BorderRadius.circular(5.0),
                ),child: Center(child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.asset(sales,color: Colors.green.shade400,),
                ))),const SizedBox(width: 10,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:   [
                const Text('Total Sales',style: TextStyle(fontWeight: FontWeight.w400)),
                  Text('$weekNo',style: TextStyle(fontSize: size.width*0.02, fontWeight: FontWeight.w700)),
                ],)
                          ],),Row(children: [
                            Container(height: 45,
                            width: 45,
                            decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.15),
            
                  borderRadius: BorderRadius.circular(5.0),
                ),child: Center(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(earn,color: Colors.green.shade400,),
                ))),const SizedBox(width: 10,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:   [
                const Text('Earned',style: TextStyle(fontWeight: FontWeight.w400)),
                  Text('Rs. $week',style:  TextStyle(fontSize: size.width*0.02, fontWeight: FontWeight.w700)),
                ],)
                          ],),Row(children: [
                            Container(height: 45,
                            width: 45,
                            decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.15),
            
                  borderRadius: BorderRadius.circular(5.0),
                ),child: Center(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(profitimg,color: Colors.green.shade400,),
                ))),const SizedBox(width: 10,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:   [
               const  Text('Profit',style: TextStyle(fontWeight: FontWeight.w400)),
                  Text('Rs. $weekPro',style: TextStyle(fontSize: size.width*0.02, fontWeight: FontWeight.w700)),
                ],)
                          ],)
                        ],
                      ),
                    ),SizedBox(
              width: size.width * 0.2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('This Month',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                          Row(children: [
                            Container(height: 45,
                            width: 45,
                            decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.15),
            
                  borderRadius: BorderRadius.circular(5.0),
                ),child: Center(child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.asset(sales,color: Colors.red.shade400,),
                ))),const SizedBox(width: 10,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:   [
                const Text('Total Sales',style: TextStyle(fontWeight: FontWeight.w400)),
                  Text('$monthNo',style:  TextStyle(fontSize: size.width*0.02, fontWeight: FontWeight.w700)),
                ],)
                          ],),Row(children: [
                            Container(height: 45,
                            width: 45,
                            decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.15),
            
                  borderRadius: BorderRadius.circular(5.0),
                ),child: Center(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(earn,color: Colors.red.shade400,),
                ))),const SizedBox(width: 10,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:   [
                const Text('Earned',style: TextStyle(fontWeight: FontWeight.w400)),
                  Text('Rs. $month',style:  TextStyle(fontSize: size.width*0.02, fontWeight: FontWeight.w700)),
                ],)
                          ],),Row(children: [
                            Container(height: 45,
                            width: 45,
                            decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.15),
            
                  borderRadius: BorderRadius.circular(5.0),
                ),child: Center(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(profitimg,color: Colors.red.shade400,),
                ))),const SizedBox(width: 10,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:   [
                const Text('Profit',style: TextStyle(fontWeight: FontWeight.w400)),
                  Text('Rs. $monthPro',style: TextStyle(fontSize: size.width*0.02, fontWeight: FontWeight.w700)),
                ],)
                          ],)
                        ],
                      ),
                    ),SizedBox(
              width: size.width * 0.2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('This Year',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                          Row(children: [
                            Container(height: 45,
                            width: 45,
                            decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.15),
            
                  borderRadius: BorderRadius.circular(5.0),
                ),child: Center(child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.asset(sales,color: Colors.purple.shade400,),
                ))),const SizedBox(width: 10,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:   [
                const Text('Total Sales',style: TextStyle(fontWeight: FontWeight.w400)),
                  Text('$yearNo',style:  TextStyle(fontSize: size.width*0.02, fontWeight: FontWeight.w700)),
                ],)
                          ],),Row(children: [
                            Container(height: 45,
                            width: 45,
                            decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.15),
            
                  borderRadius: BorderRadius.circular(5.0),
                ),child: Center(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(earn,color: Colors.purple.shade400,),
                ))),const SizedBox(width: 10,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:   [
                const Text('Earned',style: TextStyle(fontWeight: FontWeight.w400)),
                  Text('Rs. $year',style:  TextStyle(fontSize: size.width*0.02, fontWeight: FontWeight.w700)),
                ],)
                          ],),Row(children: [
                            Container(height: 45,
                            width: 45,
                            decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.15),
            
                  borderRadius: BorderRadius.circular(5.0),
                ),child: Center(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(profitimg,color: Colors.purple.shade400,),
                ))),const SizedBox(width: 10,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:   [
               const  Text('Profit',style: TextStyle(fontWeight: FontWeight.w400)),
                  Text('Rs. $yearPro',style: TextStyle(fontSize: size.width*0.02, fontWeight: FontWeight.w700)),
                ],)],)
                    ],
                  ),
                )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: size.width * 0.2,
              height: size.width * 0.3,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                border: Border.all(
                  color: Colors.grey.shade100,
                ),
                borderRadius: BorderRadius.circular(5.0),
              ),)
          ],
        ),
      ),
    );
  }
}

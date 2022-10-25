import 'package:firedart/firestore/firestore.dart';
import 'package:firedart/firestore/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';
import '../Models/data.dart';
import '../constants.dart';
import '../home.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({Key? key}) : super(key: key);

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  CollectionReference pos = Firestore.instance
      .collection("AWT")
      .document('inventory')
      .collection('POS');

  TextEditingController expenseName = TextEditingController();
  TextEditingController price = TextEditingController();

  NumberFormat myFormat = NumberFormat.decimalPattern('en_us');

  String expense = '';
  int spend = 0;

  int totalExpense = 0;

  String date = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String expenseDate = DateFormat('yMMM').format(DateTime.now());
  String expenseMonthNum = DateFormat('y-MM').format(DateTime.now());
  String error = '';

  String fielderror = '';

  DateTime? month;
  bool load = false;

  String search = 'Cash';

  List<Expenses> expenseItems = [];

  @override
  void initState() {
    getData(0);

    super.initState();
  }

  Future<List<Expenses>> getData(int n) async {
    expenseItems.clear();

    if (n == 0) {
      await expenseRef.get().asStream().forEach((element) {
        for (var element in element) {
          if ((element['date']).toString().contains(expenseMonthNum)) {
            Expenses list = Expenses(
                date: element['date'],
                expenseName: element['expense'],
                spentRs: element['spent'],
                spendfrom: element['spentFrom'],
                id: element.id);

            expenseItems.add(list);
            getSortList();
            getTotalExpense();
            setState(() {});
          }
        }
      }).whenComplete(() {
        if (expenseItems.isEmpty) {
          setState(() {
            error = 'No Data';
          });
        }
      });
    } else {
      await expenseRef.get().asStream().forEach((element) {
        for (var element in element) {
          Expenses list = Expenses(
              date: element['date'],
              expenseName: element['expense'],
              spentRs: element['spent'],
              spendfrom: element['spentFrom'],
              id: element.id);

          expenseItems.add(list);
          getSortList();
          getTotalExpense();
          setState(() {});
        }
      }).whenComplete(() {
        if (expenseItems.isEmpty) {
          setState(() {
            error = 'No Data';
          });
        }
      });
    }
    return expenseItems;
  }

  int getTotalExpense() {
    for (var i = 0; i < expenseItems.length; i++) {
      setState(() {
        totalExpense = totalExpense + expenseItems[i].spentRs;
      });
    }
    return totalExpense;
  }

  getSortList() {
    expenseItems.sort((a, b) {
      return b.date
          .toString()
          .toLowerCase()
          .compareTo(a.date.toString().toLowerCase());
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(15, 0, 0, 10),
            decoration: BoxDecoration(color: Colors.pink.withOpacity(0.15)),
            width: size.width * 0.85,
            height: size.height * 0.17,
            alignment: Alignment.bottomLeft,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Add Expense                   ',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
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

                          setState(() {
                            date =
                                formattedDate; //set output date to TextField value.
                          });
                        } else {}
                      },
                      child: Text(
                        date,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: size.width * 0.7,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: size.width * 0.23,
                        child: TextFormField(
                          controller: expenseName,
                          decoration: InputDecoration(
                            label: Text(
                              'Expense...',
                              style: TextStyle(color: black),
                            ),
                          ),
                          onChanged: (val) {
                            setState(() {
                              expense = val;
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        width: size.width * 0.2,
                        child: TextFormField(
                          controller: price,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                            label: Text(
                              'Rs. Spent',
                              style: TextStyle(color: black),
                            ),
                          ),
                          onChanged: (val) {
                            setState(() {
                              spend = int.parse(val.trim());
                            });
                          },
                        ),
                      ),
                      Row(
                        children: [
                          const Text('Spent From:   ',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold)),
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
                                search = newValue!;
                              });
                            },
                            items: <String>[
                              'Cash',
                              'Bank',
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: size.width * 0.07,
                        height: size.height * 0.05,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (expense != '' && spend != 0) {
                              setState(() {
                                load = true;
                              });
                              Firestore.instance
                                  .collection("AWT")
                                  .document('inventory')
                                  .collection('expenses')
                                  .add({
                                'expense': expense,
                                'date': date,
                                'spent': spend,
                                'spentFrom': search,
                              }).then((value) {
                                if (search == 'Cash') {
                                  pos
                                      .document('Cash Rs')
                                      .set({'cash': (cashRs - spend)});
                                } else {
                                  pos
                                      .document('Bank Rs')
                                      .set({'bank': (bankRs - spend)});
                                }
                                setState(() {
                                  load = false;
                                  index = 6;
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const HomeScreen()));
                                });
                              });
                              setState(() {
                                fielderror = '';
                              });
                            } else {
                              setState(() {
                                fielderror =
                                    'Please fill all details carefully!';
                              });
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              load
                                  ? SpinKitWave(
                                      size: size.height * 0.02, color: white)
                                  : const Text("Save"),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(fielderror),
              ],
            ),
          ),
          SizedBox(
              width: size.width * 0.85,
              height: size.height * 0.7,
              child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Text('Your Expenses of - '),
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
                                        DateFormat('yMMM').format(pickedDate);

                                    String numM =
                                        DateFormat('y-MM').format(pickedDate);
                                    setState(() {
                                      expenseDate = formattedDate;
                                      expenseMonthNum = numM;
                                      error = '';
                                      getData(0);
                                      totalExpense = 0;
                                      totalExpense = getTotalExpense();
                                    });
                                  } else {}
                                },
                                child: Text(
                                  expenseDate,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                expenseDate = 'Select Month';
                                getData(1);
                                totalExpense = 0;
                                totalExpense = getTotalExpense();
                              });
                            },
                            child: const Text(
                              'Want to see ALL Expenses? Click here...',
                              style: TextStyle(fontSize: 11),
                            ),
                          ),
                        ],
                      ),
                      expenseItems.isEmpty
                          ? error != ''
                              ? Center(child: Text(error))
                              : Center(
                                  child: SpinKitWave(
                                    size: size.height * 0.035,
                                    color: black,
                                  ),
                                )
                          : SizedBox(
                              width: size.width * 0.85,
                              height: size.height * 0.6,
                              child: ListView(
                                shrinkWrap: true,
                                children: [
                                  DataTable(
                                      columns: const [
                                        DataColumn(
                                            label: Flexible(
                                                fit: FlexFit.loose,
                                                child: Text(
                                                  'Date',
                                                  softWrap: false,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ))),
                                        DataColumn(
                                            label: Flexible(
                                                fit: FlexFit.loose,
                                                child: Text(
                                                  'Expense',
                                                  softWrap: false,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ))),
                                        DataColumn(
                                            label: Flexible(
                                                fit: FlexFit.loose,
                                                child: Text(
                                                  'Spent Rs',
                                                  softWrap: false,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ))),
                                        DataColumn(
                                            label: Flexible(
                                                fit: FlexFit.loose,
                                                child: Text(
                                                  'Spent From',
                                                  softWrap: false,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ))),
                                      ],
                                      rows: expenseItems
                                          .map((item) => DataRow(cells: [
                                                DataCell(Text(item.date)),
                                                DataCell(
                                                    Text(item.expenseName)),
                                                DataCell(
                                                    Text('${item.spentRs}')),
                                                DataCell(Text(
                                                  item.spendfrom,
                                                )),
                                              ]))
                                          .toList()),
                                ],
                              ),
                            ),
                    ],
                  ))),
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
                            text: 'Total Expenses:  ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: ' Rs. ${myFormat.format(totalExpense)}'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]);
  }

  Future<void> onPressed({
    required BuildContext context,
    String? locale,
  }) async {
    final localeObj = locale != null ? Locale(locale) : null;
    final selected = await showMonthYearPicker(
      context: context,
      initialDate: month ?? DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
      locale: localeObj,
    );
  
    if (selected != null) {
      setState(() {
        month = selected;
      });
    }
  }
}

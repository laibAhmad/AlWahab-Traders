import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import '../Models/data.dart';
import '../constants.dart';
import '../home.dart';

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({Key? key}) : super(key: key);

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {

  TextEditingController expenseName = TextEditingController();
  TextEditingController price = TextEditingController();

  TextEditingController cnameText = TextEditingController();
  TextEditingController cr = TextEditingController();

  TextEditingController controller = TextEditingController();

  NumberFormat myFormat = NumberFormat.decimalPattern('en_us');

  String cnameDialog = '';
  int crDialog = 0;

  String expense = '';
  int spend = 0;

  int pp = 0;
  int items = 0;
  String name = '';
  String uid = '';

  String date = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String invoiceDate = 'Select Month';
  String invoiceMonthNum = DateFormat('y-MM').format(DateTime.now());

  String error = '';

  bool load = false;
  bool buttonLoad = false;

  String search = 'Cash';

  List<Customers> customerList1 = [];

  Future<List<Customers>> getInvoices(int n) async {
    customerList1.clear();

    if (n == 0) {
      await customerRef.get().asStream().forEach((element) {
        for (var element in element) {
          if (((element['customer']).toString()).toLowerCase().contains((controller.text).toLowerCase())) {
            Customers list = Customers(
                customerName: element['customer'],
                cr: element['cr'],
                id: element.id);

            customerList1.add(list);

            setState(() {});
          }
        }
      }).whenComplete(() {
        if (customerList1.isEmpty) {
          setState(() {
            error = 'No Customers yet';
          });
        }
      });
    } else if (n == 1) {
      await customerRef.get().asStream().forEach((element) {
        for (var element in element) {
          Customers list = Customers(
              customerName: element['customer'],
              cr: element['cr'],
              id: element.id);

          customerList1.add(list);

          setState(() {});
        }
      }).whenComplete(() {
        if (customerList1.isEmpty) {
          setState(() {
            error = 'No Customers yet';
          });
        }
      });
    }
    // getInvoiceItems();
    getSortList();
    return customerList1;
  }

  @override
  void initState() {
    getInvoices(1);
    super.initState();
  }

  getSortList() {
    customerList1.sort((a, b) {
      return a.customerName
          .toString()
          .toLowerCase()
          .compareTo(b.customerName.toString().toLowerCase());
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
                Text('Customers:   ${customerList1.length}'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: size.width * 0.17,
                          height: size.height * 0.05,
                          child: TextFormField(
                            controller: controller,
                            decoration: const InputDecoration(
                              hintText: 'Search by Customer Name',
                            ),
                            onChanged: (val) {
                              setState(
                                () {
                                  error = '';
                                },
                              );
                              getInvoices(0);
                            },
                          ),
                        ),
                        TextButton(
                            onPressed: () {
                              if (controller.text.isNotEmpty) {
                                setState(
                                  () {
                                    error = '';
                                  },
                                );
                                getInvoices(0);
                              }
                            },
                            child: const Text('Search'))
                      ],
                    ),
                    ElevatedButton(
                        onPressed: () {
                          showDialog<void>(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Add Customer'),
                                content: SizedBox(
                                  width: size.width * 0.3,
                                  height: size.height * 0.25,
                                  child: Form(
                                    child: Column(
                                      children: [
                                        TextFormField(
                                          controller: cnameText,
                                          decoration: const InputDecoration(
                                            hintText: 'Customer Name',
                                          ),
                                          onChanged: (val) {
                                            setState(
                                              () {
                                                cnameDialog =
                                                    val.trim().toString();
                                              },
                                            );
                                          },
                                        ),
                                        TextFormField(
                                          controller: cr,
                                          decoration: const InputDecoration(
                                            hintText: 'CR',
                                          ),
                                          onChanged: (val) {
                                            setState(() {
                                              crDialog = int.parse(val.trim());
                                            });
                                          },
                                        )
                                      ],
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
                                      if (cnameText.text.isNotEmpty &&
                                          cr.text.isNotEmpty) {
                                        //add customer
                                      await  customerRef.add({
                                          'customer': cnameDialog,
                                          'cr': crDialog
                                        }).then((v) async {
                                            customerRef
                                                .document(v.id)
                                                .collection('cr')
                                                .add({
                                              'date': date,
                                              'cr': crDialog,
                                              'status': true,
                                            });
                                        });
                                        setState(() {
                                          error = '';
                                          getInvoices(1);
                                        });
                                      }
                                      cnameText.clear();
                                      cr.clear();
                                      Navigator.of(context).pop();
                                    },
                                  )
                                ],
                              );
                            },
                          );
                        },
                        child: const Text('Add New Customer'))
                  ],
                ),
                const SizedBox(height: 20),
                customerList1.isEmpty
                    ? error != ''
                        ? Center(child: Text(error))
                        : Center(
                            child: SpinKitWave(
                                size: size.height * 0.035, color: black),
                          )
                    : SizedBox(
                        width: size.width * 0.85,
                        height: (size.height * 0.73),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: customerList1.length,
                          itemBuilder: (BuildContext context, int i) {
                            return Row(
                              children: [
                                
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      index = 8;
                                    });

                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => HomeScreen(
                                                cname: customerList1[i]
                                                    .customerName,
                                                cr: customerList1[i].cr,
                                                id: customerList1[i].id)));
                                  },
                                  child: SizedBox(
                                    width: size.width*0.76,
                                    height: size.height*0.1,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        ListTile(
                                          leading: CircleAvatar(
                                            backgroundColor:
                                                Colors.deepPurple.withOpacity(0.2),
                                            foregroundColor: Colors.deepPurple,
                                            child: Center(
                                              child: Text(customerList1[i]
                                                  .customerName
                                                  .substring(0, 1)
                                                  .toUpperCase()),
                                            ),
                                          ),
                                          title: Text(
                                              customerList1[i].customerName,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w700)),
                                          trailing: Column(
                                            children: [
                                              Text(
                                                'Rs. ${customerList1[i].cr}',
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.w700),
                                              ),
                                              customerList1[i].cr == 0
                                                  ? const Text(
                                                      'Settled',
                                                      style: TextStyle(
                                                          fontWeight: FontWeight.w300,
                                                          fontSize: 12),
                                                    )
                                                  : const Text(
                                                      'You will get',
                                                      style: TextStyle(
                                                          fontWeight: FontWeight.w300,
                                                          fontSize: 12),
                                                    ),
                                            ],
                                          ),
                                        ),
                                        const Padding(
                                          padding:
                                              EdgeInsets.symmetric(horizontal: 20.0),
                                          child: Divider(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                IconButton(
                                          onPressed: () {
                                            setState(() {
                                              buttonLoad = true;
                                              
                                            });
                                            customerRef
                                                .document(customerList1[i].id)
                                                .delete()
                                                .then((value) {
                                              setState(() {
                                                error='';
                                              customerList1.clear();
                                                buttonLoad = false;
                                                getInvoices(1);
                                              });
                                            });
                                          },
                                          icon: buttonLoad
                                              ? SpinKitWave(
                                                  size: size.height * 0.02,
                                                  color: black)
                                              : Icon(Icons.delete_rounded,
                                                  color: red)),
                              ],
                            );
                          },
                        ),
                      )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

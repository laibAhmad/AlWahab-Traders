import 'package:firedart/firestore/firestore.dart';
import 'package:firedart/firestore/models.dart';
import 'package:flutter/material.dart';

import 'Models/data.dart';

String? currentUser;

int? invoiceNo;

int profit = 0;
int cashRs = 0;
int crRs = 0;
int totalRs = 0;

int ccR = 0;
int tCash = 0;

int todaySales = 0;
int cashSales = 0;
int crSales = 0;
int totalPcs = 0;

int todaySalesMo = 0;
int cashSalesMo = 0;
int crSalesMo = 0;
int totalPcsMo = 0;
int profitMo = 0;
int expenseMo=0;

int todaySalesYr = 0;
int cashSalesYr = 0;
int crSalesYr = 0;
int totalPcsYr = 0;
int profitYr = 0;
int expenseYr=0;


dynamic l;

Color black = Colors.black;

Color grey = const Color.fromRGBO(224, 224, 224, 1);

Color darkgrey = Colors.grey;

Color white = Colors.white;

Color greyBlack = Colors.white24;

Color yellow = const Color.fromRGBO(253, 216, 53, 1);

Color red = const Color.fromRGBO(229, 57, 53, 1);

int index = 0;

FontWeight bold = FontWeight.bold;

double fsize20 = 20;

double fsize15 = 15;

double fsize18 = 18;

List<InStockData> itemsList1 = [];

List<Customers> customerList = [];

CollectionReference ref = Firestore.instance
    .collection("AWT")
    .document('inventory')
    .collection('stock');

CollectionReference invoiceRef = Firestore.instance
    .collection("AWT")
    .document('inventory')
    .collection('invoices');

CollectionReference returnRef = Firestore.instance
    .collection("AWT")
    .document('inventory')
    .collection('return');

CollectionReference expenseRef = Firestore.instance
    .collection("AWT")
    .document('inventory')
    .collection('expenses');

CollectionReference pos = Firestore.instance
    .collection("AWT")
    .document('inventory')
    .collection('POS');

CollectionReference customerRef = Firestore.instance
    .collection("AWT")
    .document('inventory')
    .collection('customers');

CollectionReference paymentRef = Firestore.instance
    .collection("AWT")
    .document('inventory')
    .collection('payment');

CollectionReference receiveRef = Firestore.instance
    .collection("AWT")
    .document('inventory')
    .collection('receive');

CollectionReference profitRef = Firestore.instance
    .collection("AWT")
    .document('inventory')
    .collection('Profit');

int indexList = -1;

IconData salesicon = Icons.money;

IconData cricon = Icons.paid;

IconData earnicon = Icons.assignment_turned_in_rounded;

IconData profiticon = Icons.numbers;

String kmbgenerator(int n) {
  if (n > 999 && n < 99999) {
    return "${(n / 1000).toStringAsFixed(3)}K";
  } else if (n > 99999 && n < 999999) {
    return "${(n / 1000).toStringAsFixed(3)}K";
  } else if (n > 999999 && n < 999999999) {
    return "${(n / 1000000).toStringAsFixed(3)}M";
  } else if (n > 999999999) {
    return "${(n / 1000000000).toStringAsFixed(3)}B";
  } else {
    return n.toString();
  }
}

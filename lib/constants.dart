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

int todaySales =0;
int cashSales = 0;
int crSales = 0;
int totalPcs = 0;

  int todayMain = 0;
  int weekMain = 0;
  int monthMain = 0;
  int yearMain = 0;

  int todayProMain = 0;
  int weekProMain = 0;
  int monthProMain = 0;
  int yearProMain = 0;

  int todayNoMain = 0;
  int weekNoMain = 0;
  int monthNoMain = 0;
  int yearNoMain = 0;

  int todayCrMain = 0;
  int weekCrMain = 0;
  int monthCrMain = 0;
  int yearCrMain = 0;

dynamic l;

Color black = Colors.black;

Color grey = const Color.fromRGBO(224, 224, 224, 1);

Color darkgrey = Colors.grey;

Color white = Colors.white;

Color greyBlack = Colors.white24;

Color yellow = const Color.fromRGBO(253, 216, 53, 1);

Color red = const Color.fromRGBO(229, 57, 53, 1);

Color darkblue = const Color.fromARGB(255, 0, 69, 129);

Color midblue = const Color.fromARGB(255, 1, 139, 189);

Color lighblue = const Color.fromARGB(255, 151, 203, 220);

Color dimblue = const Color.fromARGB(255, 221, 232, 240);

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

int indexList = -1;

IconData salesicon =Icons.money;

IconData cricon =Icons.paid;

IconData earnicon=Icons.assignment_turned_in_rounded;

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
import 'package:firedart/firestore/firestore.dart';
import 'package:firedart/firestore/models.dart';
import 'package:flutter/material.dart';

import 'Models/data.dart';

String? currentUser;

int? invoiceNo;

int profit = 0;
int cashRs = 0;
int bankRs = 0;
int crRs = 0;
int totalRs = 0;

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


int indexList = -1;

IconData salesicon =Icons.price_check_rounded;

IconData earnicon=Icons.assignment_turned_in_rounded;

IconData profiticon = Icons.trending_up_rounded; 

String kmbgenerator(int n) {
  if (n > 999 && n < 99999) {
    return "${(n / 1000).toStringAsFixed(1)}K";
  } else if (n > 99999 && n < 999999) {
    return "${(n / 1000).toStringAsFixed(0)}K";
  } else if (n > 999999 && n < 999999999) {
    return "${(n / 1000000).toStringAsFixed(1)}M";
  } else if (n > 999999999) {
    return "${(n / 1000000000).toStringAsFixed(1)}B";
  } else {
    return n.toString();
  }
}
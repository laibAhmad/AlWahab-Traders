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

CollectionReference ref = Firestore.instance
    .collection("AWT")
    .document('inventory')
    .collection('stock');

int indexList = -1;

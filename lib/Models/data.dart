class InStockData {
  String uid, name, date;

  int pp, total, items, index;
  dynamic id;

  InStockData(
      {required this.uid,
      required this.date,
      required this.name,
      required this.pp,
      required this.total,
      required this.items,
      required this.index,
      required this.id});
}

class CartList {
  String uid, nameofItem, date, payType, cname;

  int pp, totalP, items, newPrice, saleItems, cpay, cr, bpay;
  dynamic id;

  CartList(
      {required this.uid,
      required this.date,
      required this.cname,
      required this.nameofItem,
      required this.pp,
      required this.totalP,
      required this.items,
      required this.newPrice,
      required this.saleItems,
      required this.payType,
      required this.cpay,
      required this.cr,
      required this.bpay,
      required this.id});
}

class Invoices {
  int bank, cash, cr, netTotal, profit, invo, totalitems, index;
  dynamic id;
  String date, cname, paytype;
  List<InvoiceItems> invoiceitems;
  Invoices(
      {required this.bank,
      required this.cash,
      required this.cr,
      required this.netTotal,
      required this.profit,
      required this.id,
      required this.invo,
      required this.cname,
      required this.paytype,
      required this.totalitems,
      required this.date,
      required this.invoiceitems,
      required this.index});
}

class InvoiceItems {
  String iname, ino;
  int isold, iPrice, totalsold;
  dynamic id;
  InvoiceItems(
      {required this.iPrice,
      required this.id,
      required this.iname,
      required this.ino,
      required this.isold,
      required this.totalsold});
}

class Expenses {
  int spentRs;
  String expenseName, spendfrom, date;
  dynamic id;
  Expenses(
      {required this.spendfrom,
      required this.spentRs,
      required this.date,
      required this.expenseName,
      required this.id});
}

class Customers {
  String customerName;
  int cr;
  dynamic id;
  Customers({required this.customerName, required this.cr, required this.id});
}

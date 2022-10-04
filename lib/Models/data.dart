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
  int bank, cash, cr, netTotal,profit;
  dynamic id;
  String date;
  Invoices(
      {required this.bank,
      required this.cash,
      required this.cr,
      required this.netTotal,
      required this.profit,
      required this.id,
      required this.date});
}

class Expenses {
  int spent;
  String expense, spendfrom, date;
  dynamic id;
  Expenses(
      {required this.spendfrom,
      required this.spent,
      required this.date,
      required this.expense,
      required this.id});
}

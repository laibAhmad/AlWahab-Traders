import 'package:flutter/cupertino.dart';
import 'package:inventory_system/constants.dart';

class Return extends StatefulWidget {
  const Return({Key? key}) : super(key: key);

  @override
  State<Return> createState() => _ReturnState();
}

class _ReturnState extends State<Return> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(color: grey),
          width: size.width * 0.8,
          height: 500,
        )
      ],
    );
  }
}

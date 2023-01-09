import 'package:flutter/material.dart';

class CartCounter extends StatelessWidget {
  CartCounter({
    Key? key,
    required this.count,
  }) : super(key: key);

  String count = '0';
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 12,
        width: 12,
        decoration:
            BoxDecoration(color: Colors.red[800], shape: BoxShape.circle),
        child: Center(
            child: Text(
          count,
          style: const TextStyle(color: Colors.black, fontSize: 7),
        )));
  }
}

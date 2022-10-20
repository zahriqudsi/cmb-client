import 'package:flutter/material.dart';

class TextFieldDetail extends StatelessWidget {
  final Widget child;
  const TextFieldDetail({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      width: 90,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black26),
        // border: Border.all(
        //   color: Colors.black,
        // ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(1, 4), // changes position of shadow
          ),
        ],
      ),
      child: child,
    );
  }
}

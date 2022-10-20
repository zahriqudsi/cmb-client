import 'package:colombo_express_client/constant.dart';
import 'package:flutter/material.dart';

class Pagination extends StatelessWidget {
  final int from;
  final int to;
  final int total;
  final Function onNext;
  final Function onPrev;
  const Pagination(
      {Key? key,
      required this.from,
      required this.to,
      required this.total,
      required this.onNext,
      required this.onPrev})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                if (from > 1) {
                  onPrev();
                }
              },
              child: Container(
                margin: const EdgeInsets.only(
                  top: 20,
                  right: 15,
                  left: 15,
                  bottom: 10,
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                width: 90,
                height: 35,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 4,
                      offset: const Offset(1, 4), // changes position of shadow
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.arrow_back_ios,
                  size: 18,
                  color: chipColorA,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                top: 20,
                right: 5,
                left: 5,
                bottom: 10,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              // width: 90,
              // height: 35,
              child: Text(
                from.toString() +
                    " - " +
                    to.toString() +
                    " of " +
                    total.toString(),
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
            InkWell(
              onTap: () {
                if (to < total) {
                  onNext();
                }
              },
              child: Container(
                margin: const EdgeInsets.only(
                  top: 20,
                  right: 15,
                  left: 15,
                  bottom: 10,
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                width: 90,
                height: 35,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 4,
                      offset: const Offset(1, 4), // changes position of shadow
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                  color: chipColorA,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}

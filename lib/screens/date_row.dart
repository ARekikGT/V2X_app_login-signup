import 'package:flutter/material.dart';

import '../app_style.dart';

class DateRow extends StatelessWidget {
  final Color boxColor;
  final String date;
  final Color dateColor;
  const DateRow({Key? key, required this.boxColor, required this.date, required this.dateColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,width: 90,
      margin: const EdgeInsets.only(left: 20,bottom: 10),
      decoration: BoxDecoration(
        color: boxColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(date,style: Style.headLineStyle3.copyWith(color: dateColor),),
          Text("mo",style: Style.headLineStyle3.copyWith(color: greyColor),)
        ],
      ),
    );
  }
}

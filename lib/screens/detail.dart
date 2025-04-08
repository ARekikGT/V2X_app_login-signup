import 'package:flutter/material.dart';

import '../app_style.dart';

class Detail extends StatelessWidget {
  final Color boxColor;
  final String testName;
  final Color nameColor;
  final Color testColor;
  final String day;
  final Color dayColor;
  const Detail({Key? key, required this.boxColor, required this.testName, required this.testColor, required this.day, required this.dayColor, required this.nameColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 190,width: 160,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: boxColor,
          borderRadius: BorderRadius.circular(20)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(testName,style: Style.headLineStyle1.copyWith(color: testColor),),

          Text("Lorem\nipsuim dolor",style: Style.headLineStyle4.copyWith(color: nameColor),),

          Text(day,style: Style.headLineStyle1.copyWith(color: dayColor),),
        ],
      ),
    );
  }
}

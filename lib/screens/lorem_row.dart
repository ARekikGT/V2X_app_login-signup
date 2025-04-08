import 'package:flutter/material.dart';

import '../app_style.dart';

class LoremRow extends StatelessWidget {
  final Color boxColor;
  final dynamic child;
  const LoremRow({super.key, required this.boxColor, this.child});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          height: 120,
          width: 100,
          decoration: BoxDecoration(
            color: boxColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(child: child),
        ),

        Expanded(
          child: Container(
            margin: const EdgeInsets.only(top: 20, bottom: 10, right: 20),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: whiteColor,
              border: Border.all(color: grey300),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Lorem ipsum",
                  style: Style.headLineStyle3.copyWith(
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Lorem ipsum dolor sit amet",
                  style: Style.headLineStyle3.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

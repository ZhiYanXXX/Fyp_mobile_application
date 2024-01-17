import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ExtendInfoTab extends StatelessWidget {
  const ExtendInfoTab(
      {super.key, required this.fieldTitle, required this.fieldInfo});
  final String fieldTitle;
  final String fieldInfo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(right: 0.5.w),
            child: Text(fieldTitle,
                style: const TextStyle(
                    fontFamily: "Salsa",
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Color.fromARGB(255, 45, 24, 17))),
          ),
          Text(fieldInfo,
              style: const TextStyle(
                  fontFamily: "VarelaRound",
                  fontWeight: FontWeight.normal,
                  fontSize: 20,
                  color: Color.fromARGB(255, 53, 13, 122))),
        ],
      ),
    );
  }
}

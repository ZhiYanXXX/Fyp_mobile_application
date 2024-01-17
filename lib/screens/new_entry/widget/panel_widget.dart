import 'package:flutter/material.dart';
import 'package:medapp/constant/colors.dart';
import 'package:sizer/sizer.dart';

class PanelTitle extends StatelessWidget {
  const PanelTitle({super.key, required this.title, required this.isRequired});
  final String title;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: 2.h),
        child: Text.rich(
          TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: title,
                style: const TextStyle(
                    color: Color.fromARGB(255, 4, 12, 100),
                    fontFamily: 'RubikDoodleShadow',
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: isRequired ? "*" : "",
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      color: kPrimaryColor,
                    ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

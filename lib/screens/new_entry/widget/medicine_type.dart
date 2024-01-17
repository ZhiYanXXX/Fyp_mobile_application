import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:medapp/constant/colors.dart';
import 'package:medapp/models/medicine_type.dart';
import 'package:sizer/sizer.dart';

class MedicineTypeColumn extends StatelessWidget {
  const MedicineTypeColumn(
      {super.key,
      required this.medicineType,
      required this.name,
      required this.iconValue,
      required this.isSelected,
      required this.ontap,
      required this.onDoubletap});
  final MedicineType medicineType;
  final String name;
  final String iconValue;
  final bool isSelected;
  final Callback ontap;
  final Callback onDoubletap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      onDoubleTap: onDoubletap,
      child: Column(
        children: [
          Container(
            width: 20.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3.h),
                color: isSelected
                    ? const Color.fromARGB(255, 255, 191, 0)
                    : Colors.white),
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(top: 1.h, bottom: 1.h),
                child: SvgPicture.asset(
                  iconValue,
                  height: 7.h,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 1.h),
            child: Container(
              width: 20.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color.fromARGB(255, 255, 191, 0)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  name,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: isSelected ? Colors.white : kOtherColor),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

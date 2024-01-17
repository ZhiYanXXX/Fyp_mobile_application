import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medapp/constant/colors.dart';
import 'package:medapp/constant/image_string.dart';
import 'package:medapp/constant/text_string.dart';
import 'package:sizer/sizer.dart';

class MainSection extends StatelessWidget {
  const MainSection({super.key, required this.medicineData});
  final Map<String, dynamic> medicineData;
  Hero makeIcon(String medicineType, String id, double size) {
    if (medicineType == mInhaler) {
      return Hero(
        tag: "$id.",
        child: SvgPicture.asset(
          mInhalerIcon,
          height: 7.h,
        ),
      );
    } else if (medicineType == mSyrup) {
      return Hero(
        tag: "$id..",
        child: SvgPicture.asset(
          mSyrupIcon,
          height: 7.h,
        ),
      );
    } else if (medicineType == mPill) {
      return Hero(
          tag: "$id...",
          child: SvgPicture.asset(
            mPillIcon,
            height: 7.h,
          ));
    } else if (medicineType == mSyringe) {
      return Hero(
          tag: "$id....",
          child: SvgPicture.asset(
            mSyringeIcon,
            height: 7.h,
          ));
    } else if (medicineType == mTablet) {
      return Hero(
          tag: "$id.....",
          child: SvgPicture.asset(
            mTabletIcon,
            height: 7.h,
          ));
    }
    //In case no medicine type is selected
    return Hero(
      tag: medicineType,
      child: Icon(
        Icons.error,
        color: kOtherColor,
        size: size,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String medicineName = medicineData['medicationName'] ?? 'Unknown';
    final dynamic dosage = medicineData['dosage'] ?? "Unknown";
    final String medicineType = medicineData['medicineType'] ?? 'Unknown';
    final String documentId = medicineData['id'] ?? 'Unknown';

    // Make icon based on medicineType
    final Hero icon = makeIcon(medicineType, documentId, 7.h);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.greenAccent,
          ),
          child: icon,
        ),
        SizedBox(
          width: 2.w,
        ),
        Column(
          children: [
            Text(
              medicineName,
              style: const TextStyle(
                  fontFamily: "RubikDoodleShadow",
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Color.fromARGB(255, 198, 7, 7)),
            ),
            Text("$dosage mg",
                style: const TextStyle(
                    fontFamily: "RubikDoodleShadow",
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Color.fromARGB(255, 77, 6, 90)))
          ],
        )
      ],
    );
  }
}

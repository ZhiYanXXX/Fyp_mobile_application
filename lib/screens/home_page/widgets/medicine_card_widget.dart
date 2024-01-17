import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:medapp/constant/colors.dart';
import 'package:medapp/constant/image_string.dart';
import 'package:medapp/constant/text_string.dart';
import 'package:medapp/models/medicine_name.dart';
import 'package:medapp/screens/medicine_details/medicine_details.dart';
import 'package:sizer/sizer.dart';

class MedicineCard extends StatelessWidget {
  const MedicineCard({
    super.key,
    required this.medicationNamesModel,
    required this.medicineData,
    required this.userId,
  });
  final Map<String, dynamic>
      medicineData; //for getting the current details of the saved items
  final MedicationNamesModel medicationNamesModel;
  final String userId;

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

  Map<String, dynamic> getMedicineDetails(String name) {
    return medicationNamesModel.medicineLists.firstWhere(
      (element) => element['name'] == name,
      orElse: () => {
        "usage": "No usage information available.",
        "sideEffect": "No side effect information available."
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Use medicineData directly
    final String medicineName = medicineData['medicationName'] ?? 'Unknown';
    final int interval = medicineData['interval'] as int? ?? 0;
    final String medicineType = medicineData['medicineType'] ?? 'Unknown';
    final String documentId = medicineData['id'] ?? 'Unknown';
    // Make icon based on medicineType
    final Hero icon = makeIcon(medicineType, documentId, 7.h);

    //Look up the medicine details
    final Map<String, dynamic> medicineDetails =
        getMedicineDetails(medicineName);
    return InkWell(
      highlightColor: const Color.fromARGB(255, 235, 188, 188),
      splashColor: const Color.fromARGB(255, 246, 170, 170),
      onTap: () {
        Navigator.of(context).push(PageRouteBuilder<void>(
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) {
              return AnimatedBuilder(
                  animation: animation,
                  builder: (context, Widget? child) {
                    return Opacity(
                      opacity: animation.value,
                      child: MedicineDetails(
                        userId: userId,
                        medicineData: medicineData,
                        documentId: documentId,
                      ),
                    );
                  });
            },
            transitionDuration: const Duration(milliseconds: 500)));
      },
      child: Container(
        padding: EdgeInsets.only(left: 2.w, right: 2.w, top: 1.h, bottom: 1.h),
        margin: EdgeInsets.all(1.h),
        decoration: BoxDecoration(
            color: const Color.fromARGB(
                255, 245, 186, 186), // Set the background color here
            borderRadius: BorderRadius.circular(2.h),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [
                0.1,
                0.4,
                0.6,
                0.9,
              ],
              colors: [
                Color.fromARGB(255, 254, 236, 187),
                Color.fromARGB(255, 250, 221, 135),
                Color.fromRGBO(254, 217, 107, 1),
                Color.fromARGB(255, 255, 209, 71),
              ],
            )),
        child: Stack(children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              icon,
              const Spacer(),
              Text(
                medicineName,
                overflow: TextOverflow.fade,
                textAlign: TextAlign.start,
                style: const TextStyle(
                    fontFamily: "RubikDoodleShadow",
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 0.3.h,
              ),
              Hero(
                tag: medicineName,
                child: Text(
                  interval == 1
                      ? "Every $interval second"
                      : "Every $interval seconds",
                  overflow: TextOverflow.fade,
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                      fontFamily: "VarelaRound",
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 176, 18, 7)),
                ),
              )
            ],
          ),
          Align(
            alignment: Alignment.topRight,
            child: InkWell(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(medicineName),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: <Widget>[
                              RichText(
                                text: TextSpan(
                                  style: const TextStyle(
                                    color: Colors
                                        .black, // Default text color, you can change this as needed
                                    fontSize:
                                        14, // Default text size, you can change this as needed
                                  ),
                                  children: [
                                    const TextSpan(
                                      text: mUsage,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                      text: medicineDetails['usage'],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              RichText(
                                text: TextSpan(
                                  style: const TextStyle(
                                    color: Colors
                                        .black, // Default text color, you can change this as needed
                                    fontSize:
                                        14, // Default text size, you can change this as needed
                                  ),
                                  children: [
                                    const TextSpan(
                                      text: mSideEffect,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                      text: medicineDetails['sideEffect'],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("Close"))
                        ],
                      );
                    });
              },
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.amber,
                  shape: BoxShape.circle,
                ),
                width: 24,
                height: 24,
                child: const Icon(
                  LineAwesomeIcons.info,
                  color: Colors.black,
                  size: 20,
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }
}

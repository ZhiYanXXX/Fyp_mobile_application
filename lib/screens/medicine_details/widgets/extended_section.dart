import 'package:flutter/material.dart';
import 'package:medapp/constant/text_string.dart';
import 'package:medapp/screens/medicine_details/widgets/extended_info_tab.dart';

class ExtendedSection extends StatelessWidget {
  const ExtendedSection({super.key, required this.medicineData});
  final Map<String, dynamic> medicineData;

  @override
  Widget build(BuildContext context) {
    final String startTime = medicineData['startTime'];
    final String extInfo = medicineData['extraInfo'] ?? 'Unknown';
    final int interval = medicineData['interval'] as int? ?? 0;
    final String medicineType = medicineData['medicineType'] ?? 'Unknown';
    final String treatmentDuration =
        medicineData['treatmentDuration'] ?? 'Unknown';
    return ListView(
      shrinkWrap: true,
      children: [
        ExtendInfoTab(
          fieldTitle: mMedicineType,
          fieldInfo: medicineType == 'None' ? 'Not Specified' : medicineType,
        ),
        ExtendInfoTab(
          fieldTitle: mDosageInterval,
          fieldInfo: 'Every $interval seconds'
              '   | ${interval == 60 ? "One time per minute" : "${(720 / interval).floor()} times in 12 minutes"}',
        ),
        ExtendInfoTab(
          fieldTitle: mStartingTime,
          fieldInfo:
              '${startTime[0]}${startTime[1]}${startTime[2]}${startTime[3]}${startTime[4]} hours',
        ),
        ExtendInfoTab(
            fieldTitle: mExtraInfo,
            fieldInfo: extInfo == 'None' ? 'None' : extInfo),
        ExtendInfoTab(
            fieldTitle: mTreatmentDuration,
            fieldInfo: treatmentDuration == "None"
                ? 'Not Specified'
                : treatmentDuration),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:medapp/constant/colors.dart';
import 'package:sizer/sizer.dart';

class TreatmentDurationSelection extends StatefulWidget {
  const TreatmentDurationSelection(
      {super.key, required this.onTreatmentDurationSelected});
  final Function(String) onTreatmentDurationSelected;

  @override
  State<TreatmentDurationSelection> createState() =>
      _TreatmentDurationSelectionState();
}

class _TreatmentDurationSelectionState
    extends State<TreatmentDurationSelection> {
  final selection = [
    '1 month',
    '2 months',
    '3 months',
    '6 months',
  ];
  var _selected = "";
  IconData icon = Icons.date_range;
  Color iconColor = Colors.black;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 1.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: iconColor,
            weight: 5.0,
            size: 40,
          ),
          SizedBox(
            width: 4.w,
          ),
          DropdownButton(
            iconEnabledColor: kOtherColor,
            dropdownColor: const Color.fromARGB(255, 245, 223, 157),
            itemHeight: 8.h,
            hint: _selected == ""
                ? const Text(
                    'Select an option',
                    style: TextStyle(
                        fontFamily: "VarelaRound",
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  )
                : null,
            elevation: 4,
            value: _selected == "" ? null : _selected,
            items: selection.map(
              (String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value.toString(),
                    style: const TextStyle(
                        fontFamily: "VarelaRound",
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent),
                  ),
                );
              },
            ).toList(),
            onChanged: (newVal) {
              setState(
                () {
                  _selected = newVal!;
                  widget.onTreatmentDurationSelected(newVal);
                  icon = Icons.check_rounded;
                  iconColor = Colors.greenAccent;
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

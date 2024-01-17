import 'package:flutter/material.dart';
import 'package:medapp/constant/colors.dart';
import 'package:sizer/sizer.dart';

class ExtraInfoSelection extends StatefulWidget {
  const ExtraInfoSelection({super.key, required this.onExtInfoSelected});
  final Function(String) onExtInfoSelected;

  @override
  State<ExtraInfoSelection> createState() => _ExtraInfoSelectionState();
}

class _ExtraInfoSelectionState extends State<ExtraInfoSelection> {
  final selection = ['After Meal', 'Before Meal'];
  IconData icon = Icons.info_rounded;
  Color iconColor = Colors.black;
  var _selected = "";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 1.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 2.h,
          ),
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
                  widget.onExtInfoSelected(newVal);
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

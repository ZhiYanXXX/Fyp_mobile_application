import 'package:flutter/material.dart';
import 'package:medapp/constant/colors.dart';
import 'package:medapp/constant/text_string.dart';
import 'package:sizer/sizer.dart';

class IntervalSelection extends StatefulWidget {
  const IntervalSelection({super.key, required this.onIntervalSelected});
  final Function(int) onIntervalSelected;

  @override
  State<IntervalSelection> createState() => _IntervalSelectionState();
}

class _IntervalSelectionState extends State<IntervalSelection> {
  final _intervals = [30, 60, 120, 180];
  var _selected = 0;
  IconData icon = Icons.timelapse;
  Color iconColor = Colors.black;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 1.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(mRemindMeEvery,
              style: TextStyle(
                  fontFamily: "VarelaRound",
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          Row(
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
                hint: _selected == 0
                    ? const Text(
                        mSelectAnInterval,
                        style: TextStyle(
                            fontFamily: "VarelaRound",
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                        selectionColor: Colors.white,
                      )
                    : null,
                elevation: 4,
                value: _selected == 0 ? null : _selected,
                items: _intervals.map(
                  (int value) {
                    return DropdownMenuItem<int>(
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
                      widget.onIntervalSelected(newVal);
                      icon = Icons.check_rounded;
                      iconColor = Colors.greenAccent;
                    },
                  );
                },
              ),
              Text(
                _selected == 1 ? " second" : " seconds",
                style: const TextStyle(
                    fontFamily: "VarelaRound",
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ],
          )
        ],
      ),
    );
  }
}

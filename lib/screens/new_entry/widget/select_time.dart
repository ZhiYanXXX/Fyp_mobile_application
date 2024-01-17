import 'package:flutter/material.dart';
import 'package:medapp/common/convert_time.dart';
import 'package:medapp/constant/colors.dart';
import 'package:medapp/constant/text_string.dart';
import 'package:sizer/sizer.dart';

class SelectTime extends StatefulWidget {
  const SelectTime({super.key, required this.onTimeSelected});

  final Function(TimeOfDay) onTimeSelected;

  @override
  State<SelectTime> createState() => _SelectTimeState();
}

class _SelectTimeState extends State<SelectTime> {
  TimeOfDay _time = const TimeOfDay(hour: 0, minute: 00);
  bool _clicked = false;
  Color buttonColor = kPrimaryColor;
  Color textColor = Colors.white;

  Future<TimeOfDay?> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _time,
    );

    if (picked != null && picked != _time) {
      setState(() {
        _time = picked;
        _clicked = true;
        buttonColor = Colors.greenAccent;
        textColor = Colors.black;
      });
      widget.onTimeSelected(TimeOfDay(hour: _time.hour, minute: _time.minute));
    }

    return picked;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 8.h,
      child: Padding(
        padding: EdgeInsets.only(top: 2.h),
        child: TextButton(
          style: TextButton.styleFrom(
              backgroundColor: buttonColor, shape: const StadiumBorder()),
          onPressed: () {
            _selectTime();
          },
          child: Center(
            child: Text(
              _clicked == false
                  ? mSelectTime
                  : '${convertTime(_time.hour.toString())}: ${convertTime(_time.minute.toString())}',
              style: Theme.of(context)
                  .textTheme
                  .displaySmall!
                  .copyWith(color: textColor),
            ),
          ),
        ),
      ),
    );
  }
}

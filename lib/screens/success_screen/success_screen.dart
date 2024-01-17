import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medapp/screens/home_page/home_page.dart';
import 'package:rive/rive.dart';

class SuccessScreen extends StatefulWidget {
  const SuccessScreen({super.key, required this.userId});
  final String userId;

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 2500), () {
      Get.offAll(() => HomePage(userId: widget.userId));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: const Center(
        child: RiveAnimation.asset(
          'assets/animations/1029-2009-success-check.riv',
          alignment: Alignment.center,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

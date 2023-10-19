import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class SuccessScreen extends StatefulWidget {
  const SuccessScreen({super.key});

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 2500), () {
      Navigator.popUntil(context, ModalRoute.withName('/'));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
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

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

typedef CallbackAction = void Function();

class ConfirmationDialog {
  final String title;
  final String content;
  final String cancelButtonText;
  final String confirmButtonText;
  final String lottieAnimationPath;
  final CallbackAction onPressedCancel;
  final CallbackAction onPressedConfirm;

  ConfirmationDialog({
    required this.lottieAnimationPath,
    required this.title,
    required this.content,
    this.cancelButtonText = 'Cancel',
    this.confirmButtonText = 'Confirm',
    required this.onPressedCancel,
    required this.onPressedConfirm,
  });

  String get getLottieAnimationPath => lottieAnimationPath;

  static Future<bool?> showConfirmationDialog(
    BuildContext context,
    String title,
    String content,
    CallbackAction onPressedCancel,
    CallbackAction onPressedConfirm, {
    String cancelButtonText = 'Cancel',
    String confirmButtonText = 'Confirm',
    required String lottieAnimationPath,
  }) async {
    return await showDialog<bool?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 255, 232, 162),
          title: Column(
            children: [
              Lottie.asset(
                lottieAnimationPath,
                height: 100.0,
                width: 100.0,
                repeat: true,
                onLoaded: (composition) {},
              ),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: "RubikDoodleShadow",
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 14, 2, 65),
                ),
              ),
            ],
          ),
          content: Text(
            content,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: "VarelaRound",
              fontWeight: FontWeight.w200,
              fontSize: 20,
              color: Color.fromARGB(255, 1, 53, 3),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
                onPressedCancel();
              },
              child: Text(
                cancelButtonText,
                style: const TextStyle(
                  fontFamily: "Satisfy",
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              width: 22.w,
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
                onPressedConfirm();
              },
              child: Text(
                confirmButtonText,
                style: const TextStyle(
                  fontFamily: "Satisfy",
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

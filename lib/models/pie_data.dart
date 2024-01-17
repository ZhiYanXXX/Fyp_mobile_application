import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Data {
  final String medicationName;
  double percentage;
  final Color colour;

  Data(
      {required this.medicationName,
      required this.percentage,
      required this.colour});
}

class PieData {
  static List<Data> data = [];

  static Future<void> fetchData(String userId) async {
    // Access Firestore and retrieve data from the "Medications History" collection
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection("Users")
        .doc(userId)
        .collection('Reminders History')
        .get();

    data.clear();

    // Count occurrences of each unique medication name
    Map<String, int> medicationCount = {};

    for (QueryDocumentSnapshot<Map<String, dynamic>> document
        in querySnapshot.docs) {
      String medicationName = document['medicationName'];

      // Increment count for each medication name
      medicationCount[medicationName] =
          (medicationCount[medicationName] ?? 0) + 1;
    }

    // Generate random colors for each unique medication name without duplication
    Set<Color> usedColors = {};

    medicationCount.forEach((medicationName, count) {
      double percentage = (count / querySnapshot.size) * 100;

      // Generate a random color that has not been used before
      Color randomColor;
      do {
        randomColor = _getRandomRainbowColor();
      } while (usedColors.contains(randomColor));

      usedColors.add(randomColor);

      data.add(Data(
        medicationName: medicationName,
        percentage: percentage,
        colour: randomColor,
      ));
    });
  }

  // Helper function to generate a random color
  static Color _getRandomRainbowColor() {
    final Random random = Random();

    int red = random.nextInt(256);
    int green = random.nextInt(256);
    int blue = random.nextInt(256);

    // Calculate random alpha value
    double alpha = 1.0;

    return Color.fromRGBO(
      red,
      green,
      blue,
      alpha,
    );
  }
}

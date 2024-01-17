import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:medapp/models/pie_data.dart';

List<PieChartSectionData> getSections() => PieData.data
    .asMap()
    .map<int, PieChartSectionData>((index, data) {
      final value = PieChartSectionData(
          color: data.colour,
          value: data.percentage,
          title: data.medicationName,
          titleStyle: const TextStyle(
              fontFamily: "Salsa", fontSize: 16)); // Change this line
      return MapEntry(index, value);
    })
    .values
    .toList();

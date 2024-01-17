import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:medapp/models/pie_data.dart';
import 'package:medapp/screens/daily_report/widget/indicator.dart';
import 'package:medapp/screens/daily_report/widget/pie_chart_section.dart';

class DailyReportPage extends StatefulWidget {
  const DailyReportPage({super.key, required this.userId});
  final String userId;

  @override
  State<DailyReportPage> createState() => _DailyReportPageState();
}

class _DailyReportPageState extends State<DailyReportPage> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daily Report"),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            LineAwesomeIcons.angle_left,
            weight: BouncingScrollSimulation.maxSpringTransferVelocity,
          ),
        ),
      ),
      body: FutureBuilder(
        future: PieData.fetchData(widget.userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While data is loading
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // If there's an error
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            // If data has been loaded successfully
            return _buildChart(); // Create a separate method to build your chart widget
          }
        },
      ),
    );
  }

  Widget _buildChart() {
    return AspectRatio(
      aspectRatio: 1.3,
      child: Column(
        children: <Widget>[
          const SizedBox(
            height: 28,
          ),
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: PieData.data.length,
              itemBuilder: (context, index) {
                Data data = PieData.data[index];
                return Indicator(
                  color: data.colour,
                  textColor: touchedIndex == index ? data.colour : Colors.black,
                  isSquare: false,
                  text: data.medicationName,
                  size: touchedIndex == index ? 18 : 16,
                );
              },
            ),
          ),
          const SizedBox(
            height: 18,
          ),
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex = pieTouchResponse
                            .touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                  startDegreeOffset: 180,
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 1,
                  centerSpaceRadius: 0,
                  sections: getSections(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

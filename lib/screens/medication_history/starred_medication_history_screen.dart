import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:logger/logger.dart';
import 'package:medapp/constant/image_string.dart';
import 'package:medapp/models/medicine.dart';

class StarredMedicationHistoryScreen extends StatefulWidget {
  const StarredMedicationHistoryScreen({super.key, required this.userId});
  final String userId;

  @override
  State<StarredMedicationHistoryScreen> createState() =>
      _StarredMedicationHistoryScreenState();
}

class _StarredMedicationHistoryScreenState
    extends State<StarredMedicationHistoryScreen> {
  late MedicationReminder reminder;
  late List<MedicationReminder> reminders;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "~Starred~",
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            LineAwesomeIcons.angle_left,
            weight: BouncingScrollSimulation.maxSpringTransferVelocity,
          ),
        ),
        // actions: [
        //   IconButton(
        //     icon: const Icon(
        //       Icons.email,
        //       color: Colors.white,
        //     ),
        //     onPressed: () {
        //       // sendAllMedicationHistoriesByEmail();
        //     },
        //   ),
        // ],
      ),
      body: FutureBuilder<List<MedicationReminder>>(
          future: fetchMedicationReminders(widget.userId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: SpinKitCubeGrid(
                  color: Colors.amber,
                ),
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              reminders = snapshot.data ?? [];
              if (reminders.isEmpty) {
                return Center(
                  child: Image.asset(
                    mMedicationHistoryImage,
                    width: 300.0,
                    height: 300.0,
                    fit: BoxFit.contain,
                  ),
                );
              }
              return ListView.builder(
                itemCount: reminders.length,
                itemBuilder: (context, index) {
                  reminder = reminders[index];
                  return Card(
                    elevation: 5.0,
                    shadowColor: const Color.fromARGB(255, 18, 142, 23),
                    margin: const EdgeInsets.all(10.0),
                    child: Container(
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(colors: [
                        Color.fromARGB(255, 255, 182, 182),
                        Color.fromARGB(255, 253, 244, 255),
                      ])),
                      child: ListTile(
                        title: Text(
                          reminder.getMedicationName,
                          style: const TextStyle(
                              fontFamily: "RubikDoodleShadow",
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Color.fromARGB(255, 3, 40, 71)),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text.rich(TextSpan(children: [
                              const TextSpan(
                                  text: 'Dosage: ',
                                  style: TextStyle(
                                      fontFamily: "VarelaRound",
                                      fontWeight: FontWeight.bold,
                                      color: Colors.deepPurple)),
                              TextSpan(
                                  text: '${reminder.dosage} mg',
                                  style: const TextStyle(
                                      fontFamily: "Satisfy",
                                      fontSize: 18,
                                      color: Colors.redAccent))
                            ])),
                            Text.rich(TextSpan(children: [
                              const TextSpan(
                                  text: 'Medicine Type: ',
                                  style: TextStyle(
                                      fontFamily: "VarelaRound",
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 44, 12, 99))),
                              TextSpan(
                                  text: '${reminder.medicineType}',
                                  style: const TextStyle(
                                      fontFamily: "Satisfy",
                                      fontSize: 18,
                                      color: Color.fromARGB(255, 57, 43, 1)))
                            ])),
                            Text.rich(TextSpan(children: [
                              const TextSpan(
                                  text: 'Interval: ',
                                  style: TextStyle(
                                      fontFamily: "VarelaRound",
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 22, 4, 53))),
                              TextSpan(
                                  text:
                                      '${reminder.interval} hours | ${reminder.interval == 24 ? "One time a day" : "${(24 / (reminder.interval)).floor()} times a day"}',
                                  style: const TextStyle(
                                      fontFamily: "Satisfy",
                                      fontSize: 18,
                                      color: Colors.red))
                            ])),
                            Text.rich(TextSpan(children: [
                              const TextSpan(
                                  text: 'Start Time: ',
                                  style: TextStyle(
                                      fontFamily: "VarelaRound",
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 9, 1, 21))),
                              TextSpan(
                                  text: reminder.startTime,
                                  style: const TextStyle(
                                      fontFamily: "Satisfy",
                                      fontSize: 18,
                                      color: Color.fromARGB(255, 135, 8, 8)))
                            ])),
                            Text.rich(TextSpan(children: [
                              const TextSpan(
                                  text: 'Treatment Duration: ',
                                  style: TextStyle(
                                      fontFamily: "VarelaRound",
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 0, 0, 0))),
                              TextSpan(
                                  text: reminder.treatmentDuration,
                                  style: const TextStyle(
                                      fontFamily: "Satisfy",
                                      fontSize: 18,
                                      color: Color.fromARGB(255, 96, 4, 4)))
                            ])),
                          ],
                        ),
                        // You can customize the content padding as needed
                        contentPadding: const EdgeInsets.all(16.0),
                      ),
                    ),
                  );
                },
              );
            }
          }),
    );
  }

  Future<List<MedicationReminder>> fetchMedicationReminders(
      String userId) async {
    final logger = Logger();
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('Users')
              .doc(userId)
              .collection('Starred Medication History')
              .get();

      reminders = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        return MedicationReminder(
            notificationIDs: data['notificationIDs'],
            uniqueID: data['id'],
            medicineName: data['medicationName'],
            dosage: data['dosage'] ?? "unknown",
            medicineType: data['medicineType'],
            interval: data['interval'],
            startTime: data['startTime'],
            treatmentDuration: data['treatmentDuration'] ?? "",
            extInfo: data['extraInfo'] ?? '',
            isStarred: data['isStarred'],
            createdTime: data['createdTime']);
      }).toList();

      return reminders;
    } catch (e, stackTrace) {
      logger.e('Error fetching medication reminders',
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }
}

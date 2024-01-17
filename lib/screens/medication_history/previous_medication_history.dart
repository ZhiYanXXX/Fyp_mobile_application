import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:logger/logger.dart';
import 'package:medapp/constant/image_string.dart';
import 'package:medapp/models/past_medication_history.dart';
import 'package:medapp/screens/medication_history/add_previous_medication_history.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class PreviousMedicationHistoryPage extends StatefulWidget {
  const PreviousMedicationHistoryPage({super.key, required this.userId});
  final String userId;

  @override
  State<PreviousMedicationHistoryPage> createState() =>
      _PreviousMedicationHistoryPageState();
}

class _PreviousMedicationHistoryPageState
    extends State<PreviousMedicationHistoryPage> {
  late List<PastMedicationHistory> histories;
  final Logger logger = Logger();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Past Medication History"),
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
        //       onPressed: () {},
        //       icon: const Icon(
        //         Icons.email,
        //         color: Colors.white,
        //       ))
        // ],
      ),
      body: FutureBuilder<List<PastMedicationHistory>>(
        future: fetchPastMedicationHistory(widget.userId),
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
            histories = snapshot.data ?? [];
            if (histories.isEmpty) {
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
                itemCount: histories.length,
                itemBuilder: (context, index) {
                  return Card(
                    shadowColor: Colors.amber,
                    margin: const EdgeInsets.all(10.0),
                    elevation: 5.0,
                    child: ListTile(
                      title: Text(
                        histories[index].getIllness,
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
                                text: 'How To Treate: ',
                                style: TextStyle(
                                    fontFamily: "VarelaRound",
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepPurple)),
                            TextSpan(
                                text: histories[index].getHowToTreate,
                                style: const TextStyle(
                                    fontFamily: "Salsa",
                                    fontSize: 18,
                                    color: Colors.redAccent))
                          ])),
                          Text.rich(TextSpan(children: [
                            const TextSpan(
                                text: 'Dosage: ',
                                style: TextStyle(
                                    fontFamily: "VarelaRound",
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 44, 12, 99))),
                            TextSpan(
                                text: '${histories[index].getDosage} mg',
                                style: const TextStyle(
                                    fontFamily: "Salsa",
                                    fontSize: 18,
                                    color: Color.fromARGB(255, 57, 43, 1)))
                          ])),
                          Text.rich(TextSpan(children: [
                            const TextSpan(
                                text: 'Start Date: ',
                                style: TextStyle(
                                    fontFamily: "VarelaRound",
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 22, 4, 53))),
                            TextSpan(
                                text: histories[index].getStartDate,
                                style: const TextStyle(
                                    fontFamily: "Salsa",
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
                                text: histories[index].getEndDate,
                                style: const TextStyle(
                                    fontFamily: "Salsa",
                                    fontSize: 18,
                                    color: Color.fromARGB(255, 135, 8, 8)))
                          ])),
                          Text.rich(TextSpan(children: [
                            const TextSpan(
                                text: 'Treatment Effectiveness: ',
                                style: TextStyle(
                                    fontFamily: "VarelaRound",
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 0, 0, 0))),
                            TextSpan(
                                text: histories[index].getEffectiveness,
                                style: const TextStyle(
                                    fontFamily: "Salsa",
                                    fontSize: 18,
                                    color: Color.fromARGB(255, 96, 4, 4)))
                          ])),
                        ],
                      ),
                    ),
                  );
                });
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 255, 240, 195),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: ((context) => AddPastMedicationHistory(
                        userId: widget.userId,
                      ))));
        },
        child: const Icon(Icons.medication),
      ),
    );
  }

  Future<List<PastMedicationHistory>> fetchPastMedicationHistory(
      String userId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('Users')
              .doc(userId)
              .collection('Past Medication History')
              .get();

      histories = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        return PastMedicationHistory(
            id: data["id"],
            illness: data["illness"],
            howToTreate: data["howToTreate"] ?? "Not Specified",
            dosage: data["dosage"],
            startDate: data["startDate"],
            endDate: data["endDate"],
            effectiveness: data["effectiveness"]);
      }).toList();
      return histories;
    } catch (e, stackTrace) {
      logger.e('Error fetching past medication history',
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }
}

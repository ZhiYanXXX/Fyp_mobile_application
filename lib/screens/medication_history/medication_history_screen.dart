import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
// import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:logger/logger.dart';
import 'package:medapp/common/confirmation_dialog.dart';
import 'package:medapp/constant/image_string.dart';
import 'package:medapp/constant/text_string.dart';
import 'package:medapp/models/medicine.dart';
import 'package:medapp/screens/medication_history/previous_medication_history.dart';
import 'package:medapp/screens/medication_history/starred_medication_history_screen.dart';
import 'package:sizer/sizer.dart';
// import 'package:url_launcher/url_launcher.dart';

class MedicationHistoryScreen extends StatefulWidget {
  final String userId;

  const MedicationHistoryScreen({
    super.key,
    required this.userId,
  });

  @override
  State<MedicationHistoryScreen> createState() =>
      _MedicationHistoryScreenState();
}

class _MedicationHistoryScreenState extends State<MedicationHistoryScreen> {
  late List<MedicationReminder> reminders;
  final Logger logger = Logger();
  bool status = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Reminder History",
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
                bool isMarked = reminders[index].isStarred;
                return Dismissible(
                  key: Key(reminders[index].getUniqueID),
                  onDismissed: (direction) async {
                    if (direction == DismissDirection.startToEnd) {
                      _showConfirmation(reminders, index);
                    } else if (direction == DismissDirection.endToStart) {
                      _showConfirmation(reminders, index);
                    }
                  },
                  background: Container(
                    color: Colors.redAccent,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.all(8.0),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                  child: Card(
                    elevation: 5.0,
                    shadowColor: const Color.fromARGB(255, 19, 1, 88),
                    margin: const EdgeInsets.all(10.0),
                    child: Container(
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(colors: [
                        Color.fromARGB(255, 255, 221, 182),
                        Color.fromARGB(255, 253, 244, 255),
                      ])),
                      child: ListTile(
                        title: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  if (!isMarked) {
                                    starredMedicationHistory(
                                        reminders[index].getUniqueID, index);
                                  } else {
                                    unStarredMedicationHistory(
                                        reminders[index].getUniqueID, index);
                                  }
                                });
                              },
                              child: Icon(
                                size: 40,
                                isMarked ? Icons.star : Icons.star_border,
                                color: isMarked
                                    ? const Color.fromARGB(255, 255, 154, 59)
                                    : null,
                              ),
                            ),
                            SizedBox(
                              width: 20.w,
                            ),
                            Text(
                              reminders[index].getMedicationName,
                              style: const TextStyle(
                                  fontFamily: "RubikDoodleShadow",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Color.fromARGB(255, 3, 40, 71)),
                            ),
                          ],
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
                                  text: '${reminders[index].dosage} mg',
                                  style: const TextStyle(
                                      fontFamily: "Salsa",
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
                                  text: '${reminders[index].medicineType}',
                                  style: const TextStyle(
                                      fontFamily: "Salsa",
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
                                      '${reminders[index].interval} seconds | ${reminders[index].interval == 60 ? "One time per minute" : "${(720 / (reminders[index].interval)).floor()} times in 12 minutes"}',
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
                                  text: "${reminders[index].startTime} hours",
                                  style: const TextStyle(
                                      fontFamily: "Salsa",
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
                                  text: reminders[index].treatmentDuration,
                                  style: const TextStyle(
                                      fontFamily: "Salsa",
                                      fontSize: 18,
                                      color: Color.fromARGB(255, 96, 4, 4)))
                            ])),
                          ],
                        ),
                        // You can customize the content padding as needed
                        contentPadding: const EdgeInsets.all(16.0),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 255, 245, 156),
        onPressed: () {},
        tooltip: 'Navigate to Pages',
        child: PopupMenuButton<int>(
          color: const Color.fromARGB(255, 255, 249, 199),
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 1,
              child: Row(
                children: [
                  Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Starred Reminder',
                    style: TextStyle(
                      fontFamily: "Salsa",
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 2,
              child: Row(
                children: [
                  Icon(Icons.history),
                  SizedBox(width: 8),
                  Text(
                    'Past Medication',
                    style: TextStyle(
                      fontFamily: "Salsa",
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ],
          onSelected: (value) {
            switch (value) {
              case 1:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        StarredMedicationHistoryScreen(userId: widget.userId),
                  ),
                );
                break;
              case 2:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        PreviousMedicationHistoryPage(userId: widget.userId),
                  ),
                );
                break;
            }
          },
        ),
      ),
    );
  }

  // void sendAllMedicationHistoriesByEmail() async {
  //   List<MedicationReminder> reminders =
  //       await fetchMedicationReminders(widget.userId);

  //   // Concatenate the information of all reminders into a single string
  //   String emailContent = '';
  //   for (MedicationReminder reminder in reminders) {
  //     emailContent += """
  //       Medication Name: ${reminder.getMedicationName}
  //       Dosage: ${reminder.dosage} mg
  //       Medicine Type: ${reminder.medicineType}
  //       Interval: ${reminder.interval} hours | ${reminder.interval == 24 ? "One time a day" : "${(24 / (reminder.interval)).floor()} times a day"}
  //       Start Time: ${reminder.startTime}
  //       Created Time: ${DateFormat.yMd().add_jm().format(reminder.createdTime)}
  //       -------------------------------------
  //     """;
  //   }

  //   // Launch the default email application
  //   final Uri emailLaunchUri = Uri(
  //     scheme: 'mailto',
  //     path: 'ZhiYanWai@gmail.com', // Set the recipient email address
  //     queryParameters: {
  //       'subject': 'Medication Histories',
  //       'body': emailContent
  //     },
  //   );

  //   if (await canLaunchUrl(emailLaunchUri)) {
  //     await launchUrl(emailLaunchUri);
  //   } else {
  //     throw 'Could not launch email';
  //   }
  // }

  void _showConfirmation(List<MedicationReminder> reminders, int index) async {
    String medicationNameToDelete = reminders[index].getMedicationName;
    bool? result = await ConfirmationDialog.showConfirmationDialog(
        context,
        mGeneralConfirmation,
        'Are you sure you want to delete $medicationNameToDelete?',
        () {},
        () {},
        lottieAnimationPath:
            'assets/animations/lottie/Animation - 1704102211072.json');
    if (result == true) {
      await deleteMedicationHistory(reminders[index].getUniqueID);

      // Delete locally from the list
      setState(() {
        reminders.removeAt(index);
      });

      // ignore: use_build_context_synchronously
      Get.snackbar("", '$medicationNameToDelete is deleted!',
          backgroundColor:
              const Color.fromARGB(255, 217, 5, 5).withOpacity(0.7),
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          duration: const Duration(milliseconds: 1000));
    } else {
      setState(() {});
    }
  }

  Future<List<MedicationReminder>> fetchMedicationReminders(
      String userId) async {
    final logger = Logger();
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('Users')
              .doc(userId)
              .collection('Reminders History')
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
          treatmentDuration: data['treatmentDuration'] ?? 'Not Specified',
          extInfo: data['extraInfo'] ?? '',
          isStarred: data['isStarred'] ?? false,
          createdTime: data['createdTime'],
        );
      }).toList();

      return reminders;
    } catch (e, stackTrace) {
      logger.e('Error fetching medication reminders',
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<void> deleteMedicationHistory(String documentId) async {
    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.userId)
          .collection('Reminders History')
          .doc(documentId)
          .delete();
    } catch (e) {
      Get.snackbar("Error", 'Error deleting medication history: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Future<void> starredMedicationHistory(String documentId, int index) async {
    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.userId)
          .collection('Reminders History')
          .doc(documentId)
          .update({
        'isStarred': true,
      });

      DocumentSnapshot<Map<String, dynamic>> medicationHistorySnapshot =
          await FirebaseFirestore.instance
              .collection('Users')
              .doc(widget.userId)
              .collection('Reminders History')
              .doc(documentId)
              .get();

      Map<String, dynamic>? medicationData = medicationHistorySnapshot.data();
      if (medicationData != null) {
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(widget.userId)
            .collection('Starred Medication History')
            .doc(documentId)
            .set(medicationData);
      }
      Get.snackbar("", '${reminders[index].getMedicationName} is starred!',
          backgroundColor:
              const Color.fromARGB(255, 0, 152, 15).withOpacity(0.7),
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          duration: const Duration(milliseconds: 1000));
    } catch (e) {
      Get.snackbar("Error", 'Error moving medication history: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Future<void> unStarredMedicationHistory(String documentId, int index) async {
    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.userId)
          .collection('Reminders History')
          .doc(documentId)
          .update({
        'isStarred': false,
      });

      await FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.userId)
          .collection('Starred Medication History')
          .doc(documentId)
          .delete();

      Get.snackbar("", '${reminders[index].getMedicationName} is unstarred!',
          backgroundColor: Colors.red.withOpacity(0.7),
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          duration: const Duration(milliseconds: 1000));
    } catch (e) {
      logger.e('Error moving medication history: $e');
    }
  }
}

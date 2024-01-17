// ignore_for_file: use_build_context_synchronously, duplicate_ignore

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:medapp/common/confirmation_dialog.dart';
import 'package:medapp/constant/colors.dart';
import 'package:medapp/constant/image_string.dart';
import 'package:medapp/constant/text_string.dart';
import 'package:medapp/models/medicine_type.dart';
import 'package:medapp/screens/home_page/home_page.dart';
import 'package:medapp/screens/new_entry/widget/interval_selection.dart';
import 'package:medapp/screens/new_entry/widget/medicine_type.dart';
import 'package:medapp/screens/new_entry/widget/panel_widget.dart';
import 'package:medapp/screens/new_entry/widget/select_time.dart';
import 'package:medapp/services/medicine_type_controller.dart';
import 'package:sizer/sizer.dart';
import 'package:timezone/timezone.dart' as tz;

class UpdateMedicineDetailsScreen extends StatefulWidget {
  const UpdateMedicineDetailsScreen(
      {super.key,
      required this.eMedicationName,
      this.eMedicineType,
      required this.eStartTime,
      this.eDosage,
      required this.eInterval,
      this.eExtInfo,
      this.eTreatmentDuration,
      required this.userId,
      required this.eDocumentId});
  //e indicates existing
  final String userId;
  final String eMedicationName;
  final String? eMedicineType;
  final String eStartTime;
  final int? eDosage;
  final int eInterval;
  final String? eExtInfo;
  final String? eTreatmentDuration;
  final String eDocumentId;

  @override
  State<UpdateMedicineDetailsScreen> createState() =>
      _UpdateMedicineDetailsScreenState();
}

class _UpdateMedicineDetailsScreenState
    extends State<UpdateMedicineDetailsScreen> {
  late MedicineTypeController medicineTypeController;
  late TextEditingController dosageAmountController;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    medicineTypeController = MedicineTypeController();
    medicineTypeController.medicineTypeStream.listen((MedicineType type) {
      setState(() {
        selectedMedicineType = type; // Update your selectedMedicineType state
      });
    });
    dosageAmountController = TextEditingController();
    initializeNotifications();
  }

  @override
  void dispose() {
    super.dispose();
    medicineTypeController.dispose();
    dosageAmountController.dispose();
  }

  MedicineType? selectedMedicineType;
  bool isTap = false;
  int selectedInterval = 0;
  String message = "";
  String selectedTime = "";
  String pendingDltItem = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Edit Details",
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
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              _showConfirmation();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              children: [
                const PanelTitle(
                  title: mDosageInput,
                  isRequired: false,
                ),
                SizedBox(
                  height: 2.h,
                ),
                TextFormField(
                  maxLength: 3,
                  controller: dosageAmountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      hintText: "Your previous dosage is ${widget.eDosage} mg",
                      border: const OutlineInputBorder()),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: kOtherColor),
                ),
                SizedBox(
                  height: 4.h,
                ),
                const PanelTitle(title: mMedicineTypeInput, isRequired: false),
                Text(
                  "Previous medicine type - ${widget.eMedicineType}",
                  style: const TextStyle(
                      color: Colors.redAccent, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 2.h,
                ),
                StreamBuilder<MedicineType>(
                  //New entry block
                  stream: medicineTypeController.medicineTypeStream,
                  builder: (context, snapshot) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          MedicineTypeColumn(
                            medicineType: MedicineType.inhaler,
                            name: mInhaler,
                            iconValue: mInhalerIcon,
                            isSelected: snapshot.data == MedicineType.inhaler
                                ? true
                                : false,
                            ontap: () {
                              medicineTypeController
                                  .toggleMedicineType(MedicineType.inhaler);
                            },
                            onDoubletap: () {
                              medicineTypeController.deselectMedicineType();
                            },
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          MedicineTypeColumn(
                            medicineType: MedicineType.syrup,
                            name: mSyrup,
                            iconValue: mSyrupIcon,
                            isSelected: snapshot.data == MedicineType.syrup
                                ? true
                                : false,
                            ontap: () {
                              medicineTypeController
                                  .toggleMedicineType(MedicineType.syrup);
                            },
                            onDoubletap: () {
                              medicineTypeController.deselectMedicineType();
                            },
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          MedicineTypeColumn(
                            medicineType: MedicineType.pill,
                            name: mPill,
                            iconValue: mPillIcon,
                            isSelected: snapshot.data == MedicineType.pill
                                ? true
                                : false,
                            ontap: () {
                              medicineTypeController
                                  .toggleMedicineType(MedicineType.pill);
                            },
                            onDoubletap: () {
                              medicineTypeController.deselectMedicineType();
                            },
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          MedicineTypeColumn(
                            medicineType: MedicineType.syringe,
                            name: mSyringe,
                            iconValue: mSyringeIcon,
                            isSelected: snapshot.data == MedicineType.syringe
                                ? true
                                : false,
                            ontap: () {
                              medicineTypeController
                                  .toggleMedicineType(MedicineType.syringe);
                            },
                            onDoubletap: () {
                              medicineTypeController.deselectMedicineType();
                            },
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          MedicineTypeColumn(
                            medicineType: MedicineType.tablet,
                            name: mTablet,
                            iconValue: mTabletIcon,
                            isSelected: snapshot.data == MedicineType.tablet
                                ? true
                                : false,
                            ontap: () {
                              medicineTypeController
                                  .toggleMedicineType(MedicineType.tablet);
                            },
                            onDoubletap: () {
                              medicineTypeController.deselectMedicineType();
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: 4.h,
                ),
                const PanelTitle(title: mIntervalSelection, isRequired: false),
                Text(
                  "Previous interval - ${widget.eInterval} hours",
                  style: const TextStyle(
                      color: Colors.redAccent, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 2.h,
                ),
                IntervalSelection(
                  onIntervalSelected: (int val) {
                    setState(() {
                      selectedInterval = val;
                    });
                  },
                ),
                SizedBox(
                  height: 2.h,
                ),
                const PanelTitle(title: mStartingTime, isRequired: true),
                SelectTime(
                  onTimeSelected: (TimeOfDay time) {
                    setState(() {
                      selectedTime =
                          '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  initializeNotifications() async {
    var initializationSettingsAndroid =
        const AndroidInitializationSettings("@mipmap/ic_launcher");
    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  Future<void> addNotification(
      String title,
      String userId,
      String medicationName,
      int? dosage,
      String medicineType,
      String startTime,
      int? interval) async {
    DateTime now = DateTime.now();
    String message;
    int? newDosage;
    String formattedDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    if (dosage == 0) {
      dosage = widget.eDosage;
      newDosage = dosage;
    } else {
      newDosage = dosage;
    }

    message =
        "You have just editted a reminder named $medicationName with $newDosage mg at $formattedDateTime.";

    CollectionReference inAppNotifications = FirebaseFirestore.instance
        .collection("Users")
        .doc(userId)
        .collection("In App Notifications");

    await inAppNotifications.add({
      'title': title,
      'message': message,
      'timestamp': formattedDateTime,
      'read': false,
    });
  }

  void _showConfirmation() async {
    bool? result = await ConfirmationDialog.showConfirmationDialog(
        context, mUMDConfirmationTitle, mMDConfirmationContent, () {}, () {},
        lottieAnimationPath:
            'assets/animations/lottie/Animation - 1704102128921.json');
    if (result == true) {
      await _updateMedecineDetails();
      Navigator.of(context).pop();
      addNotification(
          "New Reminder!!!",
          widget.userId,
          widget.eMedicationName,
          int.tryParse(dosageAmountController.text),
          selectedMedicineType.toString(),
          widget.eStartTime,
          selectedInterval);
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => HomePage(userId: widget.userId)),
      );
    }
  }

  Future<void> scheduleNotification(
      String medicationName,
      dynamic dosage,
      String? medicineType,
      String startTime,
      int interval,
      List<int> pushNotificationIDs,
      String pendingDltItem) async {
    try {
      //Get current date
      DateTime now = DateTime.now();
      var hour = int.parse(startTime.substring(0, 2));
      var minute = int.parse(startTime.substring(3, 5));
      DateTime firstNotification =
          DateTime(now.year, now.month, now.day, hour, minute);

      var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        "pillReminderChannelId",
        "Pill Reminders",
        importance: Importance.max,
        ledColor: Colors.amber,
        ledOffMs: 1000,
        ledOnMs: 1000,
        enableLights: true,
      );

      var platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);

      message = medicineType == "none"
          ? "It is time to take your medicine, according to schedule"
          : "It is time to take your medicine in $medicineType form, according to schedule";

      if (medicineType.toString() != "none") {
        message += widget.eExtInfo != "" ? " ${widget.eExtInfo}" : "";
        message += widget.eTreatmentDuration != ""
            ? ", the treatment will take about ${widget.eTreatmentDuration}"
            : "";
      } else if (widget.eExtInfo != "") {
        message += " ${widget.eExtInfo}";
        message += widget.eTreatmentDuration != ""
            ? ", the treatment will take about ${widget.eTreatmentDuration}"
            : "";
      } else if (widget.eTreatmentDuration != "") {
        message +=
            ", the treatment will take about ${widget.eTreatmentDuration}";
      }

      for (int i = 0; i < (150 / interval).floor(); i++) {
        var scheduledTime = tz.TZDateTime.from(
          firstNotification.add(Duration(seconds: interval * i)),
          tz.local,
        );
        await flutterLocalNotificationsPlugin.zonedSchedule(
          pushNotificationIDs[i],
          "Reminder $medicationName",
          message,
          scheduledTime,
          platformChannelSpecifics,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          payload: "action_take",
        );

        // Example: Customized duration (5 minutes)
        DateTime exactDeletionTime = firstNotification
            .add(Duration(seconds: interval * 4)); // Adjust as needed
// Example: Schedule a delayed task for deletion
        Future.delayed(exactDeletionTime.difference(DateTime.now()), () async {
          try {
            // Example: Perform the deletion
            await FirebaseFirestore.instance
                .collection("Users")
                .doc(widget.userId)
                .collection("Medication Reminders")
                .doc(pendingDltItem)
                .delete();
          } catch (e) {
            Get.snackbar("Error", "Error deleting reminder: $e",
                backgroundColor: Colors.red, colorText: Colors.white);
          }
        });
      }
    } catch (e) {
      Get.snackbar("Error", "Error scheduling notification: $e",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Future<void> _updateMedecineDetails() async {
    dynamic newDosage = dosageAmountController.text.isEmpty
        ? widget.eDosage
        : int.tryParse(dosageAmountController.text) ?? widget.eDosage;
    String? newMedicineType =
        selectedMedicineType?.toString().substring(13) ?? widget.eMedicineType;
    int newInterval =
        selectedInterval == 0 ? widget.eInterval : selectedInterval;
    String newStartTime =
        selectedTime.isEmpty ? widget.eStartTime : selectedTime;
    List<int> notificationIDs = makeIDs(150 / newInterval);

    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.userId)
          .collection('Medication Reminders')
          .doc(widget.eDocumentId)
          .update({
        'notificationIDs': notificationIDs,
        'dosage': newDosage,
        'medicineType': newMedicineType,
        'interval': newInterval,
        'startTime': newStartTime
      });
      pendingDltItem = widget.eDocumentId;
      scheduleNotification(widget.eMedicationName, newDosage, newMedicineType,
          newStartTime, newInterval, notificationIDs, pendingDltItem);

      Get.snackbar('Success', 'MedPartner data updated!',
          backgroundColor: Colors.green, colorText: Colors.white);
      Navigator.pop(context);
    } catch (e) {
      Get.snackbar('Error', 'Failed to update MedPartner data!',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  List<int> makeIDs(double n) {
    var rng = Random();
    List<int> ids = [];
    for (int i = 0; i < n; i++) {
      ids.add(rng.nextInt(1000000000));
    }
    return ids;
  }
}

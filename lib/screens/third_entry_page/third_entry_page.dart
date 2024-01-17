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
import 'package:medapp/screens/new_entry/widget/extra_info_selection.dart';
import 'package:medapp/screens/new_entry/widget/panel_widget.dart';
import 'package:medapp/screens/new_entry/widget/treatment_duration.dart';
import 'package:medapp/screens/success_screen/success_screen.dart';
import 'package:sizer/sizer.dart';
import 'package:timezone/timezone.dart' as tz;

class ThirdEntryPage extends StatefulWidget {
  const ThirdEntryPage(
      {super.key,
      required this.medicationNameController,
      required this.dosageController,
      required this.selectedMedicineType,
      required this.selectedTime,
      required this.selectedInterval,
      required this.userId});
  final TextEditingController medicationNameController;
  final TextEditingController dosageController;
  final MedicineType selectedMedicineType;
  final String selectedTime;
  final int selectedInterval;
  final String userId;

  @override
  State<ThirdEntryPage> createState() => _ThirdEntryPageState();
}

class _ThirdEntryPageState extends State<ThirdEntryPage> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  //String variables
  String selectedInfo = "";
  String selectedTreatmentDuration = "";
  bool isStarred = false;
  String pendingDltItem = "";
  String message = "";
  String messageInApp = "";

  @override
  void initState() {
    super.initState();
    initializeNotifications();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Additional Info",
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
      ),
      body: Stack(children: [
        Positioned.fill(
            bottom: -300,
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                const Color.fromARGB(255, 250, 243, 222)
                    .withOpacity(0.4), // Adjust opacity value as needed
                BlendMode.dstATop,
              ),
              child: Image.asset(
                mThirdEntryImage,
                width: 200.0,
                height: 200.0,
              ),
            )),
        Column(
          children: [
            const PanelTitle(title: mExtraInfo, isRequired: false),
            SizedBox(
              height: 2.h,
            ),
            ExtraInfoSelection(
              onExtInfoSelected: (String val) {
                setState(() {
                  selectedInfo = val;
                });
              },
            ),
            SizedBox(
              height: 4.h,
            ),
            const PanelTitle(title: mTreatmentDuration, isRequired: false),
            SizedBox(
              height: 2.h,
            ),
            TreatmentDurationSelection(
                onTreatmentDurationSelected: (String val) {
              setState(() {
                selectedTreatmentDuration = val;
              });
            }),
            SizedBox(
              height: 5.h,
            ),
            Padding(
              padding: EdgeInsets.only(left: 8.w, right: 8.w),
              child: SizedBox(
                width: 80.w,
                height: 8.h,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    shape: const StadiumBorder(),
                  ),
                  child: Center(
                    child: Text(
                      mConfirm,
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                            color: Colors.white,
                          ),
                    ),
                  ),
                  onPressed: () {
                    _showConfirmation();
                  },
                ),
              ),
            )
          ],
        ),
      ]),
    );
  }

  void _showConfirmation() async {
    bool? result = await ConfirmationDialog.showConfirmationDialog(
        context, mConfirmMedicationTitle, mConfirmation, () {}, () {},
        lottieAnimationPath:
            'assets/animations/lottie/Animation - 1704102159657.json');
    if (result == true) {
      validation_1();
    }
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

      if (medicineType == "none") {
        message = "It is time to take your medicine";
        if (selectedInfo != "") {
          message += " $selectedInfo";
        }
        if (selectedTreatmentDuration != "") {
          message +=
              ", the treatment will take about $selectedTreatmentDuration";
        }
      } else {
        message = "It is time to take your medicine in $medicineType form";
        if (selectedInfo != "") {
          message += " $selectedInfo";
        }
        if (selectedTreatmentDuration != "") {
          message +=
              ", the treatment will take about $selectedTreatmentDuration";
        }
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

  List<int> makeIDs(double n) {
    var rng = Random();
    List<int> ids = [];
    for (int i = 0; i < n; i++) {
      ids.add(rng.nextInt(1000000000));
    }
    return ids;
  }

  void displayError(String error) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: kOtherColor,
      content: Text(error),
      duration: const Duration(milliseconds: 2000),
    ));
  }

  void validation_1() async {
    dynamic dsg = "";
    if (widget.dosageController.text == "") {
      dsg = "unknown";
    } else {
      dsg = int.tryParse(widget.dosageController.text);
    }

    int interval = widget.selectedInterval;
    String medicineType = widget.selectedMedicineType.toString().substring(13);
    List<int> notificationIDs = makeIDs(150 / widget.selectedInterval);
    String selectedStartTime = widget.selectedTime;
    String medicationName = widget.medicationNameController.text;

    try {
      // Create a new document reference
      var newReminderRef = FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.userId)
          .collection('Medication Reminders')
          .doc();
      var medicationHistoryRef = FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.userId)
          .collection('Reminders History')
          .doc();
      DateTime currentTime = DateTime.now();
      String formattedDateTime =
          DateFormat('yyyy-MM-dd HH:mm:ss').format(currentTime);

      // Store the medication reminder in Firestore under the current user's collection
      await newReminderRef.set({
        'id':
            newReminderRef.id, // Storing the auto-generated ID in the document
        'medicationName': medicationName,
        'notificationIDs': notificationIDs,
        'dosage': dsg,
        'medicineType': medicineType,
        'interval': interval,
        'startTime': selectedStartTime,
        'treatmentDuration': selectedTreatmentDuration,
        'extraInfo': selectedInfo,
        'createdTime': formattedDateTime,
      }).whenComplete(() => Get.snackbar(
            "Success",
            "You have successfully created a new medication reminder!",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green.withOpacity(0.1),
            colorText: Colors.green,
          ));
      pendingDltItem = newReminderRef.id;

      await medicationHistoryRef.set({
        'id': medicationHistoryRef
            .id, // Storing the auto-generated ID in the document
        'notificationIDs': notificationIDs,
        'medicationName': medicationName,
        'dosage': dsg,
        'medicineType': medicineType,
        'interval': interval,
        'startTime': selectedStartTime,
        'treatmentDuration': selectedTreatmentDuration,
        'extraInfo': selectedInfo,
        'createdTime': formattedDateTime,
        'isStarred': isStarred
      });

      await addNotification("New Reminders!!!", widget.userId, medicationName,
          dsg, selectedStartTime, medicineType, formattedDateTime);
      scheduleNotification(medicationName, dsg, medicineType, selectedStartTime,
          interval, notificationIDs, pendingDltItem);

      // Navigate to the success screen
      Get.to(() => SuccessScreen(userId: widget.userId));
    } catch (e) {
      displayError("Failed to store reminder: $e");
    }
  }

  Future<void> addNotification(
      String title,
      String userId,
      String medicationName,
      dynamic dosage,
      String startTime,
      String medicineType,
      String currentTime) async {
    messageInApp =
        "You will have a reminder at $startTime for $medicationName with ${dosage ?? "unknown"} mg";

    if (medicineType != "none") {
      messageInApp += ", $medicineType";
    }

    messageInApp += ".\nCreated time: $currentTime";

    CollectionReference inAppNotifications = FirebaseFirestore.instance
        .collection("Users")
        .doc(userId)
        .collection("In App Notifications");

    await inAppNotifications.add({
      'title': title,
      'message': messageInApp,
      'timestamp': currentTime,
      'read': false,
    });
  }
}

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
import 'package:medapp/screens/new_entry/widget/panel_widget.dart';
import 'package:medapp/screens/new_entry/widget/select_time.dart';
import 'package:medapp/screens/success_screen/success_screen.dart';
import 'package:medapp/screens/third_entry_page/third_entry_page.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:sizer/sizer.dart';
import 'package:timezone/timezone.dart' as tz;

class SecondEntryPage extends StatefulWidget {
  const SecondEntryPage(
      {super.key,
      required this.medicationNameController,
      required this.dosageController,
      required this.selectedMedicineType,
      required this.userId});
  final String userId;
  final TextEditingController medicationNameController;
  final TextEditingController dosageController;
  final MedicineType selectedMedicineType;

  @override
  State<SecondEntryPage> createState() => _SecondEntryPageState();
}

class _SecondEntryPageState extends State<SecondEntryPage> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  //int variable
  int selectedInterval = 0;
  //String variable
  String selectedTime = "";
  String pendingDltItem = "";
  String messageInApp = "";
  String messagePN = "";
  //bool variable
  bool isStarred = false;

  @override
  void initState() {
    super.initState();
    initializeNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          mAddNewMedicine,
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
                mSecondEntryImage,
                width: 200.0,
                height: 200.0,
              ),
            )),
        Padding(
          padding: EdgeInsets.all(2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const PanelTitle(title: mIntervalSelection, isRequired: true),
              SizedBox(
                height: 2.h,
              ),
              IntervalSelection(
                onIntervalSelected: (int val) {
                  setState(() {
                    selectedInterval = val;
                    _showProgressIndicator(context);
                  });
                },
              ),
              SizedBox(
                height: 4.h,
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
              SizedBox(
                height: 30.h,
              ),
              Padding(
                padding: EdgeInsets.only(left: 8.w, right: 8.w),
                child: SizedBox(
                  width: 80.w,
                  height: 8.h,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      shape: const StadiumBorder(
                          side: BorderSide(width: 2, color: Colors.pinkAccent)),
                    ),
                    child: Center(
                      child: Text(
                        mNext,
                        style:
                            Theme.of(context).textTheme.displayLarge!.copyWith(
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
        ),
      ]),
    );
  }

  void _showConfirmation() async {
    bool? result = await ConfirmationDialog.showConfirmationDialog(
        context, mSEConfirmationTitle, mSEConfirmationContent, () {}, () {},
        cancelButtonText: "Done",
        confirmButtonText: "Proceed",
        lottieAnimationPath:
            'assets/animations/lottie/Animation - 1704100271063.json');
    if (!context.mounted) return;
    if (result == true) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ThirdEntryPage(
            userId: widget.userId,
            medicationNameController: widget.medicationNameController,
            dosageController: widget.dosageController,
            selectedTime: selectedTime,
            selectedInterval: selectedInterval,
            selectedMedicineType: widget.selectedMedicineType,
          ),
        ),
      );
    } else if (result == false) {
      validation_2();
    }
  }

  void _showProgressIndicator(BuildContext context) {
    String medicationName = widget.medicationNameController.text;
    if (medicationName != "" && selectedInterval != 0) {
      // Show progress indicator as an overlay
      showGeneralDialog(
        context: context,
        barrierDismissible: false,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext, Animation animation,
            Animation secondaryAnimation) {
          return Center(
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularPercentIndicator(
                    animation: true,
                    animationDuration: 1000,
                    radius: 100,
                    lineWidth: 20,
                    percent: 0.67,
                    progressColor: Colors.greenAccent,
                    backgroundColor: const Color.fromARGB(255, 60, 98, 61),
                    circularStrokeCap: CircularStrokeCap.round,
                    center: const Text(
                      textAlign: TextAlign.center,
                      "67%, One \nmore step left!",
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 191, 0),
                        fontFamily: "RubikDoodleShadow",
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
      // Simulate a 2-second delay, then you can perform additional tasks
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.of(context).pop(); // Close the progress indicator overlay
      });
    }
  }

  void displayError(String error) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: kOtherColor,
      content: Text(error),
      duration: const Duration(milliseconds: 2000),
    ));
  }

  List<int> makeIDs(double n) {
    var rng = Random();
    List<int> ids = [];
    for (int i = 0; i < n; i++) {
      ids.add(rng.nextInt(1000000000));
    }
    return ids;
  }

  initializeNotifications() async {
    var initializationSettingsAndroid =
        const AndroidInitializationSettings("@mipmap/ic_launcher");
    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void validation_2() async {
    dynamic dsg = "";
    if (widget.dosageController.text == "") {
      dsg = "unknown";
    } else {
      dsg = int.tryParse(widget.dosageController.text);
    }
    List<int> notificationIDs = makeIDs(150 / selectedInterval);
    String medicineType = widget.selectedMedicineType.toString().substring(13);
    String medicineName = widget.medicationNameController.text;

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
        'medicationName': widget.medicationNameController.text,
        'notificationIDs': notificationIDs,
        'dosage': dsg,
        'medicineType': medicineType,
        'interval': selectedInterval,
        'startTime': selectedTime,
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
        'medicationName': medicineName,
        'dosage': dsg,
        'medicineType': medicineType,
        'interval': selectedInterval,
        'startTime': selectedTime,
        'createdTime': formattedDateTime,
        'isStarred': isStarred
      });
      await addNotification("New Reminders!!!", widget.userId, medicineName,
          dsg, selectedTime, medicineType, formattedDateTime);
      scheduleNotification(medicineName, dsg, medicineType, selectedTime,
          selectedInterval, notificationIDs, pendingDltItem);
      // scheduleNotification(newReminderRef);
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
    messageInApp = "You will have a reminder at $startTime for $medicationName";

    if (dosage != "unknown") {
      messageInApp += ", $dosage mg";
    }

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

      messagePN = "Times to take your medication!!!";
      if (medicineType != "none") {
        messagePN += " In $medicineType form.";
      }
      if (dosage != "unknown") {
        messagePN += " $dosage mg.";
      }

      var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
          "pillReminderChannelId", "Pill Reminders",
          importance: Importance.max,
          ledColor: Colors.amber,
          ledOffMs: 1000,
          ledOnMs: 1000,
          enableLights: true);

      var platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);

      for (int i = 0; i < (150 / interval).floor(); i++) {
        var scheduledTime = tz.TZDateTime.from(
          firstNotification.add(Duration(seconds: interval * i)),
          tz.local,
        );
        await flutterLocalNotificationsPlugin.zonedSchedule(
          pushNotificationIDs[i],
          "Reminder $medicationName",
          messagePN,
          scheduledTime,
          platformChannelSpecifics,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          payload: "action_take",
        );

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

  Future onSelectNotification(String? payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => HomePage(userId: widget.userId)));
  }
}

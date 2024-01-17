import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:medapp/common/confirmation_dialog.dart';
import 'package:medapp/constant/colors.dart';
import 'package:medapp/models/illness.dart';
import 'package:medapp/screens/new_entry/widget/panel_widget.dart';
import 'package:medapp/screens/success_screen/success_screen.dart';
import 'package:sizer/sizer.dart';

class AddPastMedicationHistory extends StatefulWidget {
  const AddPastMedicationHistory({super.key, required this.userId});
  final String userId;

  @override
  State<AddPastMedicationHistory> createState() =>
      _AddPastMedicationHistoryState();
}

class _AddPastMedicationHistoryState extends State<AddPastMedicationHistory> {
  TextEditingController illnessC = TextEditingController();
  TextEditingController treatmentC = TextEditingController();
  TextEditingController dosageC = TextEditingController();
  TextEditingController dateController = TextEditingController();
  Illness illness = Illness();
  List<Map<String, dynamic>> foundIllnessNames = [];

  IconData icon = Icons.search_rounded;
  Color iconColor = Colors.black;
  IconData icon2 = Icons.keyboard;
  Color iconColor2 = Colors.black;
  IconData icon3 = Icons.medication_outlined;
  Color iconColor3 = Colors.black;
  Color buttonColor = kPrimaryColor;
  Color textColor = Colors.white;

  //String variables
  String selectedIllness = "";
  String customIllnessName = "";
  String feedback = "-";

  //DateTime
  DateTime? startDate;
  DateTime? endDate;

  //bool variable
  bool showDropdown = false;
  bool isDateSelected = false;

  //double variable
  double sliderValue = 0.0;

  //Icon data
  IconData feedbackEmoji = FontAwesomeIcons.faceMehBlank;

  //color
  Color feedbackColor = Colors.grey;
  Color activeColor = Colors.grey;
  Color feedbackStringColor = Colors.grey;
  Color ratingColor = Colors.grey;

  @override
  void dispose() {
    super.dispose();
    illnessC.dispose();
    treatmentC.dispose();
    dosageC.dispose();
    dateController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("~Add~"),
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
            icon: const Icon(
              Icons.save,
              color: Colors.white,
            ),
            onPressed: () {
              showConfirmation();
            },
          ),
        ],
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: [
          Padding(
            padding: EdgeInsets.all(2.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const PanelTitle(title: "Illness", isRequired: true),
                TextFormField(
                  controller: illnessC,
                  onChanged: (value) {
                    setState(() {
                      filteredIllnessNames(value);
                      if (value.isEmpty) {
                        icon = Icons.search_rounded;
                        iconColor = Colors.black;
                      }
                    });
                  },
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                      hintText: "Your illness name...",
                      border: const OutlineInputBorder(),
                      suffixIcon: Icon(
                        icon,
                        color: iconColor,
                        weight: 5.0,
                        size: 40,
                      )),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: kOtherColor),
                ),
                buildIllnessDropdown(),
                const PanelTitle(title: "How to treat?", isRequired: false),
                TextFormField(
                  controller: treatmentC,
                  textCapitalization: TextCapitalization.words,
                  onChanged: (value) {
                    setState(() {
                      if (value.isNotEmpty) {
                        icon2 = Icons.check_rounded;
                        iconColor2 = Colors.greenAccent;
                      } else if (value.isEmpty) {
                        icon2 = Icons.keyboard;
                        iconColor2 = Colors.black;
                      }
                    });
                  },
                  decoration: InputDecoration(
                      hintText: "What treatment you have undergone...",
                      border: const OutlineInputBorder(),
                      suffixIcon: Icon(
                        icon2,
                        color: iconColor2,
                        weight: 5.0,
                        size: 40,
                      )),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: kOtherColor),
                ),
                const PanelTitle(title: "Dosage", isRequired: false),
                TextFormField(
                  controller: dosageC,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      if (value.isNotEmpty) {
                        icon3 = Icons.check_rounded;
                        iconColor3 = Colors.greenAccent;
                      } else if (value.isEmpty) {
                        icon3 = Icons.medication_outlined;
                        iconColor3 = Colors.black;
                      }
                    });
                  },
                  decoration: InputDecoration(
                      hintText: "Mg per dosage...",
                      border: const OutlineInputBorder(),
                      suffixIcon: Icon(
                        icon3,
                        color: iconColor3,
                        weight: 5.0,
                        size: 40,
                      )),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: kOtherColor),
                ),
                const PanelTitle(title: "Start/End Date", isRequired: false),
                Center(
                  child: SizedBox(
                    height: 10.h,
                    width: 75.w,
                    child: Padding(
                      padding: EdgeInsets.only(top: 2.h),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: buttonColor,
                          shape: const StadiumBorder(),
                        ),
                        onPressed: () => _selectDate(context),
                        child: Text(
                          isDateSelected
                              ? startDate != null && endDate != null
                                  ? "${DateFormat.yMMMd().format(startDate!)} - ${DateFormat.yMMMd().format(endDate!)}"
                                  : "Select Dates"
                              : "Select Dates",
                          style: TextStyle(
                              fontFamily: "Varelaround",
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: textColor),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Align(
                    child: Material(
                  color: const Color.fromARGB(255, 52, 50, 47),
                  elevation: 6.0,
                  borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                  shadowColor: Colors.amber,
                  child: SizedBox(
                    width: 350,
                    height: 400,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            feedback,
                            style: TextStyle(
                                fontFamily: "RubikDoodleShadow",
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: feedbackStringColor),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            feedbackEmoji,
                            color: feedbackColor,
                            size: 80,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Slider(
                            min: 0.0,
                            max: 5.0,
                            divisions: 5,
                            value: sliderValue,
                            activeColor: activeColor,
                            inactiveColor: Colors.grey,
                            onChanged: (newValue) {
                              setState(() {
                                sliderValue = newValue;
                                if (sliderValue >= 0.1 && sliderValue <= 1.0) {
                                  feedbackEmoji = FontAwesomeIcons.faceSadCry;
                                  feedbackColor = Colors.red;
                                  activeColor = Colors.red;
                                  feedbackStringColor = Colors.red;
                                  ratingColor = Colors.red;
                                  feedback = "NOT EFFECTIVE";
                                } else if (sliderValue >= 1.1 &&
                                    sliderValue <= 2.0) {
                                  feedbackEmoji = FontAwesomeIcons.faceFrown;
                                  feedbackColor = Colors.orange;
                                  activeColor = Colors.orange;
                                  feedbackStringColor = Colors.orange;
                                  ratingColor = Colors.orange;
                                  feedback = "SLIGHTLY EFFECTIVE";
                                } else if (sliderValue >= 2.1 &&
                                    sliderValue <= 3.0) {
                                  feedbackEmoji = FontAwesomeIcons.faceMeh;
                                  feedbackColor = Colors.amber;
                                  activeColor = Colors.amber;
                                  feedbackStringColor = Colors.amber;
                                  ratingColor = Colors.amber;
                                  feedback = "MODERATELY EFFECTIVE";
                                } else if (sliderValue >= 3.1 &&
                                    sliderValue <= 4.0) {
                                  feedbackEmoji = FontAwesomeIcons.faceSmile;
                                  feedbackColor = Colors.yellow;
                                  activeColor = Colors.yellow;
                                  feedbackStringColor = Colors.yellow;
                                  ratingColor = Colors.yellow;
                                  feedback = "EFFECTIVE";
                                } else if (sliderValue >= 4.1 &&
                                    sliderValue <= 5.0) {
                                  feedbackEmoji = FontAwesomeIcons.faceLaugh;
                                  feedbackColor = Colors.greenAccent;
                                  activeColor = Colors.greenAccent;
                                  feedbackStringColor = Colors.greenAccent;
                                  ratingColor = Colors.greenAccent;
                                  feedback = "VERY EFFECTIVE";
                                } else {
                                  feedbackEmoji = FontAwesomeIcons.faceMehBlank;
                                  feedbackColor = Colors.grey;
                                  activeColor = Colors.grey;
                                  feedbackStringColor = Colors.grey;
                                  ratingColor = Colors.grey;
                                  feedback = "-";
                                }
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            "Your Rating: $sliderValue",
                            style: TextStyle(
                                color: ratingColor,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ))
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTimeRange? pickedDateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDateRange != null) {
      setState(() {
        startDate = pickedDateRange.start;
        endDate = pickedDateRange.end;
        dateController.text = _formatDateRange(startDate, endDate);
        isDateSelected = true;
        buttonColor = Colors.greenAccent;
        textColor = Colors.black;
      });
    }
  }

  String _formatDateRange(DateTime? start, DateTime? end) {
    if (start != null && end != null) {
      return "Start Date: ${DateFormat.yMMMd().format(start)}\nEnd Date: ${DateFormat.yMMMd().format(end)}";
    } else {
      return "Select Dates";
    }
  }

  Widget buildIllnessDropdown() {
    if (showDropdown) {
      if (foundIllnessNames.isNotEmpty) {
        return SizedBox(
          height: foundIllnessNames.length * 25.0,
          child: Scrollbar(
            child: ListView.builder(
              itemCount: foundIllnessNames.length,
              itemBuilder: (context, index) => ListTile(
                key: ValueKey(foundIllnessNames[index]),
                onTap: () => selectIllness(foundIllnessNames[index]["name"]),
                title: RichText(
                  text: highlightMatchedLetters(
                    foundIllnessNames[index]["name"],
                  ),
                ),
              ),
            ),
          ),
        );
      } else {
        return SizedBox(
          height: 200,
          child: Image.asset(
            'assets/images/no_record_2.png', // Replace with the actual path to your image
            fit: BoxFit.cover,
          ),
        );
      }
    } else {
      return const SizedBox.shrink();
    }
  }

  TextSpan highlightMatchedLetters(String itemName) {
    final String searchTerm = illnessC.text.toLowerCase();
    final int matchStartIndex = itemName.toLowerCase().indexOf(searchTerm);
    if (matchStartIndex != -1) {
      final int matchEndIndex = matchStartIndex + searchTerm.length;
      return TextSpan(
        style: const TextStyle(
          fontFamily: "VarelaRound",
          color: Colors.black,
          fontSize: 18.0,
        ),
        children: [
          if (matchStartIndex > 0) ...[
            TextSpan(text: itemName.substring(0, matchStartIndex)),
          ],
          TextSpan(
            text: itemName.substring(matchStartIndex, matchEndIndex),
            style: const TextStyle(
              color: Colors.amber,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
          ),
          if (matchEndIndex < itemName.length) ...[
            TextSpan(text: itemName.substring(matchEndIndex)),
          ],
        ],
      );
    } else {
      return TextSpan(
        text: itemName,
        style: const TextStyle(
          fontFamily: "VarelaRound",
          color: Colors.black,
          fontSize: 18.0,
        ),
      );
    }
  }

  void selectIllness(String illnessName) {
    setState(() {
      selectedIllness = illnessName;
      illnessC.text = illnessName;
      if (selectedIllness != "") {
        icon = Icons.check_rounded;
        iconColor = Colors.greenAccent;
      }
      showDropdown = false;
      foundIllnessNames.clear();
    });
  }

  void filteredIllnessNames(String keyword) {
    List<Map<String, dynamic>> results = [];
    if (keyword.isEmpty) {
      results = [];
      showDropdown = false;
    } else {
      results = illness.illnessLists
          .where((illness) =>
              illness["name"].toLowerCase().contains(keyword.toLowerCase()))
          .toList();
      showDropdown = results.isNotEmpty;
    }
    setState(() {
      foundIllnessNames = results;
      showDropdown = keyword.isNotEmpty;
    });
  }

  void showConfirmation() async {
    bool? result = await ConfirmationDialog.showConfirmationDialog(
        context,
        "Save Confirmation",
        "Are you sure to save it? It can not be deleted.",
        () {},
        () {},
        lottieAnimationPath:
            "assets/animations/lottie/Animation - 1704099431942.json");
    if (result == true) {
      saveAsPastMedicationHistory(widget.userId);
    }
  }

  void saveAsPastMedicationHistory(String userId) async {
    dynamic dsg = "";
    if (dosageC.text == "") {
      dsg = "unknown";
    } else {
      dsg = int.tryParse(dosageC.text);
    }
    try {
      var pastMedicationHistory = FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .collection('Past Medication History')
          .doc();
      DateTime now = DateTime.now();

      await pastMedicationHistory.set({
        'id': pastMedicationHistory.id,
        'illness': illnessC.text,
        'howToTreate': treatmentC.text,
        'dosage': dsg,
        'startDate': DateFormat.yMMMd().format(startDate!),
        'endDate': DateFormat.yMMMd().format(endDate!),
        'effectiveness': feedback,
        'CreatedTime': now
      }).whenComplete(() => Get.snackbar(
            "Success",
            "You have successfully stored a past medication history!",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green.withOpacity(0.1),
            colorText: Colors.green,
          ));
      // Navigate to the success screen
      Get.to(() => SuccessScreen(userId: widget.userId));
    } catch (e) {
      displayError("Failed to store past medication history: $e");
    }
  }

  void displayError(String error) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: kOtherColor,
      content: Text(error),
      duration: const Duration(milliseconds: 2000),
    ));
  }
}

import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:medapp/common/confirmation_dialog.dart';
import 'package:medapp/constant/colors.dart';
import 'package:medapp/constant/image_string.dart';
import 'package:medapp/constant/text_string.dart';
import 'package:medapp/models/medicine_name.dart';
import 'package:medapp/models/medicine_type.dart';
import 'package:medapp/screens/new_entry/widget/medicine_type.dart';
import 'package:medapp/screens/new_entry/widget/panel_widget.dart';
import 'package:medapp/screens/second_entry_page/second_entry_page.dart';
import 'package:medapp/services/medicine_type_controller.dart';
import 'package:sizer/sizer.dart';

class NewEntryPage extends StatefulWidget {
  const NewEntryPage({super.key, required this.userId});
  final String? userId;

  @override
  State<NewEntryPage> createState() => _NewEntryPageState();
}

class _NewEntryPageState extends State<NewEntryPage> {
  final now = DateTime.now();
  IconData icon = Icons.search_rounded;
  Color iconColor = Colors.black;
  IconData icon2 = Icons.medication;
  Color iconColor2 = Colors.black;

  //Users need to input by typing
  TextEditingController medicationNameC = TextEditingController();
  TextEditingController dosageAmountC = TextEditingController();
  MedicationNamesModel medicineModel = MedicationNamesModel();
  //Late initialize
  late GlobalKey<ScaffoldState> _scaffoldKey;
  late MedicineTypeController medicineTypeController;

  //For found medication name
  List<Map<String, dynamic>> foundMedicationNames = [];

  //String variables
  String selectedMedication = "";
  String customMedicationName = "";

  //Boolean variables
  bool showDropdown = false;

  //Medicine type
  MedicineType? selectedMedicineType;

  @override
  void dispose() {
    super.dispose();
    medicationNameC.dispose();
    dosageAmountC.dispose();
    medicineTypeController.dispose();
  }

  @override
  void initState() {
    super.initState();
    medicineTypeController = MedicineTypeController();
    medicineTypeController.medicineTypeStream.listen((MedicineType type) {
      setState(() {
        selectedMedicineType = type; // Update your selectedMedicineType state
      });
    });
    _scaffoldKey = GlobalKey<ScaffoldState>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
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
                    .withOpacity(0.1), // Adjust opacity value as needed
                BlendMode.dstATop,
              ),
              child: Image.asset(
                mNewEntryImage,
                width: 200.0,
                height: 200.0,
              ),
            )),
        ListView(shrinkWrap: true, children: [
          Padding(
            padding: EdgeInsets.all(2.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const PanelTitle(
                  title: mMedicationName,
                  isRequired: true,
                ),
                TextFormField(
                  controller: medicationNameC,
                  onChanged: (value) {
                    setState(() {
                      customMedicationName = value;
                      filteredMedicationNames(value);
                      if (value.isEmpty) {
                        icon = Icons.search_rounded;
                        iconColor = Colors.black;
                      }
                    });
                  },
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                      hintText: "Your medication name...",
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
                buildMedicationDropdown(),
                SizedBox(
                  height: 4.h,
                ),
                const PanelTitle(
                  title: mDosageInput,
                  isRequired: false,
                ),
                TextFormField(
                  maxLength: 3,
                  controller: dosageAmountC,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      if (value.isNotEmpty) {
                        icon2 = Icons.check_rounded;
                        iconColor2 = Colors.greenAccent;
                      } else if (value.isEmpty) {
                        icon2 = Icons.medication;
                        iconColor2 = Colors.black;
                      }
                    });
                  },
                  decoration: InputDecoration(
                      hintText: "You can refer to your prescription...",
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
                SizedBox(
                  height: 4.h,
                ),
                const PanelTitle(title: mMedicineTypeInput, isRequired: false),
                Padding(
                  padding: EdgeInsets.only(top: 1.h),
                  child: StreamBuilder<MedicineType>(
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
                ),
                SizedBox(
                  height: 4.h,
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
                            side:
                                BorderSide(width: 2, color: Colors.pinkAccent)),
                      ),
                      child: Center(
                        child: Text(
                          mNext,
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge!
                              .copyWith(
                                color: Colors.white,
                              ),
                        ),
                      ),
                      onPressed: () {
                        // Show a confirmation dialog
                        _showConfirmation();
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ]),
      ]),
    );
  }

  Widget buildMedicationDropdown() {
    if (showDropdown) {
      if (foundMedicationNames.isNotEmpty) {
        return SizedBox(
          height: foundMedicationNames.length * 25.0,
          child: Scrollbar(
            child: ListView.builder(
              itemCount: foundMedicationNames.length,
              itemBuilder: (context, index) => ListTile(
                key: ValueKey(foundMedicationNames[index]),
                onTap: () =>
                    selectMedication(foundMedicationNames[index]["name"]),
                title: RichText(
                  text: highlightMatchedLetters(
                    foundMedicationNames[index]["name"],
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
    final String searchTerm = medicationNameC.text.toLowerCase();
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

  void selectMedication(String medicationName) {
    setState(() {
      selectedMedication = medicationName;
      medicationNameC.text = medicationName;
      if (selectedMedication != "") {
        icon = Icons.check_rounded;
        iconColor = Colors.greenAccent;
      }
      showDropdown = false;
      foundMedicationNames.clear(); // Clear the filtered results
    });
  }

  void filteredMedicationNames(String keyword) {
    List<Map<String, dynamic>> results = [];
    if (keyword.isEmpty) {
      results = [];
      showDropdown = false;
    } else {
      results = medicineModel.medicineLists
          .where((medication) =>
              medication["name"].toLowerCase().contains(keyword.toLowerCase()))
          .toList();
      showDropdown = results.isNotEmpty; // Show dropdown if there are results
    }

    setState(() {
      foundMedicationNames = results;
      showDropdown = keyword.isNotEmpty;
    });
  }

  void _showConfirmation() async {
    bool? result = await ConfirmationDialog.showConfirmationDialog(context,
        "2 Steps Left...", "Are you to proceed to next page?", () {}, () {},
        lottieAnimationPath:
            'assets/animations/lottie/Animation - 1704099431942.json');
    if (result == true) {
      if (!context.mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SecondEntryPage(
            userId: widget.userId!,
            medicationNameController: medicationNameC,
            dosageController: dosageAmountC,
            selectedMedicineType: selectedMedicineType ?? MedicineType.none,
          ),
        ),
      );
    }
  }
}

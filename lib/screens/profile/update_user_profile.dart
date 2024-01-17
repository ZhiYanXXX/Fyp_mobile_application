import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:medapp/common/confirmation_dialog.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key, required this.userId});
  final String userId;

  @override
  // ignore: library_private_types_in_public_api
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _phoneNoController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  String? _selectedGender;
  DateTime? selectedDate;
  bool isDateSelected = false;

  IconData icon = Icons.verified_user_rounded;
  Color iconColor = Colors.black;
  IconData icon2 = Icons.date_range;
  Color iconColor2 = Colors.black;
  IconData icon3 = Icons.phone_android;
  Color iconColor3 = Colors.black;
  IconData icon4 = LineAwesomeIcons.address_card;
  Color iconColor4 = Colors.black;
  IconData icon5 = Icons.supervised_user_circle;
  Color iconColor5 = Colors.black;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  void _loadUserProfile() async {
    // Check if the current user ID is not empty
    if (widget.userId.isNotEmpty) {
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.userId) // Using the current user's ID
          .collection('Profile Data')
          .doc(widget.userId)
          .get();
      final userProfile = userDoc.data() as Map<String, dynamic>?;

      setState(() {
        if (userProfile != null) {
          isDateSelected = true;
          if (userProfile['Name'] != "") {
            icon = Icons.check_rounded;
            iconColor = Colors.greenAccent;
            _nameController.text = userProfile['Name'];
          } else {
            icon = Icons.verified_user_rounded;
            iconColor = Colors.black;
          }
          if (userProfile['Phone No.'] != "") {
            _phoneNoController.text = userProfile['Phone No.'];
            iconColor3 = Colors.greenAccent;
            icon3 = Icons.check_rounded;
          } else {
            icon3 = Icons.phone_android;
            iconColor3 = Colors.black;
          }
          if (userProfile['Address'] != "") {
            _addressController.text = userProfile['Address'];
            iconColor4 = Colors.greenAccent;
            icon4 = Icons.check_rounded;
          } else {
            icon4 = LineAwesomeIcons.address_card;
            iconColor4 = Colors.black;
          }
          if (userProfile['DOB'] != "") {
            isDateSelected = true;
            selectedDate = DateFormat.yMMMd().parse(userProfile['DOB']);
            iconColor2 = Colors.greenAccent;
            icon2 = Icons.check_rounded;
          } else {
            icon2 = Icons.date_range;
            iconColor2 = Colors.black;
          }
          if (userProfile['Gender'] != "") {
            _selectedGender = userProfile['Gender'] as String?;
            iconColor5 = Colors.greenAccent;
            icon5 = Icons.check_rounded;
          } else {
            icon5 = Icons.supervised_user_circle;
            iconColor5 = Colors.black;
          }
        }
      });
    }
  }

  @override
  void dispose() {
    _dobController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Update Profile',
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
        // Background Image
        Positioned.fill(
            bottom: -200,
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                const Color.fromARGB(255, 253, 238, 195)
                    .withOpacity(0.4), // Adjust opacity value as needed
                BlendMode.dstATop,
              ),
              child: Image.asset(
                'assets/images/Update_Profile_bg_pic.png',
                width: 200.0,
                height: 200.0,
              ),
            )),
        Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextFormField(
                style: const TextStyle(
                    fontFamily: "VarelaRound",
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
                controller: _nameController,
                onChanged: (value) {
                  setState(() {
                    if (value.isNotEmpty) {
                      icon = Icons.check_rounded;
                      iconColor = Colors.greenAccent;
                    } else if (value.isEmpty) {
                      icon = Icons.verified_user_rounded;
                      iconColor = Colors.black;
                    }
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Full Name (Optional)',
                  suffixIcon: Icon(
                    icon,
                    color: iconColor,
                    weight: 5.0,
                    size: 30,
                  ),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
                validator: (value) {
                  // Add your validation logic here if any
                  return null;
                },
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 40),
              TextFormField(
                style: const TextStyle(
                    fontFamily: "VarelaRound",
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
                readOnly: true, // Set to true to make it read-only
                onTap: () => _selectDate(context),
                decoration: InputDecoration(
                  suffixIcon: Icon(
                    icon2,
                    color: iconColor2,
                    weight: 5,
                    size: 30,
                  ),
                  hintText: isDateSelected
                      ? selectedDate != null
                          ? "Date of Birth: ${DateFormat.yMMMd().format(selectedDate!)}"
                          : "Select DOB"
                      : "Select DOB",
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              TextFormField(
                style: const TextStyle(
                    fontFamily: "VarelaRound",
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
                controller: _phoneNoController,
                onChanged: (value) {
                  setState(() {
                    if (value.isNotEmpty) {
                      icon3 = Icons.check_rounded;
                      iconColor3 = Colors.greenAccent;
                    } else if (value.isEmpty) {
                      icon3 = Icons.phone_android;
                      iconColor3 = Colors.black;
                    }
                  });
                },
                decoration: InputDecoration(
                  suffixIcon: Icon(
                    icon3,
                    color: iconColor3,
                    weight: 5.0,
                    size: 30,
                  ),
                  labelText: 'Phone No. (Optional)',
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
                validator: (value) {
                  // Add your validation logic here if any
                  return null;
                },
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 40),
              TextFormField(
                style: const TextStyle(
                    fontFamily: "VarelaRound",
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
                controller: _addressController,
                onChanged: (value) {
                  setState(() {
                    if (value.isNotEmpty) {
                      icon4 = Icons.check_rounded;
                      iconColor4 = Colors.greenAccent;
                    } else if (value.isEmpty) {
                      icon4 = LineAwesomeIcons.address_card;
                      iconColor4 = Colors.black;
                    }
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Address (Optional)',
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  suffixIcon: Icon(
                    icon4,
                    color: iconColor4,
                    weight: 5.0,
                    size: 30,
                  ),
                ),
                validator: (value) {
                  // Add your validation logic here if any
                  return null;
                },
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 40),
              DropdownButtonFormField<String>(
                style: const TextStyle(
                    fontFamily: "VarelaRound",
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 20),
                dropdownColor: const Color.fromARGB(255, 255, 240, 189),
                value: _selectedGender,
                items: ['Male', 'Female', 'Prefer Not To Say']
                    .map((String value) => DropdownMenuItem(
                          value: value,
                          child: Text(value),
                        ))
                    .toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedGender = newValue;
                    icon5 = Icons.check_rounded;
                    iconColor5 = Colors.greenAccent;
                  });
                },
                decoration: InputDecoration(
                  suffixIcon: Icon(
                    icon5,
                    color: iconColor5,
                    weight: 5.0,
                    size: 30,
                  ),
                  labelText: 'Gender (Optional)',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a gender';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: 100,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      showConfirmation();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      elevation: 5.0,
                      backgroundColor: const Color.fromARGB(255, 255, 209, 72),
                      side: BorderSide.none,
                      shape: const StadiumBorder()),
                  child: const Text(
                    'Update Profile',
                    style: TextStyle(
                        color: Color.fromARGB(255, 18, 17, 16),
                        fontFamily: 'VarelaRound',
                        fontWeight: FontWeight.bold,
                        fontSize: 22.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }

  void showConfirmation() async {
    bool? result = await ConfirmationDialog.showConfirmationDialog(
        context,
        "Update Confirmation",
        "Are you sure to update your personal info?",
        () {},
        () {},
        lottieAnimationPath:
            "assets/animations/lottie/Animation - 1704102159657.json");
    if (result == true) {
      if (!context.mounted) return;
      updateUserProfile();
      Navigator.pop(context);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900), // Set the earliest date allowed
      lastDate: DateTime
          .now(), // Set the latest date allowed (you can adjust it accordingly)
    );

    if (picked != null && picked != DateTime.now()) {
      setState(() {
        selectedDate = picked;
        _dobController.text = _formatDate(picked);
        isDateSelected = true;
        iconColor2 = Colors.greenAccent;
        icon2 = Icons.check_rounded;
      });
    }
  }

  String _formatDate(DateTime? selectedDate) {
    if (selectedDate != null) {
      return "DOB: ${DateFormat.yMMMd().format(selectedDate)}}";
    } else {
      return "Select DOB";
    }
  }

  Future<void> updateUserProfile() async {
    String? fullName = _nameController.text;
    DateTime? dateOfBirth = selectedDate;
    String? phoneNo = _phoneNoController.text;
    String? address = _addressController.text;
    // Check if the current user ID is not empty
    if (widget.userId.isNotEmpty) {
      try {
        // Update the user's profile information in Firestore
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(widget.userId) // Using the current user's ID
            .collection('Profile Data')
            .doc(widget.userId)
            .set(
          {
            'Name': fullName,
            'DOB': DateFormat.yMMMd().format(dateOfBirth!),
            'Phone No.': phoneNo,
            'Address': address,
            'Gender': _selectedGender,
          },
        );

        // Show a success message using GetX
        Get.snackbar('Success', 'Profile updated successfully!',
            backgroundColor: Colors.green, colorText: Colors.white);
      } catch (e) {
        // If an error occurs, show an error message using GetX
        Get.snackbar('Error', 'Failed to update profile: $e',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } else {
      // Handle the case where there is no user logged in
      Get.snackbar('Error', 'No user logged in.',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
}

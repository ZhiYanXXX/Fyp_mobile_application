import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medapp/authentication/screens/welcome_page/welcome_page.dart';
import 'package:medapp/common/confirmation_dialog.dart';
import 'package:medapp/constant/text_string.dart';
import 'package:medapp/screens/daily_report/daily_report_page.dart';
import 'package:medapp/screens/home_page/notifications_page/notifications_page.dart';
import 'package:medapp/screens/home_page/widgets/bottom_container.dart';
import 'package:medapp/screens/home_page/widgets/top_container.dart';
import 'package:medapp/screens/medication_history/medication_history_screen.dart';
import 'package:medapp/screens/new_entry/new_entry_page.dart';
import 'package:medapp/screens/profile/user_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:badges/badges.dart' as badges;

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.userId});
  final String? userId;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int unreadCount = 0;
  bool isDropdownOpen = false;
  List<String> expandedNotifications = [];

  @override
  void initState() {
    super.initState();
    fetchUnreadCount();
  }

  @override
  Widget build(BuildContext context) {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      displayError("No user is currently signed in.");
    }
    return Stack(children: [
      Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
              color: Colors.white), // Change the color of the burger icon
          title: const Text(mAppName,
              style: TextStyle(
                  color: Color.fromARGB(255, 41, 30, 26),
                  fontFamily: 'VarelaRound',
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0)),
          actions: [
            badges.Badge(
              position: badges.BadgePosition.topEnd(top: 10, end: 10),
              badgeAnimation: const badges.BadgeAnimation.slide(
                  animationDuration: Duration(milliseconds: 300)),
              badgeContent: Text(
                '$unreadCount',
                style: const TextStyle(color: Colors.white),
              ),
              showBadge: unreadCount > 0,
              badgeStyle: const badges.BadgeStyle(badgeColor: Colors.redAccent),
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          InAppNotificationScreen(userId: userId!),
                    ),
                  ).then((result) {
                    if (result == true) {
                      setState(() {
                        fetchUnreadCount();
                      });
                    }
                  });
                },
                icon: const Icon(
                  Icons.notifications,
                  size: 35,
                ),
              ),
            ),
          ],
        ),
        drawer: Drawer(
          backgroundColor: const Color.fromARGB(255, 250, 234, 186),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.amber,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/images/drawer_header_image.png', // Replace with the actual asset path for your logo
                      width: 150.0, // Adjust the width as needed
                      height: 120.0, // Adjust the height as needed
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(
                  Icons.account_circle,
                  color: Colors.amber,
                  size: 45.0,
                ),
                title: const Text(
                  mHomePageMenu1,
                  style: TextStyle(
                      fontFamily: 'VarelaRound',
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserProfileScreen(
                        userId: widget.userId,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20.0),
              ListTile(
                leading: const Icon(
                  Icons.report_sharp,
                  color: Colors.amber,
                  size: 45.0,
                ),
                title: const Text(
                  mHomePageMenu2,
                  style: TextStyle(
                      fontFamily: 'VarelaRound',
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DailyReportPage(
                        userId: widget.userId!,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20.0),
              ListTile(
                leading: const Icon(
                  Icons.document_scanner,
                  color: Colors.amber,
                  size: 45.0,
                ),
                title: const Text(
                  mHomePageMenu3,
                  style: TextStyle(
                      fontFamily: 'VarelaRound',
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  User? user = FirebaseAuth.instance.currentUser;
                  if (user != null) {
                    String userId = user.uid;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            MedicationHistoryScreen(userId: userId),
                      ),
                    );
                  } else {
                    Get.snackbar("",
                        'You are not signed in. Please sign in to view medication history.',
                        snackPosition: SnackPosition.TOP,
                        backgroundColor: Colors.red,
                        colorText: Colors.white);
                  }
                },
              ),
              const SizedBox(
                height: 20.0,
              ),
              ListTile(
                leading: const Icon(
                  Icons.logout,
                  color: Colors.redAccent,
                  size: 45.0,
                ),
                title: const Text(
                  mHomePageMenu4,
                  style: TextStyle(
                      fontFamily: 'VarelaRound',
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0),
                ),
                onTap: () {
                  _showLogOutConfirmation();
                },
              ),
            ],
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(2.h),
          child: Column(children: [
            const TopContainer(),
            SizedBox(height: 2.h),
            //the widget take space as per need
            Flexible(
              child: BottomContainer(
                userId: widget.userId,
              ),
            ),
          ]),
        ),
        floatingActionButton: InkResponse(
          onTap: () {
            // //go to new entry page
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewEntryPage(
                  userId: widget.userId,
                ),
              ),
            );
          },
          child: Material(
            color: const Color.fromARGB(255, 255, 239, 193),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40.0),
            ),
            shadowColor: Colors.amber,
            elevation: 7.0,
            child: Icon(
              Icons.medication,
              color: const Color.fromARGB(255, 255, 191, 0),
              size: 50.sp,
            ),
          ),
        ),
      )
    ]);
  }

  void _showLogOutConfirmation() async {
    bool? result = await ConfirmationDialog.showConfirmationDialog(
      context,
      mHomePageMenu3DialogTitle,
      mHomePageMenu3DialogSubtitle,
      () {},
      () {},
      lottieAnimationPath:
          'assets/animations/lottie/Animation - 1704102128921.json',
    );
    if (!context.mounted) return;
    if (result == true) {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Record the sign out time in Firestore
        await FirebaseFirestore.instance.collection('Users').doc(user.uid).set({
          'lastSignOutTime': DateTime.now(),
        }, SetOptions(merge: true));
      }

      // Sign out the user
      await FirebaseAuth.instance.signOut();
      await updateAuthenticationStatus(false);
      // Navigate to the WelcomePage
      Get.to(() => const WelcomePage());
    }
  }

  void displayError(String error) {
    Get.snackbar('Error', error,
        backgroundColor: Colors.red, colorText: Colors.white);
  }

  Future<List<DocumentSnapshot>> getAllInAppNotifications(String userId) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection('In App Notifications')
        .get();

    return querySnapshot.docs;
  }

  Future<void> fetchUnreadCount() async {
    List<DocumentSnapshot> unreadNotifications =
        await getUnreadInAppNotifications(widget.userId!);
    setState(() {
      unreadCount = unreadNotifications.length;
    });
  }

  Future<void> markNotificationAsRead(
      String userId, DocumentSnapshot notification) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection('In App Notifications')
        .doc(notification.id)
        .update({'read': true});

    setState(() {
      unreadCount--;
    });
  }

  Future<void> updateUnreadCount(String userId) async {
    List<DocumentSnapshot> unreadNotifications =
        await getUnreadInAppNotifications(userId);
    setState(() {
      unreadCount = unreadNotifications.length;
    });
  }

  Future<List<DocumentSnapshot>> getUnreadInAppNotifications(
      String userId) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection('In App Notifications')
        .where('read', isEqualTo: false)
        .get();

    return querySnapshot.docs;
  }

  Future<void> updateAuthenticationStatus(bool isAuthenticated) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_authenticated', isAuthenticated);
  }
}

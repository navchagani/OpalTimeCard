// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names

import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:opaltimecard/Admin/Modal/loggedInUsermodel.dart';
import 'package:opaltimecard/User/Views/logoutDailog.dart';
import 'package:opaltimecard/Utils/calculator.dart';
import 'package:opaltimecard/Utils/qr.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String UserLocation = '';
  late SharedPreferences _prefs;
  bool loggingIn = false;
  LoggedInUser? currentUser;
  bool toggle = true;

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky,
        overlays: [SystemUiOverlay.bottom]);
    Future.delayed(const Duration(minutes: 1))
        .whenComplete(() => setState(() {}));
    _loadUserData();
    super.initState();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> _loadUserData() async {
    await _initPrefs();
    String? userJson = _prefs.getString('loggedInUser');
    if (userJson != null) {
      log("Loaded user JSON: $userJson");
      setState(() {
        currentUser = LoggedInUser.fromJson(jsonDecode(userJson));
        UserLocation = currentUser?.locationId ?? '';
        emailController.text = currentUser?.email ?? '';
      });
    } else {
      log("No user data found in SharedPreferences.");
    }
  }

  Widget pinDailog() {
    return const Calculator();
  }

  Widget qrCodeDailog() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Card(
      child: Container(
        height: height > 800 ? height / 1.85 : height / 1.55,
        width: width > 900 ? width / 3.85 : width / 1.5,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  userAttendance() {
    double width = MediaQuery.of(context).size.width;
    if (width > 900) {
      return const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          QRCodeScanner(),
          SizedBox(
            width: 20,
          ),
          Calculator(),
        ],
      );
    } else {
      return Column(
        children: <Widget>[
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: toggle ? const Calculator() : const QRCodeScanner(),
          ),
          const SizedBox(height: 50),
          ElevatedButton(
            onPressed: () {
              setState(() {
                toggle = !toggle;
              });
            },
            child: Text(toggle ? 'Switch to QR ' : 'Switch to Pin'),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String date = DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now());
    String time = DateFormat('hh:mm a').format(DateTime.now());
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 29, 29, 29),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                UserLocation,
                style: TextStyle(
                  fontSize: width > 600 ? 30 : 20,
                  color: const Color.fromARGB(255, 177, 149, 226),
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                time,
                style: const TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.w900,
                    color: Colors.white),
              ),
              Text(
                date,
                style: TextStyle(
                    fontSize: width > 600 ? 30 : 20, color: Colors.white),
              ),
              SizedBox(height: height > 768 ? height / 20 : height / 30),
              userAttendance(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) => LogoutDailog(
                    email: emailController.text,
                  ));
        },
        child: const Icon(Icons.power_settings_new_rounded,
            color: Colors.deepOrange),
      ),
    );
  }
}

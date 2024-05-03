// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:opaltimecard/Admin/Modal/loggedInUsermodel.dart';
import 'package:opaltimecard/User/Services/userService.dart';
import 'package:opaltimecard/User/Views/logoutDailog.dart';
import 'package:opaltimecard/Utils/calculator.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  UserService userService = UserService();
  bool attendance = false;

  String UserLocation = '';
  late SharedPreferences _prefs;
  bool loggingIn = false;
  LoggedInUser? currentUser;
  bool toggle = true;
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  void _onQRViewCreated(QRViewController qrController) {
    controller = qrController;
    qrController.scannedDataStream.listen((scanData) {
      if (result == null) {
        setState(() {
          result = scanData;
        });
        toggle = !toggle;
        userService.userAttendance(context, result!.code.toString()).then((_) {
          log("Attendance recorded successfully for QR code: ${result!.code}");
        }).catchError((error) {
          log("Error recording attendance: $error");
        }).whenComplete(() {
          Future.delayed(const Duration(seconds: 5), () {
            setState(() {
              result = null;
            });
          });
        });
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

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

  Widget qrCodeDailog() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Card(
      child: Container(
        height: height > 800 ? height / 1.85 : height / 1.55,
        width: width > 900 ? width / 3.85 : width / 1.5,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
        child: QRView(
          key: qrKey,
          onQRViewCreated: _onQRViewCreated,
          cameraFacing: CameraFacing.front,
          overlay: QrScannerOverlayShape(
            borderColor: Colors.red,
            borderRadius: 10,
            borderLength: 30,
            borderWidth: 10,
            cutOutSize: width > 900 ? 300 : 350,
          ),
        ),
      ),
    );
  }

  userAttendance() {
    double width = MediaQuery.of(context).size.width;
    if (width > 900) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          qrCodeDailog(),
          const SizedBox(
            width: 20,
          ),
          const Calculator(),
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
            child: toggle ? const Calculator() : qrCodeDailog(),
          ),
          const SizedBox(height: 50),
          ElevatedButton(
            style: ButtonStyle(
              fixedSize: MaterialStateProperty.all(const Size(200, 60)),
            ),
            onPressed: () {
              setState(() {
                toggle = !toggle;
              });
            },
            child: Text(
              toggle ? 'Switch to QR ' : 'Switch to Pin',
              style: const TextStyle(
                  color: Color.fromRGBO(30, 60, 87, 1),
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
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

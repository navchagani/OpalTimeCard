import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:opaltimecard/Admin/Services/loginService.dart';
import 'package:opaltimecard/Admin/Views/admin_login.dart';
import 'package:opaltimecard/Utils/button.dart';
import 'package:opaltimecard/Utils/customDailoge.dart';
import 'package:opaltimecard/Utils/inputFeild.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogoutDailog extends StatefulWidget {
  final String email;
  const LogoutDailog({super.key, required this.email});

  @override
  State<LogoutDailog> createState() => _LogoutDailogState();
}

class _LogoutDailogState extends State<LogoutDailog> {
  final AuthService _authService = AuthService();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isObscure = true;
  bool loggingIn = false;
  late SharedPreferences _prefs;
  String? modelName;
  String deviceType = Platform.isAndroid ? 'Android' : 'iOS';
  String? appVersion;
  String? buildNumber;
  String? deviceMACAddress;

  Future<String?> getMacAddress() async {
    try {
      final networkInfo = NetworkInfo();
      String? wifiBSSID = await networkInfo.getWifiBSSID();
      return wifiBSSID;
    } catch (e) {
      log("Error getting WiFi BSSID: $e");
      return null;
    }
  }

  Future<void> getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    appVersion = '${packageInfo.version}.${packageInfo.buildNumber}';
  }

  Future<Map<String, String>> getDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    String? androidId = androidInfo.fingerprint;

    List<String> parts = androidId.split('/');

    if (parts.length >= 2) {
      String secondLastSegment =
          parts[parts.length - 2]; // This will be "TP1A.220624.014"
      List<String> secondLastParts = secondLastSegment.split(':');
      if (secondLastParts.length >= 2) {
        buildNumber = secondLastParts.first; // This will be "TP1A.220624.014"
      } else {
        print("Second last segment does not contain a colon.");
      }
    } else {
      print("String does not have enough parts.");
    }

    return {
      'modelName': androidInfo.model,
      'buildNumber': buildNumber.toString(),
    };
  }

  @override
  void initState() {
    emailController.text = widget.email;
    getVersion(); // Call getVersion() to initialize appVersion
    super.initState();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  void loginUser({required BuildContext context}) async {
    Map<String, String> deviceInfo = await getDeviceInfo();
    String modelName = deviceInfo['modelName'] ?? 'Unknown';
    String buildNumber = deviceInfo['buildNumber'] ?? 'Unknown';

    String email = emailController.text;
    String pass = passwordController.text;
    setState(() {
      loggingIn = true;
    });
    if (passwordController.text.isEmpty) {
      ConstDialog(context).showErrorDialog(error: 'Please enter password.');
    } else {
      try {
        final Map<String, dynamic> response = await _authService.loginUser(
            context,
            email,
            pass,
            modelName.toString(),
            buildNumber,
            deviceType,
            appVersion.toString());
        if (response['success'] == true) {
          await _prefs.clear();
          Navigator.of(context).pop();
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => const AdminLoginScreen()));
        } else {
          // ConstDialog(context)
          //     .showErrorDialog(error: response['error']['info']);
        }
      } catch (e) {
        log('logout error:$e');
      } finally {
        if (mounted) {
          setState(() {
            loggingIn = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.5,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Wrap(
            children: [
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Logout',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.start,
                      ),
                      IconButton(
                        alignment: Alignment.topRight,
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.cancel_rounded,
                            size: 30, color: Colors.black),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  CustomInputField(
                      controller: emailController,
                      enabled: false,
                      labelText: '',
                      hintText: "Email Address"),
                  const SizedBox(height: 5),
                  CustomInputField(
                    controller: passwordController,
                    labelText: '',
                    hintText: 'Enter Your Password',
                    toHide: _isObscure,
                    icon: InkWell(
                      onTap: () {
                        setState(() {
                          _isObscure = !_isObscure;
                        });
                      },
                      child: Icon(
                          _isObscure ? Icons.visibility : Icons.visibility_off,
                          color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 30),
                  loginButton()
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget loginButton() {
    return CustomButton(
      text: "Logout",
      isLoading: loggingIn,
      backgroundColor: const Color.fromARGB(255, 37, 84, 124),
      textColor: Colors.white,
      onTap: () async {
        await _initPrefs();
        loginUser(context: context);
      },
    );
  }
}

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:opaltimecard/Admin/Modal/loggedInUsermodel.dart';
import 'package:opaltimecard/Admin/Services/loginService.dart';
import 'package:opaltimecard/Admin/Views/admin_login.dart';
import 'package:opaltimecard/Utils/button.dart';
import 'package:opaltimecard/Utils/calculator.dart';
import 'package:opaltimecard/Utils/customDailoge.dart';
import 'package:opaltimecard/Utils/inputFeild.dart';
import 'package:opaltimecard/bloc/Blocs.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final AuthService _authService = AuthService();
  TextEditingController emailaddress = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  void initState() {
    setState(() {});
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky,
        overlays: [SystemUiOverlay.bottom]);
    super.initState();
  }

  void loginUser({required BuildContext context}) async {
    String email = emailaddress.text.toString();
    String pass = password.text;
    log("message:$email");
    log("message:${password.text}");

    try {
      final Map<String, dynamic> response =
          await _authService.loginUser(email, pass);

      if (response['success'] == true) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AdminLoginScreen()),
        );
      } else {
        ConstDialog(context).showErrorDialog(error: response['error']['info']);
      }
    } catch (e) {
      ConstDialog(context).showErrorDialog(error: 'An error occurred: $e');
      log("catch error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    String Date = DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now());
    String Time = DateFormat('hh:mm a').format(DateTime.now());
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    UserBloc userBloc = BlocProvider.of<UserBloc>(context);
    emailaddress.text = userBloc.state!.email!;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 29, 29, 29),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Texas E Cigrates Inc',
                      style: TextStyle(
                          fontSize: width > 600 ? 30 : 20,
                          color: const Color.fromARGB(255, 177, 149, 226),
                          fontWeight: FontWeight.w900),
                    ),
                    Text(
                      Time,
                      style: const TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.w900,
                          color: Colors.white),
                    ),
                    Text(
                      Date,
                      style: TextStyle(
                          fontSize: width > 600 ? 30 : 20, color: Colors.white),
                    ),
                    SizedBox(
                      height: height > 768 ? height / 20 : height / 30,
                    ),
                    const Calculator()
                  ],
                )
              ],
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return logout();
                });
          },
          child: IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return logout();
                    });
              },
              icon: const Icon(Icons.power_settings_new_rounded,
                  color: Colors.deepOrange))),
    );
  }

  logout() {
    return Dialog(
      child: SizedBox(
        // height: MediaQuery.of(context).size.height * 0.4,
        width: MediaQuery.of(context).size.width * 0.3,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Wrap(
            children: [
              Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Logout',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    IconButton(
                      alignment: Alignment.topRight,
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.cancel_rounded,
                        size: 30,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomInputField(
                    controller: emailaddress,
                    enabled: false,
                    labelText: 'Email Address',
                    hintText: "Email Address"),
                const SizedBox(
                  height: 5,
                ),
                CustomInputField(
                    controller: password,
                    labelText: 'Password',
                    hintText: "Password"),
                const SizedBox(
                  height: 30,
                ),
                CustomButton(
                  title: "Logout",
                  onTap: () => loginUser(context: context),
                )
              ]),
            ],
          ),
        ),
      ),
    );
  }
}

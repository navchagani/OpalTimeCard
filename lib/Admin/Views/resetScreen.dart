import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opaltimecard/Admin/Services/resetPasswordService.dart';
import 'package:opaltimecard/Admin/Views/admin_login.dart';
import 'package:opaltimecard/Utils/button.dart';
import 'package:opaltimecard/Utils/inputFeild.dart';
import 'package:opaltimecard/connectivity.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final ResetPasswordService _resetPasswordService = ResetPasswordService();
  final TextEditingController _emailAddress = TextEditingController();
  bool loggingIn = false;

  Future<void> resetPassword() async {
    try {
      final Map<String, dynamic> response = await _resetPasswordService
          .resetPassword(context, _emailAddress.text);
      log('email:${_emailAddress.text} response: $response');

      if (response['success'] == true) {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              double width = MediaQuery.of(context).size.width;
              return Dialog(
                child: SizedBox(
                  width: width > 800 ? width * 0.3 : width * 0.5,
                  child: Wrap(
                    children: [
                      Column(children: [
                        Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20)),
                            color: Color.fromARGB(255, 37, 84, 124),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Text(
                                  'Reset Successfully',
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(
                          height: 3,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.email,
                                color: Color.fromARGB(255, 37, 84, 124),
                                size: 30,
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Text(
                                "Please Check your Email",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: width < 700 ? 18 : 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 70,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: InkWell(
                            onTap: () => Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const AdminLoginScreen())),
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Container(
                                width: 100,
                                height: 30,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: const Color.fromARGB(
                                          255, 37, 84, 124),
                                      width: 2.0, // Border width
                                    ),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10))),
                                child: const Center(
                                    child: Text(
                                  'OK',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 37, 84, 124)),
                                )),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                      ]),
                    ],
                  ),
                ),
              );
            });
      } else {
        if (mounted) {
          setState(() {
            loggingIn = true;
          });
        }
      }
    } catch (e) {}
    if (mounted) {
      setState(() {
        loggingIn = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Builder(builder: (context) {
      return Scaffold(
        // appBar: AppBar(
        //   actions: [],
        // ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: width > 700 ? 200 : 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Image(
                  image: AssetImage('assets/images/logo.png'),
                ),
                // Text(
                //   'Forgot Password',
                //   style: TextStyle(
                //     fontSize: width > 700 ? 30 : 20,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
                // const SizedBox(height: 15),
                Text(
                  'Provide Email Address to Reset Your Account',
                  style: TextStyle(
                    fontSize: width > 700 ? 15 : 15,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 30,
                ),
                CustomInputField(
                  labelText: 'Email Address',
                  hintText: "Enter Email Address",
                  controller: _emailAddress,
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AdminLoginScreen())),
                    child: const Text('Back to Login?'),
                  ),
                ),
                const SizedBox(height: 30),
                resetButton()
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget resetButton() {
    return BlocBuilder<CheckConnection, bool>(builder: (context, isConnected) {
      return CustomButton(
          text: "Reset Password",
          isLoading: false,
          backgroundColor: const Color.fromARGB(255, 37, 84, 124),
          textColor: Colors.white,
          onTap: () => resetPassword());
    });
  }
}

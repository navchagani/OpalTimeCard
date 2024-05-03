// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opaltimecard/Admin/Modal/loggedInUsermodel.dart';
import 'package:opaltimecard/Admin/Services/loginService.dart';
import 'package:opaltimecard/User/Views/UserScreen.dart';
import 'package:opaltimecard/Utils/button.dart';
import 'package:opaltimecard/Utils/customDailoge.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:opaltimecard/Utils/inputFeild.dart';
import 'package:opaltimecard/bloc/Blocs.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  bool _isObscure = true;
  bool loggingIn = false;
  final AuthService _authService = AuthService();

  TextEditingController emailaddress = TextEditingController();
  TextEditingController password = TextEditingController();
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky,
        overlays: [SystemUiOverlay.bottom]);
    super.initState();
  }

  void loginUser({required BuildContext context}) async {
    String email = emailaddress.text;
    String pass = password.text;

    setState(() {
      loggingIn = true;
    });

    try {
      final Map<String, dynamic> response =
          await _authService.loginUser(email, pass);

      if (response['success'] == true) {
        LoggedInUser loggedInUser = LoggedInUser.fromJson(response['data']);

        UserBloc userBloc = BlocProvider.of<UserBloc>(context);
        userBloc.add(loggedInUser);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        String userJson = jsonEncode(loggedInUser.toJson());
        prefs.setString('loggedInUser', userJson);
        prefs.setString('email', email);
        prefs.setString('password', pass);
        log("Saving user data: $userJson");

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const UserScreen()),
        );
      } else {
        ConstDialog(context).showErrorDialog(error: response['error']['info']);
      }
    } catch (e) {
      ConstDialog(context).showErrorDialog(error: 'An error occurred: $e');
      log("catch error: $e");
    } finally {
      if (mounted) {
        setState(() {
          loggingIn = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: width > 900 ? bigScreenLayout() : smallScreenLayout(),
        );
      },
    );
  }

  Widget smallScreenLayout() {
    double screenWidth = MediaQuery.of(context).size.width;
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(screenWidth > 700 ? 200 : 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png',
              ),
              const SizedBox(height: 40),
              CustomInputField(
                  controller: emailaddress,
                  labelText: 'Email Address ',
                  hintText: "Enter Email Address"),
              const SizedBox(height: 10),
              CustomInputField(
                controller: password,
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
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              loginButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget bigScreenLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Image(
                          image: AssetImage('assets/images/login_img.png'),
                          width: 500,
                          height: 500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(130.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/logo.png',
                          // width: wid >= 600 ? 400 : 250,
                          // height: screenWidth >= 600 ? 400 : 250,
                        ),
                        const SizedBox(height: 40),
                        CustomInputField(
                            controller: emailaddress,
                            labelText: 'Email Address ',
                            hintText: "Enter Email Address"),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomInputField(
                          controller: password,
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
                              _isObscure
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        loginButton()
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget loginButton() {
    return CustomButton(
      text: "Login",
      // buttonSize: 200,
      isLoading: loggingIn,
      backgroundColor: const Color.fromARGB(255, 37, 84, 124),
      textColor: Colors.white,
      onTap: () => loginUser(context: context),
    );
  }
}

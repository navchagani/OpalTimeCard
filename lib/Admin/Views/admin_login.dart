import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opaltimecard/Admin/Modal/loggedInUsermodel.dart';
import 'package:opaltimecard/Admin/Services/loginService.dart';
import 'package:opaltimecard/User/UserScreen.dart';
import 'package:opaltimecard/Utils/button.dart';
import 'package:opaltimecard/Utils/customDailoge.dart';

import 'package:opaltimecard/Utils/inputFeild.dart';
import 'package:opaltimecard/bloc/Blocs.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  bool _isObscure = true;
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

    try {
      final Map<String, dynamic> response =
          await _authService.loginUser(email, pass);

      if (response['success'] == true) {
        LoggedInUser loggedInUser = LoggedInUser.fromJson(response['data']);

        UserBloc userBloc = BlocProvider.of<UserBloc>(context);
        userBloc.add(loggedInUser);

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
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: width > 600 ? bigScreenLayout() : smallScreenLayout(),
        );
      },
    );
  }

  Widget smallScreenLayout() {
    double screenWidth = MediaQuery.of(context).size.width;

    double buttonWidth = screenWidth;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/images/login_img.png', width: 250, height: 250),
            const SizedBox(height: 20),
            const Text("Sign In",
                style: TextStyle(
                    fontSize: 24,
                    color: Color(0XFF390E82),
                    fontWeight: FontWeight.bold)),
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
            CustomButton(
              title: "Login",
              // buttonSize: 200,
              onTap: () => loginUser(context: context),
            )
          ],
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
                        const Text("Sign In",
                            style: TextStyle(
                              fontSize: 40,
                              color: Color(0XFF390E82),
                              fontWeight: FontWeight.bold,
                            )),
                        const SizedBox(height: 60),
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
                          height: 50,
                        ),
                        CustomButton(
                          title: "Login",
                          buttonSize: 200,
                          onTap: () => loginUser(context: context),
                        )
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
}

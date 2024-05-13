// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opaltimecard/Admin/Modal/loggedInUsermodel.dart';
import 'package:opaltimecard/Admin/Services/loginService.dart';
import 'package:opaltimecard/User/Views/UserScreen.dart';
import 'package:opaltimecard/Utils/button.dart';
import 'package:opaltimecard/Utils/customDailoge.dart';
import 'package:opaltimecard/connectivity.dart';
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

  late StreamSubscription<bool> streamSubscription;
  TextEditingController emailaddress = TextEditingController();
  TextEditingController password = TextEditingController();

  Future<void> loginUser(
      {required BuildContext context, required bool isConnected}) async {
    String email = emailaddress.text;
    String pass = password.text;
    if (!isConnected) {
      // Show dialog for no internet connection
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Row(
              children: [
                Icon(
                  Icons.error,
                  color: Colors.red,
                ),
                SizedBox(width: 8),
                Text("Alert")
              ],
            ),
            content: const Text("Check Your Internet Connection"),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Ok',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          );
        },
      );
    } else {
      if (mounted) {
        setState(() {
          loggingIn = true;
        });
      }
      if (emailaddress.text.isEmpty || password.text.isEmpty) {
        ConstDialog(context)
            .showErrorDialog(error: 'Please enter both username and password.');
      }
      try {
        final Map<String, dynamic> response = await _authService.loginUser(
          context,
          emailaddress.text.trim(),
          password.text.trim(),
        );

        if (response['success'] == true) {
          LoggedInUser loggedInUser = LoggedInUser.fromJson(response['data']);

          UserBloc userBloc = BlocProvider.of<UserBloc>(context);
          userBloc.add(loggedInUser);

          SharedPreferences prefs = await SharedPreferences.getInstance();
          String userJson = jsonEncode(loggedInUser.toJson());
          prefs.setString('loggedInUser', userJson);
          prefs.setString('email', email);
          prefs.setString('password', pass);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const UserScreen()),
          );
        } else {}
      } catch (e) {}
      if (mounted) {
        setState(() {
          loggingIn = false;
        });
      }
    }
  }

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky,
        overlays: [SystemUiOverlay.bottom]);
    streamSubscription = ConnectionFuncs.checkInternetConnectivityStream()
        .asBroadcastStream()
        .listen((isConnected) {
      if (mounted) {
        CheckConnection connection = BlocProvider.of<CheckConnection>(context);
        connection.add(isConnected);
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    streamSubscription.cancel();
    super.dispose();
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
    return BlocBuilder<CheckConnection, bool>(builder: (context, isConnected) {
      return CustomButton(
          text: "Login",
          isLoading: loggingIn,
          backgroundColor: const Color.fromARGB(255, 37, 84, 124),
          textColor: Colors.white,
          onTap: () {
            loginUser(context: context, isConnected: isConnected);
          });
    });
  }
}

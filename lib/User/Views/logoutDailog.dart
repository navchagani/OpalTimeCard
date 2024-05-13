import 'package:flutter/material.dart';
import 'package:opaltimecard/Admin/Services/loginService.dart';
import 'package:opaltimecard/Admin/Views/admin_login.dart';
import 'package:opaltimecard/Utils/button.dart';
import 'package:opaltimecard/Utils/customDailoge.dart';
import 'package:opaltimecard/Utils/inputFeild.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogoutDailog extends StatefulWidget {
  final String email;
  LogoutDailog({super.key, required this.email});

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

  @override
  void initState() {
    emailController.text = widget.email;
    super.initState();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  void loginUser({required BuildContext context}) async {
    String email = emailController.text;
    String pass = passwordController.text;
    setState(() {
      loggingIn = true;
    });
    try {
      final Map<String, dynamic> response =
          await _authService.loginUser(context, email, pass);
      if (response['success'] == true) {
        await _prefs.clear();
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => AdminLoginScreen()));
      } else {
        ConstDialog(context).showErrorDialog(error: response['error']['info']);
      }
    } catch (e) {
      ConstDialog(context).showErrorDialog(error: 'An error occurred: $e');
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

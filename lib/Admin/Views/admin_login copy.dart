import 'package:flutter/material.dart';
import 'package:opaltimecard/Utils/button.dart';

import 'package:opaltimecard/Utils/inputFeild.dart';

class AdminLoginScreen2 extends StatefulWidget {
  const AdminLoginScreen2({super.key});

  @override
  State<AdminLoginScreen2> createState() => _AdminLoginScreen2State();
}

class _AdminLoginScreen2State extends State<AdminLoginScreen2> {
  bool _isObscure = true;

  TextEditingController emailaddress = TextEditingController();
  TextEditingController password = TextEditingController();
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
          const CustomInputField(
              labelText: 'Email Address ', hintText: "Enter Email Address"),
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
          GestureDetector(
              onTap: () {},
              child: Container(
                width: buttonWidth,
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                margin: const EdgeInsets.only(left: 3, right: 3),
                decoration: BoxDecoration(
                  color: const Color(0xff390E82),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text(
                    " Login snd",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              )),
          // CustomButton(title: "Loginjsd"),
          ElevatedButton(onPressed: () {}, child: Text('login')),
          ElevatedButton(onPressed: () {}, child: Text('login')),
          ElevatedButton(onPressed: () {}, child: Text('login'))
        ],
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
                        const CustomInputField(
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
                        const CustomButton(
                          title: "Login kad",
                          buttonSize: 200,
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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opaltimecard/Admin/Views/admin_login.dart';
import 'package:opaltimecard/User/Views/UserScreen.dart';
import 'package:opaltimecard/bloc/Blocs.dart';
import 'package:opaltimecard/connectivity.dart';
import 'package:opaltimecard/localDatabase/localDatabase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WakelockPlus.enable();

  await LocalDatabaseInit.initialize();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? email = prefs.getString('email');
  String? password = prefs.getString('password');

  runApp(MyApp(email: email, password: password));
}

class MyApp extends StatelessWidget {
  final String? email;
  final String? password;

  const MyApp({super.key, this.email, this.password});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserBloc>(create: (context) => UserBloc()),
        BlocProvider<EmployeeBloc>(create: (context) => EmployeeBloc()),
        BlocProvider<CheckConnection>(
          create: (context) => CheckConnection(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: email != null && password != null
            ? const UserScreen()
            : const AdminLoginScreen(),
        initialRoute: '/',
        routes: {
          '/adminLogin': (context) => const AdminLoginScreen(),
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opaltimecard/Admin/Views/admin_login.dart';
import 'package:opaltimecard/bloc/Blocs.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: listProviders,
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AdminLoginScreen(),
      ),
    );
  }
}

final listProviders = [
  BlocProvider(create: (context) => UserBloc()),
];

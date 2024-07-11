import 'dart:async';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';

class CheckConnection extends Bloc<bool, bool> {
  CheckConnection() : super(true) {
    on<bool>((event, emit) => emit(event));
  }
}

class ConnectionFuncs {
  static Stream<bool> checkInternetConnectivityStream() async* {
    while (true) {
      await Future.delayed(const Duration(seconds: 5));
      yield await _checkInternet();
    }
  }

  static Future<bool> checkInternetConnectivity() async {
    return await _checkInternet();
  }

  static Future<bool> _checkInternet() async {
    try {
      final lookup = await InternetAddress.lookup('www.google.com');
      return lookup.isNotEmpty;
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }
}

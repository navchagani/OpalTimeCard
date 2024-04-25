import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opaltimecard/Admin/Modal/loggedInUsermodel.dart';
import 'package:opaltimecard/User/Modal/usermodal.dart';

class UserBloc extends Bloc<LoggedInUser?, LoggedInUser?> {
  UserBloc() : super(null) {
    on<LoggedInUser?>((event, emit) => emit(event));
  }
}

class EmployeeBloc extends Bloc<EmployeeModel?, EmployeeModel?> {
  EmployeeBloc() : super(null) {
    on<EmployeeModel?>((event, emit) => emit(event));
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opaltimecard/Admin/Modal/loggedInUsermodel.dart';

class UserBloc extends Bloc<LoggedInUser?, LoggedInUser?> {
  UserBloc() : super(null) {
    on<LoggedInUser?>((event, emit) => emit(event));
  }
}

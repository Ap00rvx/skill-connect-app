import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shatter_vcs/config/network_exception.dart';
import 'package:shatter_vcs/locator.dart';
import 'package:shatter_vcs/model/user_model.dart';
import 'package:shatter_vcs/services/user_service.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserInitial()) {
    on<SaveUserDetails>((event, emit) async {
      emit(UserLoading());
      final user = event.user;
      final image = event.image;
      try {
        final response = await UserService().saveUserDetails(user, image);

        response.fold((message) => emit(UserSaved(user)),
            (exception) => emit(UserFailure(exception)));
      } catch (e) {
        print(e);
        emit(UserFailure(NetworkException("Error saving user details", 500)));
      }
    });
    on<GetUserDetails>((event, emit) async {
      emit(UserLoading());
      try {
        final response = await locator.get<UserService>().getUserDetails();
        response.fold((user) => emit(UserSuccess(user)),
            (exception) => emit(UserFailure(exception)));
      } catch (e) {
        print(e);
        emit(UserFailure(NetworkException("Error fetching user details", 500)));
      }
    });

    on<UpdateUserDetails>((event, emit) async {
      emit(UserLoading());
      final user = event.user;
      final image = event.image;
      try {
        final response = await UserService().updateUserDetails(user, image);
        response.fold((message) => emit(UserUpdated(user)),
            (exception) => emit(UserFailure(exception)));
      } catch (e) {
        print(e);
        emit(UserFailure(NetworkException("Error updating user details", 500)));
      }
    });
  }
}

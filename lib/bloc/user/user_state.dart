part of 'user_bloc.dart';

@immutable
sealed class UserState {}

final class UserInitial extends UserState {}

final class UserLoading extends UserState {}

final class UserSuccess extends UserState {
  final UserModel user;

  UserSuccess(this.user);
}

final class UserFailure extends UserState {
  final NetworkException exception;
  UserFailure(this.exception);
}
final class UserSaved extends UserState {
  final UserModel user;
  UserSaved(this.user);
}
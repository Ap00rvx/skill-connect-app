part of 'user_bloc.dart';

@immutable
sealed class UserEvent {}

class SaveUserDetails extends UserEvent {
  final UserModel user;
  File? image; 
  SaveUserDetails(this.user, this.image);
}

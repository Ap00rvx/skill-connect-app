part of 'user_bloc.dart';

@immutable
sealed class UserEvent {}

class SaveUserDetails extends UserEvent {
  final UserModel user;
  final File? image; 
  SaveUserDetails(this.user, this.image);
}
class GetUserDetails extends UserEvent {}
class UpdateUserDetails extends UserEvent {
  final UserModel user;
  final File? image;
  UpdateUserDetails(this.user, this.image);
}
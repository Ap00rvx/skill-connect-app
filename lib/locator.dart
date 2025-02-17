import 'package:get_it/get_it.dart';
import 'package:shatter_vcs/services/user_service.dart';

final locator = GetIt.instance;

void setUp()async{
  locator.registerLazySingleton(() => UserService());
}

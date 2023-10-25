import 'package:chatting_app/models/user_data.dart';

import 'package:flutter/foundation.dart';

class UserProvider with ChangeNotifier {
  UserData? _user;

  UserData? get user => _user;

  void signUpProvider(UserData newUser) {
    _user = newUser;
    notifyListeners();
  }

  void createUser() {}
}

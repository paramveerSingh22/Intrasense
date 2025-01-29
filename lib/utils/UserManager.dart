import '../model/user_model.dart';
import '../view_models/user_view_model.dart';

class UserManager {
  // Private static instance of the class
  static final UserManager _instance = UserManager._internal();

  // User data to store the fetched user details
  UserModel? _userData;

  // Private constructor to prevent external instantiation
  UserManager._internal();

  // Public factory method to access the instance
  factory UserManager() {
    return _instance;
  }

  // Method to get the user data, fetches only if it's not already loaded
  Future<UserModel?> getUserData() async {
    if (_userData == null) {
      // Fetch user data if not available
      _userData = await UserViewModel().getUser();
    }
    return _userData;
  }

  // Method to reset user data (optional, if you need to refresh it)
  void resetUserData() {
    _userData = null;
  }
}
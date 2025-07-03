// controllers/login_controller.dart
import 'package:champion_car_wash_app/service/login_service.dart';
import 'package:flutter/material.dart';


class LoginController with ChangeNotifier {
  final LoginService _authService = LoginService();

  bool isLoading = false;
  String? errorMessage;

  Future<bool> login(String username, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    bool isSuccess = await _authService.login(username, password);

    isLoading = false;

    if (isSuccess) {
      notifyListeners();
      return true;
    } else {
      errorMessage = 'Invalid username or password';
      notifyListeners();
      return false;
    }
  }
}

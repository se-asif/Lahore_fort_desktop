
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../data_models/login_datamodel/user_model.dart';
import '../dio_service/dio_service.dart';
import '../utils/Constants.dart';
import '../utils/SharedPrefHelper.dart';
import 'package:flutter_sliding_toast/flutter_sliding_toast.dart';

import '../utils/ToastUtils.dart';

class LoginProvider with ChangeNotifier {
  final DioService _dioService = DioService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  User? _user; // Store user data in provider
  User? get user => _user;

  Future<UserResponse?> postLogin(BuildContext context,String email, String password) async {
    _isLoading = true;
    notifyListeners(); // Notify UI to show loader

    try {
      final fullUrl = "${_dioService.baseUrl}${Constants.login}";
      print("🔄 API Request Sent: '$fullUrl'");
      print("📤 Request Data: {'email': $email, 'password': $password}");

      final macId = await getWindowsId(); // make sure it's awaited
      print("🖥️ Device ID: $macId");

      Response response = await _dioService.postRequest(
        Constants.login,
        {
          'email': email,
          'password': password,
          'user_android_id': macId,
        },
        options: Options(
          validateStatus: (status) => true,
        ),
      );

      if (response.statusCode == 200) {
        print("✅ Success! Status Code: ${response.statusCode}");
        print("✅ Success! Status Code: ${response.statusMessage}");
        print("📥 Response Data: ${response.data}");

        UserResponse userResponse = UserResponse.fromJson(response.data);
        ToastUtils.showSuccessToast(context, "${userResponse.message}");
        // Save user in provider
        _user = userResponse.user;
        notifyListeners();

        // Save user in SharedPreferences
        await SharedPrefHelper.saveUser(userResponse.user!);
        await SharedPrefHelper.saveSession(true);
        Navigator.pushNamed(context, '/dashboard');
        return userResponse;
      } else {
        print("⚠️ Failed! Status Code: ${response.statusCode}");
        print("⚠️ Failed! Status Code: ${response.statusMessage}");
        print("📥 Response Data: ${response.data}");
        UserResponse errorResponse = UserResponse.fromJson(response.data);

        // Show error toast if error message exists
        if (errorResponse.error != null) {
          ToastUtils.showErrorToast(
              context, errorResponse.error! ?? errorResponse.message!);
        } else {
          ToastUtils.showErrorToast(
              context, "Unauthorized access. Please check your credentials.");
        }
      }
    } catch (e) {
      print("❌ Error adding post: $e");

    } finally {
      _isLoading = false;
      notifyListeners(); // Notify UI to hide loader
    }

    return null;
  }

  Future<String?> getWindowsId() async {
      final deviceInfo = DeviceInfoPlugin();
      final windowsInfo = await deviceInfo.windowsInfo;
      return windowsInfo.deviceId; // Unique ID for Windows device
    }


  Future<void> loadUser() async {
     _user = (await SharedPrefHelper.getUser()) as User;
     notifyListeners();
   }
}

import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';


import '../providers/LoginProvider.dart';
import '../utils/Constants.dart';
import '../utils/HelperFunctions.dart';
import '../utils/SharedPrefHelper.dart';
import '../utils/ToastUtils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});


  @override
  _LoginScreenState createState() => _LoginScreenState();
}



class _LoginScreenState extends State<LoginScreen> {
  bool _isObscure = true; // Toggle password visibility

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isLoggedIn = false;
  @override
  void initState() {

    super.initState();
    checkSession();

    print(isLoggedIn);
    if(isLoggedIn){
      Future.microtask(() {
        Navigator.pushNamed(context, '/dashboard');
      });

    }

  }
  Future<bool> checkSession() async {
        isLoggedIn = SharedPrefHelper.getSession();
        return isLoggedIn ?? false; // Ensure it never returns null
      }
  void _submitLogin() async {
     final loginProvider = Provider.of<LoginProvider>(context, listen: false);

     final response = await loginProvider.postLogin(
       context,
       _emailController.text,
       _passwordController.text,
     );
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/lhore_fort.png', // Replace with your image path
              fit: BoxFit.cover,
            ),
          ),

          // Centered Login Card with Backdrop Filter
          Center(
            child: Container(
              width: 180.w,
              height: 320.h,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFFCDA1E4), // Purple color
                  width: 3, // Border thickness
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                  )
                ],
              ),
              child: Row(
                children: [
                  // Left Section: Login Form
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Welcome to ${Constants.lahoreZoo}",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.purple,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text("Log in to your account"),

                          const SizedBox(height: 15),

                          // Email Input
                          TextField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: "Email",
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Color(0xFFD0D5DD),
                                  width: 2,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Color(0xFFA020F0),
                                  width: 3,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 16.h),

                          // Password Input
                          TextField(
                            obscureText: _isObscure, // Toggles visibility
                            controller: _passwordController,
                            decoration: InputDecoration(
                              labelText: "Password",
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: Color(0xFFD0D5DD), width: 2),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: Color(0xFFA020F0), width: 3),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isObscure
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isObscure = !_isObscure; // Toggle password visibility
                                  });
                                },
                              ),
                            ),
                          ),

                          SizedBox(height: 32.h),

                          // Login Button
                          SizedBox(
                            width: double.infinity,
                            child: Consumer<LoginProvider>(
                              builder: (context, loginProvider, child) {
                                return ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.purple,
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(vertical: 15.h),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      side: const BorderSide(
                                        color: Color(0xFFD64305), // Border color (Stroke)
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                  onPressed: loginProvider.isLoading
                                      ? null
                                      : () async {
                                          final connected = await HelperFunction.hasInternetConnection();
                                          if (!connected) {
                                            if (context.mounted) {
                                              ToastUtils.showErrorToast(context, "No internet available!");
                                            }
                                            return;
                                          }

                                          _submitLogin();
                                        },
                                  child: loginProvider.isLoading
                                      ? const SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Text("Login"),
                                );
                              },
                            ),

                          ),
                       //  SizedBox(height: 10,),
                       const  SizedBox(
                           child: Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                               Text("IP: 192.168.1.112"),
                               Text("VERSION : 1.0.7")
                             ],
                           ),
                         )
                        ],
                      ),
                    ),
                  ),

                  // Right Section: Company Logo
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/lahore_fort_logo.png',
                          width: 100,
                        ),
                        // const SizedBox(height: 10),
                        // const Text(
                        //   "Unicorn Prestige\n(Pvt) Ltd.",
                        //   textAlign: TextAlign.center,
                        //   style: TextStyle(
                        //     fontSize: 16,
                        //     fontWeight: FontWeight.bold,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

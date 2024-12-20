import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dailyease/screens/auth_screen/signupscreen.dart';
import 'package:dailyease/screens/main_screen/home_screen.dart';
import 'package:dailyease/screens/store_creating_screen/store_creating_home_screen.dart';
import 'package:dailyease/widgets/custom_button.dart';
import 'package:dailyease/widgets/loading_widget.dart';
import 'package:dailyease/widgets/toast_msg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode emailFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  bool obsecure = true;
  bool isloading = false;

  // Login function
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: isloading,
        progressIndicator: const Center(child: LoadingBar()),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Image.asset(
                      'images/logo.jpg',
                      height: height * 0.2,
                      width: width * 0.7,
                    ),
                  ),
                  // Email TextFormField
                  TextFormField(
                    controller: emailController,
                    focusNode: emailFocus,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (value) {
                      FocusScope.of(context).requestFocus(passwordFocus);
                    },
                    decoration: InputDecoration(
                      fillColor: Colors.blue.shade100,
                      hintText: 'Enter Email',
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    // Email validation
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email is required';
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(value)) {
                        return 'Enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10.0),
                  // Password TextFormField
                  TextFormField(
                    controller: passwordController,
                    focusNode: passwordFocus,
                    obscureText: obsecure,
                    obscuringCharacter: '*',
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (value) {},
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            obsecure = !obsecure;
                          });
                        },
                        icon: Icon(
                          color: Colors.blue,
                          obsecure ? Icons.visibility_off : Icons.visibility,
                        ),
                      ),
                      fillColor: Colors.blue.shade100,
                      hintText: 'Enter Password',
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    // Password validation
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters long';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  // Login Button
                  CustomButton(
                    text: 'Login',
                    color: Colors.blue,
                    onTap: () async {
                      await loginFun();
                    },
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Don't Have any account"),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RegisterScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            "SignUp",
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Login function
  Future<void> loginFun() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isloading = true;
    });

    try {
      // Sign in with email and password
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Get the logged-in user's UID
      String uid = userCredential.user!.uid;

      // Fetch user data from Firestore
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (userDoc.exists) {
        // Get the user role from Firestore
        String role = userDoc['role'] ?? '';

        // Navigate based on user role
        if (role == 'User') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        } else if (role == 'Create Store') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const StoreCreatingHomeScreen()),
          );
        } else {
          ToastMsg().showToast("Invalid role, please contact support.");
        }
      } else {
        ToastMsg().showToast("User data not found.");
      }

      setState(() {
        isloading = false;
      });

      ToastMsg().showToast("Login Successfully");
    } on FirebaseAuthException catch (e) {
      setState(() {
        isloading = false;
      });

      if (e.code == '[firebase_auth/invalid-credential]') {
        ToastMsg().showToast("Password is Wrong");
      } else if (e.code == 'wrong-password') {
        ToastMsg().showToast("Incorrect password. Please try again.");
      } else if (e.code == 'invalid-email') {
        ToastMsg().showToast("Email format is invalid.");
      } else if (e.code == 'network-request-failed') {
        ToastMsg().showToast("Network error. Please check your connection.");
      } else {
        ToastMsg().showToast("An unexpected error occurred: ${e.message}");
      }
    }
  }
}

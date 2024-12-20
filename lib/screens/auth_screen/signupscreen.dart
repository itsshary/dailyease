import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dailyease/screens/main_screen/home_screen.dart';
import 'package:dailyease/screens/store_creating_screen/store_creating_home_screen.dart';
import 'package:dailyease/widgets/custom_button.dart';
import 'package:dailyease/widgets/loading_widget.dart';
import 'package:dailyease/widgets/toast_msg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegisterScreen extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  bool isloading = false;
  String? _selectedRole;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  InputDecoration _buildInputDecoration(String hintText) {
    return InputDecoration(
      fillColor: Colors.blue.shade100,
      hintText: hintText,
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: isloading,
        progressIndicator: const Center(child: LoadingBar()),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    BackButton(
                      color: Colors.white,
                      style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(Colors.blue)),
                    )
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Center(
                    child: Text(
                      "Set Up Your Account",
                      style: TextStyle(
                          fontSize: 25.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                // First Name Field
                TextFormField(
                  controller: _firstNameController,
                  decoration: _buildInputDecoration("Enter First Name"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your first name";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                // Last Name Field
                TextFormField(
                  controller: _lastNameController,
                  decoration: _buildInputDecoration("Enter Last Name"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your last name";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                // Email Field
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: _buildInputDecoration("Enter Email"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your email address";
                    } else if (!RegExp(
                            r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                        .hasMatch(value)) {
                      return "Please enter a valid email address";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                // Password Field
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: _buildInputDecoration("Enter Password"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your password";
                    } else if (value.length < 6) {
                      return "Password must be at least 6 characters";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),

                IntlPhoneField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.blue.shade100,
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  initialCountryCode: 'PK',
                  onChanged: (phone) {},
                ),

                const SizedBox(height: 10),
                // Role Selection Dropdown
                DropdownButtonFormField<String>(
                  value: _selectedRole,
                  items: const [
                    DropdownMenuItem(value: 'User', child: Text('User')),
                    DropdownMenuItem(
                        value: 'Create Store', child: Text('Create Store')),
                  ],
                  decoration: _buildInputDecoration("Select Role"),
                  onChanged: (value) {
                    setState(() {
                      _selectedRole = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please select a role";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                // Register Button
                CustomButton(
                  text: "Register",
                  color: Colors.blue,
                  onTap: () async {
                    await _registerUser();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Updated Register Function
  Future<void> _registerUser() async {
    if (_formKey.currentState!.validate()) {
      try {
        setState(() {
          isloading = true;
        });

        // Create user with email and password
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        FocusScope.of(context).unfocus();
        String uid = userCredential.user!.uid;

        // Assign donatorId and needyId based on selected role
        String? storeid;
        String? userid;
        if (_selectedRole == 'User') {
          userid = uid;
        } else if (_selectedRole == 'Create Store') {
          storeid = uid;
        }

        // Save user data to Firestore
        await _firestore.collection('users').doc(uid).set({
          'uid': uid,
          'email': _emailController.text.trim(),
          'firstName': _firstNameController.text.trim(),
          'lastName': _lastNameController.text.trim(),
          'phone': _phoneController.text.trim(),
          'role': _selectedRole,
          'storeid': storeid ?? '',
          'userid': userid ?? '',
          'createdAt': DateTime.now(),
          'image': "",
        });

        setState(() {
          isloading = false;
        });

        if (_selectedRole == "User") {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
              (route) => false);
        }
        if (_selectedRole == "Create Store") {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => const StoreCreatingHomeScreen()),
              (route) => false);
        }

        ToastMsg().showToast("Registered Successfully");
      } catch (e) {
        setState(() {
          isloading = false;
        });
        ToastMsg().showToast(e.toString());
      }
    }
  }
}

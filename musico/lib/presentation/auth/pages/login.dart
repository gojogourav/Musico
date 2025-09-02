import 'package:flutter/material.dart';
import 'package:musico/core/config/theme/app_colors.dart';
import 'package:musico/data/service/auth_service.dart';
import 'package:musico/presentation/auth/pages/signup.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _registerText(),
                  const SizedBox(height: 40),
                  _emailField(),
                  const SizedBox(height: 20),
                  _passwordField(),
                  const SizedBox(height: 40),
                  _signupButton(context),

                  const SizedBox(height: 20),

                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Signup()),
                      );
                    },
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                        ),
                        children: <TextSpan>[
                          const TextSpan(text: 'Don\'t have an account? '),
                          TextSpan(
                            text: 'SignUp',
                            style: const TextStyle(
                              color:
                                  Colors.white, // Or your app's primary color
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
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

  Widget _registerText() {
    return const Center(
      child: Text(
        "Login .",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50),
        textAlign: TextAlign.center,
      ),
    );
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    // Regular expression for email validation
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null; // Return null if the input is valid
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }

    return null; // Return null if the input is valid
  }

  Widget _emailField() {
    return TextFormField(
      controller: _emailController,
      validator: validateEmail,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'Email',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        floatingLabelStyle: TextStyle(color: AppColors.primary),
      ),
    );
  }

  Widget _passwordField() {
    return TextFormField(
      controller: _passwordController,
      validator: validatePassword,
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Password',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        floatingLabelStyle: TextStyle(color: AppColors.primary),
      ),
    );
  }

  Widget _signupButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        if (!_formKey.currentState!.validate()) return;

        final email = _emailController.text.trim();
        final password = _passwordController.text.trim();

        try {
          final res = await AuthService.login(email, password);
          print("Login response: $res"); // Debug output

          if (res['ok'] == true) {

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Center(
                  child: Text(
                    "Login successful!",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                behavior:
                    SnackBarBehavior.floating, // Often used with rounded shapes
                margin: EdgeInsets.all(16.0),
                dismissDirection: DismissDirection.down, // Optional: if you want swipe-down dismissal
                duration: const Duration(
                  seconds: 3,
                ), // How long it stays visible
              ),
            );
            // TODO: Navigate to home/dashboard
          } else {
            print(res);
           ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Center(
                  child: Text(
                    "Login Failed!",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                behavior:
                    SnackBarBehavior.floating, // Often used with rounded shapes
                margin: EdgeInsets.all(16.0),
                dismissDirection: DismissDirection.down, // Optional: if you want swipe-down dismissal
                duration: const Duration(
                  seconds: 3,
                ), // How long it stays visible
              ),
            );
 
          }
        } catch (e) {
          print("Login failed: $e"); // Debug output
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Network or server error: $e")),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        backgroundColor: Colors.white,
        textStyle: const TextStyle(color: Colors.black),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
      ),
      child: const Text(
        'Login',
        style: TextStyle(
          fontSize: 16,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

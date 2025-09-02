import 'package:flutter/material.dart';
import 'package:musico/core/config/theme/app_colors.dart';
import 'package:musico/data/service/auth_service.dart';
import 'package:musico/presentation/auth/pages/login.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
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
                  _username(),
                  const SizedBox(height: 20),

                  _name(),
                  const SizedBox(height: 20),

                  _emailField(),
                  const SizedBox(height: 20),
                  _passwordField(),
                  const SizedBox(height: 20),
                  _confirmPasswordField(),
                  const SizedBox(height: 40),
                  _signupButton(context),

                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Login(),
                          ),
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
                            const TextSpan(text: 'Already have an account? '),
                            TextSpan(
                              text: 'Log in',
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
        "Register .",
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

  String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your Username';
    }
    // Check if username exists TODO:

    return null; // Return null if the input is valid
  }

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your Username';
    }
    // Check if username exists TODO:

    return null; // Return null if the input is valid
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }

    return null; // Return null if the input is valid
  }

  String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != password) {
      return 'Passwords do not match';
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

  Widget _username() {
    return TextFormField(
      controller: _usernameController,
      validator: validateUsername,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        labelText: 'Username',
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

  Widget _name() {
    return TextFormField(
      controller: _nameController,
      validator: validateName,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        labelText: 'Name',
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

  Widget _confirmPasswordField() {
    return TextFormField(
      controller: _confirmPasswordController,
      validator: (value) =>
          validateConfirmPassword(value, _passwordController.text),
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Confirm Password',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.white, width: 1),
        ),
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

      try {
        final res = await AuthService.register(
          email:_emailController.text,
          password:_passwordController.text,
          username:_usernameController.text,
          name :_nameController.text,
        );

        if (res['ok'] == true) {
          final snackBar = SnackBar(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            content: Text(
              "SignUp Successful!",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: AppColors.primary,
            action: SnackBarAction(
              label: 'Dismiss',
              onPressed: () {},
              textColor: Colors.black,
            ),
            duration: const Duration(seconds: 3),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);

          // Navigate to home/dashboard
          // Navigator.pushReplacementNamed(context, '/home');
        } else {
          print(res);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(res['message'] ?? "SignUp failed")),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    },
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 16),
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
    ),
    child: const Text(
      'Sign Up',
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

}

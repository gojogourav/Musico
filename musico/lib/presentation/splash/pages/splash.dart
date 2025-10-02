import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:musico/core/assets/app_vectors.dart';
import 'package:musico/core/config/theme/app_colors.dart';
import 'package:musico/data/service/auth_service.dart';
import 'package:musico/presentation/auth/pages/login.dart';
import 'package:musico/presentation/home/HomePage.dart';
import 'package:musico/presentation/intro/get_started.dart';
import 'package:musico/presentation/navbar/navbar.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    await Future.delayed(const Duration(seconds: 3));

    final access_token = await AuthService.getAccessToken();
    if (!mounted) return;

    if (access_token != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const BlurredNavbarPage()),
      );
    } else {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (context) => const Login()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              AppVectors.logo,
              width: MediaQuery.of(context).size.width * 0.6,
              height: MediaQuery.of(context).size.width * 0.2,
            ),
            const SizedBox(height: 10), // spacing between image and text
            const Text(
              "Just keep on vibin’",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.gray,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

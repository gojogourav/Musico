import 'package:flutter/material.dart';
import 'package:spotify_clone/core/config/assets/app_vectors.dart';
import 'package:spotify_clone/core/config/theme/app_colors.dart';
import 'package:spotify_clone/presentation/auth/pages/signup.dart';

class GetStarted extends StatelessWidget {
  const GetStarted({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // top & bottom
          children: [
            // Logo at the top
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Column(
                children: [
                  Center(
                    child: Image.asset(
                      AppVectors.logo,
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: MediaQuery.of(context).size.width * 0.2,
                    ),
                  ),
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

            // Buttons at the bottom
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch, // full width
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> const Signup()));
                      
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(26),
                      ),
                    ),
                    child: const Text(
                      "Sign up",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.darkBackground,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(26),
                      ),
                      side: const BorderSide(color: Colors.white, width: 1),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft, // 👈 move to left
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 20,
                            ), // spacing from edge
                            child: Image.asset(AppVectors.login),
                          ),
                        ),
                        const Text("Continue with Phone Number"),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                    },

                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          AppColors.darkBackground, // Spotify green
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(26),
                      ),
                      side: const BorderSide(color: Colors.white, width: 1),
                    ),

                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 20,
                            ), // spacing from left
                            child: Image.asset(AppVectors.google),
                          ),
                        ),
                        const Text(
                          "Continue with Google",
                        ), // always stays centered
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

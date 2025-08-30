import 'package:flutter/material.dart';
import 'package:spotify_clone/core/config/assets/app_vectors.dart';
import 'package:spotify_clone/core/config/theme/app_colors.dart';
import 'package:spotify_clone/presentation/intro/get_started.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState(){
    super.initState();

    redirect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(AppVectors.logo, width: MediaQuery.of(context).size.width*0.6, height: MediaQuery.of(context).size.width*0.2),
            const SizedBox(height: 10), // spacing between image and text
            const Text(
              "Just keep on vibin’",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold,color:AppColors.gray ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> redirect() async{
    await Future.delayed(Duration(seconds: 2));
    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (BuildContext context)=> GetStarted()
    ));
  }
}

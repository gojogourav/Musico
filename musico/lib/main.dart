
import 'package:flutter/material.dart';
import 'package:musico/core/config/theme/app_theme.dart';
import 'package:musico/presentation/splash/pages/splash.dart';


void main()async{
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      home: SplashPage(),
    );

  }
}
import 'package:flutter/material.dart';
import 'package:intrasense/utils/AppColors.dart';
import 'package:intrasense/view/Login/SplashScreen.dart';
import 'package:intrasense/view_models/auth_view_model.dart';
import 'package:intrasense/view_models/user_view_model.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_)=> AuthViewModel()),
          ChangeNotifierProvider(create: (_)=> UserViewModel())
        ],
      child: (MaterialApp(
        theme: ThemeData(
            primaryColor: AppColors.primaryColor,
            dividerColor: Colors.grey[200],
            textSelectionTheme: const TextSelectionThemeData(
              cursorColor: AppColors.primaryColor,
              // Set your desired cursor color here
            ),
            inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: AppColors.primaryColor
                    )
                )
            )
        ),
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
      )
    ));
  }
}

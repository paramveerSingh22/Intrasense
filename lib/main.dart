import 'package:flutter/material.dart';
import 'package:intrasense/utils/AppColors.dart';
import 'package:intrasense/view/Login/SplashScreen.dart';
import 'package:intrasense/view_models/UserProvider.dart';
import 'package:intrasense/view_models/auth_view_model.dart';
import 'package:intrasense/view_models/client_view_model.dart';
import 'package:intrasense/view_models/common_view_model.dart';
import 'package:intrasense/view_models/leave_view_model.dart';
import 'package:intrasense/view_models/projects_view_model.dart';
import 'package:intrasense/view_models/tasks_view_model.dart';
import 'package:intrasense/view_models/teams_view_model.dart';
import 'package:intrasense/view_models/time_sheet_view_model.dart';
import 'package:intrasense/view_models/user_view_model.dart';
import 'package:provider/provider.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
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
          ChangeNotifierProvider(create: (_)=> UserViewModel()),
          ChangeNotifierProvider(create: (_)=> CommonViewModel()),
          ChangeNotifierProvider(create: (_)=> ClientViewModel()),
          ChangeNotifierProvider(create: (_)=> UserProvider()),
          ChangeNotifierProvider(create: (_)=> TeamsViewModel()),
          ChangeNotifierProvider(create: (_)=> ProjectsViewModel()),
          ChangeNotifierProvider(create: (_)=> TasksViewModel()),
          ChangeNotifierProvider(create: (_)=> LeaveViewModel()),
          ChangeNotifierProvider(create: (_)=> TimeSheetViewModel()),
        ],
      child: (MaterialApp(
        theme: ThemeData(
            primaryColor: AppColors.primaryColor,
            colorScheme: ColorScheme.fromSwatch().copyWith(
              primary: AppColors.primaryColor,  // Use your custom primary color
            ),
            dividerColor: Colors.grey[200],
            textSelectionTheme: TextSelectionThemeData(
              cursorColor: AppColors.primaryColor,
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
        navigatorObservers: [routeObserver]
      )
    ));
  }
}

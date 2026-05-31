import 'package:agri_app/Forgot.dart';
import 'package:agri_app/LoginScreen.dart';
import 'package:agri_app/Navigation.dart';
import 'package:agri_app/Profile.dart';
import 'package:agri_app/RegisterScreen.dart';
import 'package:agri_app/Setting.dart' as setting;
import 'package:agri_app/SplashScreen.dart';
import 'package:agri_app/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const AgriApp());
}

class AgriApp extends StatelessWidget {
  const AgriApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grow Mate',
      debugShowCheckedModeBanner: false,

      // 🌍 Localization
      locale: AppLocale.instance.locale,
      supportedLocales: AppLocale.supportedLocales,
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // 🎨 Theme
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E7D32),
          primary: const Color(0xFF2E7D32),
          secondary: const Color(0xFFF9A825),
          surface: const Color(0xFFF5F5F0),
        ),
        useMaterial3: true,
        fontFamily: 'Poppins',
      ),

      // 🚀 Routes
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/forgot-password': (context) => const ForgotPasswordScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const MainNavigation(),
        '/profile': (context) => const ProfileScreen(),

        // ✅ FIXED SETTINGS ROUTE
        '/settings': (context) => const setting.SettingsScreen(),
      },
    );
  }
}

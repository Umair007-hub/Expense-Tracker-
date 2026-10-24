import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'models/expense_model.dart';
import 'models/user_model.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // HIVE INITIALIZE
  await Hive.initFlutter();

  // REGISTER ADAPTERS
  Hive.registerAdapter(ExpenseModelAdapter());
  Hive.registerAdapter(UserModelAdapter());

  // OPEN BOXES
  await Hive.openBox<ExpenseModel>('expenses');
  await Hive.openBox<UserModel>('users');
  await Hive.openBox('settings');

  runApp(const CashNovaApp());
}

class CashNovaApp extends StatefulWidget {
  const CashNovaApp({super.key});

  @override
  State<CashNovaApp> createState() => _CashNovaAppState();
}

class _CashNovaAppState extends State<CashNovaApp> {
  final Box settingsBox = Hive.box('settings');

  bool get isDarkMode =>
      settingsBox.get('isDarkMode', defaultValue: false);

  void toggleTheme() {
    settingsBox.put('isDarkMode', !isDarkMode);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cash Nova',
      debugShowCheckedModeBanner: false,

      // 🌞 LIGHT THEME
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,

        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2563EB),
          brightness: Brightness.light,
        ),

        scaffoldBackgroundColor: const Color(0xFFF8FAFC),

        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Color(0xFF0F172A),
            fontSize: 24,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.none,
          ),
          iconTheme: IconThemeData(color: Color(0xFF2563EB)),
        ),

        textTheme: const TextTheme(
          bodyLarge: TextStyle(
            decoration: TextDecoration.none,
          ),
          bodyMedium: TextStyle(
            decoration: TextDecoration.none,
          ),
          titleLarge: TextStyle(
            decoration: TextDecoration.none,
          ),
          titleMedium: TextStyle(
            decoration: TextDecoration.none,
          ),
        ),

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(
              color: Color(0xFF2563EB),
              width: 2,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2563EB),
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(vertical: 18),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.none,
            ),
          ),
        ),

        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF2563EB),
          foregroundColor: Colors.white,
          elevation: 8,
        ),

        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 4,
          shadowColor: Colors.black12,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
      ),

      // 🌙 DARK THEME
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,

        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7C3AED),
          brightness: Brightness.dark,
        ),

        scaffoldBackgroundColor: const Color(0xFF020617),

        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.none,
          ),
        ),

        textTheme: const TextTheme(
          bodyLarge: TextStyle(
            decoration: TextDecoration.none,
          ),
          bodyMedium: TextStyle(
            decoration: TextDecoration.none,
          ),
          titleLarge: TextStyle(
            decoration: TextDecoration.none,
          ),
          titleMedium: TextStyle(
            decoration: TextDecoration.none,
          ),
        ),

        cardTheme: CardThemeData(
          color: const Color(0xFF0F172A),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
      ),

      // THEME MODE
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,

      // 🚀 STARTING SCREEN = QUANTUM SPLASH
      home: const SplashScreen(),
    );
  }
}
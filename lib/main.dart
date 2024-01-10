import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/LoginPage.dart';
import 'package:flutter_application/RegisterPage.dart';
import 'package:flutter_application/pages/DashboardPage.dart';
import 'package:flutter_application/pages/TaskProvider.dart';
import 'package:flutter_application/pages/TodoListPage.dart';
import 'package:flutter_application/pages/theme_provider.dart' as myTheme;
import 'package:flutter_application/pages/SettingsPage.dart';
import 'package:flutter_application/splash.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Kode yang sudah ada sebelumnya (penginisialisasian Firebase)
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Firebase
  await Firebase.initializeApp();

  // Load tasks from SharedPreferences
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String>? savedTasks = prefs.getStringList('tasks');
  List<String> initialTasks = savedTasks ?? [];

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => myTheme.ThemeProvider()),
        ChangeNotifierProvider(
          create: (context) => TaskProvider(initialTasks),
        ),
      ],
      child: MyApp(),
    ),
  );
}

// Kode MyApp yang sudah ada sebelumnya
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login Page',
      home: Splash(),
      theme: Provider.of<myTheme.ThemeProvider>(context).getTheme(),
      routes: {
        '/DashboardPage': (context) => DashboardPage(username: '$username'),
        '/LoginPage': (context) => LoginPage(),
        '/SettingsPage': (context) => SettingsPage(
              themeProvider: Provider.of<myTheme.ThemeProvider>(context),
            ),
        '/TodoListPage': (context) => TodoListPage(),
        '/RegisterPage': (context) => RegisterPage(),
      },
    );
  }
}

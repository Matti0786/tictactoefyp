import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tictactoe/Pages/ForgotPasswordPage.dart';
import 'package:tictactoe/Pages/HomePage.dart';
import 'package:tictactoe/Pages/MainMenu.dart';
import 'package:tictactoe/Pages/MultiPlayerTicTacToe.dart';
import 'package:tictactoe/Pages/SigninPage.dart';
import 'package:tictactoe/Pages/SignupPage.dart';
import 'package:tictactoe/Pages/SinglePlayerTicTacToe.dart';
import 'package:tictactoe/Pages/SplashPage.dart';
import 'package:tictactoe/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const TicTacToe());
}

class TicTacToe extends StatelessWidget {
  const TicTacToe({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        primaryColor: Colors.deepPurple,
        appBarTheme: AppBarTheme(
            backgroundColor: Theme.of(context).primaryColor,
            titleTextStyle: TextStyle(color: Colors.white, fontSize: 22),
            centerTitle: true,
            actionsIconTheme: IconThemeData(color: Colors.white),
            iconTheme: IconThemeData(color: Colors.white)),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(fontSize: 30, fontFamily: "ZirkelBold"),
          headlineSmall: TextStyle(fontSize: 20, fontFamily: "ZirkelBold"),
          bodyMedium:
              TextStyle(fontFamily: "Heebo", fontSize: 12, color: Colors.black),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: Colors.deepPurple),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white),
        ),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => SplashPage(),
        '/signin': (context) => SigninPage(),
        '/signup': (context) => SignupPage(),
        '/home': (context) => HomePage(),
        '/forgotPassword': (context) => ForgotPasswordPage(),
        '/mainMenu': (context) => MainMenu(),
        '/singlePlayerTicTacToe': (context) => SinglePlayerTicTacToe(),
        '/multiPlayerTicTacToe': (context) => MultiPlayerTicTacToe()
      },
    );
  }
}

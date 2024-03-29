import 'package:flutter/material.dart';

class CustomThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;

  ThemeData getTheme() {
    return _isDarkMode ? darkTheme : lightTheme;
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    // Define your futuristic light theme properties here
    primaryColor: Colors.white,
    hintColor: Colors.indigo.shade900,
    dialogBackgroundColor: Colors.white,
    indicatorColor: Colors.indigo.shade200,
    textTheme: lightTextTheme,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: lightAppBarTheme,
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.blueGrey[900],
    dialogBackgroundColor: Colors.black,
    indicatorColor: Colors.blue.shade200,
    hintColor: Colors.blue,
    textTheme: darkTextTheme,
    scaffoldBackgroundColor: Colors.blueGrey[900],
    appBarTheme: darkAppBarTheme,
  );
}

//************************************************************************ Custom light text theme
const lightTextTheme = TextTheme(
  displayLarge: TextStyle(
      fontSize: 72.0, fontWeight: FontWeight.bold, color: Colors.black),
  titleLarge: TextStyle(
      fontSize: 36.0, fontStyle: FontStyle.italic, color: Colors.black),
  bodyMedium: const TextStyle(fontSize: 14.0, color: Colors.black),
);

//************************************************************************ Custom dark text theme
const darkTextTheme = TextTheme(
  displayLarge: TextStyle(
      fontSize: 72.0, fontWeight: FontWeight.bold, color: Colors.white),
  titleLarge: TextStyle(
      fontSize: 36.0, fontStyle: FontStyle.italic, color: Colors.white),
  bodyMedium: TextStyle(fontSize: 14.0, color: Colors.white),
);

//************************************************************************ Custom dark app bar theme
const darkAppBarTheme = AppBarTheme(
  backgroundColor: Colors.black87,
  iconTheme: IconThemeData(color: Colors.white),
  titleTextStyle: TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 25,
    color: Colors.white,
  ),
);

//************************************************************************ Custom light app bar theme
final lightAppBarTheme = AppBarTheme(
  backgroundColor: Colors.white,
  iconTheme: IconThemeData(color: Colors.indigo.shade100),
  titleTextStyle: const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 25,
    color: Colors.black,
  ),
);

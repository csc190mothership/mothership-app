import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Themes {
  
  static ThemeData lightTheme = ThemeData(
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFC2B2B4),
      foregroundColor: Color(0xFF0E131F),
      titleTextStyle: TextStyle(
        color: Color(0xFF0E131F),
        fontSize: 20,
        fontFamily: 'Nunito',
        fontWeight: FontWeight.bold,
      ),
      centerTitle: true,
    ),

    colorScheme: const ColorScheme.light(
      brightness: Brightness.light,
      background: Color(0xFFe6e6e6),
      onBackground: Color(0xFF0E131F),
      primary: Color(0xFFC2B2B4),
      onPrimary: Color(0xFF0E131F),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF0E131F)),
        foregroundColor: MaterialStateProperty.all<Color>(Color(0xFFe6e6e6)),
      ),
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFFC2B2B4),
      selectedItemColor: Color(0xFF53B175),
      unselectedItemColor: Color(0xFFe6e6e6),
    ),
    //TEXT BELOW \/\/\/
    fontFamily: 'Nunito',
    textTheme: const TextTheme(
      bodyLarge: TextStyle(fontSize: 18.0),
      bodyMedium: TextStyle(fontSize: 16.0),
      bodySmall: TextStyle(fontSize: 14.0),
    ),
    
    
  );

  static ThemeData darkTheme = ThemeData(
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFC2B2B4),
      foregroundColor: Color(0xFF0E131F),
      titleTextStyle: TextStyle(
        color: Color(0xFF0E131F),
        fontSize: 20,
        fontFamily: 'Nunito',
        fontWeight: FontWeight.bold,
      ),
      centerTitle: true,
    ),

    colorScheme: const ColorScheme.dark(
      brightness: Brightness.dark,
      background:Color(0xFF0E131F), 
      onBackground: Color(0xFFe6e6e6),
      primary: Color(0xFFC2B2B4),
      onPrimary: Color(0xFF0E131F),
    ),
    
    
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFC2B2B4)),
        foregroundColor: MaterialStateProperty.all<Color>(Color(0xFF0E131F)),
      ),
    ),


    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color.fromARGB(255, 24, 36, 63),
      selectedItemColor: Color(0xFF53B175),
      unselectedItemColor: Color(0xFFC2B2B4),
    ),

    //TEXT BELOW \/\/\/
    fontFamily: 'Nunito',

    textTheme: const TextTheme(
      bodyLarge: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400),
      bodyMedium: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400),
      bodySmall: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400),
    ),
  );
} 
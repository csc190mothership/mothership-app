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
        fontWeight: FontWeight.bold,
        fontFamily: 'Nunito Bold'
      ),
      centerTitle: true,
    ),

    colorScheme: const ColorScheme.light(
      brightness: Brightness.light,
      background: Color(0xFFF0FFCE),
      onBackground: Color(0xFF0E131F),
      primary: Color(0xFFC2B2B4),
      onPrimary: Color(0xFF0E131F),
    ),
    
    fontFamily: 'Nunito',
    textTheme: TextTheme(
      bodyLarge: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w900),
      bodyMedium: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w900),
      bodySmall: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w900),
    ),
    
  );

  static ThemeData darkTheme = ThemeData(
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFC2B2B4),
      foregroundColor: Color(0xFF0E131F),
      titleTextStyle: TextStyle(
        color: Color(0xFF0E131F),
        fontSize: 20,
        fontWeight: FontWeight.bold,
        fontFamily: 'Nunito Bold'
      ),
      centerTitle: true,
    ),

    colorScheme: const ColorScheme.dark(
      brightness: Brightness.dark,
      background:Color(0xFF0E131F), 
      onBackground: Color(0xFFF0FFCE),
      primary: Color(0xFF0E131F),
      onPrimary: Color(0xFFC2B2B4),
    ),
    
    fontFamily: 'Nunito',
    textTheme: TextTheme(
      bodyLarge: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w900),
      bodyMedium: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w900),
      bodySmall: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w900),
    ),
  );
} 
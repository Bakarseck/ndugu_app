import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/categories_screen.dart';

void main() {
  runApp(const NduguApp());
}

class NduguApp extends StatelessWidget {
  const NduguApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ndugu App',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/categories': (context) => const CategoriesPage(),
        // '/favourites': (context) => const FavouritesPage(),
        // '/cart': (context) => const CartPage(),
      },
    );
  }
}

import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accueil'),
      ),
      body: const Center(
        child: Text(
          'Bienvenue sur la page d’accueil !',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

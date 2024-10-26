// lib/utils/auth_utils.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> checkRoleAndRedirect(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('jwt');

  if (token == null) {
    // Pas de token trouvé, redirection vers la page d'accueil
    Navigator.pushReplacementNamed(context, '/home');
    return;
  }

  try {
    // Décoder la deuxième partie du token (payload)
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('Token invalide');
    }

    final payload = parts[1];
    final normalized = base64Url.normalize(payload);
    final decodedPayload = utf8.decode(base64Url.decode(normalized));

    final Map<String, dynamic> payloadMap = json.decode(decodedPayload);

    // Vérifier si le rôle est 'Producteur' ou autre
    if (payloadMap['role'] == 'Producteur') {
      // Redirection vers la page de création de produit
      Navigator.pushReplacementNamed(context, '/createProduct');
    } else {
      // Redirection vers la page d'accueil
      Navigator.pushReplacementNamed(context, '/home');
    }
  } catch (e) {
    Navigator.pushReplacementNamed(context, '/home');
  }
}
    
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ProductCreationPage extends StatefulWidget {
  const ProductCreationPage({super.key});

  @override
  _ProductCreationPageState createState() => _ProductCreationPageState();
}

Future<void> _checkRoleAndRedirect(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('jwt');

  if (token == null) {
    // Pas de token trouvé, redirection vers la page d'accueil
    Navigator.pushReplacementNamed(context, '/home');
    return;
  }

  // Décoder le JWT pour vérifier le rôle
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
    
    // Vérifier si le rôle est bien 'Producteur'
    if (payloadMap['role'] == 'Producteur') {
      // Redirection vers la page de création de produit
      Navigator.pushReplacementNamed(context, '/product-creation');
    } else {
      // Redirection vers la page d'accueil si l'utilisateur n'est pas producteur
      Navigator.pushReplacementNamed(context, '/home');
    }
  } catch (e) {
    // Si une erreur se produit lors du décodage, redirection vers la page d'accueil
    Navigator.pushReplacementNamed(context, '/home');
  }
}

class _ProductCreationPageState extends State<ProductCreationPage> {
  final _productNameController = TextEditingController();
  final _harvestDateController = TextEditingController();
  final _productionLocationController = TextEditingController();
  final _cultivationMethodController = TextEditingController();
  final _quantityController = TextEditingController();
  final _lotNumberController = TextEditingController();
  final _certificationsController = TextEditingController();
  final _additionalInfoController = TextEditingController();
  bool _isLoading = false;

  Future<void> _registerProduct() async {
    setState(() {
      _isLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt');

    if (token == null) {
      // Pas de token trouvé, redirection vers la page d'accueil
      Navigator.pushReplacementNamed(context, '/home');
      return;
    }

    const url = 'https://e-ceddo.com/ussd/product';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': token,
        },
        body: jsonEncode({
          'productName': _productNameController.text,
          'harvestDate': _harvestDateController.text,
          'productionLocation': _productionLocationController.text,
          'cultivationMethod': _cultivationMethodController.text,
          'quantity': _quantityController.text,
          'lotNumber': _lotNumberController.text,
          'certifications': _certificationsController.text,
          'additionalInfo': _additionalInfoController.text,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'])),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erreur lors de l\'enregistrement du produit')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erreur lors de la connexion au serveur')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Création de produit'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _productNameController,
                decoration: InputDecoration(
                  labelText: 'Nom du produit',
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _harvestDateController,
                decoration: InputDecoration(
                  labelText: 'Date de récolte',
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _productionLocationController,
                decoration: InputDecoration(
                  labelText: 'Lieu de production',
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _cultivationMethodController,
                decoration: InputDecoration(
                  labelText: 'Méthode de culture',
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _quantityController,
                decoration: InputDecoration(
                  labelText: 'Quantité',
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _lotNumberController,
                decoration: InputDecoration(
                  labelText: 'Numéro de lot',
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _certificationsController,
                decoration: InputDecoration(
                  labelText: 'Certifications',
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _additionalInfoController,
                decoration: InputDecoration(
                  labelText: 'Informations supplémentaires',
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _registerProduct,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Enregistrer le produit'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

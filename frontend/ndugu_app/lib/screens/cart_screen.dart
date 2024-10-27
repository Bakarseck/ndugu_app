import 'package:flutter/material.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  // Fonction pour afficher la boîte de dialogue de succès
  void _showPaymentSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Succès"),
          content: const Text("Paiement effectué avec succès !"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  // Fonction de paiement Wave
  void _launchWavePayment(BuildContext context) {
    // Logique de lancement du paiement (ex. ouverture d'un lien, etc.)
    // Une fois le paiement terminé, affichez le message de succès
    _showPaymentSuccessDialog(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Votre Panier"),
      ),
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () => _launchWavePayment(context),
          icon: Image.asset(
            'assets/wave.png',
            width: 30,
            height: 30,
          ),
          label: const Text(
            'Payer avec Wave',
            style: TextStyle(fontSize: 18),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }
}

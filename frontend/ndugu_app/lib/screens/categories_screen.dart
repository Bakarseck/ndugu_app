import 'package:flutter/material.dart';
import '../widgets/category_card.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Categories',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Barre de recherche
            TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
                prefixIcon: const Icon(Icons.search, color: Colors.green),
                hintText: 'Search your product',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Section Daily Needs
            const Text(
              'Daily needs',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: const [
                  CategoryCard(
                    name: 'Vegetables',
                    imagePath: 'assets/vegetables.png',
                    backgroundColor: Color(0xFFA5D6A7),
                  ),
                  CategoryCard(
                    name: 'Fruits',
                    imagePath: 'assets/fruits.png',
                    backgroundColor: Color(0xFF81C784),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Section Our Selection
            const Text(
              'Our selection',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: const [
                  CategoryCard(
                    name: 'BIO',
                    imagePath: 'assets/bio.png',
                    backgroundColor: Color(0xFFB2DFDB),
                  ),
                  CategoryCard(
                    name: 'Produits Traqués',
                    imagePath: 'assets/tracked.png',
                    backgroundColor: Color(0xFFB0BEC5),
                  ),
                  CategoryCard(
                    name: 'Beverages',
                    imagePath: 'assets/beverages.png',
                    backgroundColor: Color(0xFF004D40),
                  ),
                  CategoryCard(
                    name: 'Snacks',
                    imagePath: 'assets/snacks.png',
                    backgroundColor: Color(0xFF00695C),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favourite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
        ],
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushNamed(context, '/home');
          } else if (index == 1) {
            Navigator.pushNamed(context, '/categories');
          } else if (index == 2) {
            // Redirection vers les favoris
          } else if (index == 3) {
            Navigator.pushNamed(context, '/cart');
          }
        },
      ),
    );
  }
}

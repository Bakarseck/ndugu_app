import 'package:flutter/material.dart';
import '../widgets/category_card.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Categories'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search your product',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Daily needs',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                children: const [
                  CategoryCard(
                      name: 'Vegetables', imagePath: 'assets/vegetables.png'),
                  CategoryCard(name: 'Fruits', imagePath: 'assets/fruits.png'),
                  CategoryCard(name: 'BIO', imagePath: 'assets/bio.png'),
                  CategoryCard(
                      name: 'Produits Traqués',
                      imagePath: 'assets/tracked.png'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

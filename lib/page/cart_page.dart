import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/cart.dart';
import '../model/product.dart';


/*
class CartPage extends ConsumerWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(cartProvider);
    final totalPrice = ref.watch(cartProvider.notifier).priceInEuros;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Mon panier'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Votre panier total est de"),
                Text(totalPrice, style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text("Votre panier est vide"), Icon(Icons.image)],
            ),
          ),
        ],
      ),
    );
  }
}

num total(List<Product> products){
  num s = 0;
  for(var elt in products){
    s = s + elt.price;
  }
  return s;
}
*/

class CartPage extends ConsumerWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    // Récupération du contenu du panier
    final products = ref.watch(cartProvider);

    // Récupération du prix total
    final totalPrice = ref.watch(cartProvider.notifier).priceInEuros;

    return Scaffold(
      appBar: AppBar(
        backgroundColor:
        Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Mon panier'),
      ),

      body: Column(
        children: [

          // Prix total en haut du panier
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Votre panier total est de",
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  totalPrice,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),

          const Divider(),

          // Contenu du panier
          Expanded(
            child: products.isEmpty
                ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Votre panier est vide"),
                  SizedBox(height: 10),
                  Icon(Icons.shopping_cart_outlined, size: 50),
                ],
              ),
            )
                : ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {

                final product = products[index];

                return ListTile(
                  leading: Image.network(
                    product.image,
                    width: 60,
                    errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.image_not_supported),
                  ),

                  title: Text(
                    product.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  subtitle: Text(product.getPrice()),

                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () {
                      ref.read(cartProvider.notifier)
                          .remove(product);
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: products.isEmpty
                    ? null
                    : () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Fonctionnalité de commande à venir !"),
                    ),
                  );
                },
                child: const Text("Commander"),
              ),
            ),
          ),
        ],
      ),

    );
  }
}
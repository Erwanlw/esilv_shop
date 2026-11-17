import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/cart.dart';
import '../model/product.dart';

class DetailProductPage extends ConsumerWidget {
  final Product product;

  const DetailProductPage({required this.product, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(product.title),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Container(
            color: Colors.black12,
            child: Image.network(
              product.image,
              width: MediaQuery.of(context).size.width,
              height: 200,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    product.title,
                    style: Theme.of(context).textTheme.titleLarge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(product.getPrice()),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(product.description),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                ...List.generate(5, (index) {
                  return Icon(
                    Icons.star,
                    color: index < product.rating.round()
                        ? Colors.amber
                        : Colors.grey,
                    size: 22,
                  );
                }),

                const SizedBox(width: 8),
                Text(
                  "${product.rating}/5",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                Text("(${product.ratingCount} avis)"),
              ],
            ),
          ),
          // TODO: Rajouter un chip si le produit est déjà dans le panier
          if(ref.watch(cartProvider).contains(product))
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Chip(
                label: const Text('Le produit à déjà été ajouté au panier.')
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: FilledButton(
                onPressed: () {
                  // TODO: Ajouter le produit au panier
                  ref.read(cartProvider.notifier).add(product);
                },
                child: Text("Ajouter au panier"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


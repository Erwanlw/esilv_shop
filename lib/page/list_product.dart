/*import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart';
import '../model/product.dart';


class ListProduct extends StatelessWidget {
  const ListProduct({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              pinned: true,
              expandedHeight: 150.0,
              backgroundColor: colorScheme.inversePrimary,
              flexibleSpace: const FlexibleSpaceBar(
                title: Text('Fluffer Shop', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              ),
            ),
            FutureBuilder(
                future: fetchProducts(),
                builder: (context, asyncSnapshot) {
                  if (asyncSnapshot.hasData && asyncSnapshot.data != null) {
                    final products = asyncSnapshot.data!;

                    return SliverFixedExtentList(
                      itemExtent: 64.0,
                      delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                            return ListTileProduct(
                              products: products, index: index,);
                          }, childCount: products.length
                      ),
                    );
                  }
                  return SliverFixedExtentList(
                      itemExtent: 64.0,
                      delegate: SliverChildBuilderDelegate((BuildContext context,
                          int index) {
                        return Center(child: CircularProgressIndicator());
                      }));
                })
          ],
        ));
  }

  Future<List<Product>> fetchProducts() async{
    final response = await get(Uri.parse('https://fakestoreapi.com/products'));
    if (response.statusCode == 200){
      final List<dynamic> products = json.decode(response.body);
      return products.map((product) =>
          Product.fromMap(product as Map<String, dynamic>)).toList();
    }
    return Future.error("Erreur");
  }
}

class ListTileProduct extends StatelessWidget {
  const new({
    super.key,
    required this.products,
    required this.index,
  });

  final List<Product> products;
  final int index;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => context.go('/product/${products[index].id}'),
      leading: Image.network(
        products[index].image,
        width: 150,
        height: 200,
        fit: BoxFit.cover,
      ),
      trailing: ElevatedButton.icon(
        onPressed: () {

        },
        icon: Icon(Icons.pets, size: 30),
        label: Text("Adopter"),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(products[index].title),
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(products[index].category),
              ),
              Text(products[index].getPrice()),
            ],
          )
        ],
      ),
    );
  }
}

*/

import 'dart:convert';

import 'package:esilv_shop/model/product.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import '../model/cart.dart';

class ListProductPage extends StatelessWidget {
  const ListProductPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('appbarTitle'),
        actions: [
          IconButton(
              onPressed: () => context.go('cart'),
              icon: Badge.count(
                  child: Icon(Icons.shopping_cart_outlined),
                  count: context.watch<Cart>().products.length,
              )
          )
        ],
      ),
      body: FutureBuilder(
        future: fetchProducts(),
        builder: (context, asyncSnapshot) {
          if (asyncSnapshot.hasData && asyncSnapshot.data != null) {
            final products = asyncSnapshot.data!;
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (BuildContext context, int index) => ListTile(
                onTap: () => context.go('/product/${products[index].id}'),
                title: Text(products[index].title, maxLines: 1),
                subtitle: Text(
                  products[index].getPrice(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                leading: Image.network(products[index].image, width: 80),
                trailing: TextButton(
                  onPressed: () => context.read<Cart>().add(products[index]),
                  child: Text("Ajouter".toUpperCase()),
                ),
              ),
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Future<List<Product>> fetchProducts() async {
    final response = await get(Uri.parse('https://fakestoreapi.com/products'));
    //Récupérer les produits en List<Map>
    if (response.statusCode == 200) {
      final List<dynamic> products = json.decode(response.body);
      return products
          .map((product) => Product.fromMap(product as Map<String, dynamic>))
          .toList();
    }
    return Future.error("Erreur de connexion");
  }
}
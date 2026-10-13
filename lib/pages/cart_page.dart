import 'package:flutter/material.dart';
import '../data/cart_manager.dart';
import '../models/product.dart';
import 'checkout_page_backup.dart';

class CartPage extends StatelessWidget {
  final List<Product> cartItems;

  const CartPage({
    super.key,
    required this.cartItems,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: cartManager,
      builder: (context, child) {
        final products = cartManager.items.toSet().toList();

        final Map<Product, int> quantities = {};

        for (final product in cartManager.items) {
          quantities[product] = (quantities[product] ?? 0) + 1;
        }

        double totalPrice = 0;

        for (final product in products) {
          totalPrice += product.price * (quantities[product] ?? 0);
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Shopping Cart',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: products.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_cart_outlined,
                        size: 80,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Your cart is empty',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Tambahkan produk ke keranjang terlebih dahulu.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];
                          final quantity = quantities[product] ?? 1;

                          return Card(
                            margin: const EdgeInsets.only(bottom: 14),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  // PRODUCT IMAGE
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: SizedBox(
                                      width: 90,
                                      height: 90,
                                      child: Image.asset(
                                        product.imageUrl,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Container(
                                            color: Colors.grey.shade200,
                                            child: const Icon(
                                              Icons
                                                  .image_not_supported_outlined,
                                              color: Colors.grey,
                                              size: 40,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 14),

                                  // PRODUCT INFORMATION
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product.name,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),

                                        const SizedBox(height: 6),

                                        Text(
                                          'Rp ${product.price.toStringAsFixed(0)}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.deepPurple,
                                          ),
                                        ),

                                        const SizedBox(height: 10),

                                        Row(
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                cartManager.removeFromCart(
                                                  product,
                                                );
                                              },
                                              icon: const Icon(
                                                Icons
                                                    .remove_circle_outline,
                                              ),
                                              padding: EdgeInsets.zero,
                                              constraints:
                                                  const BoxConstraints(),
                                            ),

                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 12,
                                              ),
                                              child: Text(
                                                quantity.toString(),
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),

                                            IconButton(
                                              onPressed: () {
                                                if (quantity <
                                                    product.stock) {
                                                  cartManager.addToCart(
                                                    product,
                                                  );
                                                }
                                              },
                                              icon: const Icon(
                                                Icons.add_circle_outline,
                                              ),
                                              padding: EdgeInsets.zero,
                                              constraints:
                                                  const BoxConstraints(),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                  // REMOVE
                                  IconButton(
                                    onPressed: () {
                                      while (cartManager.items
                                          .contains(product)) {
                                        cartManager.removeFromCart(product);
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.delete_outline,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // TOTAL & CHECKOUT
                    Container(
                      padding: const EdgeInsets.fromLTRB(
                        20,
                        16,
                        20,
                        20,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 10,
                            offset: const Offset(0, -3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Rp ${totalPrice.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 14),

                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              onPressed: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const CheckoutPage(),
    ),
  );
},
                              child: const Text(
                                'Checkout',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}
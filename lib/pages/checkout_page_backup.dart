import 'package:flutter/material.dart';
import '../data/cart_manager.dart';
import '../data/order_manager.dart';
import '../models/product.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String selectedPayment = 'NEXUS Pay';

  final List<String> paymentMethods = const [
    'NEXUS Pay',
    'Transfer Bank',
    'COD (Bayar di Tempat)',
  ];

  static const double shippingCost = 15000;

  void placeOrder() {
    final List<Product> items = List<Product>.from(cartManager.items);

    if (items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Keranjang masih kosong.'),
        ),
      );
      return;
    }

    orderManager.createOrder(
      products: items,
      shippingCost: shippingCost,
    );

    cartManager.clearCart();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Row(
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 30,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Pesanan Berhasil!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: const Text(
            'Pesanan kamu berhasil dibuat dan sedang diproses.',
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                Navigator.pop(context);
              },
              child: const Text('Selesai'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Product> items = cartManager.items;

    final Map<String, int> quantities = {};

    for (final product in items) {
      quantities[product.name] =
          (quantities[product.name] ?? 0) + 1;
    }

    double subtotal = 0;

    for (final product in items) {
      subtotal += product.price;
    }

    final double total = subtotal + shippingCost;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Checkout',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: items.isEmpty
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
                    'Keranjang kosong',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // =========================
                  // SHIPPING ADDRESS
                  // =========================
                  const Text(
                    'Shipping Address',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const ListTile(
                      contentPadding: EdgeInsets.all(16),
                      leading: CircleAvatar(
                        backgroundColor: Color(0xFFEDE7F6),
                        child: Icon(
                          Icons.location_on_outlined,
                          color: Colors.deepPurple,
                        ),
                      ),
                      title: Text(
                        'Kelvin',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: Text(
                          'Ketintang, Surabaya',
                        ),
                      ),
                      trailing: Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // =========================
                  // ORDER SUMMARY
                  // =========================
                  const Text(
                    'Order Summary',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          ...quantities.entries.map(
                            (entry) {
                              final product = items.firstWhere(
                                (product) =>
                                    product.name == entry.key,
                              );

                              final quantity = entry.value;
                              final itemTotal =
                                  product.price * quantity;

                              return Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 16,
                                ),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(10),
                                      child: Image.asset(
                                        product.imageUrl,
                                        width: 55,
                                        height: 55,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Container(
                                            width: 55,
                                            height: 55,
                                            color:
                                                Colors.grey.shade200,
                                            child: const Icon(
                                              Icons
                                                  .image_not_supported_outlined,
                                            ),
                                          );
                                        },
                                      ),
                                    ),

                                    const SizedBox(width: 12),

                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            product.name,
                                            style: const TextStyle(
                                              fontWeight:
                                                  FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            '× $quantity',
                                            style: TextStyle(
                                              color:
                                                  Colors.grey.shade600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    Text(
                                      'Rp ${itemTotal.toStringAsFixed(0)}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),

                          const Divider(),

                          const SizedBox(height: 12),

                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Subtotal'),
                              Text(
                                'Rp ${subtotal.toStringAsFixed(0)}',
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Shipping'),
                              Text(
                                'Rp ${shippingCost.toStringAsFixed(0)}',
                              ),
                            ],
                          ),

                          const SizedBox(height: 14),

                          const Divider(),

                          const SizedBox(height: 14),

                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total Payment',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Rp ${total.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // =========================
                  // PAYMENT METHOD
                  // =========================
                  const Text(
                    'Payment Method',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: RadioGroup<String>(
                      groupValue: selectedPayment,
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            selectedPayment = value;
                          });
                        }
                      },
                      child: Column(
                        children: paymentMethods.map(
                          (method) {
                            IconData icon;

                            if (method == 'NEXUS Pay') {
                              icon =
                                  Icons.account_balance_wallet;
                            } else if (method == 'Transfer Bank') {
                              icon = Icons.account_balance;
                            } else {
                              icon = Icons.payments_outlined;
                            }

                            return RadioListTile<String>(
                              value: method,
                              activeColor: Colors.deepPurple,
                              secondary: Icon(
                                icon,
                                color: Colors.deepPurple,
                              ),
                              title: Text(
                                method,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                method == 'NEXUS Pay'
                                    ? 'Saldo digital NEXUS'
                                    : method == 'Transfer Bank'
                                        ? 'BCA, BRI, BNI, Mandiri'
                                        : 'Bayar ketika barang sampai',
                              ),
                            );
                          },
                        ).toList(),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // =========================
                  // PLACE ORDER
                  // =========================
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: placeOrder,
                      icon: const Icon(
                        Icons.shopping_bag_outlined,
                      ),
                      label: Text(
                        'Place Order • Rp ${total.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }
}

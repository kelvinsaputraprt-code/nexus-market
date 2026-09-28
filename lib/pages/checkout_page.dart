import 'package:flutter/material.dart';

import '../data/address_manager.dart';
import '../data/cart_manager.dart';
import '../data/order_manager.dart';
import '../data/voucher_manager.dart';
import '../models/product.dart';
import 'addresses_page.dart';

class CheckoutPage extends StatefulWidget {
  final List<Product>? directItems;

  const CheckoutPage({
    super.key,
    this.directItems,
  });

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

  final TextEditingController voucherController =
      TextEditingController();

  late ShippingAddress selectedAddress;

  @override
  void initState() {
    super.initState();

    selectedAddress = addressManager.defaultAddress;
  }

  @override
  void dispose() {
    voucherController.dispose();
    super.dispose();
  }

  // =========================================================
  // ADDRESS PICKER
  // =========================================================

  void showAddressPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFFF9F5FC),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              20,
              18,
              20,
              20,
            ),
            child: AnimatedBuilder(
              animation: addressManager,
              builder: (context, _) {
                final addresses = addressManager.addresses;

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Choose Address',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.pop(sheetContext);
                          },
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    ...addresses.map((address) {
                      final isSelected =
                          address.id == selectedAddress.id;

                      return Card(
                        margin: const EdgeInsets.only(
                          bottom: 10,
                        ),
                        elevation: isSelected ? 2 : 0,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(16),
                          side: BorderSide(
                            color: isSelected
                                ? Colors.deepPurple
                                : Colors.grey.shade200,
                          ),
                        ),
                        child: ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 6,
                          ),
                          leading: CircleAvatar(
                            backgroundColor:
                                Colors.deepPurple.withValues(
                              alpha: 0.10,
                            ),
                            child: const Icon(
                              Icons.location_on_outlined,
                              color: Colors.deepPurple,
                            ),
                          ),
                          title: Row(
                            children: [
                              Flexible(
                                child: Text(
                                  address.label,
                                  style: const TextStyle(
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                              ),
                              if (address.isDefault)
                                const Padding(
                                  padding: EdgeInsets.only(
                                    left: 7,
                                  ),
                                  child: Text(
                                    'Default',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 11,
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          subtitle: Text(
                            '${address.recipientName}\n'
                            '${address.address}\n'
                            '${address.phone}',
                          ),
                          isThreeLine: true,
                          trailing: Icon(
                            isSelected
                                ? Icons
                                    .radio_button_checked
                                : Icons.radio_button_off,
                            color: isSelected
                                ? Colors.deepPurple
                                : Colors.grey,
                          ),
                          onTap: () {
                            setState(() {
                              selectedAddress = address;
                            });

                            Navigator.pop(sheetContext);
                          },
                        ),
                      );
                    }),

                    const SizedBox(height: 4),

                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          Navigator.pop(sheetContext);

                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const AddressesPage(),
                            ),
                          );

                          if (!mounted) return;

                          setState(() {
                            final exists =
                                addressManager.addresses.any(
                              (address) =>
                                  address.id ==
                                  selectedAddress.id,
                            );

                            selectedAddress = exists
                                ? addressManager.addresses
                                    .firstWhere(
                                    (address) =>
                                        address.id ==
                                        selectedAddress.id,
                                  )
                                : addressManager
                                    .defaultAddress;
                          });
                        },
                        icon: const Icon(
                          Icons.manage_accounts_outlined,
                        ),
                        label: const Text(
                          'Manage Addresses',
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  // =========================================================
  // VOUCHER
  // =========================================================

  void applyVoucher() {
    final code = voucherController.text.trim();

    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Masukkan kode voucher terlebih dahulu.',
          ),
        ),
      );
      return;
    }

    final success = voucherManager.applyVoucher(code);

    if (success) {
      setState(() {});

      final voucher = voucherManager.selectedVoucher;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Voucher ${voucher?.code ?? code} berhasil digunakan!',
          ),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Kode voucher tidak ditemukan.',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void removeVoucher() {
    voucherManager.removeVoucher();
    voucherController.clear();

    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Voucher berhasil dilepas.',
        ),
      ),
    );
  }

  // =========================================================
  // PLACE ORDER
  // =========================================================

  void placeOrder() {
    final bool isDirectBuy =
        widget.directItems != null;

    final List<Product> items = List<Product>.from(
      widget.directItems ?? cartManager.items,
    );

    if (items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Keranjang masih kosong.',
          ),
        ),
      );
      return;
    }

    double subtotal = 0;

    for (final product in items) {
      subtotal += product.price;
    }

    final double discount =
        voucherManager.calculateDiscount(
      subtotal: subtotal,
      shippingCost: shippingCost,
    );

    final voucher =
        voucherManager.selectedVoucher;

    // =======================================================
    // CREATE ORDER
    // =======================================================

    orderManager.createOrder(
      products: items,
      shippingCost: shippingCost,

      // ALAMAT
      recipientName:
          selectedAddress.recipientName,
      address:
          selectedAddress.address,
      phone:
          selectedAddress.phone,

      // VOUCHER
      voucherCode: voucher?.code,
      voucherName: voucher?.name,
      discount: discount,

      // PAYMENT METHOD
      paymentMethod: selectedPayment,
    );

    // =======================================================
    // CLEAR CART
    // =======================================================

    if (!isDirectBuy) {
      cartManager.clearCart();
    }

    // =======================================================
    // CLEAR VOUCHER
    // =======================================================

    voucherManager.removeVoucher();
    voucherController.clear();

    // =======================================================
    // SUCCESS DIALOG
    // =======================================================

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
          content: Text(
            'Pesanan kamu berhasil dibuat '
            'dan sedang diproses.\n\n'
            'Dikirim ke:\n'
            '${selectedAddress.recipientName}\n'
            '${selectedAddress.address}\n'
            '${selectedAddress.phone}',
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

  // =========================================================
  // BUILD
  // =========================================================

  @override
  Widget build(BuildContext context) {
    final List<Product> items = List<Product>.from(
      widget.directItems ?? cartManager.items,
    );

    final Map<String, int> quantities = {};

    for (final product in items) {
      quantities[product.name] =
          (quantities[product.name] ?? 0) + 1;
    }

    double subtotal = 0;

    for (final product in items) {
      subtotal += product.price;
    }

    final double discount =
        voucherManager.calculateDiscount(
      subtotal: subtotal,
      shippingCost: shippingCost,
    );

    final double finalTotal =
        (subtotal + shippingCost - discount) < 0
            ? 0
            : subtotal + shippingCost - discount;

    final voucher =
        voucherManager.selectedVoucher;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F5FC),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F5FC),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
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
                mainAxisAlignment:
                    MainAxisAlignment.center,
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
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [

                  // =================================================
                  // SHIPPING ADDRESS
                  // =================================================

                  const Text(
                    'Shipping Address',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Card(
                    elevation: 1,
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(16),
                    ),
                    child: InkWell(
                      borderRadius:
                          BorderRadius.circular(16),
                      onTap: showAddressPicker,
                      child: Padding(
                        padding:
                            const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration:
                                  BoxDecoration(
                                color: Colors
                                    .deepPurple
                                    .withValues(
                                  alpha: 0.10,
                                ),
                                shape:
                                    BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons
                                    .location_on_outlined,
                                color:
                                    Colors.deepPurple,
                              ),
                            ),

                            const SizedBox(width: 12),

                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,
                                children: [
                                  Row(
                                    children: [
                                      Flexible(
                                        child: Text(
                                          selectedAddress
                                              .label,
                                          style:
                                              const TextStyle(
                                            fontWeight:
                                                FontWeight
                                                    .bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),

                                      if (selectedAddress
                                          .isDefault)
                                        Container(
                                          margin:
                                              const EdgeInsets
                                                  .only(
                                            left: 8,
                                          ),
                                          padding:
                                              const EdgeInsets
                                                  .symmetric(
                                            horizontal: 7,
                                            vertical: 3,
                                          ),
                                          decoration:
                                              BoxDecoration(
                                            color: Colors
                                                .green
                                                .withValues(
                                              alpha: 0.10,
                                            ),
                                            borderRadius:
                                                BorderRadius
                                                    .circular(
                                              8,
                                            ),
                                          ),
                                          child:
                                              const Text(
                                            'Default',
                                            style:
                                                TextStyle(
                                              color:
                                                  Colors.green,
                                              fontSize: 10,
                                              fontWeight:
                                                  FontWeight
                                                      .bold,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),

                                  const SizedBox(height: 5),

                                  Text(
                                    selectedAddress
                                        .recipientName,
                                    style:
                                        const TextStyle(
                                      fontWeight:
                                          FontWeight.w600,
                                    ),
                                  ),

                                  const SizedBox(height: 3),

                                  Text(
                                    selectedAddress
                                        .address,
                                    style: TextStyle(
                                      color: Colors
                                          .grey
                                          .shade600,
                                    ),
                                  ),

                                  const SizedBox(height: 3),

                                  Text(
                                    selectedAddress.phone,
                                    style: TextStyle(
                                      color: Colors
                                          .grey
                                          .shade600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(width: 8),

                            const Icon(
                              Icons.chevron_right,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // =================================================
                  // ORDER SUMMARY
                  // =================================================

                  const SizedBox(height: 28),

                  const Text(
                    'Order Summary',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Card(
                    elevation: 1,
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsets.all(16),
                      child: Column(
                        children: [

                          ...quantities.entries.map(
                            (entry) {
                              final product =
                                  items.firstWhere(
                                (item) =>
                                    item.name ==
                                    entry.key,
                              );

                              final quantity =
                                  entry.value;

                              final itemTotal =
                                  product.price *
                                      quantity;

                              return Padding(
                                padding:
                                    const EdgeInsets
                                        .only(
                                  bottom: 16,
                                ),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius:
                                          BorderRadius
                                              .circular(
                                        10,
                                      ),
                                      child:
                                          Image.asset(
                                        product.imageUrl,
                                        width: 55,
                                        height: 55,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (
                                          context,
                                          error,
                                          stackTrace,
                                        ) {
                                          return Container(
                                            width: 55,
                                            height: 55,
                                            color: Colors
                                                .grey
                                                .shade200,
                                            child:
                                                const Icon(
                                              Icons
                                                  .image_not_supported_outlined,
                                            ),
                                          );
                                        },
                                      ),
                                    ),

                                    const SizedBox(
                                        width: 12),

                                    Expanded(
                                      child:
                                          Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                        children: [
                                          Text(
                                            product.name,
                                            style:
                                                const TextStyle(
                                              fontWeight:
                                                  FontWeight
                                                      .bold,
                                            ),
                                          ),
                                          const SizedBox(
                                              height: 5),
                                          Text(
                                            '× $quantity',
                                            style:
                                                TextStyle(
                                              color: Colors
                                                  .grey
                                                  .shade600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    Text(
                                      'Rp ${itemTotal.toStringAsFixed(0)}',
                                      style:
                                          const TextStyle(
                                        fontWeight:
                                            FontWeight
                                                .bold,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),

                          const Divider(),

                          const SizedBox(height: 12),

                          _summaryRow(
                            'Subtotal',
                            'Rp ${subtotal.toStringAsFixed(0)}',
                          ),

                          const SizedBox(height: 10),

                          _summaryRow(
                            'Shipping',
                            'Rp ${shippingCost.toStringAsFixed(0)}',
                          ),

                          if (discount > 0) ...[
                            const SizedBox(
                                height: 10),

                            _summaryRow(
                              'Voucher Discount',
                              '- Rp ${discount.toStringAsFixed(0)}',
                              valueColor:
                                  Colors.green.shade700,
                            ),
                          ],

                          const SizedBox(
                              height: 14),

                          const Divider(),

                          const SizedBox(
                              height: 14),

                          _summaryRow(
                            'Total Payment',
                            'Rp ${finalTotal.toStringAsFixed(0)}',
                            bold: true,
                            valueColor:
                                Colors.deepPurple,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // =================================================
                  // VOUCHER
                  // =================================================

                  const SizedBox(height: 28),

                  const Text(
                    'Voucher / Promo Code',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  if (voucher == null)
                    Card(
                      elevation: 1,
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                          16,
                        ),
                      ),
                      child: Padding(
                        padding:
                            const EdgeInsets.all(14),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller:
                                    voucherController,
                                textCapitalization:
                                    TextCapitalization
                                        .characters,
                                decoration:
                                    InputDecoration(
                                  hintText:
                                      'Masukkan kode voucher',
                                  prefixIcon:
                                      const Icon(
                                    Icons
                                        .local_offer_outlined,
                                  ),
                                  border:
                                      OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius
                                            .circular(
                                      12,
                                    ),
                                  ),
                                  contentPadding:
                                      const EdgeInsets
                                          .symmetric(
                                    horizontal: 12,
                                    vertical: 14,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(width: 10),

                            ElevatedButton(
                              onPressed:
                                  applyVoucher,
                              style:
                                  ElevatedButton
                                      .styleFrom(
                                padding:
                                    const EdgeInsets
                                        .symmetric(
                                  horizontal: 18,
                                  vertical: 15,
                                ),
                                shape:
                                    RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius
                                          .circular(
                                    12,
                                  ),
                                ),
                              ),
                              child: const Text(
                                'Pakai',
                                style: TextStyle(
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    Card(
                      elevation: 1,
                      color:
                          Colors.green.shade50,
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                          16,
                        ),
                        side: BorderSide(
                          color:
                              Colors.green.shade300,
                        ),
                      ),
                      child: Padding(
                        padding:
                            const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor:
                                  Colors.green
                                      .shade100,
                              child: Icon(
                                Icons.local_offer,
                                color: Colors
                                    .green
                                    .shade700,
                              ),
                            ),

                            const SizedBox(width: 12),

                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,
                                children: [
                                  Text(
                                    voucher.code,
                                    style:
                                        const TextStyle(
                                      fontSize: 16,
                                      fontWeight:
                                          FontWeight
                                              .bold,
                                    ),
                                  ),

                                  const SizedBox(
                                      height: 4),

                                  Text(
                                    voucher.name,
                                    style: TextStyle(
                                      color: Colors
                                          .grey
                                          .shade700,
                                    ),
                                  ),

                                  const SizedBox(
                                      height: 4),

                                  Text(
                                    voucher.description,
                                    style: TextStyle(
                                      color: Colors
                                          .green
                                          .shade700,
                                      fontWeight:
                                          FontWeight
                                              .bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            IconButton(
                              onPressed:
                                  removeVoucher,
                              icon: const Icon(
                                Icons.close,
                                color: Colors.red,
                              ),
                              tooltip:
                                  'Hapus voucher',
                            ),
                          ],
                        ),
                      ),
                    ),

                  const SizedBox(height: 10),

                  Text(
                    'Kode tersedia: NEXUS50 • NEXUS20 • '
                    'WELCOME10 • NEXUSFREE',
                    style: TextStyle(
                      fontSize: 12,
                      color:
                          Colors.grey.shade600,
                    ),
                  ),

                  // =================================================
                  // PAYMENT METHOD
                  // =================================================

                  const SizedBox(height: 28),

                  const Text(
                    'Payment Method',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Card(
                    elevation: 1,
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(16),
                    ),
                    child: RadioGroup<String>(
                      groupValue:
                          selectedPayment,
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            selectedPayment =
                                value;
                          });
                        }
                      },
                      child: Column(
                        children:
                            paymentMethods.map(
                          (method) {
                            IconData icon;

                            if (method ==
                                'NEXUS Pay') {
                              icon = Icons
                                  .account_balance_wallet;
                            } else if (method ==
                                'Transfer Bank') {
                              icon = Icons
                                  .account_balance;
                            } else {
                              icon = Icons
                                  .payments_outlined;
                            }

                            return RadioListTile<
                                String>(
                              value: method,
                              activeColor:
                                  Colors.deepPurple,
                              secondary: Icon(
                                icon,
                                color: Colors
                                    .deepPurple,
                              ),
                              title: Text(
                                method,
                                style:
                                    const TextStyle(
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                method ==
                                        'NEXUS Pay'
                                    ? 'Saldo digital NEXUS'
                                    : method ==
                                            'Transfer Bank'
                                        ? 'BCA, BRI, BNI, Mandiri'
                                        : 'Bayar ketika barang sampai',
                              ),
                            );
                          },
                        ).toList(),
                      ),
                    ),
                  ),

                  // =================================================
                  // PLACE ORDER
                  // =================================================

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: placeOrder,
                      icon: const Icon(
                        Icons
                            .shopping_bag_outlined,
                      ),
                      label: Text(
                        'Place Order • '
                        'Rp ${finalTotal.toStringAsFixed(0)}',
                        style:
                            const TextStyle(
                          fontSize: 16,
                          fontWeight:
                              FontWeight.bold,
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

  // =========================================================
  // SUMMARY ROW
  // =========================================================

  Widget _summaryRow(
    String title,
    String value, {
    bool bold = false,
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: bold
              ? const TextStyle(
                  fontSize: 18,
                  fontWeight:
                      FontWeight.bold,
                )
              : null,
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: bold ? 20 : null,
            fontWeight: bold
                ? FontWeight.bold
                : null,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
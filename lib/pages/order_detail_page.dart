import 'package:flutter/material.dart';

import '../models/order.dart';
import '../data/order_manager.dart';
import '../data/address_manager.dart';
import 'addresses_page.dart';

class OrderDetailPage extends StatefulWidget {
  final Order order;

  const OrderDetailPage({
    super.key,
    required this.order,
  });

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  Order get order => widget.order;

  String formatRupiah(double value) {
    return 'Rp ${value.toStringAsFixed(0)}';
  }

  String formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');

    return '$day-$month-${date.year}';
  }

  double get subtotal {
    double result = 0;

    for (final product in order.products) {
      result += product.price;
    }

    return result;
  }

  double get total {
    final result =
        subtotal + order.shippingCost - order.discount;

    return result < 0 ? 0 : result;
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;

      case 'cancelled':
        return Colors.red;

      case 'shipped':
        return Colors.blue;

      case 'processing':
        return Colors.orange;

      default:
        return Colors.grey;
    }
  }

  IconData getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Icons.check_circle;

      case 'cancelled':
        return Icons.cancel;

      case 'shipped':
        return Icons.local_shipping;

      case 'processing':
        return Icons.inventory_2_outlined;

      default:
        return Icons.info_outline;
    }
  }

  Future<void> changeAddress() async {
    final selected = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AddressesPage(),
      ),
    );

    if (!mounted) return;

    if (selected != null) {
      final address = addressManager.defaultAddress;

      orderManager.updateOrderAddress(
        order.orderId,
        recipientName: address.recipientName,
        address: address.address,
        phone: address.phone,
      );

      setState(() {});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Alamat pesanan berhasil diperbarui.',
          ),
        ),
      );
    }
  }

  Future<void> showStatusPicker() async {
    final statuses = [
      'Processing',
      'Shipped',
      'Completed',
      'Cancelled',
    ];

    final selected = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              20,
              10,
              20,
              20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Update Order Status',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),

                ...statuses.map(
                  (status) {
                    final color =
                        getStatusColor(status);

                    return ListTile(
                      leading: Icon(
                        getStatusIcon(status),
                        color: color,
                      ),
                      title: Text(status),
                      trailing:
                          order.status == status
                              ? const Icon(
                                  Icons.check,
                                  color:
                                      Colors.deepPurple,
                                )
                              : null,
                      onTap: () {
                        Navigator.pop(
                          context,
                          status,
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );

    if (!mounted || selected == null) {
      return;
    }

    if (selected == order.status) {
      return;
    }

    orderManager.updateOrderStatus(
      order.orderId,
      selected,
    );

    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Status pesanan diubah menjadi $selected.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final statusColor =
        getStatusColor(order.status);

    final statusIcon =
        getStatusIcon(order.status);

    final Map<String, int> quantities = {};

    for (final product in order.products) {
      quantities[product.name] =
          (quantities[product.name] ?? 0) + 1;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Order Detail',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [
            // =====================================================
            // ORDER INFORMATION
            // =====================================================

            Card(
              elevation: 1,

              shape:
                  RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(16),
              ),

              child: Padding(
                padding:
                    const EdgeInsets.all(18),

                child: Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,

                      decoration:
                          BoxDecoration(
                        color: Colors
                            .deepPurple
                            .shade50,
                        borderRadius:
                            BorderRadius
                                .circular(14),
                      ),

                      child: const Icon(
                        Icons
                            .receipt_long_outlined,
                        color:
                            Colors.deepPurple,
                        size: 28,
                      ),
                    ),

                    const SizedBox(width: 14),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,

                        children: [
                          Text(
                            order.orderId,
                            style:
                                const TextStyle(
                              fontSize: 19,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 5),

                          Text(
                            'Tanggal: ${formatDate(order.date)}',
                            style: TextStyle(
                              color: Colors
                                  .grey
                                  .shade600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Container(
                      padding:
                          const EdgeInsets
                              .symmetric(
                        horizontal: 10,
                        vertical: 7,
                      ),

                      decoration:
                          BoxDecoration(
                        color: statusColor
                            .withValues(
                          alpha: 0.12,
                        ),
                        borderRadius:
                            BorderRadius.circular(
                          20,
                        ),
                      ),

                      child: Text(
                        order.status,
                        style: TextStyle(
                          color: statusColor,
                          fontWeight:
                              FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 28),

            // =====================================================
            // SHIPPING ADDRESS
            // =====================================================

            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,

              children: [
                const Text(
                  'Shipping Address',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                TextButton.icon(
                  onPressed: changeAddress,
                  icon: const Icon(
                    Icons.edit_location_alt,
                    size: 18,
                  ),
                  label:
                      const Text('Ubah'),
                ),
              ],
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

                child: Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [
                    const CircleAvatar(
                      backgroundColor:
                          Color(0xFFEDE7F6),

                      child: Icon(
                        Icons.location_on_outlined,
                        color:
                            Colors.deepPurple,
                      ),
                    ),

                    const SizedBox(width: 14),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,

                        children: [
                          Text(
                            order.recipientName
                                    .isEmpty
                                ? 'Belum ada nama'
                                : order.recipientName,

                            style:
                                const TextStyle(
                              fontWeight:
                                  FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),

                          const SizedBox(height: 6),

                          Text(
                            order.address.isEmpty
                                ? 'Belum ada alamat'
                                : order.address,

                            style: TextStyle(
                              color: Colors
                                  .grey
                                  .shade700,
                              height: 1.4,
                            ),
                          ),

                          if (order.phone
                              .isNotEmpty) ...[
                            const SizedBox(
                              height: 6,
                            ),

                            Text(
                              order.phone,
                              style: TextStyle(
                                color: Colors
                                    .grey
                                    .shade700,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 28),

            // =====================================================
            // PRODUCTS
            // =====================================================

            const Text(
              'Products',
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
                            order.products.firstWhere(
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
                                  width: 65,
                                  height: 65,
                                  fit: BoxFit.cover,

                                  errorBuilder:
                                      (
                                    context,
                                    error,
                                    stackTrace,
                                  ) {
                                    return Container(
                                      width: 65,
                                      height: 65,

                                      color: Colors
                                          .grey
                                          .shade200,

                                      child:
                                          const Icon(
                                        Icons
                                            .image_not_supported_outlined,
                                        color:
                                            Colors.grey,
                                      ),
                                    );
                                  },
                                ),
                              ),

                              const SizedBox(
                                width: 12,
                              ),

                              Expanded(
                                child: Column(
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
                                      height: 5,
                                    ),

                                    Text(
                                      '${formatRupiah(product.price)} × $quantity',

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
                                formatRupiah(
                                  itemTotal,
                                ),

                                style:
                                    const TextStyle(
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 28),

            // =====================================================
            // PAYMENT SUMMARY
            // =====================================================

            const Text(
              'Payment Summary',
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
                    const EdgeInsets.all(18),

                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .spaceBetween,

                      children: [
                        const Text(
                          'Subtotal',
                        ),

                        Text(
                          formatRupiah(
                            subtotal,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .spaceBetween,

                      children: [
                        const Text(
                          'Shipping',
                        ),

                        Text(
                          formatRupiah(
                            order.shippingCost,
                          ),
                        ),
                      ],
                    ),

                    // =================================================
                    // VOUCHER
                    // =================================================

                    if (order.discount > 0) ...[
                      const SizedBox(
                        height: 12,
                      ),

                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment
                                .spaceBetween,

                        children: [
                          Expanded(
                            child: Text(
                              order.voucherCode !=
                                      null
                                  ? 'Voucher ${order.voucherCode}'
                                  : 'Voucher',

                              style:
                                  const TextStyle(
                                color:
                                    Colors.green,
                              ),
                            ),
                          ),

                          Text(
                            '-${formatRupiah(order.discount)}',

                            style:
                                const TextStyle(
                              color:
                                  Colors.green,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],

                    const Padding(
                      padding:
                          EdgeInsets.symmetric(
                        vertical: 14,
                      ),

                      child: Divider(),
                    ),

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .spaceBetween,

                      children: [
                        const Text(
                          'Total Payment',

                          style:
                              TextStyle(
                            fontSize: 18,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        Text(
                          formatRupiah(
                            total,
                          ),

                          style:
                              const TextStyle(
                            fontSize: 20,
                            fontWeight:
                                FontWeight.bold,
                            color:
                                Colors.deepPurple,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // =====================================================
            // PAYMENT METHOD
            // =====================================================

            const SizedBox(height: 14),

            Card(
              elevation: 0,
              color: Colors.deepPurple.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.payment_outlined,
                        color: Colors.deepPurple,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Metode Pembayaran',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            order.paymentMethod,
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // =====================================================
            // VOUCHER DETAIL
            // =====================================================

            if (order.voucherCode != null &&
                order.voucherCode!.isNotEmpty) ...[
              const SizedBox(height: 14),

              Card(
                elevation: 0,

                color:
                    Colors.green.shade50,

                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(16),
                ),

                child: Padding(
                  padding:
                      const EdgeInsets.all(16),

                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,

                        decoration:
                            BoxDecoration(
                          color: Colors
                              .green
                              .shade100,
                          borderRadius:
                              BorderRadius
                                  .circular(12),
                        ),

                        child: const Icon(
                          Icons
                              .confirmation_number_outlined,
                          color:
                              Colors.green,
                        ),
                      ),

                      const SizedBox(
                        width: 12,
                      ),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,

                          children: [
                            const Text(
                              'Voucher Digunakan',
                              style:
                                  TextStyle(
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),

                            const SizedBox(
                              height: 4,
                            ),

                            Text(
                              order.voucherName ??
                                  order.voucherCode!,

                              style: TextStyle(
                                color: Colors
                                    .grey
                                    .shade700,
                              ),
                            ),

                            const SizedBox(
                              height: 3,
                            ),

                            Text(
                              'Hemat ${formatRupiah(order.discount)}',

                              style:
                                  const TextStyle(
                                color:
                                    Colors.green,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            const SizedBox(height: 28),

            // =====================================================
            // ORDER STATUS
            // =====================================================

            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,

              children: [
                const Text(
                  'Order Status',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                TextButton.icon(
                  onPressed:
                      showStatusPicker,

                  icon: const Icon(
                    Icons.edit,
                    size: 18,
                  ),

                  label:
                      const Text('Update'),
                ),
              ],
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
                    const EdgeInsets.all(18),

                child: Row(
                  children: [
                    Icon(
                      statusIcon,
                      color: statusColor,
                      size: 30,
                    ),

                    const SizedBox(
                      width: 14,
                    ),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,

                        children: [
                          Text(
                            order.status,

                            style:
                                TextStyle(
                              color:
                                  statusColor,
                              fontSize: 17,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          const SizedBox(
                            height: 5,
                          ),

                          Text(
                            getStatusDescription(
                              order.status,
                            ),

                            style: TextStyle(
                              color: Colors
                                  .grey
                                  .shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // =====================================================
            // BACK BUTTON
            // =====================================================

            SizedBox(
              width: double.infinity,
              height: 52,

              child:
                  OutlinedButton.icon(
                onPressed: () =>
                    Navigator.pop(
                  context,
                ),

                icon: const Icon(
                  Icons.arrow_back,
                ),

                label: const Text(
                  'Back to My Orders',

                  style: TextStyle(
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

  String getStatusDescription(
    String status,
  ) {
    switch (status.toLowerCase()) {
      case 'processing':
        return 'Pesanan sedang diproses oleh NEXUS MARKET.';

      case 'shipped':
        return 'Pesanan sedang dalam perjalanan menuju alamat kamu.';

      case 'completed':
        return 'Pesanan telah selesai. Terima kasih sudah berbelanja di NEXUS MARKET.';

      case 'cancelled':
        return 'Pesanan ini telah dibatalkan.';

      default:
        return 'Status pesanan telah diperbarui.';
    }
  }
}
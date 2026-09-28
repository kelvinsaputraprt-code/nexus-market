import 'package:flutter/material.dart';

import '../data/cart_manager.dart';
import '../data/review_manager.dart';
import '../data/wishlist_manager.dart';
import '../models/product.dart';
import 'checkout_page.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;

  const ProductDetailPage({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailPage> createState() =>
      _ProductDetailPageState();
}

class _ProductDetailPageState
    extends State<ProductDetailPage> {
  int quantity = 1;

  bool get available => widget.product.isAvailable();

  void increaseQuantity() {
    if (quantity < widget.product.stock) {
      setState(() {
        quantity++;
      });
    }
  }

  void decreaseQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
    }
  }

  String formatRupiah(double value) {
    return 'Rp ${value.toStringAsFixed(0)}';
  }

  void addToCart() {
    if (!available) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Produk sedang habis.',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    for (int i = 0; i < quantity; i++) {
      cartManager.addToCart(
        widget.product,
      );
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$quantity ${widget.product.name} '
          'ditambahkan ke keranjang.',
        ),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }

  void buyNow() {
    if (!available) {
      return;
    }

    final items = List<Product>.generate(
      quantity,
      (_) => widget.product,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CheckoutPage(
          directItems: items,
        ),
      ),
    );
  }

  void toggleWishlist() {
    final isSaved =
        wishlistManager.contains(widget.product);

    wishlistManager.toggle(widget.product);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isSaved
              ? '${widget.product.name} dihapus dari Wishlist.'
              : '${widget.product.name} ditambahkan ke Wishlist.',
        ),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }

  void openCart() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CheckoutPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final totalPrice = product.price * quantity;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F5FC),

      // =========================================================
      // APP BAR
      // =========================================================

      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F5FC),
        surfaceTintColor: Colors.transparent,
        elevation: 0,

        title: const Text(
          'Product Detail',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF202020),
          ),
        ),

        actions: [
          AnimatedBuilder(
            animation: wishlistManager,
            builder: (context, _) {
              final isSaved =
                  wishlistManager.contains(widget.product);

              return IconButton(
                tooltip: isSaved
                    ? 'Hapus dari Wishlist'
                    : 'Tambah ke Wishlist',
                onPressed: toggleWishlist,
                icon: Icon(
                  isSaved
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: isSaved
                      ? Colors.redAccent
                      : const Color(0xFF4B4650),
                ),
              );
            },
          ),

          AnimatedBuilder(
            animation: cartManager,
            builder: (context, _) {
              final count =
                  cartManager.items.length;

              return Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                    tooltip: 'Keranjang',
                    onPressed: openCart,
                    icon: const Icon(
                      Icons.shopping_cart_outlined,
                      color: Color(0xFF4B4650),
                    ),
                  ),

                  if (count > 0)
                    Positioned(
                      right: 5,
                      top: 5,
                      child: Container(
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFF6C4BEF,
                          ),
                          borderRadius:
                              BorderRadius.circular(10),
                        ),
                        child: Text(
                          count > 99
                              ? '99+'
                              : '$count',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),

          const SizedBox(width: 8),
        ],
      ),

      // =========================================================
      // BODY
      // =========================================================

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            // =====================================================
            // PRODUCT IMAGE
            // =====================================================

            Container(
              width: double.infinity,
              height: 340,
              margin:
                  const EdgeInsets.fromLTRB(
                18,
                8,
                18,
                0,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.deepPurple
                        .withValues(alpha: 0.08),
                    blurRadius: 24,
                    offset:
                        const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius:
                    BorderRadius.circular(24),
                child: Image.asset(
                  product.imageUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (
                    context,
                    error,
                    stackTrace,
                  ) {
                    return const Center(
                      child: Icon(
                        Icons
                            .image_not_supported_outlined,
                        size: 80,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ),
            ),

            // =====================================================
            // PRODUCT INFORMATION
            // =====================================================

            Padding(
              padding:
                  const EdgeInsets.fromLTRB(
                22,
                24,
                22,
                30,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  // CATEGORY

                  Text(
                    product.category,
                    style: const TextStyle(
                      color: Color(0xFF6542C7),
                      fontWeight:
                          FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // PRODUCT NAME

                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 29,
                      height: 1.15,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 14),

                  // RATING & SOLD

                  AnimatedBuilder(
                    animation: reviewManager,
                    builder:
                        (context, child) {
                      final average =
                          reviewManager
                              .getAverageRating(
                        product.name,
                        product.rating,
                      );

                      final reviews =
                          reviewManager
                              .getReviewsForProduct(
                        product.name,
                      );

                      return Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            color: Colors.amber,
                            size: 21,
                          ),

                          const SizedBox(width: 5),

                          Text(
                            average
                                .toStringAsFixed(1),
                            style:
                                const TextStyle(
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          const SizedBox(
                            width: 8,
                          ),

                          if (reviews.isNotEmpty)
                            Text(
                              '(${reviews.length} review)',
                              style: TextStyle(
                                color: Colors
                                    .grey
                                    .shade600,
                              ),
                            ),

                          const SizedBox(
                            width: 14,
                          ),

                          Text(
                            '${product.sold} terjual',
                            style: TextStyle(
                              color: Colors
                                  .grey
                                  .shade600,
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 18),

                  // PRICE

                  Text(
                    formatRupiah(
                      product.price,
                    ),
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight:
                          FontWeight.w800,
                      color:
                          Color(0xFF6240C7),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // STOCK

                  Container(
                    padding:
                        const EdgeInsets
                            .symmetric(
                      horizontal: 13,
                      vertical: 10,
                    ),
                    decoration:
                        BoxDecoration(
                      color: available
                          ? Colors.green
                              .withValues(
                              alpha: 0.09,
                            )
                          : Colors.red
                              .withValues(
                              alpha: 0.09,
                            ),
                      borderRadius:
                          BorderRadius.circular(
                        12,
                      ),
                    ),
                    child: Row(
                      mainAxisSize:
                          MainAxisSize.min,
                      children: [
                        Icon(
                          available
                              ? Icons
                                  .inventory_2_outlined
                              : Icons
                                  .remove_shopping_cart_outlined,
                          size: 19,
                          color: available
                              ? Colors.green
                              : Colors.red,
                        ),

                        const SizedBox(width: 8),

                        Text(
                          'Stok: ${product.stock}',
                          style:
                              const TextStyle(
                            fontWeight:
                                FontWeight.w700,
                          ),
                        ),

                        const SizedBox(
                          width: 10,
                        ),

                        Text(
                          product
                              .getStockStatus(),
                          style: TextStyle(
                            color: available
                                ? Colors.green
                                : Colors.red,
                            fontWeight:
                                FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  const Divider(),

                  const SizedBox(height: 24),

                  // =================================================
                  // DESCRIPTION
                  // =================================================

                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    product.description,
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.7,
                      color:
                          Colors.grey.shade700,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // =================================================
                  // RATING & REVIEW
                  // =================================================

                  _buildReviewSection(),

                  const SizedBox(height: 30),

                  // =================================================
                  // QUANTITY
                  // =================================================

                  const Text(
                    'Quantity',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Container(
                    padding:
                        const EdgeInsets
                            .symmetric(
                      horizontal: 8,
                      vertical: 5,
                    ),
                    decoration:
                        BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(
                        14,
                      ),
                      border: Border.all(
                        color:
                            Colors.grey.shade300,
                      ),
                    ),
                    child: Row(
                      mainAxisSize:
                          MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed:
                              quantity > 1
                                  ? decreaseQuantity
                                  : null,
                          icon: const Icon(
                            Icons
                                .remove_circle_outline,
                          ),
                        ),

                        SizedBox(
                          width: 38,
                          child: Text(
                            '$quantity',
                            textAlign:
                                TextAlign.center,
                            style:
                                const TextStyle(
                              fontSize: 18,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ),

                        IconButton(
                          onPressed:
                              quantity <
                                      product.stock
                                  ? increaseQuantity
                                  : null,
                          icon: const Icon(
                            Icons
                                .add_circle_outline,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 26),

                  // =================================================
                  // TOTAL
                  // =================================================

                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment
                            .spaceBetween,
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      Text(
                        formatRupiah(
                          totalPrice,
                        ),
                        style:
                            const TextStyle(
                          fontSize: 22,
                          fontWeight:
                              FontWeight.w800,
                          color:
                              Color(0xFF6240C7),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 22),

                  // =================================================
                  // ADD TO CART
                  // =================================================

                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child:
                        ElevatedButton.icon(
                      onPressed: available
                          ? addToCart
                          : null,
                      style:
                          ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(
                          0xFFEFE9FF,
                        ),
                        foregroundColor:
                            const Color(
                          0xFF6240C7,
                        ),
                        elevation: 0,
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius
                                  .circular(
                            16,
                          ),
                        ),
                      ),
                      icon: const Icon(
                        Icons
                            .shopping_cart_outlined,
                      ),
                      label: const Text(
                        'Add to Cart',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // =================================================
                  // BUY NOW
                  // =================================================

                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child:
                        ElevatedButton.icon(
                      onPressed: available
                          ? buyNow
                          : null,
                      style:
                          ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(
                          0xFF6240C7,
                        ),
                        foregroundColor:
                            Colors.white,
                        elevation: 4,
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius
                                  .circular(
                            16,
                          ),
                        ),
                      ),
                      icon: const Icon(
                        Icons.flash_on_rounded,
                      ),
                      label: const Text(
                        'Buy Now',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===============================================================
  // REVIEW SECTION
  // ===============================================================

  Widget _buildReviewSection() {
    return AnimatedBuilder(
      animation: reviewManager,
      builder: (context, child) {
        final reviews =
            reviewManager
                .getReviewsForProduct(
          widget.product.name,
        );

        final average =
            reviewManager
                .getAverageRating(
          widget.product.name,
          widget.product.rating,
        );

        return Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment:
                  MainAxisAlignment
                      .spaceBetween,
              children: [
                const Text(
                  'Rating & Reviews',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                TextButton.icon(
                  onPressed: () {
                    _showReviewDialog(
                      context,
                    );
                  },
                  icon: const Icon(
                    Icons.rate_review_outlined,
                    size: 18,
                  ),
                  label: const Text(
                    'Tulis Review',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // =====================================================
            // RATING SUMMARY
            // =====================================================

            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(18),
                border: Border.all(
                  color: Colors.grey.shade200,
                ),
              ),
              child: Row(
                children: [
                  Column(
                    children: [
                      Text(
                        average
                            .toStringAsFixed(1),
                        style:
                            const TextStyle(
                          fontSize: 34,
                          fontWeight:
                              FontWeight.bold,
                          color:
                              Colors.deepPurple,
                        ),
                      ),

                      Row(
                        children:
                            List.generate(
                          5,
                          (index) {
                            return Icon(
                              index <
                                      average
                                          .round()
                                  ? Icons.star
                                  : Icons
                                      .star_border,
                              color:
                                  Colors.amber,
                              size: 18,
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        '${reviews.length} review',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors
                              .grey.shade600,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(width: 24),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                      children: [
                        _buildRatingBar(
                          5,
                          reviews,
                        ),
                        _buildRatingBar(
                          4,
                          reviews,
                        ),
                        _buildRatingBar(
                          3,
                          reviews,
                        ),
                        _buildRatingBar(
                          2,
                          reviews,
                        ),
                        _buildRatingBar(
                          1,
                          reviews,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // =====================================================
            // REVIEWS
            // =====================================================

            if (reviews.isEmpty)
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(
                    18,
                  ),
                  border: Border.all(
                    color:
                        Colors.grey.shade200,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons
                          .rate_review_outlined,
                      size: 42,
                      color:
                          Colors.grey.shade400,
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      'Belum ada review',
                      style: TextStyle(
                        fontWeight:
                            FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      'Jadilah yang pertama memberikan '
                      'review untuk produk ini.',
                      textAlign:
                          TextAlign.center,
                      style: TextStyle(
                        color:
                            Colors.grey.shade600,
                        fontSize: 13,
                      ),
                    ),

                    const SizedBox(height: 14),

                    ElevatedButton.icon(
                      onPressed: () {
                        _showReviewDialog(
                          context,
                        );
                      },
                      icon: const Icon(
                        Icons.star_outline,
                      ),
                      label: const Text(
                        'Beri Rating',
                      ),
                      style:
                          ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.deepPurple,
                        foregroundColor:
                            Colors.white,
                      ),
                    ),
                  ],
                ),
              )
            else
              ...reviews.map(
                (review) {
                  return _buildReviewCard(
                    review,
                  );
                },
              ),
          ],
        );
      },
    );
  }

  // ===============================================================
  // RATING BAR
  // ===============================================================

  Widget _buildRatingBar(
    int star,
    List<ProductReview> reviews,
  ) {
    final count = reviews
        .where(
          (review) =>
              review.rating.round() == star,
        )
        .length;

    final percentage = reviews.isEmpty
        ? 0.0
        : count / reviews.length;

    return Padding(
      padding:
          const EdgeInsets.symmetric(
        vertical: 2,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            child: Text(
              '$star',
              style: const TextStyle(
                fontSize: 12,
                fontWeight:
                    FontWeight.w600,
              ),
            ),
          ),

          const Icon(
            Icons.star,
            color: Colors.amber,
            size: 14,
          ),

          const SizedBox(width: 6),

          Expanded(
            child: ClipRRect(
              borderRadius:
                  BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: percentage,
                minHeight: 7,
                backgroundColor:
                    Colors.grey.shade200,
                color: Colors.amber,
              ),
            ),
          ),

          const SizedBox(width: 8),

          SizedBox(
            width: 20,
            child: Text(
              '$count',
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 11,
                color:
                    Colors.grey.shade600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===============================================================
  // REVIEW CARD
  // ===============================================================

  Widget _buildReviewCard(
    ProductReview review,
  ) {
    return Container(
      width: double.infinity,
      margin:
          const EdgeInsets.only(
        bottom: 12,
      ),
      padding:
          const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(18),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor:
                    Colors.deepPurple
                        .withValues(
                  alpha: 0.10,
                ),
                child: const Icon(
                  Icons.person_outline,
                  color:
                      Colors.deepPurple,
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [
                    Text(
                      review.reviewerName,
                      style:
                          const TextStyle(
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Row(
                      children: [
                        ...List.generate(
                          5,
                          (index) {
                            return Icon(
                              index <
                                      review.rating
                                          .round()
                                  ? Icons.star
                                  : Icons
                                      .star_border,
                              size: 15,
                              color:
                                  Colors.amber,
                            );
                          },
                        ),

                        const SizedBox(
                          width: 8,
                        ),

                        Text(
                          review.rating
                              .toStringAsFixed(
                            1,
                          ),
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors
                                .grey
                                .shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Text(
                _formatReviewDate(
                  review.date,
                ),
                style: TextStyle(
                  fontSize: 11,
                  color:
                      Colors.grey.shade500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Text(
            review.comment,
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color:
                  Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  // ===============================================================
  // REVIEW DATE
  // ===============================================================

  String _formatReviewDate(
    DateTime date,
  ) {
    final day =
        date.day.toString().padLeft(
              2,
              '0',
            );

    final month =
        date.month.toString().padLeft(
              2,
              '0',
            );

    return '$day-$month-${date.year}';
  }

  // ===============================================================
  // REVIEW DIALOG
  // ===============================================================

  void _showReviewDialog(
    BuildContext context,
  ) {
    int selectedRating = 5;

    final controller =
        TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (
            context,
            setDialogState,
          ) {
            return AlertDialog(
              title: const Text(
                'Tulis Review',
              ),

              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize:
                      MainAxisSize.min,
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [
                    Text(
                      widget.product.name,
                      maxLines: 2,
                      overflow:
                          TextOverflow.ellipsis,
                      style:
                          const TextStyle(
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 18),

                    const Text(
                      'Berikan rating',
                      style:
                          TextStyle(
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .center,
                      children:
                          List.generate(
                        5,
                        (index) {
                          final star =
                              index + 1;

                          return IconButton(
                            onPressed: () {
                              setDialogState(
                                () {
                                  selectedRating =
                                      star;
                                },
                              );
                            },
                            icon: Icon(
                              star <=
                                      selectedRating
                                  ? Icons
                                      .star_rounded
                                  : Icons
                                      .star_border_rounded,
                              color:
                                  Colors.amber,
                              size: 34,
                            ),
                          );
                        },
                      ),
                    ),

                    Center(
                      child: Text(
                        '$selectedRating / 5',
                        style:
                            const TextStyle(
                          fontWeight:
                              FontWeight.bold,
                          color:
                              Colors.deepPurple,
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    const Text(
                      'Review kamu',
                      style:
                          TextStyle(
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 8),

                    TextField(
                      controller:
                          controller,
                      maxLines: 4,
                      maxLength: 250,
                      decoration:
                          InputDecoration(
                        hintText:
                            'Ceritakan pengalaman kamu...',
                        filled: true,
                        fillColor:
                            Colors.grey.shade100,
                        border:
                            OutlineInputBorder(
                          borderRadius:
                              BorderRadius
                                  .circular(
                            14,
                          ),
                          borderSide:
                              BorderSide.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              actions: [
                TextButton(
                  onPressed: () {
                    controller.dispose();
                    Navigator.pop(
                      dialogContext,
                    );
                  },
                  child: const Text(
                    'Batal',
                  ),
                ),

                ElevatedButton(
                  onPressed: () {
                    final comment =
                        controller.text
                            .trim();

                    if (comment.isEmpty) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Tulis review terlebih dahulu.',
                          ),
                        ),
                      );
                      return;
                    }

                    reviewManager
                        .addReview(
                      productName:
                          widget.product.name,
                      reviewerName:
                          'Kelvin',
                      rating:
                          selectedRating
                              .toDouble(),
                      comment: comment,
                    );

                    controller.dispose();

                    Navigator.pop(
                      dialogContext,
                    );

                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Review berhasil ditambahkan! ⭐',
                        ),
                        backgroundColor:
                            Colors.green,
                      ),
                    );
                  },
                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.deepPurple,
                    foregroundColor:
                        Colors.white,
                  ),
                  child: const Text(
                    'Submit Review',
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
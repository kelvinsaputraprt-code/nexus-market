import 'package:flutter/material.dart';

import '../data/products.dart';
import '../data/cart_manager.dart';
import '../data/categories.dart';
import '../data/notification_manager.dart';
import '../widgets/product_card.dart';
import '../widgets/category_card.dart';
import 'checkout_page.dart';
import 'notifications_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController searchController =
      TextEditingController();

  String selectedCategory = 'Semua Produk';
  String searchQuery = '';

  @override
  void initState() {
    super.initState();

    searchController.addListener(() {
      setState(() {
        searchQuery =
            searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<dynamic> get filteredProducts {
    return products.where((product) {
      final categoryMatch =
          selectedCategory == 'Semua Produk' ||
              product.category == selectedCategory;

      final searchMatch =
          searchQuery.isEmpty ||
              product.name
                  .toLowerCase()
                  .contains(searchQuery) ||
              product.description
                  .toLowerCase()
                  .contains(searchQuery) ||
              product.category
                  .toLowerCase()
                  .contains(searchQuery);

      return categoryMatch && searchMatch;
    }).toList();
  }

  void selectCategory(String category) {
    setState(() {
      selectedCategory = category;
    });
  }

  void openCart() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CheckoutPage(),
      ),
    );
  }

  void openNotifications() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const NotificationsPage(),
      ),
    );
  }

  void clearSearch() {
    searchController.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final displayedProducts = filteredProducts;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F5FC),

      // =========================================================
      // APP BAR
      // =========================================================

      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F5FC),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 20,

        title: const Text(
          'NEXUS MARKET',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.8,
            color: Color(0xFF29232F),
          ),
        ),

        actions: [
          // =====================================================
          // NOTIFICATION
          // =====================================================

          AnimatedBuilder(
            animation: notificationManager,
            builder: (context, _) {
              final unread =
                  notificationManager.unreadCount;

              return Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                    tooltip: 'Notifications',
                    onPressed: openNotifications,
                    icon: const Icon(
                      Icons.notifications_none_outlined,
                      color: Color(0xFF4B4650),
                    ),
                  ),

                  if (unread > 0)
                    Positioned(
                      right: 4,
                      top: 3,
                      child: Container(
                        constraints:
                            const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 2,
                        ),
                        decoration:
                            const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          unread > 99
                              ? '99+'
                              : '$unread',
                          textAlign:
                              TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
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

          // =====================================================
          // CART
          // =====================================================

          AnimatedBuilder(
            animation: cartManager,
            builder: (context, _) {
              final count =
                  cartManager.items.length;

              return Padding(
                padding:
                    const EdgeInsets.only(right: 10),
                child: Stack(
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
                        right: 2,
                        top: 3,
                        child: Container(
                          padding:
                              const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 2,
                          ),
                          decoration:
                              BoxDecoration(
                            color: const Color(
                              0xFF6C4BEF,
                            ),
                            borderRadius:
                                BorderRadius.circular(
                              10,
                            ),
                          ),
                          child: Text(
                            count > 99
                                ? '99+'
                                : '$count',
                            style:
                                const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ],
      ),

      // =========================================================
      // BODY
      // =========================================================

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          20,
          8,
          20,
          30,
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            // =====================================================
            // HERO
            // =====================================================

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(24),
                gradient:
                    const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF25154A),
                    Color(0xFF5532A8),
                    Color(0xFF7A55D9),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.deepPurple,
                    blurRadius: 22,
                    offset:
                        const Offset(0, 10),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: -18,
                    top: -25,
                    child: Icon(
                      Icons.shopping_bag_rounded,
                      size: 145,
                      color: Colors.white
                          .withValues(
                        alpha: 0.08,
                      ),
                    ),
                  ),

                  Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding:
                            const EdgeInsets
                                .symmetric(
                          horizontal: 11,
                          vertical: 6,
                        ),
                        decoration:
                            BoxDecoration(
                          color: Colors.white
                              .withValues(
                            alpha: 0.14,
                          ),
                          borderRadius:
                              BorderRadius.circular(
                            20,
                          ),
                        ),
                        child: const Text(
                          'NEXUS MARKET',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight:
                                FontWeight.bold,
                            letterSpacing: 1.4,
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 18,
                      ),

                      const Text(
                        'Everything You Need,',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const Text(
                        'All in One Place.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      const Text(
                        'Gaming • Automotive • Technology • More',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // =====================================================
            // SEARCH
            // =====================================================

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black
                        .withValues(alpha: 0.04),
                    blurRadius: 12,
                    offset:
                        const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: searchController,
                decoration:
                    InputDecoration(
                  hintText:
                      'Cari produk, kategori...',
                  prefixIcon: const Icon(
                    Icons.search,
                    color:
                        Colors.deepPurple,
                  ),
                  suffixIcon:
                      searchQuery.isNotEmpty
                          ? IconButton(
                              onPressed:
                                  clearSearch,
                              icon:
                                  const Icon(
                                Icons.close,
                              ),
                            )
                          : null,
                  border:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(
                      16,
                    ),
                    borderSide:
                        BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      const EdgeInsets
                          .symmetric(
                    vertical: 16,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 28),

            // =====================================================
            // CATEGORIES
            // =====================================================

            const Text(
              'Categories',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection:
                    Axis.horizontal,
                itemCount:
                    categories.length,
                itemBuilder:
                    (context, index) {
                  final category =
                      categories[index];

                  final isSelected =
                      selectedCategory ==
                          category.name;

                  return Padding(
                    padding:
                        const EdgeInsets.only(
                      right: 12,
                    ),
                    child: InkWell(
                      borderRadius:
                          BorderRadius.circular(
                        18,
                      ),
                      onTap: () {
                        selectCategory(
                          category.name,
                        );
                      },
                      child:
                          AnimatedContainer(
                        duration:
                            const Duration(
                          milliseconds: 200,
                        ),
                        decoration:
                            BoxDecoration(
                          borderRadius:
                              BorderRadius
                                  .circular(
                            18,
                          ),
                          border: Border.all(
                            color: isSelected
                                ? Colors
                                    .deepPurple
                                : Colors
                                    .transparent,
                            width: 2,
                          ),
                        ),
                        child:
                            CategoryCard(
                          name:
                              category.name,
                          icon:
                              category.icon,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            // =====================================================
            // PRODUCT HEADER
            // =====================================================

            Row(
              children: [
                Expanded(
                  child: Text(
                    selectedCategory ==
                            'Semua Produk'
                        ? 'Featured Products'
                        : selectedCategory,
                    style:
                        const TextStyle(
                      fontSize: 20,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),

                if (selectedCategory !=
                    'Semua Produk')
                  TextButton(
                    onPressed: () {
                      selectCategory(
                        'Semua Produk',
                      );
                    },
                    child: const Text(
                      'Reset',
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 5),

            Text(
              '${displayedProducts.length} produk tersedia',
              style: TextStyle(
                fontSize: 13,
                color:
                    Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 16),

            // =====================================================
            // PRODUCTS
            // =====================================================

            SizedBox(
              height: 330,
              child: displayedProducts.isEmpty
                  ? const Center(
                      child: Text(
                        'Produk tidak ditemukan.',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : ListView.builder(
                      scrollDirection:
                          Axis.horizontal,
                      itemCount:
                          displayedProducts.length,
                      itemBuilder:
                          (context, index) {
                        return Padding(
                          padding:
                              const EdgeInsets
                                  .only(
                            right: 16,
                          ),
                          child:
                              ProductCard(
                            product:
                                displayedProducts[
                                    index],
                          ),
                        );
                      },
                    ),
            ),

            const SizedBox(height: 28),

            // =====================================================
            // INFO CARD
            // =====================================================

            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(20),
                border: Border.all(
                  color:
                      Colors.deepPurple
                          .withValues(
                    alpha: 0.10,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration:
                        BoxDecoration(
                      color: Colors.deepPurple
                          .withValues(
                        alpha: 0.10,
                      ),
                      shape:
                          BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.verified_outlined,
                      color:
                          Colors.deepPurple,
                    ),
                  ),

                  const SizedBox(width: 14),

                  const Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                      children: [
                        Text(
                          'Belanja di NEXUS MARKET',
                          style:
                              TextStyle(
                            fontWeight:
                                FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Produk pilihan dengan pengalaman '
                          'belanja yang mudah dan nyaman.',
                          style:
                              TextStyle(
                            fontSize: 12,
                            color:
                                Colors.grey,
                          ),
                        ),
                      ],
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
}
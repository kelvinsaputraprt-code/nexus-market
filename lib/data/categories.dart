import 'package:flutter/material.dart';

class CategoryItem {
  final String name;
  final IconData icon;

  const CategoryItem({
    required this.name,
    required this.icon,
  });
}

final List<CategoryItem> categories = [
  const CategoryItem(
    name: 'Gaming',
    icon: Icons.sports_esports,
  ),
  const CategoryItem(
    name: 'Automotive',
    icon: Icons.two_wheeler,
  ),
  const CategoryItem(
    name: 'Technology',
    icon: Icons.computer,
  ),
  const CategoryItem(
    name: 'Fashion',
    icon: Icons.checkroom,
  ),
  const CategoryItem(
    name: 'Accessories',
    icon: Icons.watch,
  ),
  const CategoryItem(
    name: 'Home & Living',
    icon: Icons.home_outlined,
  ),
];
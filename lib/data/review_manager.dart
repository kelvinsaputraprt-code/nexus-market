import 'package:flutter/foundation.dart';

class ProductReview {
  final String productName;
  final String reviewerName;
  final double rating;
  final String comment;
  final DateTime date;

  ProductReview({
    required this.productName,
    required this.reviewerName,
    required this.rating,
    required this.comment,
    required this.date,
  });
}

class ReviewManager extends ChangeNotifier {
  final List<ProductReview> _reviews = [];

  List<ProductReview> get reviews =>
      List.unmodifiable(_reviews);

  List<ProductReview> getReviewsForProduct(
    String productName,
  ) {
    return _reviews
        .where(
          (review) => review.productName == productName,
        )
        .toList()
        .reversed
        .toList();
  }

  void addReview({
    required String productName,
    required String reviewerName,
    required double rating,
    required String comment,
  }) {
    final review = ProductReview(
      productName: productName,
      reviewerName: reviewerName,
      rating: rating,
      comment: comment,
      date: DateTime.now(),
    );

    _reviews.add(review);

    notifyListeners();
  }

  double getAverageRating(
    String productName,
    double defaultRating,
  ) {
    final productReviews = getReviewsForProduct(
      productName,
    );

    if (productReviews.isEmpty) {
      return defaultRating;
    }

    double total = 0;

    for (final review in productReviews) {
      total += review.rating;
    }

    return total / productReviews.length;
  }

  void clearReviews() {
    _reviews.clear();
    notifyListeners();
  }
}

final ReviewManager reviewManager = ReviewManager();
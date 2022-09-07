import 'package:flutter/material.dart';
import 'package:bike_cafe/screens/Dashboard/product/locale/productdetails/reviews.dart';
import 'package:bike_cafe/services/api.dart';
import 'package:bike_cafe/widget/locale/scaffold.dart';

class ReviewsPage extends StatefulWidget {
  ReviewsPage({Key? key, this.token, this.userId, this.productId})
      : super(key: key);
  @override
  _ReviewsPageState createState() => _ReviewsPageState();

  String? token, userId;
  String? productId;
}

class _ReviewsPageState extends State<ReviewsPage> {
  APIService service = APIService();

  @override
  Widget build(BuildContext context) {
    return GetScaffold(
      index: 6,
      title: "Reviews",
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 6),
            ProductReviews(
                token: widget.token.toString(),
                userId: widget.userId.toString(),
                productId: widget.productId.toString(),
                allReviews: true)
          ],
        ),
      ),
    );
  }
}

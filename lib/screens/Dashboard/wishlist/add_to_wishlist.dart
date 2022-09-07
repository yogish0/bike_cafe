import 'package:flutter/material.dart';
import 'package:bike_cafe/widget/config.dart';

import '../../../models/Products/check_wishlist_model.dart';
import '../../../services/api.dart';

class AddWishlist extends StatefulWidget {
  AddWishlist({Key? key, this.token, this.userId, this.productId})
      : super(key: key);

  String? token, userId, productId;

  @override
  _AddWishlistState createState() => _AddWishlistState();
}

class _AddWishlistState extends State<AddWishlist> {
  APIService service = APIService();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.topRight,
        child: InkWell(
          onTap: () {
            service
                .addToWishlistApi(
                    token: widget.token,
                    userId: widget.userId,
                    productId: widget.productId.toString())
                .then((value) {
              setState(() {});
            });
          },
          child: FutureBuilder<CheckWishlisted?>(
            future: service.checkWishlist(
                token: widget.token,
                userId: widget.userId,
                productId: widget.productId.toString()),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.checkout.iswishlist == 1) {
                  return const Icon(Icons.favorite,
                      color: kPrimaryColor, size: 24);
                } else {
                  return const Icon(Icons.favorite_border,
                      color: Colors.grey, size: 24);
                }
              } else {
                return const Icon(Icons.favorite_border,
                    color: Colors.grey, size: 24);
              }
            },
          ),
        ),
      ),
    );
  }
}

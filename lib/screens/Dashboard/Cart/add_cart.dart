import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../services/api.dart';
import '../../../widget/constrants.dart';
import 'cart.dart';
import 'package:get/get.dart';

class AddCart{
  APIService service = APIService();
  CartController cartController = Get.put(CartController());
  Widget addToCart(String token, String userId, int productId){
    return InkWell(
      onTap: () {
        var addItemApi = service.addItemToCart(
            token: token,
            userId: userId,
            productId: productId);
        int? success = 0;
        addItemApi.then((value) {
          success = value!.success;
          // print("up $success");
          if (success == 1) {
            Fluttertoast.showToast(
                msg: 'Item added to cart');
            service
                .cartCheckoutApi(
                token: token,
                userId: userId)
                .then((value) {
              cartController.cartItemsCount.value =
                  value!.products!.length;
              debugPrint(cartController.cartItemsCount.value.toString());
            });
          } else {
            Fluttertoast.showToast(
                msg: 'Failed to add item to cart');
          }
        });
      },
      child: Constants.cartIcon(),
    );
  }
}
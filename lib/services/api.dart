import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:bike_cafe/models/Cart_Model/add_cart_model.dart';
import 'package:bike_cafe/models/Cart_Model/cart_checkout_model.dart';
import 'package:bike_cafe/models/Cart_Model/cart_list_model.dart';
import 'package:bike_cafe/models/Categories/category_model.dart';
import 'package:bike_cafe/models/Order_Model/online_payment_initiate_model.dart';
import 'package:bike_cafe/models/Order_Model/online_payment_verify.dart';
import 'package:bike_cafe/models/Order_Model/order_details_model.dart';
import 'package:bike_cafe/models/Order_Model/order_response_model.dart';
import 'package:bike_cafe/models/Order_Model/orders_by_id_model.dart';
import 'package:bike_cafe/models/Order_Model/users_product_review_model.dart';
import 'package:bike_cafe/models/Products/aadto_wishlist_model.dart';
import 'package:bike_cafe/models/Products/check_wishlist_model.dart';
import 'package:bike_cafe/models/Products/get_banners.dart';
import 'package:bike_cafe/models/Products/get_wishlist_model.dart';
import 'package:bike_cafe/models/Products/getcuponproduct.dart';
import 'package:bike_cafe/models/Products/product_related_variants.dart';
import 'package:bike_cafe/models/Products/product_review_rating_model.dart';
import 'package:bike_cafe/models/Products/products_by_banner_model.dart';
import 'package:bike_cafe/models/Products/products_by_cat_variant_id_model.dart';
import 'package:bike_cafe/models/Products/products_model.dart';
import 'package:bike_cafe/models/Products/review_by_user_model.dart';
import 'package:bike_cafe/models/Products/review_like_by_user_model.dart';
import 'package:bike_cafe/models/Storage/address/availCityList.dart';
import 'package:bike_cafe/models/Storage/address/availableSt.dart';
import 'package:bike_cafe/models/Storage/address/get_addressby_add_id_model.dart';
import 'package:bike_cafe/models/Storage/address/getaddressmodel.dart';
import 'package:bike_cafe/models/Storage/address/postaddress.dart';
import 'package:bike_cafe/models/UserProfile/query_model.dart';
import 'package:bike_cafe/models/UserProfile/usermodel.dart';
import 'package:bike_cafe/models/UserProfile/userprofile.dart';
import 'package:bike_cafe/models/Vechile/delete_vehicle.dart';
import 'package:bike_cafe/models/Vechile/getbrand.dart';
import 'package:bike_cafe/models/Vechile/getmodel.dart';
import 'package:bike_cafe/models/Vechile/getvariant.dart';
import 'package:bike_cafe/models/Vechile/getvechiclebyuserid.dart';
import 'package:bike_cafe/models/Vechile/postVechicle.dart';
import 'package:bike_cafe/models/auth/forgot_password_model.dart';
import 'package:bike_cafe/models/auth/login_model.dart';
import 'package:bike_cafe/models/auth/logout_model.dart';
import 'package:bike_cafe/models/auth/otp_to_mobile_model.dart';
import 'package:bike_cafe/models/auth/signIn_model.dart';
import 'package:bike_cafe/models/auth/verify_otp_model.dart';
import 'package:bike_cafe/models/Vechile/vechileDetailsModel.dart';
import 'package:bike_cafe/screens/Dashboard/Address/address.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/Notifications/get_notification_model.dart';
import '../models/Order_Model/push_order_model.dart';
import '../models/auth/social_auth_model.dart';

class APIService {

  // String baseurl = "https://msilonline.in/";
  String baseurl = "http://3.109.69.39/";

  Map<String, String> defaultHeaderParams(String? token) =>
      {"Content-Type": "application/json", "Authorization": "Bearer $token"};

  Future<LoginResponseModel?> login(
      LoginRequestModel requestModel, String apiUrl0) async {
    try {

      log(requestModel.email.toString());
      log(requestModel.password.toString());
      log(requestModel.deviceToken.toString());
      log(requestModel.andriod_id.toString());
      log(requestModel.web_id.toString());

      log(requestModel.toJson().toString());


      final response = await http.post(Uri.parse(baseurl + apiUrl0),
          body: requestModel.toJson());
      if (response.statusCode == 200) {
        var data = LoginResponseModel.fromJson(json.decode(response.body));

        return data;
      } else if (response.statusCode == 500) {
        Get.snackbar(response.body.toString(), 'Internal server error',
            snackPosition: SnackPosition.TOP,
            duration: const Duration(seconds: 5),
            backgroundColor: Colors.white,
            colorText: Colors.red);
      } else {
        Get.snackbar('Failed..', 'The provided credentials do not match.',
            snackPosition: SnackPosition.TOP,
            duration: const Duration(seconds: 5),
            backgroundColor: Colors.white,
            colorText: Colors.red);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  //login using mobile number
  Future<LoginResponseModel?> loginUsingNumber({String? mobileNumber,
    String? password, String? deviceToken}) async {
    try {
      final response = await http.post(Uri.parse(baseurl + "logindevice"),
          body: {"phone_no" : mobileNumber.toString(),
            "password" : password.toString(),
            "login_type" : "phone_no",
            "device_token" : deviceToken
          },
      );
      if (response.statusCode == 200) {
        var data = LoginResponseModel.fromJson(json.decode(response.body));

        return data;
      } else if (response.statusCode == 500) {
        Get.snackbar(response.statusCode.toString(), 'Internal server error',
            snackPosition: SnackPosition.TOP,
            duration: const Duration(seconds: 5),
            backgroundColor: Colors.white,
            colorText: Colors.red);
      } else {
        Get.snackbar('Failed..', 'The provided credentials do not match.',
            snackPosition: SnackPosition.TOP,
            duration: const Duration(seconds: 5),
            backgroundColor: Colors.white,
            colorText: Colors.red);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<SignUpResponseModel?> signUp(
      {SignInRequestModel? requestModel1,
      String? apiUrl1,
      String? name,
      String? email,
      String? password,
      String? number,
      String? confrmpass}) async {
    final response = await http.post(Uri.parse(baseurl + apiUrl1!), body: {
      "name": name,
      "email": email,
      "phone_no": number,
      "password": password,
      "password_confirmation": confrmpass,
      "role": "customer",
    });
    // debugPrint(response.body);
    try {
      if (response.statusCode == 200) {
        // Get.to(() => SignIn());
        return SignUpResponseModel.fromMap(jsonDecode(response.body));
      } else {
        var failResponse = SignUpResponseModel.fromMap(jsonDecode(response.body));
        Get.snackbar(response.statusCode.toString(), failResponse.message.toString(),
            snackPosition: SnackPosition.TOP,
            duration: const Duration(seconds: 5),
            backgroundColor: Colors.white,
            colorText: Colors.red);
      }
    } catch (e) {
      debugPrint(e.toString());
      debugPrint(response.body.toString());
    }
  }

  Future<EditProfileResponseModel?> edituser({String? id, String? token, String? name, String? email,
      String? number}) async {
    try {
      var response = await http.post(
          Uri.parse(baseurl + "api/v1/accounts/user/$id/update"),
          headers: {
            // "Content-Type": "application/json",
            "Authorization": "Bearer $token"
          },
          body: {
            "name": name,
            "email": email,
            "phone_no": number,
          });
      // debugPrint(response.body);
      if (response.statusCode == 200) {
        return EditProfileResponseModel.fromMap(jsonDecode(response.body));
      } else if(response.statusCode == 400){
        var responseMessage = EditProfileResponseModel.fromMap(jsonDecode(response.body));
        Fluttertoast.showToast(msg: responseMessage.message.toString());
      }
      else {
        Get.snackbar('Failed', 'Failed to update user profile',
            snackPosition: SnackPosition.TOP,
            duration: const Duration(seconds: 5),
            backgroundColor: Colors.white,
            colorText: Colors.red);
      }
    } catch (e) {
      debugPrint("not success" + e.toString());
    }
  }

  Future<PostAddressResponseModel?> postaddress(
      {PostAddressModel? responsemodel,
      String? id,
      String? token,
      String? name,
      String? number,
      String? altnumber,
      String? address,
      String? landmark,
      String? city,
      String? pincode,
      String? isDefault}) async {
    try {
      http.Response response = await http.post(
          Uri.parse(baseurl + "api/v1/accounts/address/$id/store"),
          body: {
            "name": name,
            "phonenumber": number,
            "alt_phonenumber": altnumber,
            "address": address,
            "description": landmark,
            "city_id": city,
            "pincode": pincode,
            "lattitude": "55",
            "longitude": "66",
            "default_address": isDefault
          },
          headers: {
            // "Content-Type": "application/json",
            "Authorization": "Bearer $token"
          });
      // debugPrint(response.body);
      if (response.statusCode == 200) {
        Get.to(() => const AddressPage());
        return PostAddressResponseModel.fromMap(jsonDecode(response.body));
      } else if (response.statusCode == 400) {
        var msg = PostAddressResponseModel.fromMap(jsonDecode(response.body));
        Get.snackbar('Failed', msg.message.toString(),
            snackPosition: SnackPosition.TOP,
            duration: const Duration(seconds: 5),
            backgroundColor: Colors.white,
            colorText: Colors.red);
      } else {
        // throw Exception('Failed to load data!');
        Get.snackbar('failed', response.statusCode.toString(),
            snackPosition: SnackPosition.TOP,
            duration: const Duration(seconds: 5),
            backgroundColor: Colors.white,
            colorText: Colors.red);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<GetAddressResponseModel?> addressdata(
      {GetAddressResponseModel? responsemodel,
      String? id,
      String? token}) async {
    var modelmap;
    try {
      http.Response response = await http.get(
          Uri.parse(baseurl + "api/v1/accounts/addressbyuser/$id"),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token"
          });

      if (response.statusCode == 200 || response.statusCode == 400) {
        var address = response.body;
        var addressmap = json.decode(address);
        modelmap = GetAddressResponseModel.fromMap(addressmap);
      }
    } catch (e) {
      return modelmap;
    }
    return modelmap;
  }

  Future<LogoutModel> logout(
      {LogoutModel? responsemodel, String? token}) async {
    http.Response response = await http.post(Uri.parse(baseurl + "logoutdevice"), body: {"api_token": token});
    // debugPrint(response.body);
    if (response.statusCode == 200 || response.statusCode == 400) {
      return LogoutModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to Logout!');
    }
  }

  Future<Vechicletypemodel?> getuservechiletype(
      {String? token, Vechicletypemodel? responsemodel}) async {
    http.Response response = await http
        .get(Uri.parse(baseurl + "api/v1/vehicle/getvehicletype"), headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    });
    // debugPrint(response.body);
    try {
      if (response.statusCode == 200) {
        // Get.to(() => SignIn());

        return vechicletypemodelFromJson(response.body);
      } else {
        // Get.snackbar('Error occurred!', response.statusCode.toString(),
        //     snackPosition: SnackPosition.TOP,
        //     backgroundColor: const Color.fromRGBO(0,0,0,0.8),
        //     colorText: Colors.white);
        debugPrint(response.statusCode.toString());
        debugPrint(response.body.toString());
      }
    } catch (e) {
      // Get.snackbar('Error occured!', e.toString(),
      //     snackPosition: SnackPosition.BOTTOM,
      //     backgroundColor: kPrimaryColor,
      //     colorText: kBackgroundColor);
      debugPrint(e.toString());
    }
  }

  Future<VechiletypeBrand?> getuserbrandbyvechicletype(
      {String? token, VechiletypeBrand? responsemodel, String? vtypeid}) async {
    http.Response response = await http.get(
        Uri.parse(baseurl + "api/v1/vehicle/getbrand/" + vtypeid.toString()),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        });
    // debugPrint(response.body);
    try {
      if (response.statusCode == 200) {
        // Get.to(() => SignIn());

        return vechiletypeBrandFromJson(response.body);
      } else {
        // Get.snackbar('Error occured!', response.body,
        //     snackPosition: SnackPosition.TOP,
        //     backgroundColor: const Color.fromRGBO(0,0,0,0.8),
        //     colorText: Colors.white);
        debugPrint(response.statusCode.toString());
        debugPrint(response.body.toString());
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<VechileModelByBrandId?> getusermodelbybrandtype(
      {String? token,
      VechileModelByBrandId? responsemodel,
      String? brandid}) async {
    http.Response response = await http.get(
        Uri.parse(
            baseurl + "api/v1/vehicle/models/brand/" + brandid.toString()),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        });
    try {
      if (response.statusCode == 200) {
        // debugPrint(response.body);

        // Get.to(() => SignIn());

        return vechileModelByBrandIdFromJson(response.body);
      } else {
        // Get.snackbar('Error occurred!', response.body,
        //     snackPosition: SnackPosition.TOP,
        //     backgroundColor: const Color.fromRGBO(0,0,0,0.8),
        //     colorText: Colors.white);
        debugPrint(response.statusCode.toString());
        debugPrint(response.body.toString());
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<VechilevariantType?> getuservariantmodeltype(
      {String? token,
      VechilevariantType? responsemodel,
      String? modelid}) async {
    http.Response response = await http.get(
        Uri.parse(baseurl + "api/v1/vehicle/getvariants/" + modelid.toString()),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        });
    // debugPrint(response.body);
    try {
      if (response.statusCode == 200) {
        // Get.to(() => SignIn());
        // debugPrint(response.body);

        return vechilevariantTypeFromJson(response.body);
      } else {
        // Get.snackbar('Error occurred!', response.body,
        //     snackPosition: SnackPosition.TOP,
        //     backgroundColor: const Color.fromRGBO(0,0,0,0.8),
        //     colorText: Colors.white);
        debugPrint(response.statusCode.toString());
        debugPrint(response.body.toString());
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<PostVechileRequest?> postvechilebyuser(
      {PostVechileRequest? response,
      String? token,
      String? id,
      String? categoryid,
      String? brandid,
      String? modelid,
      String? variantid,
      String? vehicleNumber}) async {
    debugPrint("$categoryid");
    debugPrint("$brandid");
    debugPrint("$variantid");
    debugPrint("$modelid");
    // debugPrint("sucess");

    try {
      var response = await http.post(
          Uri.parse(baseurl + "api/v1/vehicle/registervehicle/$id"),
          headers: {
            // "Content-Type": "application/json",
            "Authorization": "Bearer $token"
          },
          body: {
            "category_id": categoryid.toString(),
            "brand_id": brandid.toString(),
            "variant_id": variantid.toString(),
            "veh_image_id": variantid.toString(),
            "model_id": modelid.toString(),
            "useveh_vehicle_number": vehicleNumber.toString(),
          });
      // debugPrint(response.body);
      if (response.statusCode == 200) {
        debugPrint("success");
        Fluttertoast.showToast(msg: "Vehicle added profile");
        return PostVechileRequest.fromJson(json.decode(response.body));
      }
      if (response.statusCode == 400) {
        debugPrint(response.statusCode.toString());
        debugPrint(response.body.toString());
        Fluttertoast.showToast(msg: "Failed to add vehicles");
        throw Exception('Failed to load data!');
      }
    } catch (e) {
      debugPrint("not success" + e.toString());
    }
  }

  //get category api request
  Future<GetCategories?> getCategoriesApi({String? token}) async {
    http.Response response = await http
        .get(Uri.parse(baseurl + "api/v1/products/getcategory"), headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    });
    try{
      if (response.statusCode == 200) {
        final categoryList = GetCategories.fromMap(jsonDecode(response.body));
        return categoryList;
      } else {
        // Get.snackbar('Error occurred!!!', response.statusCode.toString(),
        //     snackPosition: SnackPosition.TOP,
        //     backgroundColor: const Color.fromRGBO(0, 0, 0, 0.8),
        //     colorText: Colors.white);
        debugPrint(response.statusCode.toString());
        debugPrint(response.body.toString());
      }
    }catch(e){
      debugPrint(e.toString());
    }
  }

  Future<GetVechiclebyuserid?>? getvechiledetailsbyuserid({String? token, id}) async {
    http.Response response = await http.get(
        Uri.parse(baseurl + "api/v1/vehicle/getregisteredvehicle/$id"),
        headers: defaultHeaderParams(token));
    try{
      if (response.statusCode == 200) {
        return GetVechiclebyuserid.fromMap(jsonDecode(response.body));
      } else {
        debugPrint(response.statusCode.toString());
        debugPrint(response.body.toString());
      }
    }catch(e){
      debugPrint(e.toString());
    }

  }

  //get Products api request
  Future<GetProducts?> getProductsApi({String? token}) async {
    http.Response response = await http.get(Uri.parse(baseurl + "api/v1/products/getproductsall"),
        headers: defaultHeaderParams(token));
    try{
      if (response.statusCode == 200) {
        final productsList = GetProducts.fromMap(jsonDecode(response.body));
        return productsList;
      } else {
        debugPrint(response.statusCode.toString());
        debugPrint(response.body.toString());
      }
    }catch(e){
      debugPrint(e.toString());
    }
  }

  //get Products by product id api request
  Future<GetProducts?> getProductsByIdApi(
      {String? token, String? productId}) async {
    http.Response response = await http.get(
        Uri.parse(baseurl + "api/v1/products/getproductbypd/$productId"),
        headers: defaultHeaderParams(token));
    try{
      if (response.statusCode == 200) {
        final productsList = GetProducts.fromMap(jsonDecode(response.body));
        return productsList;
      } else {
        debugPrint(response.statusCode.toString());
        debugPrint(response.body.toString());
      }
    }catch(e){
      debugPrint(e.toString());
    }
  }

  //get Products related vehicles
  Future<GetProductRelatedVariant?> getProductsRelatedVehicles(
      {String? token, int? productId}) async {
    http.Response response = await http.get(
        Uri.parse(baseurl + "api/v1/vehicle/getvariantbyproductid/$productId"),
        headers: defaultHeaderParams(token));
    try{
      if (response.statusCode == 200) {
        final productsList = GetProductRelatedVariant.fromMap(jsonDecode(response.body));
        return productsList;
      } else {
        debugPrint(response.statusCode.toString());
        debugPrint(response.body.toString());
      }
    }catch(e){
      debugPrint(e.toString());
    }
  }

  //add product to cart
  Future<AddCartItem?> addItemToCart(
      {String? token, String? userId, int? productId}) async {
    var cartItem = jsonEncode(
        <String, dynamic>{'cart_product_id': productId, 'quantity': 1});

    try {
      http.Response response = await http.post(
          Uri.parse(baseurl + "additemtocart/$userId"),
          headers: defaultHeaderParams(token),
          body: cartItem);

      if (response.statusCode == 200) {
        final cartResponse = AddCartItem.fromMap(jsonDecode(response.body));
        return cartResponse;
      } else {
        debugPrint(response.statusCode.toString());
        debugPrint(response.body.toString());
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  //get Products related vehicles
  Future<CartItemList?> getCartItemList({String? token, String? userId}) async {
    try {
      http.Response response = await http
          .get(Uri.parse(baseurl + "getitemfromcart/$userId"),
          headers: defaultHeaderParams(token));
      if (response.statusCode == 200) {
        final cartList = CartItemList.fromMap(jsonDecode(response.body));
        return cartList;
      } else {
        debugPrint(response.statusCode.toString());
        debugPrint(response.body.toString());
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  //decrement cart item count
  Future<AddCartItem?> decrementCartItemCount(
      {String? token, String? userId, String? productId}) async {
    var cartItem = jsonEncode(<String, dynamic>{});

    try {
      http.Response response = await http.post(
          Uri.parse(baseurl + "decitemincart/$userId/$productId"),
          headers: defaultHeaderParams(token),
          body: cartItem);

      if (response.statusCode == 200) {
        final cartResponse = AddCartItem.fromMap(jsonDecode(response.body));
        return cartResponse;
      } else {
        debugPrint(response.statusCode.toString());
        debugPrint(response.body.toString());
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  //remove cart item
  Future<AddCartItem?> removeCartItem(
      {String? token, String? userId, String? productId}) async {
    var cartItem = jsonEncode(<String, dynamic>{});

    try {
      http.Response response = await http.post(
          Uri.parse(baseurl + "removeitemfromcart/$userId/$productId"),
          headers: defaultHeaderParams(token),
          body: cartItem);

      if (response.statusCode == 200) {
        final cartResponse = AddCartItem.fromMap(jsonDecode(response.body));
        return cartResponse;
      } else {
        debugPrint(response.statusCode.toString());
        debugPrint(response.body.toString());
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  //set default address api
  Future<SetDefaultAddress?> setDefaultAddress(
      {String? token, String? userId, String? addressId}) async {
    var cartItem = jsonEncode(<String, dynamic>{"default_address": '1'});
    try {
      http.Response response = await http.post(
          Uri.parse(baseurl +
              "api/v1/accounts/addressmakedefault/$userId/$addressId"),
          headers: defaultHeaderParams(token),
          body: cartItem);

      if (response.statusCode == 200) {
        final addResponse = SetDefaultAddress.fromMap(jsonDecode(response.body));
        return addResponse;
      } else {
        debugPrint(response.statusCode.toString());
        debugPrint(response.body.toString());
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<GetStatesList?> getAddressStates({String? token}) async {
    try {
      http.Response response = await http.get(
          Uri.parse(baseurl + "api/v1/accounts/getstate"),
          headers: defaultHeaderParams(token));
      if (response.statusCode == 200) {
        final statesList = GetStatesList.fromMap(jsonDecode(response.body));
        return statesList;
      } else {
        debugPrint(response.statusCode.toString());
        debugPrint(response.body.toString());
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<GetCitiesList?> getAddressCities(
      {String? token, String? stateId}) async {
    try {
      http.Response response = await http.get(
          Uri.parse(baseurl + "api/v1/accounts/getcity/$stateId"),
          headers: defaultHeaderParams(token));
      if (response.statusCode == 200) {
        final citiesList = GetCitiesList.fromMap(jsonDecode(response.body));
        return citiesList;
      } else {
        debugPrint(response.statusCode.toString());
        debugPrint(response.body.toString());
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  //get Products by product id api request
  Future<GetProducts?> getProductsByCatIdApi(
      {String? token, int? categoryId}) async {
    http.Response response = await http.get(
        Uri.parse(baseurl + "api/v1/products/getproductbycd/$categoryId"),
        headers: defaultHeaderParams(token));
    try{
      if (response.statusCode == 200) {
        final productsList = GetProducts.fromMap(jsonDecode(response.body));
        return productsList;
      } else {
        debugPrint(response.statusCode.toString());
        debugPrint(response.body.toString());
      }
    }catch(e){
      debugPrint(e.toString());
    }
  }

  //get Products by product id api request category and variant id
  Future<GetProductsByCatAndVarientIdModel?> getProductsByCatIdVariantIdApi(
      {String? token, String? categoryId, String? variantId}) async {
    http.Response response = await http.get(
        Uri.parse(baseurl + "api/v1/products/getproductbycatvarid/$categoryId/$variantId"),
        headers: defaultHeaderParams(token));
    try{
      if (response.statusCode == 200) {
        final productsList = GetProductsByCatAndVarientIdModel.fromMap(jsonDecode(response.body));
        return productsList;
      } else {
        debugPrint(response.statusCode.toString());
        debugPrint(response.body.toString());
      }
    }catch(e){
      debugPrint(e.toString());
    }
  }

  //delete vehicle using vehicle id
  Future<DeleteVehicleById?> deleteVehicleById(
      {String? token, String? userId, String? vehicleId}) async {
    try {
      http.Response response = await http.post(
          Uri.parse(baseurl + "api/v1/vehicle/deleteuservehicle/$userId/$vehicleId"),
          headers: defaultHeaderParams(token));

      if (response.statusCode == 200) {
        final deleteResponse = DeleteVehicleById.fromMap(jsonDecode(response.body));
        return deleteResponse;
      } else {
        debugPrint(response.statusCode.toString());
        debugPrint(response.body.toString());
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  //get checkout details
  Future<CartCheckoutModel?> cartCheckoutApi(
      {String? token, String? userId}) async {
    http.Response response = await http.get(
        Uri.parse(baseurl + "api/v1/shopping/checkoutcalcualtioncheck/$userId"),
        headers: defaultHeaderParams(token));
    try {
      if (response.statusCode == 200) {
        final checkout = CartCheckoutModel.fromMap(jsonDecode(response.body));
        return checkout;
      } else {
        debugPrint(response.statusCode.toString());
        debugPrint(response.body.toString());
      }
    } catch (e) {
      debugPrint(e.toString());
      // debugPrint("body" + response.body.toString());
    }
  }

  Future applycuponpost(
      {String? token, userId,cuponid}) async {
    http.Response response = await http.post(
        Uri.parse(baseurl + "api/v1/shopping/applycoupon/$userId"),
        body:jsonEncode( {
          "couponid":"$cuponid"
        }),
        headers: defaultHeaderParams(token));
    log(response.statusCode.toString());
    try {
      if (response.statusCode == 200) {
        final checkout = cartCheckoutApi(token: token,userId: userId);
        return checkout;
      } else {
        debugPrint(response.statusCode.toString());
        debugPrint(response.body.toString());
      }
    } catch (e) {
      debugPrint(e.toString());
      // debugPrint("body" + response.body.toString());
    }
  }


  Future cancelcupon(
      {String? token, userId}) async {
    http.Response response = await http.post(
        Uri.parse(baseurl + "api/v1/shopping/cancelcoupon/$userId"),

        headers: defaultHeaderParams(token));
    try {
      if (response.statusCode == 200) {
        final checkout = cartCheckoutApi(token: token,userId: userId);
        return checkout;
      } else {
        debugPrint(response.statusCode.toString());
        debugPrint(response.body.toString());
      }
    } catch (e) {
      debugPrint(e.toString());
      // debugPrint("body" + response.body.toString());
    }
  }

  //check wishlist products
  Future<CheckWishlisted?> checkWishlist(
      {String? token, String? userId, String? productId}) async {
    try {
      http.Response response = await http.get(
          Uri.parse(baseurl + "checkproductinwishlist/$userId/$productId"),
          headers: defaultHeaderParams(token));
      if (response.statusCode == 200) {
        final checkWishlist =
            CheckWishlisted.fromMap(jsonDecode(response.body));
        return checkWishlist;
      } else {
        debugPrint(response.statusCode.toString());
        debugPrint(response.body.toString());
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  //add to wishlist api
  Future<AddToWishlist?> addToWishlistApi(
      {String? token, String? userId, String? productId}) async {
    var addWishlist = jsonEncode(<String, dynamic>{"product_id": "$productId"});
    try {
      http.Response response = await http.post(
          Uri.parse(baseurl + "additemtowishlist/$userId"),
          headers: defaultHeaderParams(token),
          body: addWishlist);

      if (response.statusCode == 200) {
        final wishlistResponse =
            AddToWishlist.fromMap(jsonDecode(response.body));
        return wishlistResponse;
      } else {
        debugPrint(response.statusCode.toString());
        debugPrint(response.body.toString());
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  //get wishlist products
  Future<GetWishlistsProduct?> getWishlistProducts(
      {String? token, String? userId}) async {
    try {
      http.Response response = await http.get(
          Uri.parse(baseurl + "getfromwishlist/$userId"),
          headers: defaultHeaderParams(token));
      if (response.statusCode == 200) {
        final wishlistProducts =
            GetWishlistsProduct.fromMap(jsonDecode(response.body));
        return wishlistProducts;
      } else {
        debugPrint(response.statusCode.toString());
        debugPrint(response.body.toString());
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  //get user Address by user Id
  Future<GetAddressbyAddId?> addressDataByAddId(
      {String? token, String? userId, String? addressId}) async {
    try {
      http.Response response = await http.get(
          Uri.parse(baseurl + "api/v1/accounts/address/$userId/$addressId"),
          headers: defaultHeaderParams(token));
      if (response.statusCode == 200) {
        final addressData =
            GetAddressbyAddId.fromMap(jsonDecode(response.body));
        return addressData;
      } else {
        debugPrint(response.statusCode.toString());
        debugPrint(response.body.toString());
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  //Edit user address using userId
  Future<PostAddressModel?> editUserAddressApi(
      {String? token,
      String? userId,
      String? addressId,
      String? name,
      String? number,
      String? altnumber,
      String? addressdata,
      String? landmark,
      String? city,
      String? pincode,
      String? isDefault}) async {
    var address = jsonEncode(<String, dynamic>{
      "name": name,
      "phonenumber": number,
      "alt_phonenumber": altnumber,
      "address": addressdata,
      "description": landmark,
      "city_id": city,
      "pincode": pincode,
      "lattitude": "55",
      "longitude": "66",
      "default_address": isDefault
    });

    try {
      http.Response response = await http.post(
          Uri.parse(baseurl + "api/v1/accounts/editaddress/$userId/$addressId"),
          headers: defaultHeaderParams(token),
          body: address);

      if (response.statusCode == 200) {
        final addResponse = PostAddressModel.fromJson(jsonDecode(response.body));
        return addResponse;
      } else {
        debugPrint(response.statusCode.toString());
        debugPrint(response.body.toString());
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  //upload user vehicle image
  Future vehicleImageUploadApi(
      {String? token, String? userId, String? vehicleId, File? img}) async {
    try {
      var stream = http.ByteStream(img!.openRead());
      stream.cast();
      var len = await img.length();
      var uri = Uri.parse(
          baseurl + "api/v1/vehicle/uploaduservehicleimage/$userId/$vehicleId");
      var request = http.MultipartRequest("POST", uri);

      request.fields['uvi_description'] = 'vehicle';
      var multipartData = http.MultipartFile('uvi_images_path', stream, len,
          filename: img.path.toString());
      request.files.add(multipartData);
      // request.headers["Content-Type"] = "multipart/form-data";
      request.headers["Authorization"] = "Bearer $token";

      var response = await request.send();

      if (response.statusCode == 200) {
        debugPrint('image uploaded successfully');
        Fluttertoast.showToast(msg: 'Vehicle image updated');
      } else {
        Fluttertoast.showToast(msg: 'Failed to update vehicle image');
        debugPrint('failed....');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  //upload user profile image
  Future uploadProfilePhotoApi(
      {String? token, String? userId, File? img}) async {
    try {
      var stream = http.ByteStream(img!.openRead());
      stream.cast();
      var len = await img.length();
      var uri = Uri.parse(baseurl + "api/v1/accounts/uploaduserimage/$userId");
      var request = http.MultipartRequest("POST", uri);

      var multipartData = http.MultipartFile(
          'profile_photo_path', stream, len,
          filename: img.path.toString());
      request.files.add(multipartData);
      // request.headers["Content-Type"] = "multipart/form-data";
      request.headers["Authorization"] = "Bearer $token";

      var response = await request.send();

      if (response.statusCode == 200) {
        debugPrint('image uploaded successfully');
        Fluttertoast.showToast(msg: 'Profile photo updated');
      } else {
        Fluttertoast.showToast(msg: 'Failed to update profile photo');
        debugPrint('failed....');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // get user profile data
  //get user Address by user Id
  Future<GetUserProfileData?> getUserProfileApi(
      {String? token, String? userId}) async {
    try {
      http.Response response = await http.get(
          Uri.parse(baseurl + "api/v1/accounts/user/$userId"),
          headers: defaultHeaderParams(token));
      if (response.statusCode == 200) {
        final userData = GetUserProfileData.fromMap(jsonDecode(response.body));
        return userData;
      } else {
        debugPrint(response.statusCode.toString());
        debugPrint(response.body.toString());
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  //get user vehicle by vehicle id
  Future<GetVechiclebyuserid?>? getVehicleDetailsByUseridVehicleId(
      {String? token, String? userId, String? vehicleId}) async {
    http.Response response = await http.get(
        Uri.parse(baseurl +
            "api/v1/vehicle/getregisteredvehiclebyregid/$userId/$vehicleId"),
        headers: defaultHeaderParams(token));
    try {
      if (response.statusCode == 200) {
        var vehicleResponse = GetVechiclebyuserid.fromMap(jsonDecode(response.body));
        return vehicleResponse;
      } else {
        debugPrint(response.statusCode.toString());
        debugPrint(response.body.toString());
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  //main page banners
  Future<GetBanners?> getMainPageBanners({String? token}) async {
    try {
      http.Response response = await http.get(
          Uri.parse(baseurl + "api/v1/shopping/getbanners"),
          headers: defaultHeaderParams(token));
      if (response.statusCode == 200) {
        final bannerData = GetBanners.fromMap(jsonDecode(response.body));
        return bannerData;
      } else {
        debugPrint(response.statusCode.toString());
        debugPrint(response.body.toString());
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  //set default address api
  Future<VerifyOtpModel?> verifyUserByOtpApi(
      {String? userId, String? userOtp}) async {
    var otp = jsonEncode(<String, dynamic>{"otp": userOtp});
    try {
      http.Response response = await http.post(
          Uri.parse(baseurl + "api/v1/accounts/verifyotp/$userId/Register"),
          headers: {"Content-Type": "application/json"},
          body: otp);

      if (response.statusCode == 200) {
        final otpResponse = VerifyOtpModel.fromMap(jsonDecode(response.body));
        return otpResponse;
      } else {
        debugPrint(response.statusCode.toString());
        debugPrint(response.body.toString());
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  //cod payment order api
  Future<OrderResponseModel?> codPaymentOrderApi(
      {String? token, String? userId}) async {
    var paymentMethod = jsonEncode(<String, dynamic>{"payment": 1});
    try {
      http.Response response = await http.post(
          Uri.parse(baseurl + "api/v1/shopping/paymentmethod/$userId"),
          headers: defaultHeaderParams(token),
          body: paymentMethod);

      if (response.statusCode == 200) {
        final orderResponse =
            OrderResponseModel.fromMap(jsonDecode(response.body));
        return orderResponse;
      } else {
        debugPrint("response.body.toString()");
        debugPrint(response.statusCode.toString());
        debugPrint(response.body.toString());
        debugPrint("response.body.toString()");
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  //forgot password otp api
  Future<ForgotPasswordResponseModel?> forgotPasswordOtpApi(
      {String? phoneNumber}) async {
    var phone = jsonEncode(
        <String, dynamic>{ "phonenumber": phoneNumber});
    try {
      http.Response response = await http.post(
          Uri.parse(baseurl + "api/v1/accounts/forgetpasswordotp"),
          headers: {"Content-Type": "application/json"},
          body: phone
      );

      if (response.statusCode == 200) {
        final otpResponse = ForgotPasswordResponseModel.fromMap(jsonDecode(response.body));
        return otpResponse;
      } else {
        debugPrint(response.statusCode.toString());
        debugPrint(response.body.toString());
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  //forgot password reset api
  Future<ForgotPasswordResponseModel?> resetPasswordApi(
      {String? userId,String? password}) async {
    var passwordText = jsonEncode(
        <String, dynamic>{ "password": password});
    try {
      http.Response response = await http.post(
          Uri.parse(baseurl + "api/v1/accounts/forgetpassword/$userId"),
          headers: {"Content-Type": "application/json"},
          body: passwordText
      );

      if (response.statusCode == 200) {
        final passwordResponse = ForgotPasswordResponseModel.fromMap(jsonDecode(response.body));
        return passwordResponse;
      } else {
        debugPrint(response.statusCode.toString());
        debugPrint(response.body.toString());
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  //edit users existing vehicle
  Future<EditVehicleResponseModel?> editVehicleByUserVehicleIdApi({
    String? token,
    String? userId,
    String? vehicleId,
    String? vehicleTypeId,
    String? brandId,
    String? modelId,
    String? variantId,
    String? vehicleNumber
  }) async {
    try {
      var response = await http.post(
          Uri.parse(baseurl + "api/v1/vehicle/editregisteredvehicle/$userId/$vehicleId"),
          headers: {
            "Authorization": "Bearer $token"
          },
          body: {
            "vehicle_type_id": vehicleTypeId,
            "brand_id": brandId,
            "model_id": modelId,
            "variant_id": variantId,
            "useveh_vehicle_number": vehicleNumber.toString(),
          });
      // debugPrint(response.body);
      if (response.statusCode == 200) {
        // Get.snackbar('Success', 'Vehicle edit successfully',
        //     snackPosition: SnackPosition.TOP,
        //     backgroundColor: const Color.fromRGBO(0,0,0,0.8),
        //     colorText: Colors.white);
        Fluttertoast.showToast(msg: "Vehicle edit successfully");
        var editVehicleResponse = EditVehicleResponseModel.fromMap(jsonDecode(response.body));
        return editVehicleResponse;
      }else{
        debugPrint(response.statusCode.toString());
        debugPrint(response.body.toString());
        Fluttertoast.showToast(msg: "Failed to edit vehicle details");
        debugPrint("vehicle edit failed" + response.statusCode.toString());
      }
    } catch (e) {
      debugPrint("failed" + e.toString());
    }
  }

  //online payment order api
  Future<OnlinePaymentInitiateModel?> onlinePaymentInitiateApi(
      {String? token, String? userId}) async {
    var paymentMethod = jsonEncode(
        <String, dynamic>{ "payment": 2});
    http.Response response = await http.post(
        Uri.parse(baseurl + "api/v1/shopping/paymentmethodonline/$userId"),
        headers: defaultHeaderParams(token),
        body: paymentMethod
    );
    try {
      if (response.statusCode == 200) {
        final paymentResponse = OnlinePaymentInitiateModel.fromMap(jsonDecode(response.body));
        return paymentResponse;
      } else {
        debugPrint(response.statusCode.toString());
        debugPrint(response.body.toString());
      }
    } catch (e) {
      debugPrint(e.toString());
      debugPrint(response.body.toString());
    }
  }

  //online payment verify api
  Future<VerifyOnlinePaymentModel?> onlinePaymentVerifyApi(
      {String? token, String? userId,
        String? goTransactionId,
        String? orderId,
        String? paymentTransactionId,
        String? paymentStatus
      }) async {
    var paymentDetails = jsonEncode(
        <String, dynamic>{
          "payment": "2",
          "GologixTranctionid" : goTransactionId.toString(),
          "orderid" : orderId.toString(),
          "GatewayTransctionid" : paymentTransactionId.toString(),
          "paymentstatus" : paymentStatus.toString()
        });
    try {
      http.Response response = await http.post(
          Uri.parse(baseurl + "api/v1/shopping/checkTransction/$userId"),
          headers: defaultHeaderParams(token),
          body: paymentDetails
      );

      if (response.statusCode == 200) {
        final paymentVerifyResponse = VerifyOnlinePaymentModel.fromMap(jsonDecode(response.body));
        return paymentVerifyResponse;
      } else {
        debugPrint(response.statusCode.toString());
        debugPrint(response.body.toString());
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  //get products by banners
  Future<GetProductsByBannerModel?> getProductsByBanners({String? token, String? bannerId}) async {
    try {
      http.Response response = await http.get(
          Uri.parse(baseurl + "api/v1/shopping/getproductsbybanner/$bannerId"),
          headers: defaultHeaderParams(token));
      if (response.statusCode == 200) {
        final bannerData = GetProductsByBannerModel.fromMap(jsonDecode(response.body));
        return bannerData;
      } else {
        debugPrint(response.statusCode.toString());
        debugPrint(response.body.toString());
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  //Get user orders list
  Future<GetUserOrdersByIdModel?> getUserOrdersList(
      {String? token, String? userId}) async {
    http.Response response = await http.get(
        Uri.parse(baseurl + "api/v1/shopping/getorder/$userId"),
        headers: defaultHeaderParams(token));
    try {
      if (response.statusCode == 200) {
        final orderData = GetUserOrdersByIdModel.fromMap(jsonDecode(response.body));
        // debugPrint(response.body);
        return orderData;
      } else {
        debugPrint(response.statusCode.toString());
        debugPrint(response.body.toString());
      }
    } catch (e) {
      debugPrint("exception : "+ e.toString());
      debugPrint(response.body);
    }
  }

  //Get user orders details
  Future<GetOrdersDetails?> getUserOrdersDetails(
      {String? token, userId, orderId}) async {
    http.Response response = await http.get(
        Uri.parse(baseurl + "api/v1/shopping/getproductorder/$userId/$orderId"),
        headers: defaultHeaderParams(token));
    try {
      if (response.statusCode == 200) {
        final orderData = GetOrdersDetails.fromMap(jsonDecode(response.body));
        return orderData;
      } else {
        debugPrint(response.statusCode.toString());
        debugPrint(response.body.toString());
      }
    } catch (e) {
      debugPrint("exception : "+ e.toString());
      debugPrint(response.body);
    }
  }

  //send otp to verify mobile number api while register
  Future<OtpRequestToMobileModel?> OtpToMobileNumberVerify({String? phoneNumber}) async {
    var phone = jsonEncode(<String, dynamic>{ "phonenumber": phoneNumber});
    try {
      http.Response response = await http.post(
          Uri.parse(baseurl + "api/v1/accounts/usernumber/Register"),
          headers: {"Content-Type": "application/json"},
          body: phone
      );

      if (response.statusCode == 200) {
        final otpResponse = OtpRequestToMobileModel.fromMap(jsonDecode(response.body));
        return otpResponse;
      } else {
        debugPrint(response.statusCode.toString());
        debugPrint(response.body.toString());
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  //verify otp while register
  Future<OtpVerifyByMobileModel?> verifyUserByOtpToRegisterApi(
      {String? otpId, String? userOtp}) async {
    var otp = jsonEncode(<String, dynamic>{"otp": userOtp});
    try {
      http.Response response = await http.post(
          Uri.parse(baseurl + "api/v1/accounts/verifyotpreg/$otpId/Register"),
          headers: {"Content-Type": "application/json"},
          body: otp);

      if (response.statusCode == 200) {
        final verifyResponse = OtpVerifyByMobileModel.fromMap(jsonDecode(response.body));
        return verifyResponse;
      } else {
        debugPrint(response.statusCode.toString());
        debugPrint(response.body.toString());
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  //get related products
  Future<GetProducts?> getRelatedProducts(
      {String? token, String? productId}) async {
    var product = jsonEncode(<String, dynamic>{"product_id": productId.toString()});
    try {
      http.Response response = await http.post(
          Uri.parse(baseurl + "api/v1/shopping/relateproduct"),
          headers: defaultHeaderParams(token),
          body: product);

      if (response.statusCode == 200) {
        final productResponse = GetProducts.fromMap(jsonDecode(response.body));
        return productResponse;
      } else {
        debugPrint(response.statusCode.toString());
        debugPrint(response.body.toString());
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  //get related products
  Future<GetProducts?> searchProducts(
      {String? token, String? searchString}) async {
    var searchText = jsonEncode(<String, dynamic>{"term": searchString.toString()});
    try {
      http.Response response = await http.post(
          Uri.parse(baseurl + "api/v1/shopping/relateproductbyname"),
          headers: defaultHeaderParams(token),
          body: searchText);

      if (response.statusCode == 200) {
        final productResponse = GetProducts.fromMap(jsonDecode(response.body));
        return productResponse;
      } else {
        debugPrint(response.statusCode.toString());
        debugPrint(response.body.toString());
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }


   //get related products
  Future<GetCuponProductModel?> getcuponprodut(
      {String? token}) async {
   
    try {
      http.Response response = await http.get(
          Uri.parse(baseurl + "api/v1/shopping/getCoupons"),
          headers: defaultHeaderParams(token),
          );

      if (response.statusCode == 200) {
        final productResponse = GetCuponProductModel.fromMap(jsonDecode(response.body));
        return productResponse;
      } else {
        debugPrint(response.statusCode.toString());
        debugPrint(response.body.toString());
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  //product rating and reviews
  Future<GetProductReviewAndRatingModel?> productRatingAndReview(
      {String? token, String? productId}) async {
    http.Response response = await http.get(
        Uri.parse(baseurl + "api/v1/products/productoverview/$productId"),
        headers: defaultHeaderParams(token));
    try {
      if (response.statusCode == 200) {
        final reviewData = GetProductReviewAndRatingModel.fromMap(jsonDecode(response.body));
        return reviewData;
      } else {
        debugPrint(response.statusCode.toString());
        debugPrint(response.body.toString());
      }
    } catch (e) {
      debugPrint("exception : "+ e.toString());
      debugPrint(response.body);
    }
  }

  //to send query
  Future<SendQueryModel?> sendQueryApi({
    String? queryType, serviceOrOrderId, emailId, mobileNumber, queryText}) async {
    var queryInputs = jsonEncode(<String, dynamic>{
      "queryrelated": queryType.toString(),
      "orderid" : serviceOrOrderId.toString(),
      "email" : emailId.toString(),
      "phonenumber" : mobileNumber.toString(),
      "Querydetails" : queryText.toString()
    });
    try {
      http.Response response = await http.post(
          Uri.parse(baseurl + "api/v1/accounts/sendmail"),
          headers: {"Content-Type": "application/json"},
          body: queryInputs);

      if (response.statusCode == 200) {
        final queryResponse = SendQueryModel.fromMap(jsonDecode(response.body));
        return queryResponse;
      } else {
        debugPrint(response.statusCode.toString());
        debugPrint(response.body.toString());
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  //get user review for products
  Future<GetUsersProductReview?> getUsersReviewProduct(
      {String? token, userId, productId}) async {
    try {
      http.Response response = await http.get(
          Uri.parse(baseurl + "api/v1/products/getproductreview/$userId/$productId"),
          headers: defaultHeaderParams(token));
      if (response.statusCode == 200) {
        final reviewData =
        GetUsersProductReview.fromMap(jsonDecode(response.body));
        return reviewData;
      } else {
        debugPrint(response.statusCode.toString());
        debugPrint(response.body.toString());
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  //user review for product api
  Future<ProductReviewByUserModel?> userReviewForProductApi(
      {String? token, userId, orderId, productId, proRating, proReview}) async {
    var userReview = jsonEncode(<String, dynamic>{
      "prorev_review": proReview.toString(),
      "prorev_rate" : proRating.toString(),
      "order_id" : orderId.toString(),
    });

    http.Response response = await http.post(
        Uri.parse(baseurl + "api/v1/products/productreviewfromuser/$userId/$productId"),
        headers: defaultHeaderParams(token),
        body: userReview);

    try {
      if (response.statusCode == 200) {
        final reviewResponse = ProductReviewByUserModel.fromMap(jsonDecode(response.body));
        return reviewResponse;
      } else {
        debugPrint(response.statusCode.toString());
        debugPrint(response.body.toString());
      }
    } catch (e) {
      debugPrint(e.toString());
      debugPrint(response.body.toString());
    }
  }

  //update user review for product api
  Future<ProductReviewByUserModel?> updateUserReviewForProductApi(
      {String? token, userId, orderId, productId, reviewId, proRating, proReview}) async {
    var userReview = jsonEncode(<String, dynamic>{
      "prorev_review": proReview.toString(),
      "prorev_rate" : proRating.toString(),
      "order_id" : orderId.toString(),
    });

    http.Response response = await http.post(
        Uri.parse(baseurl + "api/v1/products/updateproductreview/$userId/$productId/$reviewId"),
        headers: defaultHeaderParams(token),
        body: userReview);

    try {
      if (response.statusCode == 200) {
        final reviewResponse = ProductReviewByUserModel.fromMap(jsonDecode(response.body));
        return reviewResponse;
      } else {
        debugPrint(response.statusCode.toString());
        debugPrint(response.body.toString());
      }
    } catch (e) {
      debugPrint(e.toString());
      debugPrint(response.body.toString());
    }
  }

  //add product review images
  Future addReviewImagesApi(
      {String? token, String? reviewId, File? img}) async {
    try {
      var stream = http.ByteStream(img!.openRead());
      stream.cast();
      var len = await img.length();
      var uri = Uri.parse(baseurl + "api/v1/products/uploadproductreviewimage/$reviewId");
      var request = http.MultipartRequest("POST", uri);

      var multipartData = http.MultipartFile(
          'prorev_product_img', stream, len, filename: img.path.toString());
      request.files.add(multipartData);
      request.headers["Authorization"] = "Bearer $token";

      var response = await request.send();

      if (response.statusCode == 200) {
        debugPrint('image uploaded successfully');
        // Fluttertoast.showToast(msg: 'Profile photo updated');
      } else {
        // Fluttertoast.showToast(msg: 'Failed to update profile photo');
        debugPrint('failed....'+response.statusCode.toString());
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  //get user liked / unliked review of products
  Future<ReviewsLikesDislikesModel?> getUsersReviewLikes(
      {String? token, userId, productReviewId}) async {
    try {
      http.Response response = await http.get(
          Uri.parse(baseurl + "api/v1/products/checklikeordislike/$userId/$productReviewId"),
          headers: defaultHeaderParams(token));
      if (response.statusCode == 200) {
        final reviewLikes = ReviewsLikesDislikesModel.fromMap(jsonDecode(response.body));
        return reviewLikes;
      } else {
        debugPrint(response.statusCode.toString());
        debugPrint(response.body.toString());
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  //like and dislike user reviews api
  Future<ProductReviewByUserModel?> likeAndDislikeUserReviewApi(
      {String? token, userId, reviewId, like, dislike}) async {
    var likeReview = jsonEncode(<String, dynamic>{
      "like": like.toString(),
      "dislike" : dislike.toString(),
      "userid" : userId.toString()
    });

    http.Response response = await http.post(
        Uri.parse(baseurl + "api/v1/products/reviewlikeordislike/$reviewId"),
        headers: defaultHeaderParams(token),
        body: likeReview);

    try {
      if (response.statusCode == 200) {
        final reviewResponse = ProductReviewByUserModel.fromMap(jsonDecode(response.body));
        return reviewResponse;
      } else {
        debugPrint(response.statusCode.toString());
        debugPrint(response.body.toString());
      }
    } catch (e) {
      debugPrint(e.toString());
      debugPrint(response.body.toString());
    }
  }

  //social auth check api to check user is exist or new user
  Future<SocialAuthCheckUserModel?> checkSocialAuthUserApi(
      {String? email}) async {
    var check = jsonEncode(<String, dynamic>{"email": email});
    http.Response response = await http.post(
        Uri.parse(baseurl + "api/v1/accounts/mailcheck"),
        headers: {"Content-Type": "application/json"},
        body: check);

    try {
      if (response.statusCode == 200) {
        final checkResponse = SocialAuthCheckUserModel.fromMap(jsonDecode(response.body));
        return checkResponse;
      } else {
        debugPrint(response.statusCode.toString());
        debugPrint(response.body.toString());
      }
    } catch (e) {
      debugPrint(e.toString());
      debugPrint(response.body.toString());
    }
  }

  //social auth check api to check user is exist or new user
  Future<SocialAuthModel?> socialAuthUserApi(
      {String? email, userName, deviceToken, mailIdToken, authType, phoneNumber, androidId}) async {
    var authData = jsonEncode(<String, dynamic>{
      "email": email.toString(),
      "name" : userName.toString(),
      "device_token": deviceToken.toString(),
      "token": mailIdToken.toString(),
      "typeid": authType.toString(),
      "phonenumber": phoneNumber,
      "web_id" : "",
      "android_id" : androidId.toString()
    });
    http.Response response = await http.post(
        Uri.parse(baseurl + "api/v1/accounts/login/google/callback"),
        headers: {"Content-Type": "application/json"},
        body: authData);

    try {
      if (response.statusCode == 200) {
        final socialAuthResponse = SocialAuthModel.fromMap(jsonDecode(response.body));
        return socialAuthResponse;
      } else {
        debugPrint(response.statusCode.toString());
        debugPrint(response.body.toString());
      }
    } catch (e) {
      debugPrint(e.toString());
      debugPrint(response.body.toString());
    }
  }

  //push order api
  Future<PushOrderModel?> pushOrderApi(
      {String? token, orderId}) async {
    try {
      http.Response response = await http.get(
          Uri.parse(baseurl + "api/v1/shopping/pushorder/$orderId"),
          headers: defaultHeaderParams(token));
      if (response.statusCode == 200) {
        final responseData = PushOrderModel.fromJson(jsonDecode(response.body));
        return responseData;
      } else {
        debugPrint(response.statusCode.toString());
        debugPrint(response.body.toString());
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  //send shipment id to db
  Future<ShipmentIdModel?> storeShipmentIdApi(
      {String? token, orderId, shipmentId}) async {
    var shipmentData = jsonEncode(<String, dynamic>{"shipmentid": shipmentId});
    http.Response response = await http.post(
        Uri.parse(baseurl + "api/v1/shopping/storeshipmentid/$orderId"),
        headers: defaultHeaderParams(token),
        body: shipmentData);

    try {
      if (response.statusCode == 200) {
        final responseData = ShipmentIdModel.fromJson(jsonDecode(response.body));
        return responseData;
      } else {
        debugPrint(response.statusCode.toString());
        debugPrint(response.body.toString());
      }
    } catch (e) {
      debugPrint(e.toString());
      debugPrint(response.body.toString());
    }
    return null;
  }

  //get notifications api
  Future<GetNotificationModel?> getNotificationApi(
      {String? token, userId}) async {
    try {
      http.Response response = await http.get(
          Uri.parse(baseurl + "api/v1/accounts/getnotifications/$userId"),
          headers: defaultHeaderParams(token));
      if (response.statusCode == 200) {
        final responseData = GetNotificationModel.fromMap(jsonDecode(response.body));
        return responseData;
      } else {
        // debugPrint(response.statusCode.toString());
        debugPrint(response.body.toString());
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  //update device token
  Future updateDeviceTokenApi(
      {String? userId, deviceToken, androidId}) async {
    http.Response response = await http.post(
        Uri.parse(baseurl + "api/v1/accounts/updatedevicetoken/$userId"),
        body:jsonEncode( {
          "android_id": androidId.toString(),
          "device_token" : deviceToken.toString()
        }),
        headers: {"Content-Type": "application/json"});

    try {
      if (response.statusCode == 200) {
        log(response.statusCode.toString()+" token upadated");
      } else {
        debugPrint(response.statusCode.toString());
        debugPrint(response.body.toString());
      }
    } catch (e) {
      debugPrint(e.toString());
      // debugPrint("body" + response.body.toString());
    }
  }

}
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:bike_cafe/models/Order_Model/users_product_review_model.dart';
import 'package:bike_cafe/screens/Dashboard/profile/locale/gallery_widget.dart';
import 'package:bike_cafe/services/api.dart';
import 'package:bike_cafe/widget/config.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class RatingAndReview extends StatefulWidget {
  RatingAndReview({Key? key, this.token, this.userId,this.orderId, this.productId}) : super(key: key);

  String? token, userId, orderId, productId;

  @override
  _RatingAndReviewState createState() => _RatingAndReviewState();
}

class _RatingAndReviewState extends State<RatingAndReview> {
  APIService service = APIService();
  TextEditingController reviewTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<GetUsersProductReview?>(
      future: service.getUsersReviewProduct(token: widget.token.toString(),
          userId: widget.userId.toString(),
          productId: widget.productId.toString()),
      builder: (context, snapshot){
        if(snapshot.hasData){
          if(snapshot.data!.reviews.isNotEmpty){
            return ratingAndReviewWidget(snapshot);
          }else{
            // return ratingAndReviewWidget(snapshot, false);
            return ratingAndReviewWidgetBefore();
          }
        }else{
          return Container();
        }
      },
    );
  }

  // review widget, if review for product is already given
  Widget ratingAndReviewWidget(AsyncSnapshot<GetUsersProductReview?> snapshot) {
    var reviewData = snapshot.data!.reviews[0];
    return Card(
      margin: EdgeInsets.zero,
      child: Container(
        margin: const EdgeInsets.all(6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Rate this product"),
                      const SizedBox(height: 4),
                      reviewData.prorevRate == null
                          ? giveRate(0,reviewData.reviewid)
                          : giveRate(reviewData.prorevRate,reviewData.reviewid),
                    ],
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    service.updateUserReviewForProductApi(
                      token: widget.token.toString(), userId: widget.userId.toString(),
                      orderId: widget.orderId.toString(),
                      productId: widget.productId.toString(),
                      reviewId: reviewData.reviewid.toString(),
                      proRating: reviewData.prorevRate.toString(),
                      proReview: reviewTextController.text.toString(),
                    ).then((value) {
                      if(value?.success == "1") {
                        setState(() {});
                      }
                    });
                  },
                  child: const Text('Publish'),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(kPrimaryColor),
                  ),
                ),
              ],
            ),
            writeReview(reviewData.prorevReview.toString()),
            const SizedBox(height: 4),
            reviewImagesWidget(reviewData.prorevProductImg, reviewData.reviewid.toString())
          ],
        ),
      ),
    );
  }

  //review widget, if review not given to this product
  Widget ratingAndReviewWidgetBefore() {
    return Card(
      margin: EdgeInsets.zero,
      child: Container(
        margin: const EdgeInsets.all(6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Rate this product"),
                      const SizedBox(height: 4),
                      Row(
                        //mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (var i = 1; i <= 5; i++)
                            InkWell(
                              onTap: () {
                                service.userReviewForProductApi(
                                  token: widget.token.toString(), userId: widget.userId.toString(),
                                  orderId: widget.orderId.toString(),
                                  productId: widget.productId.toString(),
                                  proRating: i.toString(),
                                  proReview: "",
                                ).then((value) {
                                  if(value?.success == "1") {
                                    setState(() {});
                                  }
                                });
                              },
                              child: i > 0
                                  ? const Icon(Icons.star_outline_outlined)
                                  : const Icon(Icons.star, color: Color.fromRGBO(251, 188, 4, 1)),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    service.userReviewForProductApi(
                      token: widget.token.toString(), userId: widget.userId.toString(),
                      orderId: widget.orderId.toString(),
                      productId: widget.productId.toString(),
                      proRating: 0.toString(),
                      proReview: reviewTextController.text.toString(),
                    ).then((value) {
                      if(value?.success == "1") {
                        setState(() {});
                      }
                    });
                  },
                  child: const Text('Publish'),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(kPrimaryColor),
                  ),
                ),
              ],
            ),
            writeReview(""),
            TextButton(
              onPressed: (){
                Fluttertoast.showToast(msg: "Give rating and review");
              },
              child: const Text("+ Add images", style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }
  //
  Widget giveRate(int? rating, int? reviewId) {
    return Row(
      //mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 1; i <= 5; i++)
          InkWell(
            onTap: () {
              service.updateUserReviewForProductApi(
                token: widget.token.toString(), userId: widget.userId.toString(),
                orderId: widget.orderId.toString(),
                productId: widget.productId.toString(),
                reviewId: reviewId.toString(),
                proRating: i.toString(),
                proReview: reviewTextController.text.toString(),
              ).then((value) {
                if(value?.success == "1") {
                  setState(() {});
                }
              });
            },
            child: i > rating!
                ? const Icon(Icons.star_outline_outlined)
                : const Icon(Icons.star, color: Color.fromRGBO(251, 188, 4, 1)),
          ),
      ],
    );
  }

  Widget writeReview(String? reviewText) {
    reviewTextController.value = reviewText == "null"
        ? const TextEditingValue(text: '')
        : TextEditingValue(text: reviewText.toString());
    return Column(
      children: [
        const SizedBox(height: 12),
        Row(
          children: const [
            Text('Write review for this product'),
          ],
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black54, width: 0.5),
              borderRadius: BorderRadius.circular(4)),
          child: TextFormField(
              controller: reviewTextController,
              minLines: 4,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              decoration: const InputDecoration(
                  border: InputBorder.none, hintText: 'Write review here...')),
        ),
      ],
    );
  }

  Widget reviewImagesWidget(String? reviewImages, String? reviewId){
    var imageList = [
      // "https://msilonline.in" + reviewImages.toString(),
      "http://3.109.69.39"+reviewImages.toString(),
    ];
    return Row(
      children: [
        if(reviewImages != null)
          SizedBox(
            height: 50,
            width: 50,
            child: InkWell(
              onTap: (){
                Get.to(() => GalleryWidget(urlImages: imageList));
              },
              child: Image.network("http://3.109.69.39"+reviewImages.toString()),
            ),
          ),
        TextButton(
          onPressed: (){
            showModalBottomSheet(
              context: context,
              builder: (context) => uploadOptions(reviewId),
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                    top: Radius.circular(15)),
              ),
            );
          },
          child: const Text("+ Add images", style: TextStyle(color: Colors.black)),
        ),
      ],
    );
  }

  bool cameraPermission = false;
  bool storagePermission = false;

  //ask permission for camera
  void checkCameraPermission(String? reviewId) async{
    if (await Permission.camera.request().isGranted) {
      setState(() {
        cameraPermission = true;
      });
      pickImage(ImageSource.camera, widget.token.toString(), reviewId);
    } else if (await Permission.camera.request().isPermanentlyDenied) {
      await openAppSettings();
      debugPrint('object3');
    } else if (await Permission.camera.request().isDenied) {
      debugPrint('object4');

      setState(() {
        cameraPermission = false;
      });
    }
  }

  //ask permission for storage
  void checkStoragePermission(String? reviewId) async{
    if (await Permission.storage.request().isGranted) {
      setState(() {
        storagePermission = true;
      });
      pickImage(ImageSource.gallery, widget.token.toString(), reviewId);
    } else if (await Permission.storage.request().isPermanentlyDenied) {
      await openAppSettings();
      debugPrint('object3');
    } else if (await Permission.storage.request().isDenied) {
      debugPrint('object4');

      setState(() {
        storagePermission = false;
      });
    }
  }

  //image upload options
  Widget uploadOptions(String? reviewId){
    return Container(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              checkCameraPermission(reviewId);
              Get.back();
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.camera_alt, size: 30),
                SizedBox(height: 4),
                Text('Camera')
              ],
            ),
          ),
          const SizedBox(width: 16),
          InkWell(
            onTap: () {
              checkStoragePermission(reviewId);
              Get.back();
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.photo_library, size: 30),
                SizedBox(height: 4),
                Text('Gallery')
              ],
            ),
          )
        ],
      ),
    );
  }

  File? image;
  final picker = ImagePicker();

  //pick image from gallery/camera
  Future pickImage(ImageSource imgSource, String? token, String? reviewId) async {
    final pickedFile = await picker.pickImage(source: imgSource, imageQuality: 50);
    if (pickedFile != null) {
      image = File(pickedFile.path);
      if (image != null) {
        service.addReviewImagesApi(token: token, reviewId: reviewId.toString(), img: image!).then((value) {
          setState(() {});
        });
      }
      setState(() {});
    } else {
      debugPrint('no image selected');
    }
  }
}
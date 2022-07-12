import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bike_cafe/models/Products/product_review_rating_model.dart';
import 'package:bike_cafe/models/Products/review_like_by_user_model.dart';
import 'package:bike_cafe/screens/Dashboard/profile/locale/gallery_widget.dart';
import 'package:bike_cafe/services/api.dart';
import 'package:bike_cafe/widget/config.dart';
import 'package:bike_cafe/widget/constrants.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:readmore/readmore.dart';
import 'package:get/get.dart';

import '../review_page.dart';

class RatingWidget {
  TextWidgetStyle style = TextWidgetStyle();
  //Rating and Review Container
  Widget ratingWidget(AsyncSnapshot<GetProductReviewAndRatingModel?> snapshot) {

    List<int?> countList = [
      snapshot.data!.numofrating1.numofrating1,
      snapshot.data!.numofrating2.numofrating2,
      snapshot.data!.numofrating3.numofrating3,
      snapshot.data!.numofrating4.numofrating4,
      snapshot.data!.numofrating5.numofrating5
    ];
    
    int? maxCount = countList.fold(countList.first, (max, element) => (max! < element!) ? element : max);

    // stars percentages
    double star5 = snapshot.data!.numofrating5.numofrating5 == 0 ? 0 : (snapshot.data!.numofrating5.numofrating5!/ maxCount!) ;
    double star4 = snapshot.data!.numofrating4.numofrating4 == 0 ? 0 : (snapshot.data!.numofrating4.numofrating4!/ maxCount!) ;
    double star3 = snapshot.data!.numofrating3.numofrating3 == 0 ? 0 : (snapshot.data!.numofrating3.numofrating3!/ maxCount!) ;
    double star2 = snapshot.data!.numofrating2.numofrating2 == 0 ? 0 : (snapshot.data!.numofrating2.numofrating2!/ maxCount!) ;
    double star1 = snapshot.data!.numofrating1.numofrating1 == 0 ? 0 : (snapshot.data!.numofrating1.numofrating1!/ maxCount!) ;

    return Container(
      color: Constants.bgwhitecolor,
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Row(
                children: [
                  Text(
                    snapshot.data!.avgRating.avgRating.toString() + " ",
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.w500),
                  ),
                  const Icon(Icons.star),
                ],
              ),
              Column(
                children: [
                  Text(
                    snapshot.data!.totaltrating.totalrate.toString() + " ratings and",
                    style: Constants.halfopacity,
                  ),
                  Text(
                    snapshot.data!.totaltreview.totalReview.toString() + " reviews",
                    style: Constants.halfopacity,
                  ),
                ],
              ),
            ],
          ),
          const Divider(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ratingCount(5, star5, snapshot.data!.numofrating5.numofrating5),
              ratingCount(4, star4, snapshot.data!.numofrating4.numofrating4),
              ratingCount(3, star3, snapshot.data!.numofrating3.numofrating3),
              ratingCount(2, star2, snapshot.data!.numofrating2.numofrating2),
              ratingCount(1, star1, snapshot.data!.numofrating1.numofrating1),
            ],
          ),
        ],
      ),
    );
  }

  //number wise rating count
  static Widget ratingCount(int number, double percent, int? count) {
    var color;
    if (number > 2) {
      color = const Color.fromRGBO(0, 128, 0, 1);
    }
    if (number == 2) {
      color = const Color.fromRGBO(255, 165, 0, 1);
    }
    if (number == 1) {
      color = const Color.fromRGBO(255, 0, 0, 1);
    }

    return Row(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$number',
              style: const TextStyle(fontSize: 12),
            ),
            const Icon(Icons.star, size: 12),
          ],
        ),
        LinearPercentIndicator(
          width: 120,
          percent: percent,
          progressColor: color,
        ),
        //number wise Rating count
        Text(
          '$count',
          style: const TextStyle(fontSize: 12, color: Colors.black54),
        ),
      ],
    );
  }
}

class ProductReviews extends StatefulWidget {
  ProductReviews({Key? key, this.token, this.userId, this.productId, required this.allReviews}) : super(key: key);

  String? token, userId, productId;
  bool allReviews;

  @override
  _ProductReviewsState createState() => _ProductReviewsState();
}

class _ProductReviewsState extends State<ProductReviews> {
  APIService service = APIService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<GetProductReviewAndRatingModel?>(
      future: service.productRatingAndReview(
          token: widget.token.toString(),
          productId: widget.productId.toString()),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.productreview.isEmpty) {
            return const Center(child: Text("No reviews"));
          } else {
            return Container(child: ratingAndReviews(snapshot));
          }
        } else {
          return const Center();
        }
      },
    );
  }

  Widget ratingAndReviews(AsyncSnapshot<GetProductReviewAndRatingModel?> snapshot) {
    var reviewLen = !widget.allReviews
        ? snapshot.data!.productreview.length > 4 ? 4 : snapshot.data!.productreview.length
        : snapshot.data!.productreview.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RatingWidget().ratingWidget(snapshot),
        const SizedBox(height: 4),
        for (var i = 0; i < reviewLen; i++)
          if(snapshot.data!.productreview[i].prorevReview != null)
            allReviewWidget(i,snapshot, widget.token.toString()),
        // ProductReviews(token: widget.token.toString(), index: i, snapshot: snapshot),
        //all reviews
        if(!widget.allReviews)
          if(snapshot.data!.productreview.length > 4)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              height: 40,
              child: InkWell(
                onTap: () {
                  Get.to(() => ReviewsPage(token: widget.token.toString(), userId: widget.userId.toString(),productId: widget.productId.toString()));
                },
                child: Row(
                  children: const [
                    Text('All Reviews', style: Constants.text1),
                    Spacer(),
                    Icon(Icons.arrow_forward_ios_sharp, size: 18)
                  ],
                ),
              ),
            )
      ],
    );
  }

  Widget allReviewWidget(int index,AsyncSnapshot<GetProductReviewAndRatingModel?> snapshot, String? token) {
    var reviews = snapshot.data!.productreview[index];
    var imageList = [
      // "https://msilonline.in" + reviews.prorevProductImg.toString(),
      "http://3.109.69.39"+reviews.prorevProductImg.toString(),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: Constants.bgwhitecolor,
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Row(
                children: [
                  ratingCard(reviews.prorevRate),
                  Text(
                    reviews.prorevDescription.toString() == "null" ? "" : " " +reviews.prorevDescription.toString(),
                    style: Constants.text1,
                  ),
                ],
              ),

              const SizedBox(height: 5),

              //Review text
              Container(
                alignment: Alignment.centerLeft,
                child: ReadMoreText(
                  reviews.prorevReview.toString(),
                  trimLines: 2,
                  trimMode: TrimMode.Line,
                  trimCollapsedText: ' more',
                  trimExpandedText: ' less',
                  //textAlign: TextAlign.justify,
                  style: const TextStyle(fontSize: 14),
                  moreStyle: const TextStyle(color: kPrimaryColor),
                  lessStyle: const TextStyle(color: kPrimaryColor),
                ),
              ),

              //if review photo is there, need to add container

              const SizedBox(height: 4),

              if(reviews.prorevProductImg != null)
                Container(
                  alignment: Alignment.topLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 50,
                        width: 50,
                        child: InkWell(
                          onTap: (){
                            Get.to(() => GalleryWidget(urlImages: imageList));
                          },
                          child: Image.network("http://3.109.69.39"+reviews.prorevProductImg.toString()),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              Row(
                children: [
                  Column(
                    children: [
                      Text(reviews.username.toString(),style: Constants.halfopacity),
                    ],
                  ),
                  const Spacer(),
                  reviewsLike(reviews)
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 2,)
      ],
    );
  }

  static ratingCard(int? rating) {
    var color;
    if (rating! > 2) {
      color = const Color.fromRGBO(0, 128, 0, 1);
    }
    if (rating == 2) {
      color = const Color.fromRGBO(255, 165, 0, 1);
    }
    if (rating == 1) {
      color = const Color.fromRGBO(255, 0, 0, 1);
    }
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 0),
      color: color,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
        child: Text.rich(
          TextSpan(children: [
            TextSpan(text: "$rating "),
            const WidgetSpan(
              child: Icon(
                Icons.star,
                size: 14,
                color: Colors.white,
              ),
            )
          ], style: const TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

  Widget reviewsLike(Productreview reviews){
    return FutureBuilder<ReviewsLikesDislikesModel?>(
      future: service.getUsersReviewLikes(
        token: widget.token.toString(),
        userId: widget.userId.toString(),
        productReviewId: reviews.id.toString()
      ),
      builder: (context, snapshot){
        if(snapshot.hasData){
          if(snapshot.data!.review.isNotEmpty){
            var likeData = snapshot.data!.review[0];
            return Row(
              children: [
                Row(
                  children: [
                    InkWell(
                      child: likeData.proLike == 1
                          ? const Icon(Icons.thumb_up_alt,size: 15,color: kPrimaryColor)
                          : const Icon(Icons.thumb_up_alt_outlined,size: 15,color: Colors.black54),
                      onTap: (){},
                    ),
                    const SizedBox(width: 2),
                    if(reviews.prorevLike != 0)
                      Text(reviews.prorevLike.toString(),style: const TextStyle(color: Colors.black54, fontSize: 12)),
                  ],
                ),
                const SizedBox(width: 15),
                Row(
                  children: [
                    InkWell(
                      child: likeData.proDislike == 1
                          ? const Icon(Icons.thumb_down_alt,size: 15,color: kPrimaryColor)
                          : const Icon(Icons.thumb_down_alt_outlined,size: 15,color: Colors.black54),
                      onTap: (){},
                    ),
                    const SizedBox(width: 2),
                    if(reviews.prorevDislike != 0)
                      Text(reviews.prorevDislike.toString(),style: const TextStyle(color: Colors.black54, fontSize: 12)),
                  ],
                ),
                const SizedBox(width: 10,),
              ],
            );
          }else{
            return reviewLikeSymbols(reviews);
          }
        }else{
          return reviewLikeSymbols(reviews);
        }
      },
    );
  }

  Widget reviewLikeSymbols(Productreview reviews){
    return Row(
      children: [
        Row(
          children: [
            InkWell(
              child: const Icon(Icons.thumb_up_alt_outlined,size: 15,color: Colors.black54,),
              onTap: (){
                service.likeAndDislikeUserReviewApi(
                    token: widget.token,userId: widget.userId,
                    reviewId: reviews.id.toString(),like: "1",dislike: "0").then((value) {
                  setState(() {});
                });
              },
            ),
            const SizedBox(width: 2),
            if(reviews.prorevLike != 0)
              Text(reviews.prorevLike.toString(),style: const TextStyle(color: Colors.black54, fontSize: 12)),
          ],
        ),
        const SizedBox(width: 15),
        Row(
          children: [
            InkWell(
              child: const Icon(Icons.thumb_down_alt_outlined,size: 15,color: Colors.black54,),
              onTap: (){
                service.likeAndDislikeUserReviewApi(
                    token: widget.token, userId: widget.userId,
                    reviewId: reviews.id.toString(),like: "0",dislike: "1").then((value) {
                  setState(() {});
                });
              },
            ),
            const SizedBox(width: 2),
            if(reviews.prorevDislike != 0)
              Text(reviews.prorevDislike.toString(),style: const TextStyle(color: Colors.black54, fontSize: 12)),
          ],
        ),
        const SizedBox(width: 10,),
      ],
    );
  }
}
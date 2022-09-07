import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bike_cafe/models/Categories/category_model.dart';
import 'package:bike_cafe/screens/Dashboard/Home/category/categorypage.dart';
import 'package:bike_cafe/screens/Dashboard/product/productpage.dart';
import 'package:bike_cafe/screens/Dashboard/product/screens/productview.dart';
import 'package:bike_cafe/services/api.dart';
import 'package:bike_cafe/widget/config.dart';
import 'package:bike_cafe/widget/constrants.dart';
import 'package:bike_cafe/widget/locale/ShimmerWidget.dart';

class Category extends StatelessWidget {
  Category({Key? key, required this.token, required this.userId})
      : super(key: key);

  final String? token;
  final String? userId;

  final double height = Get.height;
  final double width = Get.width;

  APIService service = APIService();

  CategoryProductsController categoryController =
      Get.put(CategoryProductsController());

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<GetCategories?>(
      future: service.getCategoriesApi(token: token),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return buildShimmer();
        }
        if (snapshot.hasData) {
          return categoryWidget(snapshot);
        } else {
          return Container();
        }
      },
    );
  }

  Widget categoryWidget(AsyncSnapshot<GetCategories?> snapshot) {
    return Container(
      height: 80,
      width: Config.Width,
      color: Constants.bgcolor,
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 4),
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            SizedBox(
              height: Get.height * 0.078,
              child: Row(
                children: [
                  SizedBox(
                    width: Config.Width * 0.85,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data!.categories.length,
                      itemBuilder: (context, index) {
                        var categories = snapshot.data!.categories[index];
                        return getCategory(categories.catImagepath,
                            categories.catName, categories.id);
                      },
                    ),
                  ),
                  if (snapshot.data!.categories.length >= 5)
                    SizedBox(
                      width: Config.Width * 0.15,
                      child: Align(
                        alignment: Alignment.center,
                        child: TextButton(
                          onPressed: () {
                            Get.to(() => CategoryPage());
                          },
                          child: Column(
                            children: const [
                              Icon(Icons.arrow_forward_ios_rounded,
                                  color: kPrimaryColor),
                              SizedBox(height: 4),
                              Text(
                                "View All",
                                style: TextStyle(
                                    color: kPrimaryColor, fontSize: 10),
                              ),
                            ],
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

  Widget getCategory(String? imageLocation, String? imageCaption, int catId) {
    return InkWell(
      onTap: () {
        categoryController.selectedCatId.value = catId;
        Get.to(() =>
            ProductPage(token: token.toString(), userId: userId.toString()));
      },
      child: SizedBox(
        width: 68,
        child: Column(
          children: [
            SizedBox(
              width: 62,
              height: 30,
              child: Image.network(
                imageLocation.toString(),
                height: 30,
                width: 30,
                errorBuilder: (context, img, image) {
                  return const ShimmerWidget.circular(width: 50, height: 50);
                },
              ),
            ),
            const SizedBox(height: 6),
            Container(
              alignment: Alignment.center,
              width: 62,
              height: 24,
              child: Text(
                imageCaption.toString(),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                maxLines: 1,
                style: const TextStyle(fontSize: 12),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildShimmer() {
    return SizedBox(
      height: 80,
      width: Get.width,
      child: Row(
        children: [
          const SizedBox(width: 6),
          dummyCategory(),
          const SizedBox(width: 6),
          dummyCategory(),
          const SizedBox(width: 6),
          dummyCategory(),
          const SizedBox(width: 6),
          dummyCategory(),
          const SizedBox(width: 6),
          dummyCategory(),
        ],
      ),
    );
  }

  Widget dummyCategory() {
    return Column(
      children: const [
        SizedBox(height: 6),
        ShimmerWidget.circular(width: 40, height: 40),
        SizedBox(height: 6),
        ShimmerWidget.rectangular(width: 60, height: 12)
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bike_cafe/models/Categories/category_model.dart';
import 'package:bike_cafe/screens/Dashboard/product/locale/tabbar.dart';
import 'package:bike_cafe/screens/Dashboard/product/productpage.dart';
import 'package:bike_cafe/screens/Dashboard/product/screens/productview.dart';
import 'package:bike_cafe/services/api.dart';
import 'package:bike_cafe/widget/config.dart';
import 'package:bike_cafe/widget/locale/scaffold.dart';
import 'package:hive/hive.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetScaffold(
      title: "Categories",
      body: const CategoryList(),
    );
  }
}

class CategoryList extends StatefulWidget {
  const CategoryList({Key? key}) : super(key: key);

  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  APIService service = APIService();

  Box? box1;

  @override
  void initState() {
    super.initState();
    createBox();
  }

  void createBox() async {
    box1 = await Hive.openBox('logindata');
    setState(() {});
  }

  CategoryProductsController categoryController = Get.put(CategoryProductsController());

  @override
  Widget build(BuildContext context) {
    return box1?.get("data4") == null
        ? const Center(child: CircularProgressIndicator())
        : ListView(
            children: [
              Container(
                height: 200,
                width: Config.Width,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/img/sm-post.png"),
                        fit: BoxFit.fill)),
              ),
              TabbarPage(
                children: [category(), serviceWidget()],
              ),
            ],
          );
  }

  Widget category() {
    return SizedBox(
      height: 300,
      width: Config.Width,
      child: FutureBuilder<GetCategories?>(
        future: service.getCategoriesApi(token: box1!.get("data4")),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GridView.builder(
                itemCount: snapshot.data!.categories.length,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 140),
                itemBuilder: (context, index) {
                  var categories = snapshot.data!.categories[index];
                  return getCategory(categories);
                });
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget serviceWidget() {
    return SizedBox(
      height: Config.Height,
      width: Config.Width,
      // padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            getCategory2("assets/bike_cafe/bikewash.jpg", "Automatic bike wash in 2 minutes"),
            getCategory2("assets/bike_cafe/carwash.jpg", "Automatic car wash"),
            getCategory2("assets/img/msc.png", "General Services"),
            const SizedBox(height: 25)
          ],
        ),
      ),
    );
  }

  Widget getCategory(Category categories) {
    return Container(
      margin: const EdgeInsets.all(2),
      child: Card(
        elevation: 6,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
        child: InkWell(
          onTap: () {
            categoryController.selectedCatId.value = categories.id;
            Get.to(() => ProductPage(token: box1?.get("data4").toString(),
                userId: box1?.get("data3")));
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.network(categories.catImagepath.toString(), height: 40, width: 40),
              const SizedBox(height: 10),
              Text(
                categories.catName.toString(),
                maxLines: 2,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 10),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget getCategory2(final String imageLocation, final String imageCaption) {
    return Container(
      margin: const EdgeInsets.all(2),
      child: Card(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
        child: InkWell(
          onTap: () {
            // Get.to(() => ProductPage());
          },
          child: Column(
            children: [
              SizedBox(
                height: 200,
                width: Config.Width,
                child: Image.asset(imageLocation, fit: BoxFit.cover),
              ),
              const SizedBox(height: 10),
              Text(
                imageCaption,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

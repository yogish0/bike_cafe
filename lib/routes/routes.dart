import 'package:get/get.dart';
import 'package:bike_cafe/screens/Dashboard/Address/locale/addresspage.dart';
import 'package:bike_cafe/screens/Dashboard/Cart/cart.dart';
import 'package:bike_cafe/screens/Dashboard/Home/category/categorypage.dart';
import 'package:bike_cafe/screens/Dashboard/Home/dashboard.dart';
import 'package:bike_cafe/screens/Dashboard/MyOrder/orders_list.dart';
import 'package:bike_cafe/screens/Dashboard/Notification/notification.dart';
import 'package:bike_cafe/screens/Dashboard/myoffres/myoffers.dart';
import 'package:bike_cafe/screens/Dashboard/payment/mainpage.dart';
import 'package:bike_cafe/screens/Dashboard/profile/profile.dart';
import 'package:bike_cafe/screens/Dashboard/wishlist/mywishlist.dart';
import 'package:bike_cafe/screens/SlidingScreen/vehicleList/listVehicle.dart';
import 'package:bike_cafe/screens/SplashScreen/splashScreen.dart';
import 'package:bike_cafe/screens/auth/password/password.dart';
import 'package:bike_cafe/screens/auth/sign_up/sign_up.dart';
import 'package:bike_cafe/screens/chatbotScreen/chatbot.dart';
import 'package:bike_cafe/screens/root.dart';

abstract class Routes {
  static const INITIAL = '/';
  static const Login = '/login';
  static const signUp = '/signUp';
  static const forgotpwd = '/forgotpassword';
  // static const Dashboard = '/Dashboard';
}

abstract class AppPages {
  static final pages = [
    GetPage(
      name: Routes.INITIAL,
      page: () => SplashPage(),
    ),
    GetPage(
      name: Routes.Login,
      page: () => Root(),
    ),
    GetPage(
      name: Routes.signUp,
      page: () => SignUp(),
    ),
    GetPage(
      name: Routes.forgotpwd,
      page: () => ResetPassword(),
    ),
    // GetPage(
    //   name: Routes.Dashboard,
    //   page: () => BottomNavBarPage(),
    // ),

    // GetPage(name: Routes.APRESENTACAO, page:()=> ApresentacaoPage()),


    GetPage(name: '/categories', page: ()=> CategoryPage()),
    // GetPage(name: '/bikecafe', page: ()=> BikeCafePage()),
    GetPage(name: '/myvehicles', page: ()=> ListedVehicle()),
    GetPage(name: '/mycart', page: ()=> CartPage()),
    GetPage(name: '/myorders', page: ()=> OrdersListPage()),
    GetPage(name: '/myaddress', page: ()=> AddressPageList()),
    GetPage(name: '/mywishlist', page: ()=> WishList()),
    GetPage(name: '/myprofile', page: ()=> ProfilePage()),
    GetPage(name: '/mynotification', page: ()=> NotificationPage()),
    GetPage(name: '/mychats', page: ()=> ChatBotPage()),
    GetPage(name: '/myoffers', page: ()=> MyOffersPage()),
    GetPage(name: '/mydashboard', page: ()=> Dashboard()),
    //route for checkoutpage
    GetPage(name: '/checkoutpage', page: ()=> MainPage()),
  ];
}

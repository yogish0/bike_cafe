import 'package:bike_cafe/screens/CloudParking/CP_Dashboard/CloudParkingDashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bike_cafe/controllers/bottombarcontroller.dart';
import 'package:bike_cafe/models/UserProfile/userprofile.dart';
import 'package:bike_cafe/screens/Dashboard/NavBar/bottomNavBar.dart';
import 'package:bike_cafe/screens/auth/login/signin.dart';
import 'package:bike_cafe/services/api.dart';
import 'package:bike_cafe/widget/config.dart';
import 'package:bike_cafe/widget/locale/scaffold.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../auth/sign_up/google_authentication.dart';
import '../../auth/sign_up/sign_up.dart';
import 'locale/editProfile.dart';
import 'dart:io';
import 'locale/gallery_widget.dart';
import 'locale/user_wallet.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  BottomNavBarPresisitant buildBottomBar = BottomNavBarPresisitant();
  BottomNavigationController bottomcontroller = BottomNavigationController();

  @override
  Widget build(BuildContext context) {
    return GetScaffold(
      title: "My Profile",
      body: const Profile(),
      index: 4,
    );
  }
}

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
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

  APIService service = APIService();

  File? image;
  final picker = ImagePicker();

  //pick image from gallery/camera
  Future pickImage(ImageSource imgSource, String token, String userId) async {
    final pickedFile =
        await picker.pickImage(source: imgSource, imageQuality: 50);
    if (pickedFile != null) {
      image = File(pickedFile.path);
      if (image != null) {
        service
            .uploadProfilePhotoApi(token: token, userId: userId, img: image!)
            .then((value) {
          setState(() {});
        });
      }
      setState(() {});
    } else {
      debugPrint('no image selected');
    }
  }

  GoogleAuthentication googleAuthentication = GoogleAuthentication();

  @override
  Widget build(BuildContext context) {
    return box1?.get('data4') == null
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: Column(
              children: [
                FutureBuilder<GetUserProfileData?>(
                  future: service.getUserProfileApi(
                      token: box1?.get('data4'), userId: box1?.get('data3')),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        children: [
                          for (var i = 0; i < snapshot.data!.user.length; i++)
                            profileCard(i, snapshot),
                          profileOptionsLists(),
                        ],
                      );
                    } else {
                      return const Center();
                    }
                  },
                ),
              ],
            ),
          );
  }

  Widget profileCard(int index, AsyncSnapshot<GetUserProfileData?> snapshot) {
    var user = snapshot.data!.user[index];
    var imageList = [
      // "https://msilonline.in" + user.profilePhotoPath.toString(),
      "https://" + user.profilePhotoPath.toString(),
    ];
    return Stack(
      children: [
        Card(
          child: Container(
            alignment: Alignment.center,
            child: Column(
              children: [
                const SizedBox(height: 10),
                //profile photo
                Stack(
                  children: [
                    ClipOval(
                      child: SizedBox(
                        height: 120,
                        width: 120,
                        child: user.profilePhotoPath == null
                            ? const Icon(Icons.account_circle_sharp,
                                size: 130, color: Colors.black54)
                            : InkWell(
                                onTap: () {
                                  Get.to(() =>
                                      GalleryWidget(urlImages: imageList));
                                },
                                child: Image.network(
                                  // "https://msilonline.in" + user.profilePhotoPath.toString(),
                                  "https://" + user.profilePhotoPath.toString(),
                                  fit: BoxFit.cover,
                                  width: 120,
                                  height: 120,
                                  errorBuilder: (context, img, image) {
                                    return Image.asset(
                                        "assets/img/no_image_available.jpg");
                                  },
                                ),
                              ),
                      ),
                    ),
                    Positioned(
                      right: -6,
                      bottom: -4,
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt_outlined,
                            color: kPrimaryColor),
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) => uploadOptions(user),
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(15)),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 5),
                //profile name
                Text(
                  user.name.toString(),
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),

                const SizedBox(height: 5),
                //profile email
                Text(
                  user.email.toString(),
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),

                const SizedBox(height: 5),
                //profile name
                Text(
                  '+91 ' + user.phonenumber.toString(),
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),

        //edit button
        Positioned(
          bottom: 5,
          right: 5,
          child: IconButton(
              onPressed: () async {
                Get.to(() => EditProfile(
                    token: box1?.get('data4'),
                    userId: box1?.get('data3')))?.then((value) {
                  setState(() {});
                });
              },
              icon: const Icon(Icons.edit)),
        ),

        //wallet card
        // Positioned(
        //   top: 5,
        //   right: 5,
        //   child: Container(
        //     child: Row(
        //       children: [
        //         Text('Wallet ',
        //             style:
        //                 TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        //         Icon(Icons.account_balance_wallet, size: 14),
        //         Card(
        //           child: Text(
        //             ' ' + '100' + ' GC ',
        //             style: TextStyle(color: Colors.green, fontSize: 12),
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
      ],
    );
  }

  Widget profileOptionsLists() {
    return StaggeredGrid.count(
      crossAxisCount: 1,
      children: [
        profileOptionTile(
            svgname: 'My cart.svg', text: 'My Cart', routename: '/mycart'),
        profileOptionTile(
            svgname: 'My orders.svg',
            text: 'My Orders',
            routename: '/myorders'),
        profileOptionTile(
            svgname: 'My Vehicles.svg',
            text: 'My Vehicles',
            routename: '/myvehicles'),
        profileOptionTile(
            svgname: 'My Addresss.svg',
            text: 'My Address',
            routename: '/myaddress'),
        profileOptionTile(
            svgname: 'My Wishlist.svg',
            text: 'My Wishlist',
            routename: '/mywishlist'),
        profileOptionTile(
            svgname: 'My Notification.svg',
            text: 'My Notifications',
            routename: '/mynotification'),
        profileOptionTile(
            svgname: 'My chats.svg', text: 'My Chats', routename: '/mychats'),
        profileOptionTile(
            svgname: 'offers.svg', text: 'My Offers', routename: '/myoffers'),
        // profileOptionWalletTile(
        //     icon: Icons.account_balance_wallet, text: 'My Wallet'),
        Card(
          margin: const EdgeInsets.all(3),
          child: InkWell(
            onTap: () {
              Get.to(()=> CloudParkingDashboard());
            },
            child: ListTile(
              leading: SvgPicture.asset('assets/img/svg/offers.svg',
                  height: 20, width: 20),
              title: const Text(
                "Cloud Parking",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
            ),
          ),
        ),
        logoutOptionTile(svgname: 'log out.svg', text: 'Logout'),
      ],
    );
  }

  Widget profileOptionTile(
      {required String svgname,
      required String text,
      required String routename}) {
    return Card(
      margin: const EdgeInsets.all(3),
      child: InkWell(
        onTap: () {
          Get.toNamed(routename);
        },
        child: ListTile(
          leading: SvgPicture.asset('assets/img/svg/$svgname',
              height: 20, width: 20),
          title: Text(
            text,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
        ),
      ),
    );
  }

  Widget profileOptionWalletTile(
      {required IconData icon, required String text}) {
    return Card(
      margin: const EdgeInsets.all(3),
      child: InkWell(
        onTap: () {
          Get.to(() => const UserWallet());
        },
        child: ListTile(
          leading: Icon(
            icon,
            color: const Color.fromRGBO(94, 91, 91, 1),
          ),
          title: Text(
            text,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          subtitle: const Text(
            'GC : Golo Coin, 1 GC = ₹ 1',
            style: TextStyle(fontSize: 12),
          ),
          // trailing: Text(
          //   ' ' + '100' + ' GC',
          //   style: TextStyle(
          //     color: Colors.green,
          //   ),
          // ),
          visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
        ),
      ),
    );
  }

  Widget logoutOptionTile({required String svgname, required String text}) {
    return Card(
      margin: const EdgeInsets.all(3),
      child: InkWell(
        onTap: () {
          if (box1!.get("isGoogleAuth") != null) {
            if (box1!.get("isGoogleAuth") == true) {
              googleAuthentication.logOut();
              box1!.put("isGoogleAuth", false);
            }
          }
          APIService apiService = APIService();
          var token = box1!.get("data4");
          if (token != null) {
            apiService.logout(token: token);
            box1!.put('isLogged', false);
            Get.offAll(() => const SignIn());
          } else {
            debugPrint("failed to logout");
          }
        },
        child: ListTile(
          leading: SvgPicture.asset('assets/img/svg/$svgname',
              height: 20, width: 20),
          title: Text(
            text,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
        ),
      ),
    );
  }

  bool cameraPermission = false;
  bool storagePermission = false;

  //ask permission for camera
  void checkCameraPermission() async {
    if (await Permission.camera.request().isGranted) {
      setState(() {
        cameraPermission = true;
      });
      pickImage(ImageSource.camera, box1?.get('data4'), box1?.get('data3'));
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
  void checkStoragePermission() async {
    if (await Permission.storage.request().isGranted) {
      setState(() {
        storagePermission = true;
      });
      pickImage(ImageSource.gallery, box1?.get('data4'), box1?.get('data3'));
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
  Widget uploadOptions(User user) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              // pickImage(ImageSource.camera, box1?.get('data4'), box1?.get('data3'));
              checkCameraPermission();
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
              checkStoragePermission();
              // pickImage(ImageSource.gallery, box1?.get('data4'), box1?.get('data3'));
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
}

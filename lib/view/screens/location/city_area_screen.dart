import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:sixam_mart/controller/auth_controller.dart';
import 'package:sixam_mart/controller/location_controller.dart';
import 'package:sixam_mart/data/model/response/address_model.dart';
import 'package:sixam_mart/data/model/response/zone_response_model.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/view/base/custom_app_bar.dart';
import 'package:sixam_mart/view/base/custom_button.dart';
import 'package:sixam_mart/view/base/custom_loader.dart';
import 'package:sixam_mart/view/base/custom_snackbar.dart';
import 'package:sixam_mart/view/base/footer_view.dart';
import 'package:sixam_mart/view/base/menu_drawer.dart';
import 'package:sixam_mart/view/base/no_data_screen.dart';
import 'package:sixam_mart/view/screens/address/widget/address_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/view/screens/location/pick_map_screen.dart';
import 'package:sixam_mart/view/screens/location/widget/web_landing_page.dart';

import '../../../controller/banner_controller.dart';
import '../../../controller/notification_controller.dart';
import '../../../controller/splash_controller.dart';
import '../../../controller/store_controller.dart';
import '../../../controller/user_controller.dart';
import '../../base/item_view.dart';
import '../../base/paginated_list_view.dart';
import '../../base/web_menu_bar.dart';
import '../home/theme1/theme1_home_screen.dart';
import '../home/web_home_screen.dart';
import '../home/widget/banner_view.dart';
import '../home/widget/city_view_widget.dart';
import '../home/widget/module_view.dart';
import '../home/widget/popular_store_view.dart';
import '../parcel/parcel_category_screen.dart';

class CityAreaScreen extends StatefulWidget {
  final bool fromSignUp;
  final bool fromHome;
  final String? route;

  const CityAreaScreen({
    Key? key,
    required this.fromSignUp,
    required this.fromHome,
    required this.route,
  }) : super(key: key);

  @override
  State<CityAreaScreen> createState() => _CityAreaScreenState();

}

class _CityAreaScreenState extends State<CityAreaScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _canExit = GetPlatform.isWeb ? true : false;
  bool showChooseAreaButton = true; // Set it to true or false based on your logic



  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      // This code will be executed after the widget is built and displayed on the screen.
      if (Get.find<AuthController>().isLoggedIn()) {
        Get.find<LocationController>().getAddressList();
        Get.find<SplashController>().getCities();
      }
      else{
        Get.find<SplashController>().getCities();
      }
    });
  }


  // Function to execute the code on page load


  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(builder: (splashController) {
      bool showMobileModule = !ResponsiveHelper.isDesktop(context) && splashController.city == null && splashController.configModel!.module == null;
      bool isParcel = splashController.module != null && splashController.configModel!.moduleConfig!.module!.isParcel!;
      // bool isTaxiBooking = splashController.module != null && splashController.configModel!.moduleConfig!.module!.isTaxi!;

      return Scaffold(
        appBar: ResponsiveHelper.isDesktop(context) ? const WebMenuBar() : null,
        endDrawer: const MenuDrawer(), endDrawerEnableOpenDragGesture: false,
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              if(Get.find<SplashController>().city != null) {

                // await Get.find<LocationController>().syncZoneData();
                // await Get.find<BannerController>().getBannerList(true);
                // await Get.find<CategoryController>().getCategoryList(true);
                // await Get.find<StoreController>().getPopularStoreList(true, 'all', false);
                // await Get.find<CampaignController>().getItemCampaignList(true);
                // await Get.find<ItemController>().getPopularItemList(true, 'all', false);
                // await Get.find<StoreController>().getLatestStoreList(true, 'all', false);
                // await Get.find<ItemController>().getReviewedItemList(true, 'all', false);
                // await Get.find<StoreController>().getStoreList(1, true);
                if(Get.find<AuthController>().isLoggedIn()) {
                  await Get.find<UserController>().getUserInfo();
                  await Get.find<NotificationController>().getNotificationList(true);
                }
              }else {
                // await Get.find<BannerController>().getFeaturedBanner();
                await Get.find<SplashController>().getCities();
                // if(Get.find<AuthController>().isLoggedIn()) {
                //   await Get.find<LocationController>().getAddressList();
                // }
                // await Get.find<StoreController>().getFeaturedStoreList();
              }
            },
            child: ResponsiveHelper.isDesktop(context) ? WebHomeScreen(
              scrollController: _scrollController,
            ) : (Get.find<SplashController>().module != null && Get.find<SplashController>().module!.themeId == 2) ?
            Theme1HomeScreen(
              scrollController: _scrollController, splashController: splashController, showMobileModule: showMobileModule,
            ) : CustomScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [

                /// Main City Selection Screen (After Splash Screen)
                SliverToBoxAdapter(
                  child: Center(
                    child: SizedBox(
                      width: Dimensions.webMaxWidth,
                      child: Column(
                        children: [

                          const Padding(
                            padding: EdgeInsets.only(top: 20.0),
                            child: Text(
                            "Please Select Your City",
                            style: TextStyle(
                              fontSize: 18, // Adjust the font size as needed
                              fontWeight: FontWeight.bold, // You can change the fontWeight
                            ),
                          ),
                          ),
                          CityViewWidget(
                            splashController: splashController,
                            city: 1,
                            page: 'home',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      );
    });
  }
}



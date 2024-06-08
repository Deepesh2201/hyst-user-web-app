import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

import '../../../controller/wishlist_controller.dart';
import '../home/home_screen.dart';

class AccessLocationScreen extends StatefulWidget {
  final bool fromSignUp;
  final bool fromHome;
  final String? route;

  const AccessLocationScreen({
    Key? key,
    required this.fromSignUp,
    required this.fromHome,
    required this.route,
  }) : super(key: key);

  @override
  State<AccessLocationScreen> createState() => _AccessLocationScreenState();
}

class _AccessLocationScreenState extends State<AccessLocationScreen> {
  bool _canExit = GetPlatform.isWeb ? true : false;
  bool showChooseAreaButton = true; // Set it to true or false based on your logic


  @override
  void initState() {
    super.initState();
    if (Get.find<AuthController>().isLoggedIn()) {
      Get.find<LocationController>().getAddressList();
    }

    // Automatically trigger executeOnPageLoad after 2 seconds
    Timer(Duration(seconds: 1), executeOnPageLoad);
  }

  // Function to execute the code on page load
  void executeOnPageLoad() {
    /// Retriving the data from sharedspace (added in login page)
    Future<String?> _getData() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString('phone'); // Replace 'key' with the key you used to store the data
    }
    /// Checking guest login and if yes then login out
    void fetchData() async {
      String? phone = await _getData();
      if (phone == '+441234567890') {
        Get.find<AuthController>().clearSharedData();
        Get.find<AuthController>().socialLogout();
        // Get.find<CartController>().clearCartList();
        Get.find<WishListController>().removeWishes();
      }
    }
    /// Redirecting to homescreen
    Get.to(() => HomeScreen(area: 'test'));
    // The code you want to execute on page load
    if (Get.find<LocationController>().addressList != null &&
        Get.find<LocationController>().addressList!.isNotEmpty) {
      Get.dialog(const CustomLoader(), barrierDismissible: false);
      AddressModel address =
      Get.find<LocationController>().addressList![0]; // Change the index as needed
      Get.find<LocationController>().saveAddressAndNavigate(
        address,
        widget.fromSignUp,
        widget.route,
        widget.route != null,
        ResponsiveHelper.isDesktop(context),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_canExit) {
          if (GetPlatform.isAndroid) {
            SystemNavigator.pop();
          } else if (GetPlatform.isIOS) {
            exit(0);
          } else {
            Navigator.pushNamed(context, RouteHelper.getInitialRoute());
          }
          return Future.value(false);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('back_press_again_to_exit'.tr,
                style: const TextStyle(color: Colors.white)),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
            margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          ));
          _canExit = true;
          Timer(const Duration(seconds: 2), () {
            _canExit = false;
          });
          return Future.value(false);
        }
      },
      child: Scaffold(
        appBar: CustomAppBar(
            title: 'set_location'.tr, backButton: widget.fromHome),
        endDrawer: const MenuDrawer(),
        endDrawerEnableOpenDragGesture: false,
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SafeArea(
          child: Padding(
            padding: ResponsiveHelper.isDesktop(context)
                ? EdgeInsets.zero
                : const EdgeInsets.all(Dimensions.paddingSizeSmall),
            child: GetBuilder<LocationController>(
              builder: (locationController) {
                bool isLoggedIn =
                Get.find<AuthController>().isLoggedIn();
                return (ResponsiveHelper.isDesktop(context) &&
                    locationController.getUserAddress() ==
                        null)
                    ? WebLandingPage(
                  fromSignUp: widget.fromSignUp,
                  fromHome: widget.fromHome,
                  route: widget.route,
                )
                    : isLoggedIn
                    ? Column(children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: FooterView(
                        child: Column(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          children: [
                            locationController.addressList !=
                                null
                                ? locationController.addressList!
                                .isNotEmpty
                                ? ListView.builder(
                              physics:
                              const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: locationController
                                  .addressList!
                                  .length,
                              itemBuilder:
                                  (context, index) {
                                return Center(
                                    child: SizedBox(
                                      width: 700,
                                      child: AddressWidget(
                                        address:
                                        locationController
                                            .addressList![
                                        index],
                                        fromAddress: false,
                                        onTap: () {
                                          Get.dialog(
                                              const CustomLoader(),
                                              barrierDismissible:
                                              false);
                                          AddressModel
                                          address =
                                          locationController
                                              .addressList![
                                          index];
                                          locationController
                                              .saveAddressAndNavigate(
                                              address,
                                              widget.fromSignUp,
                                              widget.route,
                                              widget.route !=
                                                  null,
                                              ResponsiveHelper
                                                  .isDesktop(
                                                  context));
                                        },
                                      ),
                                    ));
                              },
                            )
                                : NoDataScreen(
                                text:
                                'no_saved_address_found'
                                    .tr)
                                : const Center(
                                child:
                                CircularProgressIndicator()),
                            const SizedBox(
                                height:
                                Dimensions.paddingSizeLarge),
                            ResponsiveHelper.isDesktop(context)
                                ? BottomButton(
                                locationController:
                                locationController,
                                fromSignUp:
                                widget.fromSignUp,
                                route: widget.route)
                                : const SizedBox(),
                          ],
                        ),
                      ),
                    ),
                  ),
                  ResponsiveHelper.isDesktop(context)
                      ? const SizedBox()
                      : BottomButton(
                      locationController:
                      locationController,
                      fromSignUp: widget.fromSignUp,
                      route: widget.route),
                ])
                    : Center(
                  child: SingleChildScrollView(
                    physics:
                    const BouncingScrollPhysics(),
                    child: FooterView(
                      child: SizedBox(
                          width: 700,
                          child: Column(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                    Images.deliveryLocation,
                                    height: 220),
                                const SizedBox(
                                    height: Dimensions
                                        .paddingSizeLarge),
                                Text(
                                    'find_stores_and_items'
                                        .tr
                                        .toUpperCase(),
                                    textAlign:
                                    TextAlign.center,
                                    style: robotoMedium.copyWith(
                                        fontSize: Dimensions
                                            .fontSizeExtraLarge)),
                                Padding(
                                  padding:
                                  const EdgeInsets.all(
                                      Dimensions
                                          .paddingSizeLarge),
                                  child: Text(
                                    'by_allowing_location_access'
                                        .tr,
                                    textAlign:
                                    TextAlign.center,
                                    style: robotoRegular.copyWith(
                                        fontSize: Dimensions
                                            .fontSizeSmall,
                                        color: Theme.of(context)
                                            .disabledColor),
                                  ),
                                ),
                                const SizedBox(
                                    height: Dimensions
                                        .paddingSizeLarge),
                                Padding(
                                  padding: ResponsiveHelper
                                      .isWeb()
                                      ? EdgeInsets.zero
                                      : const EdgeInsets
                                      .symmetric(
                                      horizontal: Dimensions
                                          .paddingSizeLarge),
                                  child: BottomButton(
                                      locationController:
                                      locationController,
                                      fromSignUp:
                                      widget.fromSignUp,
                                      route: widget.route),
                                ),
                              ])),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class BottomButton extends StatelessWidget {
  final LocationController locationController;
  final bool fromSignUp;
  final String? route;

  const BottomButton({
    Key? key,
    required this.locationController,
    required this.fromSignUp,
    required this.route,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SizedBox(
          width: 700,
          child: Column(children: [
            TextButton(
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                      width: 1, color: Theme.of(context).primaryColor),
                  borderRadius: BorderRadius.circular(
                      Dimensions.radiusDefault),
                ),
                minimumSize:
                const Size(Dimensions.webMaxWidth, 50),
                padding: EdgeInsets.zero,
              ),
              onPressed: () {
                if (ResponsiveHelper.isDesktop(Get.context)) {
                  showGeneralDialog(
                      context: Get.context!,
                      pageBuilder: (_, __, ___) {
                        return SizedBox(
                            height: 300,
                            width: 300,
                            child: PickMapScreen(
                                fromSignUp: fromSignUp,
                                canRoute: route != null,
                                fromAddAddress: false,
                                route: route ?? RouteHelper.accessLocation));
                      });
                } else {
                  Get.toNamed(RouteHelper.getPickMapRoute(
                      route ??
                          (fromSignUp
                              ? RouteHelper.signUp
                              : RouteHelper.accessLocation),
                      route != null));
                }
              },
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          right: Dimensions.paddingSizeExtraSmall),
                      child: Icon(
                          Icons.map,
                          color: Theme.of(context).primaryColor),
                    ),
                    Text('Choose your area',
                        textAlign: TextAlign.center,
                        style: robotoBold.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontSize: Dimensions.fontSizeLarge,
                        )),
                  ]),
            ),
          ]),
        ));
  }
}
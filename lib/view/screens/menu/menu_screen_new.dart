import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/controller/auth_controller.dart';
import 'package:sixam_mart/controller/cart_controller.dart';
import 'package:sixam_mart/controller/splash_controller.dart';
import 'package:sixam_mart/controller/user_controller.dart';
import 'package:sixam_mart/controller/wishlist_controller.dart';
import 'package:sixam_mart/helper/date_converter.dart';
import 'package:sixam_mart/helper/price_converter.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/view/base/confirmation_dialog.dart';
import 'package:sixam_mart/view/base/custom_image.dart';
import 'package:sixam_mart/view/screens/auth/sign_in_screen.dart';
import 'package:sixam_mart/view/screens/menu/widget/portion_widget.dart';
import 'package:sixam_mart/view/screens/menu/widget/portion_widget_web.dart';
import '../../../util/app_constants.dart';
import '../../base/not_logged_in_screen.dart';
import '../store/webview_screen.dart';

class MenuScreenNew extends StatefulWidget {
  const MenuScreenNew({Key? key}) : super(key: key);

  @override
  State<MenuScreenNew> createState() => _MenuScreenNewState();
}

class _MenuScreenNewState extends State<MenuScreenNew> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      body: GetBuilder<UserController>(
        builder: (userController) {
          final bool isLoggedIn = Get.find<AuthController>().isLoggedIn();

          return isLoggedIn ? _buildLoggedInContent(userController) : _buildNotLoggedInContent();
        },
      ),
    );
  }

  Widget _buildLoggedInContent(UserController userController) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(color: Theme.of(context).primaryColor),
          child: Padding(
            padding: const EdgeInsets.only(
              left: Dimensions.paddingSizeExtremeLarge, right: Dimensions.paddingSizeExtremeLarge,
              top: 50, bottom: Dimensions.paddingSizeExtremeLarge,
            ),
            child: Row(children: [
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(1),
                child: ClipOval(
                  child: CustomImage(
                    placeholder: Images.guestIconLight,
                    image: '${Get.find<SplashController>().configModel!.baseUrls!.customerImageUrl}'
                        '/${(userController.userInfoModel != null) ? userController.userInfoModel!.image : ''}',
                    height: 70, width: 70, fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: Dimensions.paddingSizeDefault),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    'Welcome ${userController.userInfoModel?.fName}',
                    style: TextStyle(fontSize: Dimensions.fontSizeExtraLarge, color: Theme.of(context).cardColor),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                  Text(
                    userController.userInfoModel != null ? DateConverter.containTAndZToUTCFormat(userController.userInfoModel!.createdAt!) : '',
                    style: TextStyle(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).cardColor),
                  ),
                ]),
              ),
            ]),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Ink(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              padding: const EdgeInsets.only(top: Dimensions.paddingSizeLarge),
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault, right: Dimensions.paddingSizeDefault),
                        child: Text(
                          'general'.tr,
                          style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).primaryColor.withOpacity(0.5)),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                          boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200]!, spreadRadius: 1, blurRadius: 5)],
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeDefault),
                        margin: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                        child: Column(
                          children: [
                            PortionWidget(icon: Images.profileIcon, title: 'profile'.tr, route: RouteHelper.getProfileRoute()),
                            PortionWidget(icon: Images.storeIcon, title: 'My Stores', route: RouteHelper.getAllRegisteredStoresRoute(Get.find<UserController>().userInfoModel?.id!)),
                            PortionWidget(icon: Images.aboutIcon, title: 'My Rent/Sales', route: RouteHelper.getAllPostsRoute(Get.find<UserController>().userInfoModel?.id!)),
                            PortionWidget(icon: Images.guest, title: 'My Jobs', route: RouteHelper.getAllJobsRoute(Get.find<UserController>().userInfoModel?.id!)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: Dimensions.paddingSizeExtremeLarge),
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Padding(
                      padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault, right: Dimensions.paddingSizeDefault),
                      child: Text(
                        'help_and_support'.tr,
                        style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).primaryColor.withOpacity(0.5)),
                      ),
                    ),

                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200]!, spreadRadius: 1, blurRadius: 5)],
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeDefault),
                      margin: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                      child: Column(children: [
                        // PortionWidget(icon: Images.chatIcon, title: 'live_chat'.tr, route: RouteHelper.getConversationRoute()),
                        PortionWidget(icon: Images.helpIcon, title: 'help_and_support'.tr, route: RouteHelper.getSupportRoute()),
                        // PortionWidget(icon: Images.aboutIcon, title: 'about_us'.tr, route: RouteHelper.getHtmlRoute('about-us')),
                        /// About Us Webpage
                        PortionWidgetWeb(
                          icon: Images.aboutIcon,
                          title: 'About Us',
                          route: RouteHelper.webView,
                          onTap: () {
                            String url = AppConstants.mainBaseUrl + AppConstants.aboutUsUrl;
                            String title = 'About Us'; // Replace with your dynamic title
                            Get.to(
                              WebViewScreen(title: title, url: url),
                              binding: BindingsBuilder(
                                    () {
                                  // You can add any necessary bindings here
                                },
                              ),
                            );
                          },
                        ),
                        /// Terms & Conditions Webpage
                        PortionWidgetWeb(
                          icon: Images.aboutIcon,
                          title: 'Terms & Conditions',
                          route: RouteHelper.webView,
                          onTap: () {
                            String url = AppConstants.mainBaseUrl + AppConstants.termsConditionsUrl;
                            String title = 'Terms & Conditions'; // Replace with your dynamic title
                            Get.to(
                              WebViewScreen(title: title, url: url),
                              binding: BindingsBuilder(
                                    () {
                                  // You can add any necessary bindings here
                                },
                              ),
                            );
                          },
                        ),
                        /// Privacy Policy Webpage
                        PortionWidgetWeb(
                          icon: Images.aboutIcon,
                          title: 'Privacy Policy',
                          route: RouteHelper.webView,
                          onTap: () {
                            String url = AppConstants.mainBaseUrl + AppConstants.privacyPolicyUrl;
                            String title = 'Privacy Policy'; // Replace with your dynamic title
                            Get.to(
                              WebViewScreen(title: title, url: url),
                              binding: BindingsBuilder(
                                    () {
                                  // You can add any necessary bindings here
                                },
                              ),
                            );
                          },
                        ),
                        /// Account Delete Webpage
                        PortionWidgetWeb(
                          icon: Images.profileDelete,
                          title: 'Delete Account',
                          route: RouteHelper.webView,
                          onTap: () {
                            String url = AppConstants.mainBaseUrl + AppConstants.accountDeleteUrl;
                            String title = 'Delete Account'; // Replace with your dynamic title
                            Get.to(
                              WebViewScreen(title: title, url: url),
                              binding: BindingsBuilder(
                                    () {
                                  // You can add any necessary bindings here
                                },
                              ),
                            );
                          },
                        ),
                        // PortionWidget(icon: Images.termsIcon, title: 'terms_conditions'.tr, route: RouteHelper.getHtmlRoute('terms-and-condition')),
                        // PortionWidget(icon: Images.privacyIcon, title: 'privacy_policy'.tr, route: RouteHelper.getHtmlRoute('privacy-policy')),

                        // (Get.find<SplashController>().configModel!.refundPolicyStatus == 1 ) ? PortionWidget(
                        //     icon: Images.refundIcon, title: 'refund_policy'.tr, route: RouteHelper.getHtmlRoute('refund-policy'),
                        //   hideDivider: (Get.find<SplashController>().configModel!.cancellationPolicyStatus == 1 ) ||
                        //       (Get.find<SplashController>().configModel!.shippingPolicyStatus == 1 ) ? false : true,
                        // ) : const SizedBox(),

                        // (Get.find<SplashController>().configModel!.cancellationPolicyStatus == 1 ) ? PortionWidget(
                        //     icon: Images.cancelationIcon, title: 'cancellation_policy'.tr, route: RouteHelper.getHtmlRoute('cancellation-policy'),
                        //   hideDivider: (Get.find<SplashController>().configModel!.shippingPolicyStatus == 1 ) ? false : true,
                        // ) : const SizedBox(),

                        (Get.find<SplashController>().configModel!.shippingPolicyStatus == 1 ) ? PortionWidget(
                          icon: Images.shippingIcon, title: 'shipping_policy'.tr, hideDivider: true, route: RouteHelper.getHtmlRoute('shipping-policy'),
                        ) : const SizedBox(),
                      ]),
                    )
                  ]),
                  InkWell(
                    onTap: () {
                      if (Get.find<AuthController>().isLoggedIn()) {
                        Get.dialog(ConfirmationDialog(
                          icon: Images.support,
                          description: 'are_you_sure_to_logout'.tr,
                          isLogOut: true,
                          onYesPressed: () {
                            Get.find<AuthController>().clearSharedData();
                            Get.find<AuthController>().socialLogout();
                            Get.find<WishListController>().removeWishes();
                            if (ResponsiveHelper.isDesktop(context)) {
                              Get.offAllNamed(RouteHelper.getInitialRoute());
                            } else {
                              Get.offAllNamed(RouteHelper.getSignInRoute(RouteHelper.splash));
                            }
                          },
                        ), useSafeArea: false);
                      } else {
                        Get.find<WishListController>().removeWishes();
                        Get.toNamed(RouteHelper.getSignInRoute(Get.currentRoute));
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                            child: Icon(Icons.power_settings_new_sharp, size: 18, color: Theme.of(context).cardColor),
                          ),
                          const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                          Text(Get.find<AuthController>().isLoggedIn() ? 'logout'.tr : 'sign_in'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge))
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNotLoggedInContent() {
    return NotLoggedInScreen(callBack: (value) {
      initCall();
      setState(() {});
    });
  }

  void initCall() {
    /// Using this method to check whether loggedin using Guest ID or not
    Get.find<AuthController>().fetchData();
    print("Checked yaar");
    if (Get.find<AuthController>().isLoggedIn()) {
      // Do any necessary initialization when the user logs in
    }
    else{
      print("Not login bro!");
      Get.to(() => NotLoggedInScreen(callBack: (value){
        initCall();
        setState(() {});
      }),
      );
    }
  }
}

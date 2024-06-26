import 'dart:async';

import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:sixam_mart/controller/auth_controller.dart';
// import 'package:sixam_mart/controller/location_controller.dart';
import 'package:sixam_mart/controller/order_controller.dart';
import 'package:sixam_mart/controller/splash_controller.dart';
import 'package:sixam_mart/data/model/response/order_model.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/view/base/cart_widget.dart';
import 'package:sixam_mart/view/base/custom_dialog.dart';
import 'package:sixam_mart/view/screens/checkout/widget/congratulation_dialogue.dart';
import 'package:sixam_mart/view/screens/dashboard/widget/address_bottom_sheet.dart';
import 'package:sixam_mart/view/screens/dashboard/widget/bottom_nav_item.dart';
import 'package:sixam_mart/view/screens/favourite/favourite_screen.dart';
import 'package:sixam_mart/view/screens/home/home_screen.dart';
import 'package:sixam_mart/view/screens/menu/menu_screen_new.dart';
import 'package:sixam_mart/view/screens/order/order_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../rentandsalesposts/post_full_list_screen.dart';
import '../store/webview_screen.dart';
import 'widget/running_order_view_widget.dart';

class DashboardScreen extends StatefulWidget {
  final int pageIndex;
  final bool fromSplash;
  const DashboardScreen({Key? key, required this.pageIndex, this.fromSplash = false}) : super(key: key);

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  PageController? _pageController;
  int _pageIndex = 0;
  late List<Widget> _screens;
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();
  bool _canExit = GetPlatform.isWeb ? true : false;
  final ScrollController _scrollController = ScrollController();

  GlobalKey<ExpandableBottomSheetState> key = GlobalKey();
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey<ScaffoldState>();

  void _openEndDrawer() {
    _drawerKey.currentState!.openEndDrawer();
  }

  void _closeEndDrawer() {
    Navigator.of(context).pop();
  }


  late bool _isLogin;
  bool active = false;

  @override
  void initState() {
    super.initState();

    _isLogin = Get.find<AuthController>().isLoggedIn();

    if(_isLogin){
      if(Get.find<SplashController>().configModel!.loyaltyPointStatus == 1 && Get.find<AuthController>().getEarningPint().isNotEmpty
          && !ResponsiveHelper.isDesktop(Get.context)){
        Future.delayed(const Duration(seconds: 1), () => showAnimatedDialog(context, const CongratulationDialogue()));
      }
      // suggestAddressBottomSheet();
      Get.find<OrderController>().getRunningOrders(1);
    }

    _pageIndex = widget.pageIndex;

    _pageController = PageController(initialPage: widget.pageIndex);

    _screens = [
      const HomeScreen(),
      const FavouriteScreen(),
      // const SizedBox(),
      // const PostFullListScreen(),
      jobListWidget(),
      postListWidget(),
      // _buildStoreRegistration(), // Use a function to return the Widget
      // HomeScreen.loadData(true);
      const MenuScreenNew()
    ];

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {});
    });

  }

  // Future<void> suggestAddressBottomSheet() async {
  //   active = await Get.find<LocationController>().checkLocationActive();
  //   if(widget.fromSplash && Get.find<LocationController>().showLocationSuggestion && active) {
  //     Future.delayed(const Duration(seconds: 1), () {
  //       showModalBottomSheet(
  //         context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
  //         builder: (con) => const AddressBottomSheet(),
  //       ).then((value) {
  //         Get.find<LocationController>().hideSuggestedLocation();
  //         setState(() {});
  //       });
  //     });
  //   }
  // }

  // Define a function that returns the store registration WebView
  Widget _buildStoreRegistration() {
    String url = '${AppConstants.baseUrl}${AppConstants.searchUri}business/list';
    String title = 'My Business'; // Replace with your dynamic title
    return WebViewScreen(title: title, url: url);
  }

  Widget postListWidget() {
    String url = '${AppConstants.baseUrl}/posts/list';
    String title = 'Rent/Sales'; // Replace with your dynamic title
    return WebViewScreen(title: title, url: url);
  }
  Widget jobListWidget() {
    String url = '${AppConstants.baseUrl}/vacancies/list';
    String title = 'Jobs/Vaccancies'; // Replace with your dynamic title
    return WebViewScreen(title: title, url: url);
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_pageIndex != 0) {
          _setPage(0);
          return false;
        } else {
          if (!ResponsiveHelper.isDesktop(context) &&
              Get.find<SplashController>().module != null &&
              Get.find<SplashController>().configModel!.module == null) {
            Get.find<SplashController>().setModule(null);
            return false;
          } else {
            if (_canExit) {
              return true;
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('back_press_again_to_exit'.tr, style: const TextStyle(color: Colors.white)),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
                margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              ));
              _canExit = true;
              Timer(const Duration(seconds: 2), () {
                _canExit = false;
              });
              return false;
            }
          }
        }
      },
      child: GetBuilder<OrderController>(
        builder: (orderController) {
          List<OrderModel> runningOrder = orderController.runningOrderModel != null ? orderController.runningOrderModel!.orders! : [];

          List<OrderModel> reversOrder = List.from(runningOrder.reversed);

          return Scaffold(
            key: _scaffoldKey,
            endDrawer: const MenuScreenNew(),
            // floatingActionButton: FloatingActionButton(
            //   elevation: 5,
            //   backgroundColor: _pageIndex == 2 ? Theme.of(context).primaryColor : Theme.of(context).cardColor,
            //   onPressed: () {
            //     String url = '${AppConstants.baseUrl}/vacancies/list';
            //     String title = 'Jobs';
            //     Get.to(
            //       WebViewScreen(title: title, url: url),
            //       binding: BindingsBuilder(
            //             () {},
            //       ),
            //     );
            //   },
            //   child: CartWidget(color: _pageIndex == 2 ? Theme.of(context).cardColor : Theme.of(context).disabledColor, size: 30),
            // ),
            // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: BottomAppBar(
              elevation: 5,
              notchMargin: 5,
              color: Theme.of(context).cardColor,
              clipBehavior: Clip.antiAlias,
              shape: const CircularNotchedRectangle(),
              child: Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                child: Row(children: [
                  BottomNavItem(iconData: Icons.home, isSelected: _pageIndex == 0, onTap: () => _setPage(0)),
                  BottomNavItem(iconData: Icons.favorite, isSelected: _pageIndex == 1, onTap: () => _setPage(1)),
                  BottomNavItem(iconData: Icons.cases_outlined, isSelected: _pageIndex == 2, onTap: () => _setPage(2)),
                  // const Expanded(child: SizedBox()),
                  BottomNavItem(iconData: Icons.home, isSelected: _pageIndex == 3, onTap: () => _setPage(3)),
                  BottomNavItem(iconData: Icons.menu, isSelected: _pageIndex == 4, onTap: () => _setPage(4)),
                ]),
              ),
            ),
            body: ExpandableBottomSheet(
              background: PageView.builder(
                controller: _pageController,
                itemCount: _screens.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return _screens[index];
                },
              ),
              persistentContentHeight: 100,
              onIsContractedCallback: () {
                if (!orderController.showOneOrder) {
                  orderController.showOrders();
                }
              },
              onIsExtendedCallback: () {
                if (orderController.showOneOrder) {
                  orderController.showOrders();
                }
              },
              enableToggle: true,
              expandableContent: (ResponsiveHelper.isDesktop(context) || !_isLogin ||
                  orderController.runningOrderModel == null ||
                  orderController.runningOrderModel!.orders!.isEmpty ||
                  !orderController.showBottomSheet)
                  ? const SizedBox()
                  : Dismissible(
                key: UniqueKey(),
                onDismissed: (direction) {
                  if (orderController.showBottomSheet) {
                    orderController.showRunningOrders();
                  }
                },
                child: RunningOrderViewWidget(reversOrder: reversOrder, onOrderTap: () {
                  _setPage(3);
                  if (orderController.showBottomSheet) {
                    orderController.showRunningOrders();
                  }
                }),
              ),
            ),
          );
        },
      ),
    );
  }

  void _setPage(int pageIndex) {
    setState(() {
      _pageController!.jumpToPage(pageIndex);
      _pageIndex = pageIndex;
    });
  }

  Widget trackView(BuildContext context, {required bool status}) {
    return Container(height: 3, decoration: BoxDecoration(color: status ? Theme.of(context).primaryColor
        : Theme.of(context).disabledColor.withOpacity(0.5), borderRadius: BorderRadius.circular(Dimensions.radiusDefault)));
  }
}

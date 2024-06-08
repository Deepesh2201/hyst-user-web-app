import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/controller/location_controller.dart';
import 'package:sixam_mart/controller/notification_controller.dart';
import 'package:sixam_mart/controller/splash_controller.dart';
import 'package:sixam_mart/controller/store_controller.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/view/base/item_view.dart';
import 'package:sixam_mart/view/base/paginated_list_view.dart';
import 'package:sixam_mart/view/screens/home/home_screen.dart';
import 'package:sixam_mart/view/screens/home/theme1/banner_view1.dart';
import 'package:sixam_mart/view/screens/home/theme1/best_reviewed_item_view.dart';
import 'package:sixam_mart/view/screens/home/theme1/category_view1.dart';
import 'package:sixam_mart/view/screens/home/theme1/item_campaign_view1.dart';
import 'package:sixam_mart/view/screens/home/theme1/popular_item_view1.dart';
import 'package:sixam_mart/view/screens/home/theme1/popular_store_view1.dart';
import 'package:sixam_mart/view/screens/home/widget/filter_view.dart';
import 'package:sixam_mart/view/screens/home/widget/module_view.dart';

import '../../../controller/auth_controller.dart';
import '../../../controller/custom_banner_controller.dart';
import '../../../controller/category_controller.dart';
import '../../../controller/parcel_controller.dart';
import '../../../controller/user_controller.dart';
import '../home/widget/custom_banner_view.dart';

class PostFullListScreen extends StatelessWidget {

  const PostFullListScreen({Key? key}) : super(key: key);
  static Future<void> loadData(bool reload) async {
    // Get.find<LocationController>().syncZoneData();
    // if(Get.find<SplashController>().module != null && !Get.find<SplashController>().configModel!.moduleConfig!.module!.isParcel!) {
      Get.find<CustomBannerController>().getBannerList(reload);
      // Get.find<CategoryController>().getCategoryList(reload);
      // Get.find<StoreController>().getPopularStoreList(reload, 'all', false);
      // Get.find<CampaignController>().getItemCampaignList(reload);
      // Get.find<ItemController>().getPopularItemList(reload, 'all', false);
      // Get.find<StoreController>().getLatestStoreList(reload, 'all', false);
      // Get.find<ItemController>().getReviewedItemList(reload, 'all', false);
      // Get.find<StoreController>().getStoreList(1, reload);
    // }
    if(Get.find<AuthController>().isLoggedIn()) {
      Get.find<UserController>().getUserInfo();
      Get.find<NotificationController>().getNotificationList(reload);
    }
    Get.find<SplashController>().getModules();
    if(Get.find<SplashController>().module == null && Get.find<SplashController>().configModel!.module == null) {
      Get.find<CustomBannerController>().getFeaturedBanner();
      Get.find<StoreController>().getFeaturedStoreList();
      if(Get.find<AuthController>().isLoggedIn()) {
        Get.find<LocationController>().getAddressList();
      }
    }
    if(Get.find<SplashController>().module != null && Get.find<SplashController>().configModel!.moduleConfig!.module!.isParcel!) {
      Get.find<ParcelController>().getParcelCategoryList();
    }
  }

  @override
  Widget build(BuildContext context) {
    loadData(true);
    final ScrollController scrollController = ScrollController();

    return CustomScrollView(
      controller: scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: const [

        // App Bar
        SliverAppBar(
          backgroundColor: Colors.red,
          title: Text('Rent/Sales'),
        ),

        SliverToBoxAdapter(
          child: Center(child: SizedBox(
            width: Dimensions.webMaxWidth,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              // CustomBannerView(isFeatured: true),

              // const CategoryView1(),
              // const ItemCampaignView1(),
              // const BestReviewedItemView(),
              // const PopularStoreView1(isPopular: true, isFeatured: false),
              // const PopularItemView1(isPopular: true),
              // const PopularStoreView1(isPopular: false, isFeatured: false),
              //
              // Padding(
              //   padding: const EdgeInsets.fromLTRB(10, 15, 0, 5),
              //   child: Row(children: [
              //     Expanded(child: Text(
              //       Get.find<SplashController>().configModel!.moduleConfig!.module!.showRestaurantText!
              //           ? 'all_restaurants'.tr : 'all_stores'.tr,
              //       style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
              //     )),
              //     const FilterView(),
              //   ]),
              // ),

              // GetBuilder<StoreController>(builder: (storeController) {
              //   return PaginatedListView(
              //     scrollController: scrollController,
              //     totalSize: storeController.storeModel != null ? storeController.storeModel!.totalSize : null,
              //     offset: storeController.storeModel != null ? storeController.storeModel!.offset : null,
              //     onPaginate: (int? offset) async => await storeController.getStoreList(offset!, false),
              //     itemView: ItemsView(
              //       isStore: true, items: null, showTheme1Store: true,
              //       stores: storeController.storeModel != null ? storeController.storeModel!.stores : null,
              //       padding: EdgeInsets.symmetric(
              //         horizontal: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeExtraSmall : Dimensions.paddingSizeSmall,
              //         vertical: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeExtraSmall : 0,
              //       ),
              //     ),
              //   );
              // }),

            ]),
          )),
        ),
      ],
    );
  }
}

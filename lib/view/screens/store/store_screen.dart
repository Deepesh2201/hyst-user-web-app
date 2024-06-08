import 'package:flutter/rendering.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sixam_mart/controller/auth_controller.dart';
import 'package:sixam_mart/controller/cart_controller.dart';
import 'package:sixam_mart/controller/category_controller.dart';
import 'package:sixam_mart/controller/item_controller.dart';
import 'package:sixam_mart/controller/localization_controller.dart';
import 'package:sixam_mart/controller/store_controller.dart';
import 'package:sixam_mart/controller/splash_controller.dart';
import 'package:sixam_mart/controller/wishlist_controller.dart';
import 'package:sixam_mart/data/model/response/category_model.dart';
import 'package:sixam_mart/data/model/response/item_model.dart';
import 'package:sixam_mart/data/model/response/store_model.dart';
import 'package:sixam_mart/helper/date_converter.dart';
import 'package:sixam_mart/helper/price_converter.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/view/base/custom_button.dart';
import 'package:sixam_mart/view/base/custom_image.dart';
import 'package:sixam_mart/view/base/custom_snackbar.dart';
import 'package:sixam_mart/view/base/footer_view.dart';
import 'package:sixam_mart/view/base/item_view.dart';
import 'package:sixam_mart/view/base/item_widget.dart';
import 'package:sixam_mart/view/base/menu_drawer.dart';
import 'package:sixam_mart/view/base/paginated_list_view.dart';
import 'package:sixam_mart/view/base/veg_filter_widget.dart';
import 'package:sixam_mart/view/base/web_item_view.dart';
import 'package:sixam_mart/view/base/web_item_widget.dart';
import 'package:sixam_mart/view/base/web_menu_bar.dart';
import 'package:sixam_mart/view/screens/checkout/checkout_screen.dart';
import 'package:sixam_mart/view/screens/search/widget/custom_check_box.dart';
import 'package:sixam_mart/view/screens/store/widget/ShiningDiscountTag.dart';
import 'package:sixam_mart/view/screens/store/widget/StoreDetailsWidget.dart';
import 'package:sixam_mart/view/screens/store/widget/customizable_space_bar.dart';
import 'package:sixam_mart/view/screens/store/widget/store_description_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../util/app_constants.dart';
import 'widget/bottom_cart_widget.dart';
import 'package:universal_html/html.dart' as html;

class StoreScreen extends StatefulWidget {
  final Store? store;
  final bool fromModule;
  final String slug;
  const StoreScreen({Key? key, required this.store, required this.fromModule, this.slug = ''}) : super(key: key);

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  final ScrollController scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    initDataCall();
  }

  @override
  void dispose() {
    super.dispose();

    scrollController.dispose();
  }

  Future<void> initDataCall() async {

    if(Get.find<StoreController>().isSearching) {
      Get.find<StoreController>().changeSearchStatus(isUpdate: false);
    }
    Get.find<StoreController>().hideAnimation();
    await Get.find<StoreController>().getStoreDetails(Store(id: widget.store!.id), widget.fromModule, slug: widget.slug).then((value) {
      Get.find<StoreController>().showButtonAnimation();
    });
    if(Get.find<CategoryController>().categoryList == null) {
      Get.find<CategoryController>().getCategoryList(true);
    }
    Get.find<StoreController>().getRestaurantRecommendedItemList(widget.store!.id ?? Get.find<StoreController>().store!.id, false);
    Get.find<StoreController>().getStoreItemList(widget.store!.id ?? Get.find<StoreController>().store!.id, 1, 'all', false);

    scrollController.addListener(() {
      if(scrollController.position.userScrollDirection == ScrollDirection.reverse){
        if(Get.find<StoreController>().showFavButton){
          Get.find<StoreController>().changeFavVisibility();
          Get.find<StoreController>().hideAnimation();
        }
      }else{
        if(!Get.find<StoreController>().showFavButton){
          Get.find<StoreController>().changeFavVisibility();
          Get.find<StoreController>().showButtonAnimation();
        }
      }
    });
  }
  void _launchWebsite(String website) async {
    // const url = 'https://google.com'; // Replace with the URL you want to open
    final Uri uri = Uri.parse(website); // Parse the URL string into a Uri object
    if (await canLaunch(uri.toString())) {
      await launch(uri.toString());
    } else {
      throw 'Could not launch $uri';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context) ? const WebMenuBar() : null,
      endDrawer: const MenuDrawer(),endDrawerEnableOpenDragGesture: false,
      backgroundColor: Theme.of(context).colorScheme.background,
      body: GetBuilder<StoreController>(builder: (storeController) {
        return GetBuilder<CategoryController>(builder: (categoryController) {
          Store? store;
          if(storeController.store != null && storeController.store!.name != null && categoryController.categoryList != null) {
            store = storeController.store;
            storeController.setCategoryList();
          }

          return (storeController.store != null && storeController.store!.name != null && categoryController.categoryList != null) ? CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: scrollController,
            slivers: [

              ResponsiveHelper.isDesktop(context) ? SliverToBoxAdapter(
                child: Container(
                  color: const Color(0xFF171A29),
                  padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                  alignment: Alignment.center,
                  child: Center(child: SizedBox(width: Dimensions.webMaxWidth, child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                    child: Row(children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                          child: CustomImage(
                            fit: BoxFit.contain,
                            image: '${Get.find<SplashController>().configModel!.baseUrls!.storeCoverPhotoUrl}/${store!.logo}',
                          ),
                        ),
                      ),
                      const SizedBox(width: Dimensions.paddingSizeLarge),

                      Expanded(child: StoreDescriptionView(store: store)),

                    ]),
                  ))),
                ),

              ) : SliverAppBar(
                expandedHeight: 250, toolbarHeight: 100,
                pinned: true, floating: false, elevation: 0.5,
                backgroundColor: Theme.of(context).cardColor,
                leading: IconButton(
                  icon: Container(
                    height: 50, width: 50,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).primaryColor),
                    alignment: Alignment.center,
                    child: Icon(Icons.chevron_left, color: Theme.of(context).cardColor),
                  ),
                  onPressed: () => Get.back(),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: EdgeInsets.zero,
                  centerTitle: true,
                  expandedTitleScale: 1.1,
                  title: CustomizableSpaceBar(
                    builder: (context, scrollingRate) {
                      return Container(
                        height: 100,
                        color: Theme.of(context).cardColor,
                        child: Container(
                          color: Theme.of(context).cardColor.withOpacity(scrollingRate),
                          padding: EdgeInsets.only(
                            bottom: 0,
                            left: Get.find<LocalizationController>().isLtr ? 40 * scrollingRate : 0,
                            right: Get.find<LocalizationController>().isLtr ? 0 : 40 * scrollingRate,
                          ),
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Container(
                              height: 100, color: Theme.of(context).cardColor.withOpacity(scrollingRate == 0.0 ? 1 : 0),
                              padding: EdgeInsets.only(
                                left: Get.find<LocalizationController>().isLtr ? 20 : 0,
                                right: Get.find<LocalizationController>().isLtr ? 0 : 20,
                              ),
                              child: Row(children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                  child: Stack(children: [
                                    CustomImage(
                                      image: '${Get.find<SplashController>().configModel!.baseUrls!.storeImageUrl}/${store!.logo}',
                                      height: 60 - (scrollingRate * 15), width: 70 - (scrollingRate * 15), fit: BoxFit.contain,
                                    ),

                                    storeController.isStoreOpenNow(store.active!, store.schedules) ? const SizedBox() : Positioned(
                                      bottom: 0, left: 0, right: 0,
                                      child: Container(
                                        height: 30,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(Dimensions.radiusSmall)),
                                          color: Colors.black.withOpacity(0.6),
                                        ),
                                        child: Text(
                                          'closed_now'.tr, textAlign: TextAlign.center,
                                          style: robotoRegular.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeSmall),
                                        ),
                                      ),
                                    ),
                                  ]),
                                ),
                                const SizedBox(width: Dimensions.paddingSizeSmall),

                                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.center, children: [
                                  Row(children: [
                                    Expanded(child: Text(
                                      store.name!, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge - (scrollingRate * 3), color: Theme.of(context).textTheme.bodyMedium!.color),
                                      maxLines: 1, overflow: TextOverflow.ellipsis,
                                    )),
                                    const SizedBox(width: Dimensions.paddingSizeSmall),

                                  ]),
                                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                                  Text(
                                    store.address ?? '', maxLines: 1, overflow: TextOverflow.ellipsis,
                                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall - (scrollingRate * 2), color: Theme.of(context).disabledColor),
                                  ),
                                  SizedBox(height: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeExtraSmall : 0),
                                  // Row(children: [
                                  //   Text('minimum_order'.tr, style: robotoRegular.copyWith(
                                  //     fontSize: Dimensions.fontSizeExtraSmall - (scrollingRate * 2), color: Theme.of(context).disabledColor,
                                  //   )),
                                  //   const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                                  //   Text(
                                  //     PriceConverter.convertPrice(store.minimumOrder), textDirection: TextDirection.ltr,
                                  //     style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall - (scrollingRate * 2), color: Theme.of(context).primaryColor),
                                  //   ),
                                  // ]),
                                ])),

                                GetBuilder<WishListController>(builder: (wishController) {
                                  bool isWished = wishController.wishStoreIdList.contains(store!.id);
                                  return InkWell(
                                    onTap: () {
                                      if(Get.find<AuthController>().isLoggedIn()) {
                                        isWished ? wishController.removeFromWishList(store!.id, true)
                                            : wishController.addToWishList(null, store, true);
                                      }else {
                                        showCustomSnackBar('you_are_not_logged_in'.tr);
                                      }
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                      ),
                                      padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                                      child: Icon(
                                        isWished ? Icons.favorite : Icons.favorite_border,
                                        color: isWished ? Theme.of(context).primaryColor : Theme.of(context).disabledColor,
                                        size: 24  - (scrollingRate * 4),
                                      ),
                                    ),
                                  );
                                }),
                                const SizedBox(width: Dimensions.paddingSizeSmall),

                                InkWell(
                                  onTap: (){
                                    if(store!.slug != null && store.slug!.isNotEmpty) {
                                      String? hostname = html.window.location.hostname;
                                      String protocol = html.window.location.protocol;
                                      // String shareUrl = '$protocol//$hostname${Get.find<StoreController>().filteringUrl(store!.slug!)}';
                                      String shareUrl =
                                          'https://play.google.com/store/apps/details?id=${AppConstants.packageId}';
                                      Share.share(shareUrl);
                                    } else {
                                      showCustomSnackBar('you_can_not_copy_url_as_no_slug_available_for_the_store'.tr);
                                    }

                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                    ),
                                    padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                                    child: Icon(
                                      Icons.share, size: 24  - (scrollingRate * 4),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: Dimensions.paddingSizeSmall),

                              ]),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  background: CustomImage(
                    // fit: BoxFit.none,
                    image: '${Get.find<SplashController>().configModel!.baseUrls!.storeCoverPhotoUrl}/${store!.coverPhoto}',
                    height: 60, width: 70, fit: BoxFit.contain,
                  ),
                ),
                actions: const [
                  SizedBox(),
                ],
              ),

              (ResponsiveHelper.isDesktop(context)  && storeController.recommendedItemModel != null && storeController.recommendedItemModel!.items!.isNotEmpty) ?
              SliverToBoxAdapter(
                child: Container(
                  color: Theme.of(context).primaryColor.withOpacity(0.10),
                  child: Center(
                    child: SizedBox(
                      width: Dimensions.webMaxWidth,
                      height: ResponsiveHelper.isDesktop(context) ? 300 : 125,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                          Text('recommended'.tr, style: robotoMedium),
                          const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                          SizedBox(
                            height: 250,
                            child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: storeController.recommendedItemModel!.items!.length,
                              physics: const BouncingScrollPhysics(),
                              padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
                              itemBuilder: (context, index) {
                                return Container(
                                  width:  225,
                                  padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall, left: Dimensions.paddingSizeExtraSmall),
                                  margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                                  child: WebItemWidget(
                                    isStore: false, item: storeController.recommendedItemModel!.items![index],
                                    store: null, index: index, length: null, isCampaign: false, inStore: true,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ): const SliverToBoxAdapter(child: SizedBox()),
              const SliverToBoxAdapter(child: SizedBox(height: Dimensions.paddingSizeSmall)),

              ResponsiveHelper.isDesktop(context) ? SliverToBoxAdapter(
                child: FooterView(
                  child: SizedBox(
                    width: Dimensions.webMaxWidth,
                    child: Padding(
                      padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 175,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    itemCount: storeController.categoryList!.length,
                                    padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall),
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () {
                                          storeController.setCategoryIndex(index, itemSearching: storeController.isSearching);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.bottomRight,
                                                end: Alignment.topLeft,
                                                colors: <Color>[
                                                  index == storeController.categoryIndex ? Theme.of(context).primaryColor.withOpacity(0.50) : Colors.transparent,
                                                  index == storeController.categoryIndex ? Theme.of(context).cardColor : Colors.transparent,
                                                ]
                                              )
                                            ),
                                            child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
                                              Text(
                                                storeController.categoryList![index].name!,
                                                maxLines: 1, overflow: TextOverflow.ellipsis,
                                                style: index == storeController.categoryIndex
                                                    ? robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor)
                                                    : robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                                              ),
                                            ]),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),

                                Container(
                                  height: storeController.categoryList!.length * 50, width: 1,
                                  color: Theme.of(context).disabledColor.withOpacity(0.5),
                                ),
                              ],
                            ),
                          ),
                           const SizedBox(width: Dimensions.paddingSizeLarge),

                           Expanded(child: Column (
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                                    height: 45,
                                    width: 430,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                      color: Theme.of(context).cardColor,
                                      border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.40)),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: TextField(
                                            controller: _searchController,
                                            textInputAction: TextInputAction.search,
                                            decoration: InputDecoration(
                                              contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                                              hintText: 'search_for_items'.tr,
                                              hintStyle: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall), borderSide: BorderSide.none),
                                              filled: true, fillColor:Theme.of(context).cardColor,
                                              isDense: true,
                                              prefixIcon: Icon(Icons.search, color: Theme.of(context).primaryColor.withOpacity(0.50)),
                                            ),
                                             onSubmitted: (String? value) {
                                              if(value!.isNotEmpty) {
                                                Get.find<StoreController>().getStoreSearchItemList(
                                                  _searchController.text.trim(), widget.store!.id.toString(), 1, storeController.type,
                                                );
                                              }
                                             } ,
                                             onChanged: (String? value) { } ,
                                          ),
                                        ),
                                        const SizedBox(width: Dimensions.paddingSizeSmall),

                                        !storeController.isSearching ? CustomButton(
                                          radius: Dimensions.radiusSmall,
                                          height: 40,
                                          width: 74,
                                          buttonText: 'search'.tr,
                                          isBold: false,
                                          fontSize: Dimensions.fontSizeSmall,
                                          onPressed: () {
                                            storeController.getStoreSearchItemList(
                                              _searchController.text.trim(), widget.store!.id.toString(), 1, storeController.type,
                                            );
                                          },
                                        ) : InkWell(onTap: () {
                                          _searchController.text = '';
                                          // storeController.initSearchData();
                                          storeController.changeSearchStatus();
                                        },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Theme.of(context).primaryColor,
                                              borderRadius: BorderRadius.circular(Dimensions.radiusSmall)
                                            ),
                                            padding: const EdgeInsets.symmetric(vertical: 3, horizontal: Dimensions.paddingSizeSmall),
                                            child: const Icon(Icons.clear, color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: Dimensions.paddingSizeSmall),

                                  (Get.find<SplashController>().configModel!.moduleConfig!.module!.vegNonVeg! && Get.find<SplashController>().configModel!.toggleVegNonVeg!)
                                  ? SizedBox(
                                    width: 300,
                                    height:  30,
                                    child:  ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      // itemCount: Get.find<ItemController>().itemTypeList.length,
                                      padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall),
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        // return InkWell(
                                        //   // onTap: () => storeController.setCategoryIndex(index),
                                        //   child: Padding(
                                        //     padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                                        //     child:  CustomCheckBox(
                                        //       // title: Get.find<ItemController>().itemTypeList[index].tr,
                                        //       // value: storeController.type == Get.find<ItemController>().itemTypeList[index],
                                        //       onClick: () {
                                        //         if(storeController.isSearching){
                                        //           storeController.getStoreSearchItemList(
                                        //             storeController.searchText, widget.store!.id.toString(), 1, Get.find<ItemController>().itemTypeList[index],
                                        //           );
                                        //         } else {
                                        //           storeController.getStoreItemList(storeController.store!.id, 1, Get.find<ItemController>().itemTypeList[index], true);
                                        //         }
                                        //       },
                                        //     ),
                                        //   ),
                                        // );
                                      },
                                    ),
                                  ) : const SizedBox(),
                                ],
                              ),
                              const SizedBox(height: Dimensions.paddingSizeSmall),

                              PaginatedListView(
                                scrollController: scrollController,
                                onPaginate: (int? offset) {
                                  if(storeController.isSearching){
                                    storeController.getStoreSearchItemList(
                                      storeController.searchText, widget.store!.id.toString(), offset!, storeController.type,
                                    );
                                  } else {
                                    storeController.getStoreItemList(widget.store!.id, offset!, storeController.type, false);
                                  }
                                },
                                totalSize: storeController.isSearching
                                    ? storeController.storeSearchItemModel != null ? storeController.storeSearchItemModel!.totalSize : null
                                    : storeController.storeItemModel != null ? storeController.storeItemModel!.totalSize : null,
                                offset: storeController.isSearching
                                    ? storeController.storeSearchItemModel != null ? storeController.storeSearchItemModel!.offset : null
                                    : storeController.storeItemModel != null ? storeController.storeItemModel!.offset : null,
                                itemView: WebItemsView(
                                  isStore: false, stores: null, fromStore: true,
                                  items: storeController.isSearching
                                      ? storeController.storeSearchItemModel != null ? storeController.storeSearchItemModel!.items : null
                                      : (storeController.categoryList!.isNotEmpty && storeController.storeItemModel != null) ? storeController.storeItemModel!.items : null,
                                  inStorePage: true,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: Dimensions.paddingSizeSmall,
                                    vertical: Dimensions.paddingSizeSmall,
                                  ),
                                ),
                              ),
                            ],
                          ))

                        ],
                      ),
                    ),
                  ),
                ),
              ) : const SliverToBoxAdapter(child:SizedBox()),

              ResponsiveHelper.isDesktop(context) ? const SliverToBoxAdapter(child:SizedBox()) :
              SliverToBoxAdapter(child: Center(child: Container(
                width: Dimensions.webMaxWidth,
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                color: Theme.of(context).cardColor,
                child: Column(children: [
                  ResponsiveHelper.isDesktop(context) ? const SizedBox() : StoreDescriptionView(store: store),
                  // store.discount != null ? Container(
                  //   width: context.width,
                  //   margin: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                  //   decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusSmall), color: Theme.of(context).primaryColor),
                  //   padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  //   child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  //     // Text(
                  //     //   store.discount!.discountType == 'percent' ? '${store.discount!.discount}% ${'off'.tr}'
                  //     //       : '${PriceConverter.convertPrice(store.discount!.discount)} ${'off'.tr}',
                  //     //   style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).cardColor),
                  //     //     textDirection: TextDirection.ltr,
                  //     // ),
                  //     store.discount!.discountType == 'percent' ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  //     //   Text(
                  //     //     'enjoy'.tr,
                  //     //     style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).cardColor),
                  //     //   ),
                  //
                  //       // Text(
                  //       //     '${store.discount!.discount}% ',
                  //       //     style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).cardColor), textDirection: TextDirection.ltr,
                  //       //   ),
                  //       // Text(
                  //       //     'off_on_all_categories'.tr,
                  //       //     style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).cardColor),
                  //       //   ),
                  //       ],
                  //     ) : Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  //       // Text(
                  //       //   'enjoy'.tr,
                  //       //   style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).cardColor),
                  //       // ),
                  //       //
                  //       // Text(
                  //       //   PriceConverter.convertPrice(store.discount!.discount),
                  //       //   style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).cardColor), textDirection: TextDirection.ltr,
                  //       // ),
                  //       // Text(
                  //       //   ' ${'off_on_all_categories'.tr}',
                  //       //   style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).cardColor),
                  //       // ),
                  //     ]),
                  //     SizedBox(height: (store.discount!.minPurchase != 0 || store.discount!.maxDiscount != 0) ? 5 : 0),
                  //     // store.discount!.minPurchase != 0 ? Text(
                  //     //   '[ ${'minimum_purchase'.tr}: ${PriceConverter.convertPrice(store.discount!.minPurchase)} ]',
                  //     //   style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).cardColor), textDirection: TextDirection.ltr,
                  //     // ) : const SizedBox(),
                  //     // store.discount!.maxDiscount != 0 ? Text(
                  //     //   '[ ${'maximum_discount'.tr}: ${PriceConverter.convertPrice(store.discount!.maxDiscount)} ]',
                  //     //   style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).cardColor), textDirection: TextDirection.ltr,
                  //     // ) : const SizedBox(),
                  //     // Text(
                  //     //   '[ ${'daily_time'.tr}: ${DateConverter.convertTimeToTime(store.discount!.startTime!)} '
                  //     //       '- ${DateConverter.convertTimeToTime(store.discount!.endTime!)} ]',
                  //     //   style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).cardColor),
                  //     // ),
                  //   ]),
                  // ) : const SizedBox(),
                  // const SizedBox(height: Dimensions.paddingSizeLarge),

                  // (!ResponsiveHelper.isDesktop(context) && storeController.recommendedItemModel != null && storeController.recommendedItemModel!.items!.isNotEmpty) ? Column(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     Text('recommended_items'.tr, style: robotoMedium),
                  //     const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                  //
                  //     SizedBox(
                  //       height: ResponsiveHelper.isDesktop(context) ? 150 : 125,
                  //       child: ListView.builder(
                  //         scrollDirection: Axis.horizontal,
                  //         itemCount: storeController.recommendedItemModel!.items!.length,
                  //         physics: const BouncingScrollPhysics(),
                  //         itemBuilder: (context, index) {
                  //           return Padding(
                  //             padding: ResponsiveHelper.isDesktop(context) ? const EdgeInsets.symmetric(vertical: 20) : const EdgeInsets.symmetric(vertical: 10) ,
                  //             child: Container(
                  //               width: ResponsiveHelper.isDesktop(context) ? 500 : 300,
                  //               padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall, left: Dimensions.paddingSizeExtraSmall),
                  //               margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                  //               child: ItemWidget(
                  //                 isStore: false, item: storeController.recommendedItemModel!.items![index],
                  //                 store: null, index: index, length: null, isCampaign: false, inStore: true,
                  //               ),
                  //             ),
                  //           );
                  //         },
                  //       ),
                  //     ),
                  //   ],
                  // ) : const SizedBox(),
                ]),
              ))),

              ResponsiveHelper.isDesktop(context) ? const SliverToBoxAdapter(child:SizedBox()) :
              (storeController.categoryList!.isNotEmpty) ? SliverPersistentHeader(
                pinned: true,
                delegate: SliverDelegate(height: 70, child: Center(child: Container(
                  width: Dimensions.webMaxWidth,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 700 : 300]!, spreadRadius: 1, blurRadius: 5)],
                  ),
                  padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                        child: Row(
                          children: [
                            // Text('About Store', style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault)),
                            const Expanded(child: SizedBox()),
                            ShiningDiscountTag(percentage: store!.offerPercentage), // Change '60' to your actual discount percentage
                            const SizedBox(width: 16), // Add space between buttons
                           if(store?.website_link != null) ...[ ElevatedButton(
                              onPressed: () {
                                String? website = store?.website_link;
                                _launchWebsite(website!);
                                // Define the action to be performed when the button is pressed
                                // For example, you can navigate to another screen or perform some other action.
                                // Example: Navigator.push(context, MaterialPageRoute(builder: (context) => NextScreen()));

                              },
                              child: Text(
                                'Visit Website', // Text displayed on the button
                                style: TextStyle(fontSize: 14), // Adjust the font size as needed
                              ),
                            ),
                            ],
                          ],
                        ),
                      )

                      // const SizedBox(height: Dimensions.paddingSizeSmall),

                      // SizedBox(
                      //   height: 30,
                      //   child: ListView.builder(
                      //     scrollDirection: Axis.horizontal,
                      //     itemCount: storeController.categoryList!.length,
                      //     padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall),
                      //     physics: const BouncingScrollPhysics(),
                      //     itemBuilder: (context, index) {
                      //       return InkWell(
                      //         onTap: () => storeController.setCategoryIndex(index),
                      //         child: Container(
                      //           padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
                      //           margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                      //           decoration: BoxDecoration(
                      //             borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      //             color: index == storeController.categoryIndex ? Theme.of(context).primaryColor.withOpacity(0.1) : Colors.transparent,
                      //           ),
                      //           child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      //             Text(
                      //               storeController.categoryList![index].name!,
                      //               style: index == storeController.categoryIndex
                      //                   ? robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor)
                      //                   : robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                      //             ),
                      //           ]),
                      //         ),
                      //       );
                      //     },
                      //   ),
                      // ),
                    ],
                  ),
                ))),
              ) : const SliverToBoxAdapter(child: SizedBox()),

              ResponsiveHelper.isDesktop(context) ? const SliverToBoxAdapter(child:SizedBox()) :
              SliverToBoxAdapter(child: Container(
                width: Dimensions.webMaxWidth,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                ),
                // child: PaginatedListView(
                //   scrollController: scrollController,
                //   onPaginate: (int? offset) => storeController.getStoreItemList(widget.store!.id, offset!, storeController.type, false),
                //   totalSize: storeController.storeItemModel != null ? storeController.storeItemModel!.totalSize : null,
                //   offset: storeController.storeItemModel != null ? storeController.storeItemModel!.offset : null,
                //   itemView: ItemsView(
                //     isStore: false, stores: null,
                //     items: (storeController.categoryList!.isNotEmpty && storeController.storeItemModel != null)
                //         ? storeController.storeItemModel!.items : null,
                //     inStorePage: true,
                //     padding: const EdgeInsets.symmetric(
                //       horizontal: Dimensions.paddingSizeSmall,
                //       vertical: Dimensions.paddingSizeSmall,
                //     ),
                //   ),
                // ),
          child: Padding(
          padding: const EdgeInsets.all(16.0), // Add padding from all sides

          child: StoreDetailsWidget(

                  // name: store.name ?? '',
                  address: store.address ?? '',
                  // website: Uri.parse(store.website_link ?? ''),
                  phone: store.phone ?? '',
                  email: store.email ?? '',
                  description: store.meta_description ?? '',
                  gmap: Uri.parse(store.map_location_link ?? ''),
                  offerDescription: store.offerPercentageDescription,
                  offerBanner: '${AppConstants.baseUrl}/${store.offerImage ?? ''}',

          ),

              )),
              )
            ],
          ) : const Center(child: CircularProgressIndicator());
        });
      }),

      floatingActionButton: GetBuilder<StoreController>(
        builder: (storeController) {
          return Visibility(
            visible: storeController.showFavButton && Get.find<SplashController>().configModel!.moduleConfig!.module!.orderAttachment!
                && (storeController.store != null && storeController.store!.prescriptionOrder!) && Get.find<SplashController>().configModel!.prescriptionStatus!,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                boxShadow: [BoxShadow(color: Theme.of(context).primaryColor.withOpacity(0.5), blurRadius: 10, offset: const Offset(2, 2))],
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [

                AnimatedContainer(
                  duration: const Duration(milliseconds: 800),
                  width: storeController.currentState == true ? 0 : ResponsiveHelper.isDesktop(context) ? 180 : 150,
                  height: 30,
                  curve: Curves.linear,
                  child:  Center(
                    child: Text(
                      'prescription_order'.tr, textAlign: TextAlign.center,
                      style: robotoMedium.copyWith(color: Theme.of(context).primaryColor), maxLines: 1, overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),

                InkWell(
                  onTap: () => Get.toNamed(
                    RouteHelper.getCheckoutRoute('prescription', storeId: storeController.store!.id),
                    arguments: CheckoutScreen(fromCart: false, cartList: null, storeId: storeController.store!.id),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    ),
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    child: Image.asset(Images.prescriptionIcon, height: 25, width: 25),
                  ),
                ),

              ]),
            ),
          );
        }
      ),

      // bottomNavigationBar: GetBuilder<CartController>(builder: (cartController) {
      //   return cartController.cartList.isNotEmpty && !ResponsiveHelper.isDesktop(context) ? const BottomCartWidget() : const SizedBox();
      // })
    );

  }

}



class SliverDelegate extends SliverPersistentHeaderDelegate {
  Widget child;
  double height;

  SliverDelegate({required this.child, this.height = 100});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(SliverDelegate oldDelegate) {
    return oldDelegate.maxExtent != height || oldDelegate.minExtent != height || child != oldDelegate.child;
  }
}

class CategoryProduct {
  CategoryModel category;
  List<Item> products;
  CategoryProduct(this.category, this.products);
}




///----------
///
/// // Define a constructor that accepts the title and URL as parameters
//   const WebViewScreen({Key? key, this.title, this.url}) : super(key: key);
// Widget build(BuildContext context) {
//   return Scaffold(
//     body: Container(
//       margin: EdgeInsets.only(top: 32.0), // Adjust the top margin as needed
//       child: WebView(
//         initialUrl: url ?? 'https://backend.hyst.uk', // Use the provided URL or a default value
//         javascriptMode: JavascriptMode.unrestricted,
//       ),
//     ),
//   );
// }
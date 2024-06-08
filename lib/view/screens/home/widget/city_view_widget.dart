import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:sixam_mart/controller/auth_controller.dart';
import 'package:sixam_mart/controller/banner_controller.dart';
import 'package:sixam_mart/controller/location_controller.dart';
import 'package:sixam_mart/controller/splash_controller.dart';
import 'package:sixam_mart/data/model/response/address_model.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/view/base/custom_image.dart';
import 'package:sixam_mart/view/base/custom_loader.dart';
import 'package:sixam_mart/view/base/title_widget.dart';
import 'package:sixam_mart/view/screens/address/widget/address_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/view/screens/home/widget/banner_view.dart';
import 'package:sixam_mart/view/screens/home/widget/popular_store_view.dart';

import '../../../../helper/route_helper.dart';
import '../../splash/splash_screen.dart';
import '../home_screen.dart';
import 'module_view.dart';

class CityViewWidget extends StatelessWidget {
  final SplashController splashController;
  final city;
  final page;

  const CityViewWidget({
    Key? key,
    required this.splashController,
    required this.city,
    required this.page,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // City List
      if (city == 1)
        splashController.cityList != null
            ? GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: Dimensions.paddingSizeSmall,
            crossAxisSpacing: Dimensions.paddingSizeSmall,
            childAspectRatio: (1 / 1),
          ),
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          itemCount: splashController.cityList!.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () =>
                  Get.offNamed(RouteHelper.getAreaRoute(page)),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius:
                  BorderRadius.circular(Dimensions.radiusDefault),
                  color: Theme.of(context).cardColor,
                  border: Border.all(
                      color: Theme.of(context).primaryColor,
                      width: 0.25),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context)
                          .primaryColor
                          .withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 3,
                    )
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius:
                      BorderRadius.circular(Dimensions.radiusSmall),
                      child: CustomImage(
                        image:
                        '${splashController.configModel!.baseUrls!.moduleImageUrl}/${splashController.cityList![index].icon}',
                        height: 50,
                        width: 50,
                      ),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeSmall),
                    Center(
                      child: Text(
                        splashController.cityList![index].name!,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: robotoMedium.copyWith(
                            fontSize: Dimensions.fontSizeSmall),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        )
            : ModuleShimmer(isEnabled: splashController.cityList == null)
      else if (city == 2)
      // Area List

        splashController.areaList != null
            ? GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: Dimensions.paddingSizeSmall,
            crossAxisSpacing: Dimensions.paddingSizeSmall,
            childAspectRatio: (1 / 1),
          ),
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          itemCount: splashController.areaList!.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return InkWell(
              // onTap: () => HomeScreen.loadData(true),
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString('selectedArea', splashController.areaList![index].name!);
                // Get.to(() => HomeScreen(area: splashController.areaList![index].name!));
                Get.offAllNamed(RouteHelper.getInitialRoute());
              },

              child: Container(
                decoration: BoxDecoration(
                  borderRadius:
                  BorderRadius.circular(Dimensions.radiusDefault),
                  color: Theme.of(context).cardColor,
                  border: Border.all(
                      color: Theme.of(context).primaryColor,
                      width: 0.25),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context)
                          .primaryColor
                          .withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 3,
                    )
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius:
                      BorderRadius.circular(Dimensions.radiusSmall),
                      child: CustomImage(
                        image:
                        '${splashController.configModel!.baseUrls!.moduleImageUrl}/${splashController.areaList![index].icon}',
                        height: 50,
                        width: 50,
                      ),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeSmall),
                    Center(
                      child: Text(
                        splashController.areaList![index].name!,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: robotoMedium.copyWith(
                            fontSize: Dimensions.fontSizeSmall),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        )
            : ModuleShimmer(isEnabled: splashController.areaList == null),
    ]);
  }
}


class ModuleShimmer extends StatelessWidget {
  final bool isEnabled;
  const ModuleShimmer({Key? key, required this.isEnabled}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, mainAxisSpacing: Dimensions.paddingSizeSmall,
        crossAxisSpacing: Dimensions.paddingSizeSmall, childAspectRatio: (1/1),
      ),
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      itemCount: 6,
      shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            color: Theme.of(context).cardColor,
            boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 700 : 200]!, spreadRadius: 1, blurRadius: 5)],
          ),
          child: Shimmer(
            duration: const Duration(seconds: 2),
            enabled: isEnabled,
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

              Container(
                height: 50, width: 50,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusSmall), color: Colors.grey[300]),
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              Center(child: Container(height: 15, width: 50, color: Colors.grey[300])),

            ]),
          ),
        );
      },
    );
  }
}

class AddressShimmer extends StatelessWidget {
  final bool isEnabled;
  const AddressShimmer({Key? key, required this.isEnabled}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: Dimensions.paddingSizeLarge),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
          child: TitleWidget(title: 'deliver_to'.tr),
        ),
        const SizedBox(height: Dimensions.paddingSizeExtraSmall),

        SizedBox(
          height: 70,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: 5,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
            itemBuilder: (context, index) {
              return Container(
                width: 300,
                padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                child: Container(
                  padding: EdgeInsets.all(ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeDefault
                      : Dimensions.paddingSizeSmall),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200]!, blurRadius: 5, spreadRadius: 1)],
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(
                      Icons.location_on,
                      size: ResponsiveHelper.isDesktop(context) ? 50 : 40, color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(width: Dimensions.paddingSizeSmall),
                    Expanded(
                      child: Shimmer(
                        duration: const Duration(seconds: 2),
                        enabled: isEnabled,
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                          Container(height: 15, width: 100, color: Colors.grey[300]),
                          const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                          Container(height: 10, width: 150, color: Colors.grey[300]),
                        ]),
                      ),
                    ),
                  ]),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}



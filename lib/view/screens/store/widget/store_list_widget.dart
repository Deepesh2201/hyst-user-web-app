import 'package:sixam_mart/controller/splash_controller.dart';
import 'package:sixam_mart/data/model/response/all_registered_stores_model.dart';
import 'package:sixam_mart/data/model/response/review_model.dart';
import 'package:sixam_mart/data/model/response/store_model.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/view/base/custom_image.dart';
import 'package:sixam_mart/view/base/rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/view/screens/store/widget/review_dialog.dart';

import '../../../../data/model/response/store_review_model.dart';
import '../../../../helper/route_helper.dart';
import '../../auth/store_registration_screen_update.dart';

class StoreListWidget extends StatelessWidget {
  final AllRegisteredStoresModel stores;
  final bool hasDivider;

  const StoreListWidget({Key? key, required this.stores, required this.hasDivider})
      : super(key: key);

  Color getStatusColor(int? statusId) {
    if (statusId == 0) {
      return Colors.orange;
    } else if (statusId == 1) {
      return Colors.lightGreen;
    } else {
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed(
          RouteHelper.getStoreRoute(id: stores.id, page: 'item'),
          arguments: StoreUpdateScreen(store: Store(id: stores.id), fromModule: false),
        );
      },
      child: Stack(
        children: [
          Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipOval(
                    child: CustomImage(
                      image: '${AppConstants.baseUrl}/${stores.storeImage ?? ''}',
                      height: 60,
                      width: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: Dimensions.paddingSizeSmall),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          stores.storeName ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                        ),
                        Text(
                          stores.storeDescription!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: robotoBold.copyWith(fontSize: Dimensions.fontSizeSmall),
                        ),
                        Text(
                          stores.statusName!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: Dimensions.fontSizeSmall,
                            fontWeight: FontWeight.bold,
                            color: getStatusColor(stores.statusId),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (hasDivider && ResponsiveHelper.isMobile(context))
                Padding(
                  padding: const EdgeInsets.only(left: 70),
                  child: Divider(color: Theme.of(context).disabledColor),
                ),
            ],
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Text(
                '${stores.createdDate}', // Replace with your actual date variable
                style: TextStyle(
                  fontSize: Dimensions.fontSizeSmall,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // Set the color as needed
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


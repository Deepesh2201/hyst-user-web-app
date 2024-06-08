import 'package:sixam_mart/controller/splash_controller.dart';
import 'package:sixam_mart/data/model/response/all_registered_stores_model.dart';
import 'package:sixam_mart/data/model/response/posts_model.dart';
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
import '../post_update_screen.dart';

class PostsListWidget extends StatelessWidget {
  final Posts posts;
  final bool hasDivider;

  const PostsListWidget({Key? key, required this.posts, required this.hasDivider}) : super(key: key);

  Color getStatusColor(int? statusId) {
    if (statusId == '0') {
      return Colors.orange;
    } else if (statusId == '1') {
      return Colors.lightGreen;
    } else {
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Get.to(const StoreUpdateScreen(storeID: 2));
        Get.toNamed(
          RouteHelper.getStoreRoute(id: posts.id, page: 'item'),
          arguments: PostUpdateScreen(posts: Posts(id: posts.id), fromModule: false),
        );
      },


      child: Column(children: [

        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [

          ClipOval(
            child: CustomImage(
              image: '${AppConstants.baseUrl}/${posts.image1?? ''}',
              height: 60, width: 60, fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: Dimensions.paddingSizeSmall),

          Expanded(child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [

            Text(
              posts.title ?? '',
              maxLines: 1, overflow: TextOverflow.ellipsis,
              style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
            ),
            Text(
              posts.description!, maxLines: 1, overflow: TextOverflow.ellipsis,
              style: robotoBold.copyWith(fontSize: Dimensions.fontSizeSmall),
            ),
            Text(
              posts.createdDate!, maxLines: 1, overflow: TextOverflow.ellipsis,
              style: robotoBold.copyWith(fontSize: Dimensions.fontSizeSmall),
            ),
            Text(
              posts.statusName!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: Dimensions.fontSizeSmall,
                fontWeight: FontWeight.bold,
                color: getStatusColor(posts.status), // Set the color based on statusId
              ),
            ),



            // RatingBar(rating: stores.rating!.toDouble(), ratingCount: null, size: 15),



            // Text(
            // stores.storeDescription!, maxLines: 2, overflow: TextOverflow.ellipsis,
            // style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).disabledColor),
            // ),

          ])),

        ]),

        (hasDivider && ResponsiveHelper.isMobile(context)) ? Padding(
          padding: const EdgeInsets.only(left: 70),
          child: Divider(color: Theme.of(context).disabledColor),
        ) : const SizedBox(),

      ]),
    );
  }
}


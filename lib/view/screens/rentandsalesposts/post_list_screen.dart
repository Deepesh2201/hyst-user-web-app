import 'package:sixam_mart/controller/posts_controller.dart';
import 'package:sixam_mart/controller/store_controller.dart';
import 'package:sixam_mart/controller/splash_controller.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/view/base/custom_app_bar.dart';
import 'package:sixam_mart/view/base/footer_view.dart';
import 'package:sixam_mart/view/base/menu_drawer.dart';
import 'package:sixam_mart/view/base/no_data_screen.dart';
import 'package:sixam_mart/view/screens/rentandsalesposts/widget/posts_list_widget.dart';
import 'package:sixam_mart/view/screens/store/widget/review_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/view/screens/store/widget/store_list_widget.dart';

import '../../../controller/user_controller.dart';
import '../../../data/model/response/userinfo_model.dart';
import '../../../helper/route_helper.dart';

class PostListScreen extends StatefulWidget {
  final String? userID;
  const PostListScreen({Key? key, required this.userID}) : super(key: key);

  @override
  State<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  @override
  void initState() {
    super.initState();
    int? user = Get.find<UserController>().userInfoModel?.id!;
    Get.find<PostsController>().getAllPostsList(user);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          title: Get.find<SplashController>()
              .configModel!
              .moduleConfig!
              .module!
              .showRestaurantText!
              ? 'Rent/Sales'
              : 'Rent/Sales'),
      endDrawer: const MenuDrawer(),
      endDrawerEnableOpenDragGesture: false,
      body: GetBuilder<PostsController>(builder: (postsController) {
        return postsController.allPostsList != null
            ? postsController.allPostsList!.isNotEmpty
            ? RefreshIndicator(
          onRefresh: () async {
            int? user = Get.find<UserController>().userInfoModel?.id!;
            await postsController.getAllPostsList(user);
          },
          child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: FooterView(
                  child: SizedBox(

                      width: Dimensions.webMaxWidth,
                      child: GridView.builder(
                        gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                          ResponsiveHelper.isMobile(context)
                              ? 1
                              : 2,
                          childAspectRatio: (5/1.1),
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount:
                        postsController.allPostsList!.length,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(
                            Dimensions.paddingSizeSmall),
                        itemBuilder: (context, index) {
                          return PostsListWidget(
                            posts: postsController
                                .allPostsList![index],
                            hasDivider: index !=
                                postsController
                                    .allPostsList!.length -
                                    1,
                          );
                        },
                      ))
              )),
        )
            : const Center(
          child: NoDataScreen(
              text: 'No Data Found', showFooter: true),

        )

            : const Center(child: CircularProgressIndicator());
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(RouteHelper.postCreate);
        },
        child: Icon(Icons.add, color: Colors.white,), // You can change the icon as needed
      ),
    );
  }
}

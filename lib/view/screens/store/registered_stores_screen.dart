import 'package:sixam_mart/controller/store_controller.dart';
import 'package:sixam_mart/controller/splash_controller.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/view/base/custom_app_bar.dart';
import 'package:sixam_mart/view/base/footer_view.dart';
import 'package:sixam_mart/view/base/menu_drawer.dart';
import 'package:sixam_mart/view/base/no_data_screen.dart';
import 'package:sixam_mart/view/screens/store/widget/review_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/view/screens/store/widget/store_list_widget.dart';

import '../../../controller/user_controller.dart';
import '../../../data/model/response/userinfo_model.dart';
import '../../../helper/route_helper.dart';

class RegisteredStoresScreen extends StatefulWidget {
  final String? storeID;

  const RegisteredStoresScreen({Key? key, required this.storeID}) : super(key: key);

  @override
  State<RegisteredStoresScreen> createState() => _RegisteredStoresScreenState();
}

class _RegisteredStoresScreenState extends State<RegisteredStoresScreen> {
  @override
  void initState() {
    super.initState();
    int? user = Get.find<UserController>().userInfoModel?.id!;
    Get.find<StoreController>().getAllRegisteredStoresList(user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Store List'),
      endDrawer: const MenuDrawer(),
      endDrawerEnableOpenDragGesture: false,
      body: GetBuilder<StoreController>(
        builder: (storeController) {
          return storeController.allRegisteredStoresList != null
              ? storeController.allRegisteredStoresList!.isNotEmpty
              ? RefreshIndicator(
            onRefresh: () async {
              int? user = Get.find<UserController>().userInfoModel?.id!;
              await storeController.getAllRegisteredStoresList(user);
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: FooterView(
                child: SizedBox(
                  width: Dimensions.webMaxWidth,
                  child: // ...

                  GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: ResponsiveHelper.isMobile(context) ? 1 : 2,
                      childAspectRatio: (5 / 1.1),
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: storeController.allRegisteredStoresList!.length,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    itemBuilder: (context, index) {
                      return Container(
                        padding: const EdgeInsets.only(top: 10, left: 10), // Add padding here
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 4,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: StoreListWidget(
                          stores: storeController.allRegisteredStoresList![index],
                          hasDivider: index != storeController.allRegisteredStoresList!.length - 1,
                        ),
                      );
                    },
                  )

                ),
              ),
            ),
          )
              : Center(
            child: NoDataScreen(text: 'No Data Found', showFooter: true),
          )
              : const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(RouteHelper.restaurantRegistration);
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

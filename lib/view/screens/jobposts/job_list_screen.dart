import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/controller/jobs_controller.dart';
import 'package:sixam_mart/controller/splash_controller.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/view/base/custom_app_bar.dart';
import 'package:sixam_mart/view/base/footer_view.dart';
import 'package:sixam_mart/view/base/menu_drawer.dart';
import 'package:sixam_mart/view/base/no_data_screen.dart';
import 'package:sixam_mart/view/screens/jobposts/widget/jobs_list_widget.dart';

import '../../../controller/auth_controller.dart';
import '../../../controller/user_controller.dart';
import '../../../data/model/response/userinfo_model.dart';
import '../../../helper/route_helper.dart';
import '../../base/not_logged_in_screen.dart';

class JobListScreen extends StatefulWidget {
  final String? userID;

  const JobListScreen({Key? key, required this.userID}) : super(key: key);

  @override
  State<JobListScreen> createState() => _JobListScreenState();
}

class _JobListScreenState extends State<JobListScreen> {
  @override
  void initCall(){
    if(Get.find<AuthController>().isLoggedIn()) {
      int? user = Get.find<UserController>().userInfoModel?.id!;
      Get.find<JobsController>().getAllJobsList(user);
    }
  }
  void initState() {
    super.initState();
    initCall();
    // int? user = Get.find<UserController>().userInfoModel?.id!;
    // Get.find<JobsController>().getAllJobsList(user);
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
            ? 'Jobs/Vacancy List'
            : 'Jobs/Vacancy List',
      ),
      endDrawer: const MenuDrawer(),
      endDrawerEnableOpenDragGesture: false,
      body: Get.find<AuthController>().isLoggedIn() ? GetBuilder<JobsController>(builder: (jobsController) {
        return jobsController.allJobsList != null
            ? jobsController.allJobsList!.isNotEmpty
            ? RefreshIndicator(
          onRefresh: () async {
            int? user = Get.find<UserController>().userInfoModel?.id!;
            await jobsController.getAllJobsList(user);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: FooterView(
              child: SizedBox(
                width: Dimensions.webMaxWidth,
                child: GridView.builder(
                  gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: ResponsiveHelper.isMobile(context) ? 1 : 2,
                    childAspectRatio: (5 / 1.1),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: jobsController.allJobsList!.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  itemBuilder: (context, index) {
                    return JobsListWidget(
                      jobs: jobsController.allJobsList![index],
                      hasDivider: index != jobsController.allJobsList!.length - 1,
                    );
                  },
                ),
              ),
            ),
          ),
        )
            : const Center(
          child: NoDataScreen(
            text: 'No Data Found',
            showFooter: true,
          ),
        )
            : const Center(child: CircularProgressIndicator());
      }) : NotLoggedInScreen(callBack: (value){
        initCall();
        setState(() {});
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(RouteHelper.jobCreate);
        },
        child: Icon(Icons.add, color: Colors.white,),
      ),
    );
  }
}

import 'dart:convert';
import 'dart:io';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/controller/auth_controller.dart';
import 'package:sixam_mart/controller/localization_controller.dart';
import 'package:sixam_mart/controller/posts_controller.dart';
import 'package:sixam_mart/controller/splash_controller.dart';
import 'package:sixam_mart/data/model/body/store_body.dart';
import 'package:sixam_mart/data/model/body/translation.dart';
import 'package:sixam_mart/data/model/response/config_model.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/view/base/custom_app_bar.dart';
import 'package:sixam_mart/view/base/custom_button.dart';
import 'package:sixam_mart/view/base/custom_snackbar.dart';
import 'package:sixam_mart/view/base/custom_text_field.dart';
import 'package:sixam_mart/view/base/footer_view.dart';
import 'package:sixam_mart/view/base/menu_drawer.dart';
import 'package:sixam_mart/view/base/web_page_title_widget.dart';
import 'package:sixam_mart/view/screens/auth/widget/custom_time_picker.dart';
import 'package:sixam_mart/view/screens/auth/widget/pass_view.dart';
import 'package:sixam_mart/view/screens/auth/widget/select_location_view.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../controller/user_controller.dart';
import '../../../data/model/body/post_body.dart';
import '../../../data/model/response/posts_model.dart';

class PostUpdateScreen extends StatefulWidget {
  final Posts? posts;
  final bool fromModule;
  final String slug;
  const PostUpdateScreen(
      {Key? key, required this.posts, required this.fromModule, this.slug = ''})
      : super(key: key);

  @override
  State<PostUpdateScreen> createState() => _PostUpdateScreenState();
}

class _PostUpdateScreenState extends State<PostUpdateScreen>
    with TickerProviderStateMixin {
  List<TextEditingController> _nameController = [];
  List<TextEditingController> _addressController = [];
  List<TextEditingController> _rentController = [];
  List<TextEditingController> _depositController = [];
  List<TextEditingController> _floorController = [];
  List<TextEditingController> _descriptionController = [];
  List<TextEditingController> _possessionController = [];
  List<TextEditingController> _mobileController = [];
  List<TextEditingController> _emailController = [];

  final List<Language>? _languageList =
      Get.find<SplashController>().configModel!.language;
  List<Map<String, dynamic>> amenityData = [];
  String? selectedBedroom = '0';
  String? selectedBathroom = '0';
  bool firstTime = true;
  bool liftChecked = false;
  bool gymChecked = false;
  bool parkingChecked = false;
  bool wifiChecked = false;
  bool playChecked = false;
  bool fireChecked = false;
  bool securityChecked = false;
  bool shopsChecked = false;
  bool gasChecked = false;
  bool parkChecked = false;
  bool powerChecked = false;
  bool swimmingChecked = false;
  String? postId = '0';
  List<String> initialCheckedAmenities = [];
  TabController? _tabController;

  final List<Tab> _tabs = [];

  @override
  void initState() {
    super.initState();
    fetchDataFromAPI(); // Call the fetchDataFromAPI function

    _tabController = TabController(
        length: _languageList!.length, initialIndex: 0, vsync: this);
    // _countryDialCode = CountryCode.fromCountryCode(Get.find<SplashController>().configModel!.country!).dialCode;
    for (var language in _languageList!) {
      if (kDebugMode) {
        print(language);
      }
    }
    Get.find<AuthController>().storeStatusChange(0.4, isUpdate: false);
    Get.find<AuthController>().getZoneList();
    Get.find<AuthController>().selectModuleIndex(-1, canUpdate: false);

    _languageList?.forEach((language) {
      _tabs.add(Tab(text: language.value));
    });

    if (Get.find<AuthController>().showPassView) {
      Get.find<AuthController>().showHidePass(isUpdate: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    Future<void> initDataCall() async {

      try {
        final postData = await Get.find<PostsController>().getPostDetails(
          Posts(id: widget.posts!.id),
          widget.fromModule,
          slug: widget.slug,
        );

    //
    //     // Now, you can access the data returned by the API call
        if (postData != null) {
          // Process the data here
          postId = postData.id.toString() ?? '0';

          // Initialize controllers based on _languageList and postData
          _languageList!.forEach((language) {
            _nameController.add(TextEditingController(text: postData.title?? ''));
            _addressController.add(TextEditingController(text: postData.address?? ''));
            _rentController.add(TextEditingController(text:  postData.rent_per_month?? ''));
            _depositController.add(TextEditingController(text:  postData.deposit?? ''));
            _floorController.add(TextEditingController(text:  postData.floors.toString() ?? ''));
            _descriptionController.add(TextEditingController(text:  postData.description?? ''));
            _possessionController.add(TextEditingController(text:  postData.possession_date?? ''));
            _mobileController.add(TextEditingController(text: postData.mobile?? ''));
            _emailController.add(TextEditingController(text: postData.email?? ''));
            selectedBedroom =  postData.bedrooms.toString() ?? '1';
            selectedBathroom =  postData.bathrooms.toString() ?? '1';
            // String input = "11,15,16,17,18,21";
            // List<String> ammen = input.split(',');
            // print(result); // Output: ["11", "15", "16", "17", "18", "21"]
            initialCheckedAmenities = postData.amenities!.split(',');
           });
    //
    //       // You can access other properties of storeData as needed
        } else {
    //     //   // Handle the case where storeData is null (e.g., API error)
          print('Post data not available');
        }
    //
    //     // Continue with other actions
      } catch (e) {
    //     // Handle any errors that occurred during the API request
        print('Error fetching data: $e');
      }
    }

// Call initDataCall to fetch and update data

    initDataCall();
    List<DropdownMenuEntry<Object>> countryEntries =
    []; // Initialize an empty list
    List<DropdownMenuEntry<Object>> areaEntries =
    []; // Initialize an empty list



    Future<List<DropdownMenuEntry<Object>>> fetchDropdownCountries() async {
      final List<dynamic> responseData = [
        {'id': '0', 'name': 'No. Of Bedrooms'},
        {'id': '1', 'name': '1'},
        {'id': '2', 'name': '2'},
        {'id': '3', 'name': '3'},
        {'id': '4', 'name': '4'},
        {'id': '5', 'name': '5'}
      ];

      List<DropdownMenuEntry<Object>> entries = responseData.map((item) {
        return DropdownMenuEntry<Object>(
          value: item['id'], // Adjust based on your API response
          label: item['name'], // Adjust based on your API response
        );
      }).toList();

      return entries;
    }

    Future<List<DropdownMenuEntry<Object>>> fetchDropdownBathrooms() async {
      final List<dynamic> responseData = [
        {'id': '0', 'name': 'No. Of Bathrooms'},
        {'id': '1', 'name': '1'},
        {'id': '2', 'name': '2'},
        {'id': '3', 'name': '3'},
        {'id': '4', 'name': '4'},
        {'id': '5', 'name': '5'}
      ];

      List<DropdownMenuEntry<Object>> entries = responseData.map((item) {
        return DropdownMenuEntry<Object>(
          value: item['id'], // Adjust based on your API response
          label: item['name'], // Adjust based on your API response
        );
      }).toList();

      return entries;
    }

    return Scaffold(
      appBar: CustomAppBar(
          title: 'Post Creation',
          onBackPressed: () {
            if (Get.find<AuthController>().dmStatus == 0.4 && firstTime) {
              Get.find<AuthController>().storeStatusChange(0.4);
              firstTime = false;
            } else {
              Get.back();
            }
          }),
      endDrawer: const MenuDrawer(),
      endDrawerEnableOpenDragGesture: false,
      body:
      SafeArea(child: GetBuilder<AuthController>(builder: (authController) {
        return Column(children: [
          WebScreenTitleWidget(title: 'join_as_store'.tr),
          ResponsiveHelper.isDesktop(context)
              ? const SizedBox()
              : Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.paddingSizeLarge,
                vertical: Dimensions.paddingSizeSmall),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    authController.storeStatus == 0.4
                        ? 'Provide Post Information To Proceed Next'
                        : authController.storeStatus == 0.6
                        ? 'Upload Images To Proceed Next'
                        : authController.storeStatus == 0.8
                        ? 'Select Amenities To Submit'
                        : 'Post Creation',
                    style: robotoRegular.copyWith(
                        fontSize: Dimensions.fontSizeSmall,
                        color: Theme.of(context).hintColor),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),
                  LinearProgressIndicator(
                    backgroundColor: Theme.of(context).disabledColor,
                    minHeight: 2,
                    value: authController.storeStatus,
                  ),
                ]),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: ResponsiveHelper.isDesktop(context)
                  ? EdgeInsets.zero
                  : const EdgeInsets.symmetric(
                  vertical: Dimensions.paddingSizeSmall,
                  horizontal: Dimensions.paddingSizeDefault),
              child: FooterView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Form - Part I
                        Visibility(
                          visible: authController.storeStatus == 0.4,
                          child: Column(children: [
                            ListView.builder(
                                itemCount: _languageList!.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: Dimensions.paddingSizeExtraLarge),
                                    child: CustomTextField(
                                      titleText:
                                      '${'Title'} (${_languageList![index].value!})',
                                      controller: _nameController.isNotEmpty ? _nameController[0] : null,
                                      inputType: TextInputType.name,
                                      capitalization: TextCapitalization.words,
                                    ),
                                  );
                                }),
                            ListView.builder(
                              itemCount: _languageList!.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: Dimensions.paddingSizeExtraLarge),
                                  child: Container(
                                    height: 150, // Adjust the height as needed
                                    child: CustomTextField(
                                      titleText:
                                      '${'Address'} (${_languageList![index].value!})',
                                      controller: _addressController.isNotEmpty ? _addressController[0] : null,
                                      inputType: TextInputType
                                          .multiline, // Use multiline input type for a textarea-like behavior
                                      capitalization: TextCapitalization
                                          .sentences, // You can change this to your preferred capitalization style
                                      maxLines:
                                      6, // Allow the text field to expand vertically as needed
                                    ),
                                  ),
                                );
                              },
                            ),
                            ListView.builder(
                                itemCount: _languageList!.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: Dimensions.paddingSizeExtraLarge),
                                    child: CustomTextField(
                                      titleText: 'Rent/month',
                                      controller: _rentController.isNotEmpty ? _rentController[0] : null,
                                      inputType: TextInputType.number,
                                      capitalization: TextCapitalization.words,
                                    ),
                                  );
                                }),
                            ListView.builder(
                                itemCount: _languageList!.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: Dimensions.paddingSizeExtraLarge),
                                    child: CustomTextField(
                                      titleText: 'Deposit',
                                      controller: _depositController.isNotEmpty ? _depositController[0] : null,
                                      inputType: TextInputType.number,
                                      capitalization: TextCapitalization.words,
                                    ),
                                  );
                                }),

                            Container(
                              // ... Other properties for the Container ...
                              child: FutureBuilder<List<DropdownMenuEntry<Object>>>(
                                future: fetchDropdownCountries(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    // While data is being fetched, you can show a loading indicator or a placeholder
                                    print(snapshot.data);
                                    return CircularProgressIndicator();
                                  } else {
                                    // Data has been fetched successfully
                                    countryEntries = snapshot
                                        .data!; // Update the countryEntries list with fetched data
                                    // Add a placeholder entry at the beginning of the list

                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 16.0),
                                      child: DropdownMenu(
                                        width: 350,
                                        dropdownMenuEntries: countryEntries,
                                        initialSelection: selectedBedroom,
                                        onSelected: (value) {
                                          setState(() {
                                            selectedBedroom = value.toString();
                                            print('Selected Bedrooms: $value');
                                          });
                                        },
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                            Container(
                              // ... Other properties for the Container ...
                              child: FutureBuilder<List<DropdownMenuEntry<Object>>>(
                                future: fetchDropdownBathrooms(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    // While data is being fetched, you can show a loading indicator or a placeholder
                                    print(snapshot.data);
                                    return CircularProgressIndicator();
                                  } else {
                                    // Data has been fetched successfully
                                    countryEntries = snapshot
                                        .data!; // Update the countryEntries list with fetched data
                                    // Add a placeholder entry at the beginning of the list

                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 16.0),
                                      child: DropdownMenu(
                                        width: 350,
                                        dropdownMenuEntries: countryEntries,
                                        initialSelection: selectedBathroom,
                                        onSelected: (value) {
                                          setState(() {
                                            selectedBathroom = value.toString();
                                            print('Selected Bathroom: $value');
                                          });
                                        },
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                            // Area List

                            ListView.builder(
                                itemCount: _languageList!.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: Dimensions.paddingSizeExtraLarge),
                                    child: CustomTextField(
                                      titleText: 'Enter Floor No.',
                                      controller: _floorController.isNotEmpty ? _floorController[0] : null,
                                      inputType: TextInputType.number,
                                      capitalization: TextCapitalization.sentences,
                                      maxLines: 3,
                                    ),
                                  );
                                }),
                            ListView.builder(
                                itemCount: _languageList!.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: Dimensions.paddingSizeExtraLarge),
                                    child: CustomTextField(
                                      titleText: 'Description',
                                      controller: _descriptionController.isNotEmpty ? _descriptionController[0] : null,
                                      inputType: TextInputType.text,
                                      capitalization: TextCapitalization.sentences,
                                      maxLines: 3,
                                    ),
                                  );
                                }),
                            ListView.builder(
                                itemCount: _languageList!.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: Dimensions.paddingSizeExtraLarge),
                                    child: CustomTextField(
                                      titleText: 'Possession(dd/mm/yyyy)',
                                      controller: _possessionController.isNotEmpty ? _possessionController[0] : null,
                                      inputType: TextInputType.datetime,
                                      capitalization: TextCapitalization.sentences,
                                      maxLines: 1,
                                    ),
                                  );
                                }),
                            ListView.builder(
                                itemCount: _languageList!.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: Dimensions.paddingSizeExtraLarge),
                                    child: CustomTextField(
                                      titleText: 'Mobile',
                                      controller: _mobileController.isNotEmpty ? _mobileController[0] : null,
                                      inputType: TextInputType.datetime,
                                      capitalization: TextCapitalization.sentences,
                                      maxLines: 1,
                                    ),
                                  );
                                }),
                            ListView.builder(
                                itemCount: _languageList!.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: Dimensions.paddingSizeExtraLarge),
                                    child: CustomTextField(
                                      titleText: 'Email',
                                      controller: _emailController.isNotEmpty ? _emailController[0] : null,
                                      inputType: TextInputType.emailAddress,
                                      capitalization: TextCapitalization.sentences,
                                      maxLines: 1,
                                    ),
                                  );
                                }),
                          ]),
                        ),

                        /// Form Part II
                        Visibility(
                          visible: authController.storeStatus == 0.6,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(children: [
                                  Expanded(
                                    flex: 6,
                                    child: Stack(children: [
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              Dimensions.radiusSmall),
                                          child: authController.pickedPostPic1 !=
                                              null
                                              ? GetPlatform.isWeb
                                              ? Image.network(
                                            authController
                                                .pickedPostPic1!.path,
                                            width: context.width,
                                            height: 120,
                                            fit: BoxFit.cover,
                                          )
                                              : Image.file(
                                            File(authController
                                                .pickedPostPic1!.path),
                                            width: context.width,
                                            height: 120,
                                            fit: BoxFit.cover,
                                          )
                                              : SizedBox(
                                            width: context.width,
                                            height: 120,
                                            child: Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.file_upload,
                                                      size: 38,
                                                      color: Theme.of(context)
                                                          .disabledColor),
                                                  const SizedBox(
                                                      height: Dimensions
                                                          .paddingSizeSmall),
                                                  Text(
                                                    'Post Cover Pic 1(Required)',
                                                    style:
                                                    robotoMedium.copyWith(
                                                        color: Theme.of(
                                                            context)
                                                            .disabledColor),
                                                    textAlign:
                                                    TextAlign.center,
                                                  ),
                                                ]),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        top: 0,
                                        left: 0,
                                        child: InkWell(
                                          onTap: () => authController.pickPostImage(
                                              1, false),
                                          child: DottedBorder(
                                            color: Theme.of(context).primaryColor,
                                            strokeWidth: 1,
                                            strokeCap: StrokeCap.butt,
                                            dashPattern: const [5, 5],
                                            padding: const EdgeInsets.all(0),
                                            borderType: BorderType.RRect,
                                            radius: const Radius.circular(
                                                Dimensions.radiusDefault),
                                            child: Center(
                                              child: Visibility(
                                                visible:
                                                authController.pickedCover !=
                                                    null,
                                                child: Container(
                                                  padding: const EdgeInsets.all(25),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        width: 3,
                                                        color: Colors.white),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: const Icon(
                                                      Icons.file_upload,
                                                      color: Colors.white,
                                                      size: 50),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ]),
                                  ),
                                ]),
                                const SizedBox(
                                    height: Dimensions.paddingSizeExtraLarge),
                                Row(children: [
                                  Expanded(
                                    flex: 6,
                                    child: Stack(children: [
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              Dimensions.radiusSmall),
                                          child: authController.pickedPostPic2 !=
                                              null
                                              ? GetPlatform.isWeb
                                              ? Image.network(
                                            authController
                                                .pickedPostPic2!.path,
                                            width: context.width,
                                            height: 120,
                                            fit: BoxFit.cover,
                                          )
                                              : Image.file(
                                            File(authController
                                                .pickedPostPic2!.path),
                                            width: context.width,
                                            height: 120,
                                            fit: BoxFit.cover,
                                          )
                                              : SizedBox(
                                            width: context.width,
                                            height: 120,
                                            child: Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.file_upload,
                                                      size: 38,
                                                      color: Theme.of(context)
                                                          .disabledColor),
                                                  const SizedBox(
                                                      height: Dimensions
                                                          .paddingSizeSmall),
                                                  Text(
                                                    'Post Cover Pic 2',
                                                    style:
                                                    robotoMedium.copyWith(
                                                        color: Theme.of(
                                                            context)
                                                            .disabledColor),
                                                    textAlign:
                                                    TextAlign.center,
                                                  ),
                                                ]),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        top: 0,
                                        left: 0,
                                        child: InkWell(
                                          onTap: () => authController.pickPostImage(
                                              2, false),
                                          child: DottedBorder(
                                            color: Theme.of(context).primaryColor,
                                            strokeWidth: 1,
                                            strokeCap: StrokeCap.butt,
                                            dashPattern: const [5, 5],
                                            padding: const EdgeInsets.all(0),
                                            borderType: BorderType.RRect,
                                            radius: const Radius.circular(
                                                Dimensions.radiusDefault),
                                            child: Center(
                                              child: Visibility(
                                                visible:
                                                authController.pickedCover !=
                                                    null,
                                                child: Container(
                                                  padding: const EdgeInsets.all(25),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        width: 3,
                                                        color: Colors.white),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: const Icon(
                                                      Icons.file_upload,
                                                      color: Colors.white,
                                                      size: 50),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ]),
                                  ),
                                ]),
                                const SizedBox(
                                    height: Dimensions.paddingSizeExtraLarge),
                                Row(children: [
                                  Expanded(
                                    flex: 6,
                                    child: Stack(children: [
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              Dimensions.radiusSmall),
                                          child: authController.pickedPostPic3 !=
                                              null
                                              ? GetPlatform.isWeb
                                              ? Image.network(
                                            authController
                                                .pickedPostPic3!.path,
                                            width: context.width,
                                            height: 120,
                                            fit: BoxFit.cover,
                                          )
                                              : Image.file(
                                            File(authController
                                                .pickedPostPic3!.path),
                                            width: context.width,
                                            height: 120,
                                            fit: BoxFit.cover,
                                          )
                                              : SizedBox(
                                            width: context.width,
                                            height: 120,
                                            child: Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.file_upload,
                                                      size: 38,
                                                      color: Theme.of(context)
                                                          .disabledColor),
                                                  const SizedBox(
                                                      height: Dimensions
                                                          .paddingSizeSmall),
                                                  Text(
                                                    'Post Cover Pic 3',
                                                    style:
                                                    robotoMedium.copyWith(
                                                        color: Theme.of(
                                                            context)
                                                            .disabledColor),
                                                    textAlign:
                                                    TextAlign.center,
                                                  ),
                                                ]),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        top: 0,
                                        left: 0,
                                        child: InkWell(
                                          onTap: () => authController.pickPostImage(
                                              3, false),
                                          child: DottedBorder(
                                            color: Theme.of(context).primaryColor,
                                            strokeWidth: 1,
                                            strokeCap: StrokeCap.butt,
                                            dashPattern: const [5, 5],
                                            padding: const EdgeInsets.all(0),
                                            borderType: BorderType.RRect,
                                            radius: const Radius.circular(
                                                Dimensions.radiusDefault),
                                            child: Center(
                                              child: Visibility(
                                                visible:
                                                authController.pickedCover !=
                                                    null,
                                                child: Container(
                                                  padding: const EdgeInsets.all(25),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        width: 3,
                                                        color: Colors.white),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: const Icon(
                                                      Icons.file_upload,
                                                      color: Colors.white,
                                                      size: 50),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ]),
                                  ),
                                ]),
                                const SizedBox(
                                    height: Dimensions.paddingSizeExtraLarge),
                                Row(children: [
                                  Expanded(
                                    flex: 6,
                                    child: Stack(children: [
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              Dimensions.radiusSmall),
                                          child: authController.pickedPostPic4 !=
                                              null
                                              ? GetPlatform.isWeb
                                              ? Image.network(
                                            authController
                                                .pickedPostPic4!.path,
                                            width: context.width,
                                            height: 120,
                                            fit: BoxFit.cover,
                                          )
                                              : Image.file(
                                            File(authController
                                                .pickedPostPic4!.path),
                                            width: context.width,
                                            height: 120,
                                            fit: BoxFit.cover,
                                          )
                                              : SizedBox(
                                            width: context.width,
                                            height: 120,
                                            child: Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.file_upload,
                                                      size: 38,
                                                      color: Theme.of(context)
                                                          .disabledColor),
                                                  const SizedBox(
                                                      height: Dimensions
                                                          .paddingSizeSmall),
                                                  Text(
                                                    'Post Cover Pic 4',
                                                    style:
                                                    robotoMedium.copyWith(
                                                        color: Theme.of(
                                                            context)
                                                            .disabledColor),
                                                    textAlign:
                                                    TextAlign.center,
                                                  ),
                                                ]),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        top: 0,
                                        left: 0,
                                        child: InkWell(
                                          onTap: () => authController.pickPostImage(
                                              4, false),
                                          child: DottedBorder(
                                            color: Theme.of(context).primaryColor,
                                            strokeWidth: 1,
                                            strokeCap: StrokeCap.butt,
                                            dashPattern: const [5, 5],
                                            padding: const EdgeInsets.all(0),
                                            borderType: BorderType.RRect,
                                            radius: const Radius.circular(
                                                Dimensions.radiusDefault),
                                            child: Center(
                                              child: Visibility(
                                                visible:
                                                authController.pickedCover !=
                                                    null,
                                                child: Container(
                                                  padding: const EdgeInsets.all(25),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        width: 3,
                                                        color: Colors.white),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: const Icon(
                                                      Icons.file_upload,
                                                      color: Colors.white,
                                                      size: 50),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ]),
                                  ),
                                ]),
                                const SizedBox(
                                    height: Dimensions.paddingSizeExtraLarge),
                              ]),
                        ),

                        /// Form Part III
                        Visibility(
                          visible: authController.storeStatus == 0.8,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Expanded(
                                      flex: 2, // 25% width
                                      child: Text("Select Amenities")),
                                  SizedBox(width: Dimensions.paddingSizeSmall),
                                ],
                              ),
                              const SizedBox(
                                  height: Dimensions.paddingSizeExtraLarge),
                              // Create checkboxes dynamically based on amenityData
                              Column(
                                children: amenityData.map((amenity) {
                                  return CheckboxListTile(
                                    title: Text(amenity['name']),
                                    value: amenity['checked'],
                                    onChanged: (bool? value) {
                                      setState(() {
                                        amenity['checked'] = value!;
                                      });
                                    },
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: Dimensions.paddingSizeLarge),
                      ])),
            ),
          ),
          (ResponsiveHelper.isDesktop(context) || ResponsiveHelper.isWeb())
              ? const SizedBox()
              : buttonView(),
        ]);
      })),
    );
  }

  Widget buttonView() {
    return GetBuilder<AuthController>(builder: (authController) {
      return CustomButton(
        isBold: ResponsiveHelper.isDesktop(context) ? false : true,
        radius: ResponsiveHelper.isDesktop(context)
            ? Dimensions.radiusSmall
            : Dimensions.radiusDefault,
        isLoading: authController.isLoading,
        margin: EdgeInsets.all(
            (ResponsiveHelper.isDesktop(context) || ResponsiveHelper.isWeb())
                ? 0
                : Dimensions.paddingSizeSmall),
        buttonText: authController.storeStatus != 0.8 &&
            !ResponsiveHelper.isDesktop(context)
            ? 'next'.tr
            : 'submit'.tr,
        onPressed: () {
          String title = _nameController[0].text;
          String address = _descriptionController[0].text;
          String rent = _rentController[0].text;
          String deposit = _depositController[0].text;
          String? bedroom = selectedBedroom;
          String? bathroom = selectedBathroom;
          String floor = _floorController[0].text;
          String description = _descriptionController[0].text;
          String possession = _possessionController[0].text;
          String mobile = _mobileController[0].text;
          String email = _emailController[0].text;
          int? userid = Get.find<UserController>().userInfoModel?.id!;

          String userId = userid.toString();

          // String confirmPassword = _confirmPasswordController.text.trim();

          if (authController.storeStatus == 0.4 &&
              !ResponsiveHelper.isDesktop(context)) {
            // if(authController.pickedLogo == null) {
            //   showCustomSnackBar('select_store_logo'.tr);
            // }
            // else if(defaultDataNull) {
            //   showCustomSnackBar('enter_store_name'.tr);
            // }
            // else if(description.isEmpty) {
            //   showCustomSnackBar('Enter description');
            // }
            // else if(selectedCityValue == '0' || selectedCityValue == 0 || selectedCityValue == null){
            //   showCustomSnackBar('Please select city');
            // }
            // else if(selectedAreaValue == '0' || selectedAreaValue == 0 || selectedAreaValue == null){
            //   showCustomSnackBar('Please select area');
            // }

            // }else if(authController.pickedCover == null) {
            //   showCustomSnackBar('select_store_cover_photo'.tr);
            // }

            // else if(authController.selectedModuleIndex == -1) {
            //   showCustomSnackBar('please_select_module_first'.tr);
            // }else if(authController.selectedZoneIndex == -1) {
            //   showCustomSnackBar('please_select_zone'.tr);

            //   showCustomSnackBar('enter_vat_amount'.tr);
            // }else if(minTime.isEmpty) {
            //   showCustomSnackBar('enter_minimum_delivery_time'.tr);
            // }else if(maxTime.isEmpty) {
            //   showCustomSnackBar('enter_maximum_delivery_time'.tr);
            // }else if(!valid) {
            //   showCustomSnackBar('please_enter_the_max_min_delivery_time'.tr);
            // }else if(valid && double.parse(minTime) > double.parse(maxTime)) {
            //   showCustomSnackBar('maximum_delivery_time_can_not_be_smaller_then_minimum_delivery_time'.tr);
            // }else if(authController.restaurantLocation == null) {
            //   showCustomSnackBar('set_store_location'.tr);
            // }
            // else{
            authController.storeStatusChange(0.6);
            firstTime = true;

            // }
          } else if (authController.storeStatus == 0.6 &&
              !ResponsiveHelper.isDesktop(context)) {

            authController.storeStatusChange(0.8);
            firstTime = true;

            // }
          } else if (authController.storeStatus == 0.8 &&
              !ResponsiveHelper.isDesktop(context)) {

            List<Translation> translation = [];

            List<int> amenities = [];

            for (final amenity in amenityData) {
              if (amenity['checked']) {
                amenities.add(amenity['id']);
              }
            }

            authController.createPost(PostBody(
                translation: jsonEncode(translation),
                postId: widget.posts!.id.toString(),
                title: title,
                address: address,
                rent: rent,
                deposit: deposit,
                bedrooms: bedroom,
                bathrooms: bathroom,
                floors: floor,
                description: description,
                possession: possession,
                userId: userId,
                amenities: amenities,
                mobile:mobile,
                email:email
            ));
            // }
          }
        },
      );
    });

  }

  Future<void> fetchDataFromAPI() async {

    final response = await http.get(
      Uri.parse('https://backend.hyst.uk/api/v1/post-amenities/1'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data is List) {
        amenityData = data.map((item) {
          final bool isChecked = initialCheckedAmenities.contains(item['id'].toString());
          return {
            'id': item['id'],
            'name': item['name'],
            'checked': isChecked, // You can set the initial state as needed
          };
        }).toList();

        setState(() {}); // Trigger a rebuild to display the data
      }
    } else {
      // Handle errors or show a message
    }
  }
}


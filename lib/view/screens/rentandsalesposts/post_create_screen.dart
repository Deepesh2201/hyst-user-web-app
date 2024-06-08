import 'dart:convert';
import 'dart:io';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/controller/auth_controller.dart';
import 'package:sixam_mart/controller/localization_controller.dart';
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

class PostCreateScreen extends StatefulWidget {
  const PostCreateScreen({Key? key}) : super(key: key);

  @override
  State<PostCreateScreen> createState() => _PostCreateScreenState();
}

class _PostCreateScreenState extends State<PostCreateScreen>
    with TickerProviderStateMixin {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _rentController = TextEditingController();

  final TextEditingController _depositController = TextEditingController();
  final TextEditingController _bedroomController = TextEditingController();
  final TextEditingController _bathroomController = TextEditingController();
  final TextEditingController _floorController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _possessionController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _ammenitiesController = TextEditingController();

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
          title: 'Rent/Sales',
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
                                  controller: _nameController,
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
                                  controller: _addressController,
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
                                  controller: _rentController,
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
                                  controller: _depositController,
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
                                  controller: _floorController,
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
                                  controller: _descriptionController,
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
                                  controller: _possessionController,
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
                                  controller: _mobileController,
                                  inputType: TextInputType.number,
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
                                  controller: _emailController,
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
          String title = _nameController.text.trim();
          String address = _descriptionController.text.trim();
          String rent = _rentController.text.trim();
          String deposit = _depositController.text.trim();
          String? bedroom = selectedBedroom;
          String? bathroom = selectedBathroom;
          String floor = _floorController.text.trim();
          String description = _descriptionController.text.trim();
          String possession = _possessionController.text.trim();
          String mobile = _mobileController.text.trim();
          String email = _emailController.text.trim();
          int? userid = Get.find<UserController>().userInfoModel?.id!;

          String userId = userid.toString();

          // String confirmPassword = _confirmPasswordController.text.trim();

          if (authController.storeStatus == 0.4 &&
              !ResponsiveHelper.isDesktop(context)) {

            authController.storeStatusChange(0.6);
            firstTime = true;

            // }
          } else if (authController.storeStatus == 0.6 &&
              !ResponsiveHelper.isDesktop(context)) {
            if (ResponsiveHelper.isDesktop(context)) {

            }

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
              title: title,
              address: address,
              rent: rent,
              deposit: deposit,
              bedrooms: bedroom,
              bathrooms: bathroom,
              floors: floor,
              description: description,
              possession: possession,
              mobile:mobile,
              email: email,
              userId: userId,
              amenities: amenities
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
          return {
            'id': item['id'],
            'name': item['name'],
            'checked': false, // You can set the initial state as needed
          };
        }).toList();

        setState(() {}); // Trigger a rebuild to display the data
      }
    } else {
      // Handle errors or show a message
    }
  }
}


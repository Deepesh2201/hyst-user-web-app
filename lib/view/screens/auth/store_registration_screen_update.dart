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
import 'package:sixam_mart/data/model/response/store_model.dart';
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

import '../../../controller/category_controller.dart';
import '../../../controller/store_controller.dart';
import '../../../controller/user_controller.dart';
import '../../../data/model/response/store_model.dart';
import '../../base/custom_text_field_new.dart';

class StoreUpdateScreen extends StatefulWidget {
  final Store? store;
  final bool fromModule;
  final String slug;
  const StoreUpdateScreen(
      {Key? key, required this.store, required this.fromModule, this.slug = ''})
      : super(key: key);
  @override
  State<StoreUpdateScreen> createState() => _StoreUpdateScreenState();
}

class CustomDropdownList extends StatefulWidget {
  final List<DropdownMenuItem<Object>> items;
  final Object? value;
  final ValueChanged<Object?> onChanged;

  CustomDropdownList({
    required this.items,
    required this.value,
    required this.onChanged,
  });

  // List<DropdownMenuEntry<Object>> countryEntries = [];

  @override
  _CustomDropdownListState createState() => _CustomDropdownListState();
}

class _CustomDropdownListState extends State<CustomDropdownList> {
  bool isDropdownOpen = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              isDropdownOpen = !isDropdownOpen;
            });
          },
          child: Container(
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.value != null
                      ? widget.value.toString()
                      : 'Select an item',
                ),
                Icon(
                  isDropdownOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                ),
              ],
            ),
          ),
        ),
        if (isDropdownOpen)
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(5.0),
            ),
            margin: EdgeInsets.only(top: 4.0),
            child: Column(
              children: widget.items.map((item) {
                return GestureDetector(
                  onTap: () {
                    widget.onChanged(item.value);
                    setState(() {
                      isDropdownOpen = false;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    child: Text(item.child.toString()),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}

class _StoreUpdateScreenState extends State<StoreUpdateScreen>
    with TickerProviderStateMixin {
  final TextEditingController _nameController = TextEditingController();
  List<TextEditingController> _storeNameController = [];
  List<TextEditingController>  _descriptionController = [];

  List<TextEditingController>  _addressController = [];
  List<TextEditingController>  _storeAddressController = [];
  final TextEditingController _vatController = TextEditingController();
  List<TextEditingController>  _fNameController = [];
  List<TextEditingController>  _lNameController = [];
  List<TextEditingController>  _phoneController = [];
  List<TextEditingController>  _emailController = [];
  List<TextEditingController> _websiteController = [];
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  List<TextEditingController> _locationLinkController = [];
  List<TextEditingController>  _offerDiscountController = [];
  List<TextEditingController>  _offerDiscountDiscriptionController = [];

  final List<FocusNode> _nameFocus = [];
  final List<FocusNode> _descriptionFocus = [];
  final List<FocusNode> _addressFocus = [];
  final List<FocusNode> _locationLinkFocus = [];
  final FocusNode _vatFocus = FocusNode();
  final FocusNode _fNameFocus = FocusNode();
  final FocusNode _lNameFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _websiteFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  final FocusNode _offerDiscountFocus = FocusNode();
  final FocusNode _offerDiscountDescriptionFocus = FocusNode();
  final List<Language>? _languageList =
      Get.find<SplashController>().configModel!.language;

  String? _countryDialCode;
  bool firstTime = true;
  TabController? _tabController;
  final List<Tab> _tabs = [];
  Object selectedCountryValue = 0;
// Define variables for selected values
  String? selectedCityValue = '0';
  String? selectedAreaValue = '0';
  String? selectedCategoryValue = '0';
  String? selectedSubCategoryValue = '0';
  String? storeId = '0';

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
        length: _languageList!.length, initialIndex: 0, vsync: this);
    // _countryDialCode = CountryCode.fromCountryCode(Get.find<SplashController>().configModel!.country!).dialCode;
    for (var language in _languageList!) {
      if (kDebugMode) {
        print(language);
      }

      _nameFocus.add(FocusNode());
      _descriptionFocus.add(FocusNode());
      _addressFocus.add(FocusNode());
    }
    Get.find<AuthController>().storeStatusChange(0.4, isUpdate: false);
    Get.find<AuthController>().getZoneList();
    Get.find<AuthController>().selectModuleIndex(-1, canUpdate: false);
    // Get.find<StoreController>().getStoreUpdate(256);

    _languageList?.forEach((language) {
      _tabs.add(Tab(text: language.value));
    });

    if (Get.find<AuthController>().showPassView) {
      Get.find<AuthController>().showHidePass(isUpdate: false);
    }
  }
  String selectedStatus = '1';
  @override
  Widget build(BuildContext context) {
    List<DropdownMenuEntry<Object>> countryEntries =
        []; // Initialize an empty list
    List<DropdownMenuEntry<Object>> areaEntries =
        []; // Initialize an empty list
    List<DropdownMenuEntry<Object>> statusEntries = [];

    Future<List<DropdownMenuEntry<Object>>> fetchDropdownStatus() async {
      final List<dynamic> responseData = [
        {'id': '1', 'name': 'Active'},
        {'id': '0', 'name': 'Inactive'},
      ];

      List<DropdownMenuEntry<Object>> entries = responseData.map((item) {
        return DropdownMenuEntry<Object>(
          value: item['id'], // Adjust based on your API response
          label: item['name'], // Adjust based on your API response
        );
      }).toList();

      return entries;
    }
// Modify the fetchDropdownCountries function to return a List<DropdownMenuEntry<Object>>
    Future<List<DropdownMenuEntry<Object>>> fetchDropdownCountries() async {
      final response = await http
          .get(Uri.parse(AppConstants.baseUrl + AppConstants.cityListUri));

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);

        List<DropdownMenuEntry<Object>> entries = responseData.map((item) {
          return DropdownMenuEntry<Object>(
            value: item['id'], // Adjust based on your API response
            label: item['name'], // Adjust based on your API response
          );
        }).toList();

        return entries;
      } else {
        throw Exception('Failed to fetch data');
      }
    }

    // Area data from API
    Future<List<DropdownMenuEntry<Object>>> fetchDropdownAreas() async {
      final response = await http.get(Uri.parse(AppConstants.baseUrl +
          AppConstants.areaListUri +
          '$selectedCityValue'));

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);

        List<DropdownMenuEntry<Object>> entries = responseData.map((item) {
          return DropdownMenuEntry<Object>(
            value: item['id'], // Adjust based on your API response
            label: item['name'], // Adjust based on your API response
          );
        }).toList();

        return entries;
      } else {
        throw Exception('Failed to fetch data');
      }
    }

    Future<void> initDataCall() async {
      if (Get.find<StoreController>().isSearching) {
        Get.find<StoreController>().changeSearchStatus(isUpdate: false);
      }
      Get.find<StoreController>().hideAnimation();

      try {
        final storeData = await Get.find<StoreController>().getStoreDetails(
          Store(id: widget.store!.id),
          widget.fromModule,
          slug: widget.slug,
        );

        // Now, you can access the data returned by the API call
        if (storeData != null) {
          // Process the data here
          storeId = storeData.id.toString() ?? '0';
          // _storeNameController =
          //     TextEditingController(text: storeData.name ?? '');
          // Initialize controllers based on _languageList and storeData
          _languageList!.forEach((language) {
            _storeNameController.add(TextEditingController(text: storeData.name?? ''));
            _descriptionController.add(TextEditingController(text: storeData.meta_description?? ''));
            selectedCategoryValue = storeData.storeCategory.toString()!;
            selectedCityValue = storeData.cityId.toString() ?? '1';
            selectedAreaValue = storeData.areaId.toString() ?? '1';
            _storeAddressController.add(TextEditingController(text: storeData.address?? ''));
            _locationLinkController.add(TextEditingController(text: storeData.map_location_link?? ''));
            _fNameController.add(TextEditingController(text: storeData.ownerName?? ''));
            _phoneController.add(TextEditingController(text: storeData.phone?? ''));
            _emailController.add(TextEditingController(text: storeData.email?? ''));
            _websiteController.add(TextEditingController(text: storeData.website_link?? ''));
            _offerDiscountController.add(TextEditingController(text: storeData.offerPercentage?? ''));
            _offerDiscountDiscriptionController.add(TextEditingController(text: storeData.offerPercentageDescription?? ''));
          });

          // You can access other properties of storeData as needed
        } else {
          // Handle the case where storeData is null (e.g., API error)
          print('Store data is null');
        }

        // Continue with other actions
      } catch (e) {
        // Handle any errors that occurred during the API request
        print('Error fetching data: $e');
      }
    }

// Call initDataCall to fetch and update data

    initDataCall();
    // Category data from API
    Future<List<DropdownMenuEntry<Object>>> fetchDropdownCategories() async {

      final response = await http.get(Uri.parse(AppConstants.baseUrl + AppConstants.mainCategoriesListUri));

      if (response.statusCode == 200) {

        final List<dynamic> responseData = json.decode(response.body);

        List<DropdownMenuEntry<Object>> entries = responseData.map((item) {
          return DropdownMenuEntry<Object>(
            value: item['id'], // Adjust based on your API response
            label: item['module_name'], // Adjust based on your API response
          );
        }).toList();

        return entries;
      } else {
        throw Exception('Failed to fetch data');
      }
    }

    return Scaffold(
      appBar: CustomAppBar(
          title: 'store_registration'.tr,
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
                              ? 'Provide Store Information To Proceed Next'
                              : authController.storeStatus == 0.6
                                  ? 'Provide Owner Details To Proceed Next'
                                  : authController.storeStatus == 0.8
                                      ? 'Provide Offer Details To Submit Registration'
                                      : 'Store Registration',
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
                child: SizedBox(
                    width: Dimensions.webMaxWidth,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Form - Part I
                          Visibility(
                            visible: authController.storeStatus == 0.4,
                            child: Column(children: [
                              Row(children: [
                                Expanded(
                                  flex: 4,
                                  child: Align(
                                      alignment: Alignment.center,
                                      child: Stack(children: [
                                        Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                Dimensions.radiusSmall),
                                            child: authController.pickedLogo !=
                                                    null
                                                ? GetPlatform.isWeb
                                                    ? Image.network(
                                                        authController
                                                            .pickedLogo!.path,
                                                        width: 150,
                                                        height: 120,
                                                        fit: BoxFit.cover,
                                                      )
                                                    : Image.file(
                                                        File(authController
                                                            .pickedLogo!.path),
                                                        width: 150,
                                                        height: 120,
                                                        fit: BoxFit.cover,
                                                      )
                                                : SizedBox(
                                                    width: 150,
                                                    height: 120,
                                                    child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(Icons.file_upload,
                                                              size: 38,
                                                              color: Theme.of(
                                                                      context)
                                                                  .disabledColor),
                                                          const SizedBox(
                                                              height: Dimensions
                                                                  .paddingSizeSmall),
                                                          Text(
                                                            'upload_store_logo'
                                                                .tr,
                                                            style: robotoMedium.copyWith(
                                                                color: Theme.of(
                                                                        context)
                                                                    .disabledColor),
                                                            textAlign: TextAlign
                                                                .center,
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
                                            onTap: () => authController
                                                .pickImage(1, false),
                                            child: DottedBorder(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              strokeWidth: 1,
                                              strokeCap: StrokeCap.butt,
                                              dashPattern: const [5, 5],
                                              padding: const EdgeInsets.all(0),
                                              borderType: BorderType.RRect,
                                              radius: const Radius.circular(
                                                  Dimensions.radiusDefault),
                                              child: Center(
                                                child: Visibility(
                                                  visible: authController
                                                          .pickedLogo !=
                                                      null,
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            25),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          width: 2,
                                                          color: Colors.white),
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: const Icon(
                                                        Icons.file_upload,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ])),
                                ),
                                const SizedBox(
                                    width: Dimensions.paddingSizeSmall),
                                Expanded(
                                  flex: 6,
                                  child: Stack(children: [
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            Dimensions.radiusSmall),
                                        child:
                                            authController.pickedCover != null
                                                ? GetPlatform.isWeb
                                                    ? Image.network(
                                                        authController
                                                            .pickedCover!.path,
                                                        width: context.width,
                                                        height: 120,
                                                        fit: BoxFit.cover,
                                                      )
                                                    : Image.file(
                                                        File(authController
                                                            .pickedCover!.path),
                                                        width: context.width,
                                                        height: 120,
                                                        fit: BoxFit.cover,
                                                      )
                                                : SizedBox(
                                                    width: context.width,
                                                    height: 120,
                                                    child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(Icons.file_upload,
                                                              size: 38,
                                                              color: Theme.of(
                                                                      context)
                                                                  .disabledColor),
                                                          const SizedBox(
                                                              height: Dimensions
                                                                  .paddingSizeSmall),
                                                          Text(
                                                            'Store Cover Picture',
                                                            style: robotoMedium.copyWith(
                                                                color: Theme.of(
                                                                        context)
                                                                    .disabledColor),
                                                            textAlign: TextAlign
                                                                .center,
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
                                        onTap: () =>
                                            authController.pickImage(2, false),
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
                                                padding:
                                                    const EdgeInsets.all(25),
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

                              ListView.builder(
                                  itemCount: _languageList!.length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    // Store store = Store();
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        bottom:
                                            Dimensions.paddingSizeExtraLarge,
                                      ),
                                      child: CustomTextField(
                                        titleText:
                                            '${'Store Fullname'} (${_languageList![index].value!})',
                                        controller: _storeNameController.isNotEmpty ? _storeNameController[0] : null,
                                        focusNode: _nameFocus[index],
                                        nextFocus:
                                            index != _languageList!.length - 1
                                                ? _nameFocus[index + 1]
                                                : _descriptionFocus[0],
                                        inputType: TextInputType.name,
                                        capitalization:
                                            TextCapitalization.words,
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
                                        bottom:
                                            Dimensions.paddingSizeExtraLarge),
                                    child: Container(
                                      height:
                                          150, // Adjust the height as needed
                                      child: CustomTextField(
                                        titleText:
                                            '${'Store Description'} (${_languageList![index].value!})',
                                        controller: _descriptionController.isNotEmpty ? _descriptionController[0] : null,
                                        focusNode: _descriptionFocus[index],
                                        nextFocus:
                                            index != _languageList!.length - 1
                                                ? _descriptionFocus[index + 1]
                                                : _addressFocus[0],
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
                              // Store Category
                              Container(
                                // ... Other properties for the Container ...
                                child: FutureBuilder<
                                    List<DropdownMenuEntry<Object>>>(
                                  future: fetchDropdownCategories(),
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
                                      countryEntries.insert(
                                        0,
                                        DropdownMenuEntry<Object>(
                                          value:
                                              0, // Set this to null or a value that represents "no selection"
                                          label: 'Please Select Category',
                                        ),
                                      );

                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 16.0),
                                        child: DropdownMenu(
                                          width: 350,
                                          dropdownMenuEntries: countryEntries,
                                          initialSelection: int.parse(
                                              selectedCategoryValue.toString()),
                                          onSelected: (value) {
                                            // Handle the selected value
                                            setState(() {
                                              selectedCategoryValue =
                                                  value.toString();
                                              print(
                                                  'Selected Category: $value');
                                            });
                                          },
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),

                              //City List
                              Container(
                                // ... Other properties for the Container ...
                                child: FutureBuilder<
                                    List<DropdownMenuEntry<Object>>>(
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
                                      countryEntries.insert(
                                        0,
                                        DropdownMenuEntry<Object>(
                                          value:
                                              0, // Set this to null or a value that represents "no selection"
                                          label: 'Please Select City',
                                        ),
                                      );

                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 16.0),
                                        child: DropdownMenu(
                                          width: 350,
                                          dropdownMenuEntries: countryEntries,
                                          initialSelection: int.parse(
                                              selectedCityValue.toString()),
                                          onSelected: (value) {
                                            // Handle the selected value
                                            setState(() {
                                              selectedCityValue =
                                                  value.toString();
                                              print('Selected City: $value');
                                            });
                                          },
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                              // Area List
                              Container(
                                // ... Other properties for the Container ...
                                child: FutureBuilder<
                                    List<DropdownMenuEntry<Object>>>(
                                  future: fetchDropdownAreas(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      // While data is being fetched, you can show a loading indicator or a placeholder
                                      print(snapshot.data);
                                      return CircularProgressIndicator();
                                    } else {
                                      // Data has been fetched successfully
                                      areaEntries = snapshot
                                          .data!; // Update the countryEntries list with fetched data
                                      // Add a placeholder entry at the beginning of the list
                                      areaEntries.insert(
                                        0,
                                        DropdownMenuEntry<Object>(
                                          value:
                                              0, // Set this to null or a value that represents "no selection"
                                          label: 'Please Select Area',
                                        ),
                                      );

                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 16.0),
                                        child: DropdownMenu(
                                          width: 350,
                                          dropdownMenuEntries: areaEntries,
                                          initialSelection: int.parse(
                                              selectedAreaValue.toString()),
                                          onSelected: (value) {
                                            // Handle the selected value
                                            setState(() {
                                              selectedAreaValue =
                                                  value.toString();
                                              print('Selected Area: $value');
                                            });
                                          },
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),

                              // authController.zoneList != null ? const SelectLocationView(fromView: true) : const Center(child: CircularProgressIndicator()),
                              // const SizedBox(height: Dimensions.paddingSizeLarge),

                              ListView.builder(
                                  itemCount: _languageList!.length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          bottom:
                                              Dimensions.paddingSizeExtraLarge),
                                      child: CustomTextField(
                                        titleText: 'Complete Store Address',
                                        controller: _storeAddressController.isNotEmpty ? _storeAddressController[0] : null,
                                        focusNode: _addressFocus[index],
                                        nextFocus:
                                            index != _languageList!.length - 1
                                                ? _addressFocus[index + 1]
                                                : _vatFocus,
                                        inputType: TextInputType.text,
                                        capitalization:
                                            TextCapitalization.sentences,
                                        maxLines: 3,
                                      ),



                                    );


                                  }),
                              ListView.builder(
                                  itemCount: _languageList!.length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    // Store store = Store();
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        bottom:
                                        Dimensions.paddingSizeExtraLarge,
                                      ),
                                      child: CustomTextField(
                                        titleText:
                                        '${'Google Map Link'} (${_languageList![index].value!})',
                                        controller: _locationLinkController.isNotEmpty ? _locationLinkController[0] : null,
                                        // focusNode: _nameFocus[index],
                                        // nextFocus:
                                        // index != _languageList!.length - 1
                                        //     ? _nameFocus[index + 1]
                                        //     : _descriptionFocus[0],
                                        inputType: TextInputType.name,
                                        // capitalization:
                                        // TextCapitalization.words,
                                      ),

                                    );
                                  }),
                            ]),
                          ),

                          /// Form Part II
                          Visibility(
                            visible: authController.storeStatus == 0.6,
                            child:
                            ListView.builder(
                              itemCount: 1, // You have only one item in this list
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: CustomTextField(
                                            titleText: 'Owner Full Name',
                                            controller: _fNameController[0],
                                            focusNode: _fNameFocus,
                                            nextFocus: _lNameFocus,
                                            inputType: TextInputType.name,
                                            capitalization: TextCapitalization.words,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: Dimensions.paddingSizeSmall,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: Dimensions.paddingSizeExtraLarge,
                                    ),
                                    CustomTextField(
                                      titleText: ResponsiveHelper.isDesktop(context)
                                          ? 'phone'.tr
                                          : 'enter_phone_number'.tr,
                                      controller: _phoneController[0],
                                      focusNode: _phoneFocus,
                                      nextFocus: _emailFocus,
                                      inputType: TextInputType.phone,
                                      isPhone: true,
                                      showTitle: ResponsiveHelper.isDesktop(context),
                                      onCountryChanged: (CountryCode countryCode) {
                                        _countryDialCode = countryCode.dialCode;
                                      },
                                      countryDialCode: _countryDialCode != null
                                          ? CountryCode.fromCountryCode(
                                          Get.find<SplashController>().configModel!.country!)
                                          .code
                                          : Get.find<LocalizationController>().locale.countryCode,
                                    ),
                                    const SizedBox(
                                      height: Dimensions.paddingSizeExtraLarge,
                                    ),
                                    CustomTextField(
                                      titleText: 'email'.tr,
                                      controller: _emailController[0],
                                      focusNode: _emailFocus,
                                      nextFocus: _passwordFocus,
                                      inputType: TextInputType.emailAddress,
                                    ),
                                    const SizedBox(
                                      height: Dimensions.paddingSizeExtraLarge,
                                    ),
                                    CustomTextField(
                                      titleText: 'Website',
                                      controller: _websiteController[0],
                                      focusNode: _websiteFocus,
                                      nextFocus: _passwordFocus,
                                      inputType: TextInputType.emailAddress,
                                    ),
                                    const SizedBox(
                                      height: Dimensions.paddingSizeExtraLarge,
                                    ),
                                    const SizedBox(
                                      height: Dimensions.paddingSizeExtraLarge,
                                    ),
                                  ],
                                );
                              },
                            )

                          ),

                          /// Form Part III
                          Visibility(
                            visible: authController.storeStatus == 0.8,
                            child:
                            ListView.builder(
                              itemCount: 1, // You have only one set of offer details
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: CustomTextField(
                                            titleText: 'Disc %',
                                            controller: _offerDiscountController[0],
                                            focusNode: _offerDiscountFocus,
                                            nextFocus: _offerDiscountDescriptionFocus,
                                            inputType: TextInputType.name,
                                            capitalization: TextCapitalization.words,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: Dimensions.paddingSizeSmall,
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: CustomTextField(
                                            titleText: 'Description',
                                            controller: _offerDiscountDiscriptionController[0],
                                            focusNode: _offerDiscountDescriptionFocus,
                                            inputType: TextInputType.name,
                                            capitalization: TextCapitalization.words,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(
                                          top: 20.0), // Add your desired top margin value here
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 6,
                                            child: Stack(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(5.0),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                    BorderRadius.circular(Dimensions.radiusSmall),
                                                    child: authController.pickedOfferCover != null
                                                        ? GetPlatform.isWeb
                                                        ? Image.network(
                                                      authController.pickedOfferCover!.path,
                                                      width: context.width,
                                                      height: 120,
                                                      fit: BoxFit.cover,
                                                    )
                                                        : Image.file(
                                                      File(
                                                          authController.pickedOfferCover!.path),
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
                                                          Icon(
                                                            Icons.file_upload,
                                                            size: 38,
                                                            color: Theme.of(context).disabledColor,
                                                          ),
                                                          const SizedBox(
                                                            height:
                                                            Dimensions.paddingSizeSmall,
                                                          ),
                                                          Text(
                                                            'Offer Cover Picture',
                                                            style: robotoMedium.copyWith(
                                                                color:
                                                                Theme.of(context).disabledColor),
                                                            textAlign: TextAlign.center,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  bottom: 0,
                                                  right: 0,
                                                  top: 0,
                                                  left: 0,
                                                  child: InkWell(
                                                    onTap: () =>
                                                        authController.pickImage(3, false),
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
                                                          visible: authController.pickedOfferCover != null,
                                                          child: Container(
                                                            padding: const EdgeInsets.all(25),
                                                            decoration: BoxDecoration(
                                                              border: Border.all(
                                                                  width: 3, color: Colors.white),
                                                              shape: BoxShape.circle,
                                                            ),
                                                            child: const Icon(
                                                              Icons.file_upload,
                                                              color: Colors.white,
                                                              size: 50,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                                    Container(
                                      child: FutureBuilder<List<DropdownMenuEntry<Object>>>(
                                        future: fetchDropdownStatus(),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState == ConnectionState.waiting) {

                                            return CircularProgressIndicator();
                                          } else {
                                            // Data has been fetched successfully
                                            statusEntries = snapshot.data!; // Update the countryEntries list with fetched data
                                            // Add a placeholder entry at the beginning of the list

                                            return Padding(
                                              padding: const EdgeInsets.only(bottom: 16.0),
                                              child: DropdownMenu(
                                                width: 350,
                                                dropdownMenuEntries: statusEntries,
                                                initialSelection: selectedStatus,
                                                onSelected: (value) {
                                                  setState(() {
                                                    print(selectedStatus);
                                                    selectedStatus = value.toString();
                                                    print('Selected Status: $value');
                                                    print(selectedStatus);
                                                  });
                                                  print(selectedStatus);
                                                },
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              },
                            )

                          ),

                          const SizedBox(height: Dimensions.paddingSizeLarge),
                        ])),
              ),
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
          String vat = _vatController.text.trim();
          String locationLink = _locationLinkController[0].text;
          String storeName = _storeNameController[0].text;

          String description = _descriptionController[0].text;
          String storeAddress = _storeAddressController[0].text;
          String minTime = authController.storeMinTime;
          String maxTime = authController.storeMaxTime;
          String fName = _fNameController[0].text;
          // String lName = _lNameController[0].text;
          String phone = _phoneController[0].text;
          String email = _emailController[0].text;
          String website = _websiteController[0].text;
          String password = _passwordController.text.trim();
          String offerPercentage = _offerDiscountController[0].text;
          String offerPercentageDescription =
              _offerDiscountDiscriptionController[0].text;
          String gmpLink = _locationLinkController[0].text;
          String discPer = _offerDiscountController[0].text;
          String discDesc = _offerDiscountDiscriptionController[0].text;
          int? userid = Get.find<UserController>().userInfoModel?.id!;

          String userId = userid.toString();

          // String confirmPassword = _confirmPasswordController.text.trim();
          bool valid = false;
          try {
            double.parse(maxTime);
            double.parse(minTime);
            valid = true;
          } on FormatException {
            valid = false;
          }

          if (authController.storeStatus == 0.4 &&
              !ResponsiveHelper.isDesktop(context)) {
            if (storeName == null || storeName.isEmpty) {
              showCustomSnackBar('Enter store name');
            } else {
              authController.storeStatusChange(0.6);
              firstTime = true;
            }
          } else if (authController.storeStatus == 0.6 &&
              !ResponsiveHelper.isDesktop(context)) {
            if (ResponsiveHelper.isDesktop(context)) {
            }
            if (fName.isEmpty) {
              showCustomSnackBar('Enter owner name');
            }
            else if(phone.isEmpty) {
              showCustomSnackBar('enter_phone_number'.tr);
            }
            else if(email.isEmpty) {
              showCustomSnackBar('enter_email_address'.tr);
            }
            // else if(password.isEmpty) {
            //   showCustomSnackBar('enter_password'.tr);
            // }
            // else if(password.length < 6) {
            //   showCustomSnackBar('password_should_be'.tr);
            // }
            else {
              authController.storeStatusChange(0.8);
              firstTime = true;
            }
          } else if (authController.storeStatus == 0.8 &&
              !ResponsiveHelper.isDesktop(context)) {
            if (ResponsiveHelper.isDesktop(context)) {
              if (offerPercentage.isEmpty) {
                showCustomSnackBar('Enter Discount % between 0-100');
              } /*else if(address.isEmpty) {
                showCustomSnackBar('enter_store_address'.tr);
              }*/
              else if (vat.isEmpty) {
                showCustomSnackBar('enter_vat_amount'.tr);
              } else if (minTime.isEmpty) {
                showCustomSnackBar('enter_minimum_delivery_time'.tr);
              } else if (maxTime.isEmpty) {
                showCustomSnackBar('enter_maximum_delivery_time'.tr);
              } else if (!valid) {
                showCustomSnackBar('please_enter_the_max_min_delivery_time'.tr);
              } else if (valid &&
                  double.parse(minTime) > double.parse(maxTime)) {
                showCustomSnackBar(
                    'maximum_delivery_time_can_not_be_smaller_then_minimum_delivery_time'
                        .tr);
              } else if (authController.pickedLogo == null) {
                showCustomSnackBar('select_store_logo'.tr);
              } else if (authController.pickedCover == null) {
                showCustomSnackBar('select_store_cover_photo'.tr);
              } else if (authController.restaurantLocation == null) {
                showCustomSnackBar('set_store_location'.tr);
              }
            }
            if (offerPercentage.isEmpty ||
                int.tryParse(offerPercentage)! > 100) {
              showCustomSnackBar('Enter discount percentage (Between 0-100)');
            }
            else {
              List<Translation> translation = [];

              print('Store updated name : ${storeName}');
              authController.registerStore(StoreBody(
                translation: jsonEncode(translation),
                storeId:storeId,
                storeName: storeName,
                storeAddress: storeAddress,
                cityId: selectedCityValue,
                areaId: selectedAreaValue,
                email: email,
                website: website,
                fName: fName,
                phone: phone,
                password: password,
                description: description,
                category: selectedCategoryValue,
                gmpLink: gmpLink,
                discPer: discPer,
                discDesc: discDesc,
                userId: userId,
                  active: selectedStatus,
              ));
            }
          }
        },
      );
    });
  }
}

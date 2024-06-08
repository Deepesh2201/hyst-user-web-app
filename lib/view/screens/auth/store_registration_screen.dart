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

class StoreRegistrationScreen extends StatefulWidget {
  const StoreRegistrationScreen({Key? key}) : super(key: key);

  @override
  State<StoreRegistrationScreen> createState() => _StoreRegistrationScreenState();
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
                  widget.value != null ? widget.value.toString() : 'Select an item',
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


class _StoreRegistrationScreenState extends State<StoreRegistrationScreen> with TickerProviderStateMixin {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _storeNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _storeAddressController = TextEditingController();
  final TextEditingController _vatController = TextEditingController();
  final TextEditingController _fNameController = TextEditingController();
  final TextEditingController _lNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _locationLinkController = TextEditingController();
  final TextEditingController _offerDiscountController = TextEditingController();
  final TextEditingController _offerDiscountDiscriptionController = TextEditingController();
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
  final List<Language>? _languageList = Get.find<SplashController>().configModel!.language;

  String? _countryDialCode;
  bool firstTime = true;
  TabController? _tabController;
  final List<Tab> _tabs =[];
Object selectedCountryValue = 0;
// Define variables for selected values
  String? selectedCityValue = '0';
  String? selectedAreaValue = '0';
  String? selectedCategoryValue = '0';
  String? selectedSubCategoryValue = '0';

  // List to store the day-wise data
  List<Map<String, dynamic>> dayTimes = List.generate(7, (index) {
    return {
      "day_id": index + 1,
      "starting_time": "00:00:00",
      "ending_time": "00:00:00",
    };
  });

  // Text editing controllers for open and close times
  List<TextEditingController> openTimeControllers = List.generate(7, (_) => TextEditingController());
  List<TextEditingController> closeTimeControllers = List.generate(7, (_) => TextEditingController());

  // Function to update the dayTimes list
  void updateDayTimes(int dayIndex) {
    final String openTime = openTimeControllers[dayIndex].text;
    final String closeTime = closeTimeControllers[dayIndex].text;

    dayTimes[dayIndex] = {
      "day_id": dayIndex + 1,
      "starting_time": openTime,
      "ending_time": closeTime,
    };
  }



  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _languageList!.length, initialIndex: 0, vsync: this);
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

    _languageList?.forEach((language) {
      _tabs.add(Tab(text: language.value));
    });

    if(Get.find<AuthController>().showPassView){
      Get.find<AuthController>().showHidePass(isUpdate: false);
    }

  }





  String selectedStatus = '1';
  @override
  Widget build(BuildContext context) {

    List<DropdownMenuEntry<Object>> countryEntries = []; // Initialize an empty list
    List<DropdownMenuEntry<Object>> areaEntries = []; // Initialize an empty list
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
// Modify the fetchDropdownCountries function to return a List<DropdownMenuEntry<Object>>
    Future<List<DropdownMenuEntry<Object>>> fetchDropdownCountries() async {
      final response = await http.get(Uri.parse(AppConstants.baseUrl + AppConstants.cityListUri));

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
      final response = await http.get(Uri.parse(AppConstants.baseUrl + AppConstants.areaListUri + '$selectedCityValue'));

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

    return Scaffold(
      appBar: CustomAppBar(title: 'store_registration'.tr, onBackPressed: (){
        if(Get.find<AuthController>().dmStatus == 0.4 && firstTime){
          Get.find<AuthController>().storeStatusChange(0.4);
          firstTime = false;
        }else{
          Get.back();
        }
      }),
      endDrawer: const MenuDrawer(), endDrawerEnableOpenDragGesture: false,
      body: SafeArea(child: GetBuilder<AuthController>(builder: (authController) {

        // if(authController.storeAddress != null && _languageList!.isNotEmpty){
        //   _addressController[0].text = authController.storeAddress.toString();
        // }

        return Column(children: [
          WebScreenTitleWidget(title: 'join_as_store'.tr),

          ResponsiveHelper.isDesktop(context) ? const SizedBox() : Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical:  Dimensions.paddingSizeSmall),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
            authController.storeStatus == 0.4
            ? 'Provide Store Information To Proceed Next'
                : authController.storeStatus == 0.6
                ? 'Provide Owner Details To Proceed Next'
                    : authController.storeStatus == 0.8
                ? 'Provide Offer Details To Submit Registration'
                      :authController.storeStatus == 0.9
                ? 'Provide Store Timings'
                    : 'Store Registration',

                style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
              ),

              const SizedBox(height: Dimensions.paddingSizeSmall),

              LinearProgressIndicator(
                backgroundColor: Theme.of(context).disabledColor, minHeight: 2,
                value: authController.storeStatus,
              ),
            ]),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: ResponsiveHelper.isDesktop(context) ? EdgeInsets.zero : const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: Dimensions.paddingSizeDefault),
              child: FooterView(
                child: SizedBox(width: Dimensions.webMaxWidth, child: ResponsiveHelper.isDesktop(context) ? webView(authController)
                : Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [

                  /// Form - Part I
                  Visibility(
                    visible: authController.storeStatus == 0.4,
                    child: Column(children: [

                      Row(children: [
                        Expanded(flex: 4, child:  Align(alignment: Alignment.center, child: Stack(children: [
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                              child: authController.pickedLogo != null ? GetPlatform.isWeb ? Image.network(
                                authController.pickedLogo!.path, width: 150, height: 120, fit: BoxFit.cover,
                              ) : Image.file(
                                File(authController.pickedLogo!.path), width: 150, height: 120, fit: BoxFit.cover,
                              ) : SizedBox(
                                width: 150, height: 120,
                                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

                                  Icon(Icons.file_upload, size: 38, color: Theme.of(context).disabledColor),
                                  const SizedBox(height: Dimensions.paddingSizeSmall),

                                  Text(
                                    'upload_store_logo'.tr,
                                    style: robotoMedium.copyWith(color: Theme.of(context).disabledColor), textAlign: TextAlign.center,
                                  ),
                                ]),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0, right: 0, top: 0, left: 0,
                            child: InkWell(
                              onTap: () => authController.pickImage(1, false),
                              child: DottedBorder(
                                color: Theme.of(context).primaryColor,
                                strokeWidth: 1,
                                strokeCap: StrokeCap.butt,
                                dashPattern: const [5, 5],
                                padding: const EdgeInsets.all(0),
                                borderType: BorderType.RRect,
                                radius: const Radius.circular(Dimensions.radiusDefault),
                                child: Center(
                                  child: Visibility(
                                    visible: authController.pickedLogo != null,
                                    child: Container(
                                      padding: const EdgeInsets.all(25),
                                      decoration: BoxDecoration(
                                        border: Border.all(width: 2, color: Colors.white),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.file_upload, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ])),),
                        const SizedBox(width: Dimensions.paddingSizeSmall),

                        Expanded(flex: 6, child: Stack(children: [
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                              child: authController.pickedCover != null ? GetPlatform.isWeb ? Image.network(
                                authController.pickedCover!.path, width: context.width, height: 120, fit: BoxFit.cover,
                              ) : Image.file(
                                File(authController.pickedCover!.path), width: context.width, height: 120, fit: BoxFit.cover,
                              ) : SizedBox(
                                width: context.width, height: 120,
                                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

                                  Icon(Icons.file_upload, size: 38, color: Theme.of(context).disabledColor),
                                  const SizedBox(height: Dimensions.paddingSizeSmall),

                                  Text(
                                    'Store Cover Picture',
                                    style: robotoMedium.copyWith(color: Theme.of(context).disabledColor), textAlign: TextAlign.center,
                                  ),
                                ]),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0, right: 0, top: 0, left: 0,
                            child: InkWell(
                              onTap: () => authController.pickImage(2, false),
                              child: DottedBorder(
                                color: Theme.of(context).primaryColor,
                                strokeWidth: 1,
                                strokeCap: StrokeCap.butt,
                                dashPattern: const [5, 5],
                                padding: const EdgeInsets.all(0),
                                borderType: BorderType.RRect,
                                radius: const Radius.circular(Dimensions.radiusDefault),
                                child: Center(
                                  child: Visibility(
                                    visible: authController.pickedCover != null,
                                    child: Container(
                                      padding: const EdgeInsets.all(25),
                                      decoration: BoxDecoration(
                                        border: Border.all(width: 3, color: Colors.white),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.file_upload, color: Colors.white, size: 50),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ]),),
                      ]),
                      const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                      ListView.builder(
                          itemCount: _languageList!.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeExtraLarge),
                              child: CustomTextField(
                                titleText: '${'Store Full Name'} (${_languageList![index].value!})',
                                controller: _storeNameController,
                                focusNode: _nameFocus[index],
                                nextFocus: index != _languageList!.length-1 ? _nameFocus[index+1] : _descriptionFocus[0],
                                inputType: TextInputType.name,
                                capitalization: TextCapitalization.words,
                              ),
                            );
                          }
                      ),
                      ListView.builder(
                        itemCount: _languageList!.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeExtraLarge),
                            child: Container(
                              height: 150, // Adjust the height as needed
                              child: CustomTextField(
                                titleText: '${'Store Description'} (${_languageList![index].value!})',
                                controller: _descriptionController,
                                focusNode: _descriptionFocus[index],
                                nextFocus: index != _languageList!.length - 1 ? _descriptionFocus[index + 1] : _addressFocus[0],
                                inputType: TextInputType.multiline, // Use multiline input type for a textarea-like behavior
                                capitalization: TextCapitalization.sentences, // You can change this to your preferred capitalization style
                                maxLines: 6, // Allow the text field to expand vertically as needed
                              ),
                            ),
                          );
                        },
                      ),
                      // Store Category
                      Container(
                        // ... Other properties for the Container ...
                        child: FutureBuilder<List<DropdownMenuEntry<Object>>>(
                          future: fetchDropdownCategories(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              // While data is being fetched, you can show a loading indicator or a placeholder
                              // print(snapshot.data);
                              return CircularProgressIndicator();

                            } else {
                              // Data has been fetched successfully
                              countryEntries = snapshot.data!; // Update the countryEntries list with fetched data
                              // Add a placeholder entry at the beginning of the list
                              countryEntries.insert(
                                0,
                                DropdownMenuEntry<Object>(
                                  value: 0, // Set this to null or a value that represents "no selection"
                                  label: 'Please Select Category',
                                ),
                              );

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: DropdownMenu(
                                  width: 350,
                                  dropdownMenuEntries: countryEntries,
                                  initialSelection: int.parse(selectedCategoryValue.toString()),
                                  onSelected: (value) {
                                    // Handle the selected value
                                    setState(() {
                                      selectedCategoryValue = value.toString();
                                      print('Selected Category: $value');
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
                        child: FutureBuilder<List<DropdownMenuEntry<Object>>>(
                          future: fetchDropdownCountries(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              // While data is being fetched, you can show a loading indicator or a placeholder
                              print(snapshot.data);
                              return CircularProgressIndicator();

                            } else {
                              // Data has been fetched successfully
                              countryEntries = snapshot.data!; // Update the countryEntries list with fetched data
                              // Add a placeholder entry at the beginning of the list
                              countryEntries.insert(
                                0,
                                DropdownMenuEntry<Object>(
                                  value: 0, // Set this to null or a value that represents "no selection"
                                  label: 'Please Select City',
                                ),
                              );

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: DropdownMenu(
                                  width: 350,
                                  dropdownMenuEntries: countryEntries,
                                  initialSelection: int.parse(selectedCityValue.toString()),
                                  onSelected: (value) {
                                    // Handle the selected value
                                    setState(() {
                                      selectedCityValue = value.toString();
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
                        child: FutureBuilder<List<DropdownMenuEntry<Object>>>(
                          future: fetchDropdownAreas(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              // While data is being fetched, you can show a loading indicator or a placeholder
                              print(snapshot.data);
                              return CircularProgressIndicator();

                            } else {
                              // Data has been fetched successfully
                              areaEntries = snapshot.data!; // Update the countryEntries list with fetched data
                              // Add a placeholder entry at the beginning of the list
                              areaEntries.insert(
                                0,
                                DropdownMenuEntry<Object>(
                                  value: 0, // Set this to null or a value that represents "no selection"
                                  label: 'Please Select Area',
                                ),
                              );

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: DropdownMenu(
                                  width: 350,
                                  dropdownMenuEntries: areaEntries,
                                  initialSelection: int.parse(selectedAreaValue.toString()),
                                  onSelected: (value) {
                                    // Handle the selected value
                                    setState(() {
                                      selectedAreaValue = value.toString();
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
                              padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeExtraLarge),
                              child: CustomTextField(
                                titleText: 'Complete Store Address',
                                controller: _storeAddressController,
                                focusNode: _addressFocus[index],
                                nextFocus: index != _languageList!.length-1 ? _addressFocus[index+1] : _vatFocus,
                                inputType: TextInputType.text,
                                capitalization: TextCapitalization.sentences,
                                maxLines: 3,
                              ),
                            );
                          }
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextField(
                            titleText: 'Paste Google Map Location Link',
                            controller: _locationLinkController,
                            // focusNode: _vatFocus,
                            inputAction: TextInputAction.done,
                            inputType: TextInputType.text,
                            // isAmount: true,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 8.0), // Adjust the top margin as needed
                            child: Text(
                              'Copy the link from google map & paste here(Profile > Share)',
                              style: TextStyle(
                                color: Colors.red, // Red color
                                fontSize: 12.0, // Small text size
                              ),
                            ),
                          ),
                        ],
                      )

                    ]),
                  ),

                  /// Form Part II
                  Visibility(
                    visible: authController.storeStatus == 0.6,
                    child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [

                      Row(children: [
                        Expanded(child: CustomTextField(
                          titleText: 'Owner Full Name',
                          controller: _fNameController,
                          focusNode: _fNameFocus,
                          nextFocus: _lNameFocus,
                          inputType: TextInputType.name,
                          capitalization: TextCapitalization.words,
                        )),
                        const SizedBox(width: Dimensions.paddingSizeSmall),

                      ]),

                      const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                      CustomTextField(
                        titleText: ResponsiveHelper.isDesktop(context) ? 'phone'.tr : 'enter_phone_number'.tr,
                        controller: _phoneController,
                        focusNode: _phoneFocus,
                        nextFocus: _emailFocus,
                        inputType: TextInputType.phone,
                        isPhone: true,
                        showTitle: ResponsiveHelper.isDesktop(context),
                        onCountryChanged: (CountryCode countryCode) {
                          _countryDialCode = countryCode.dialCode;
                        },
                        countryDialCode: _countryDialCode != null ? CountryCode.fromCountryCode(Get.find<SplashController>().configModel!.country!).code
                            : Get.find<LocalizationController>().locale.countryCode,
                      ),
                      const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                      CustomTextField(
                        titleText: 'email'.tr,
                        controller: _emailController,
                        focusNode: _emailFocus,
                        nextFocus: _websiteFocus,
                        inputType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                      CustomTextField(
                        titleText: 'Website',
                        controller: _websiteController,
                        focusNode: _websiteFocus,
                        // nextFocus: _passwordFocus,
                        inputType: TextInputType.text,
                      ),
                      const SizedBox(height: Dimensions.paddingSizeExtraLarge),


                    ]),
                  ),

                  /// Form Part III
                  Visibility(
                    visible: authController.storeStatus == 0.8,
                    child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [

                      Row(
                        children: [
                          Expanded(
                            flex: 1, // 25% width
                            child: CustomTextField(
                              titleText: 'Disc %',
                              controller: _offerDiscountController,
                              focusNode: _offerDiscountFocus,
                              nextFocus: _offerDiscountDescriptionFocus,
                              inputType: TextInputType.name,
                              capitalization: TextCapitalization.words,
                            ),
                          ),
                          const SizedBox(width: Dimensions.paddingSizeSmall),
                          Expanded(
                            flex: 3, // 75% width
                            child: CustomTextField(
                              titleText: 'Description',
                              controller: _offerDiscountDiscriptionController,
                              focusNode: _offerDiscountDescriptionFocus,
                              // nextFocus: _phoneFocus,
                              inputType: TextInputType.name,
                              capitalization: TextCapitalization.words,
                            ),
                          ),
                        ],

                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20.0), // Add your desired top margin value here
                        child: Row(
                          children: [
                            Expanded(
                              flex: 6,
                              child: Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                      child: authController.pickedOfferCover != null
                                          ? GetPlatform.isWeb
                                          ? Image.network(
                                        authController.pickedOfferCover!.path,
                                        width: context.width,
                                        height: 120,
                                        fit: BoxFit.cover,
                                      )
                                          : Image.file(
                                        File(authController.pickedOfferCover!.path),
                                        width: context.width,
                                        height: 120,
                                        fit: BoxFit.cover,
                                      )
                                          : SizedBox(
                                        width: context.width,
                                        height: 120,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.file_upload,
                                              size: 38,
                                              color: Theme.of(context).disabledColor,
                                            ),
                                            const SizedBox(height: Dimensions.paddingSizeSmall),
                                            Text(
                                              'Offer Cover Picture',
                                              style: robotoMedium.copyWith(color: Theme.of(context).disabledColor),
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
                                      onTap: () => authController.pickImage(3, false),
                                      child: DottedBorder(
                                        color: Theme.of(context).primaryColor,
                                        strokeWidth: 1,
                                        strokeCap: StrokeCap.butt,
                                        dashPattern: const [5, 5],
                                        padding: const EdgeInsets.all(0),
                                        borderType: BorderType.RRect,
                                        radius: const Radius.circular(Dimensions.radiusDefault),
                                        child: Center(
                                          child: Visibility(
                                            visible: authController.pickedOfferCover != null,
                                            child: Container(
                                              padding: const EdgeInsets.all(25),
                                              decoration: BoxDecoration(
                                                border: Border.all(width: 3, color: Colors.white),
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Icon(Icons.file_upload, color: Colors.white, size: 50),
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


                    ]),
                  ),

                  /// Form Part IV
                  Visibility(
                    visible: authController.storeStatus == 0.9,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        for (int dayIndex = 0; dayIndex < 7; dayIndex++)
                          Padding(
                            padding: EdgeInsets.only(bottom: 8.0), // Add your desired bottom padding
                            child: Row(
                              children: [
                                Text("${getDayName(dayIndex)}: "),
                                Expanded(
                                  flex: 1,
                                  child: CustomTextField(
                                    titleText: 'Open - 00:00:00',
                                    controller: openTimeControllers[dayIndex],
                                    inputType: TextInputType.datetime,
                                    onChanged: (_) => updateDayTimes(dayIndex),
                                  ),
                                ),
                                SizedBox(width: Dimensions.paddingSizeSmall),
                                Expanded(
                                  flex: 1,
                                  child: CustomTextField(
                                    titleText: 'Close - 00:00:00',
                                    controller: closeTimeControllers[dayIndex],
                                    inputType: TextInputType.datetime,
                                    onChanged: (_) => updateDayTimes(dayIndex),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ElevatedButton(
                          onPressed: () {
                            // Handle the save action
                            print(dayTimes);
                          },
                          child: Text('Save'),
                        ),
                      ],
                    ),
                  ),




                  const SizedBox(height: Dimensions.paddingSizeLarge),

                ])),
              ),
            ),
          ),

          (ResponsiveHelper.isDesktop(context) || ResponsiveHelper.isWeb()) ? const SizedBox() : buttonView(),
        ]);
      }
      )),
    );
  }
  String getDayName(int dayIndex) {
    switch (dayIndex) {
      case 0:
        return "Mon";
      case 1:
        return "Tue";
      case 2:
        return "Wed";
      case 3:
        return "Thu";
      case 4:
        return "Fri";
      case 5:
        return "Sat";
      case 6:
        return "Sun";
      default:
        return "Unknown";
    }
  }

  Widget webView(AuthController authController) {
    return Column(children: [
      Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1)],
        ),
        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
        margin: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Row(children: [
            Container(
              height:  40,
              width: 500,
              color: Colors.transparent,
              child: TabBar(
                controller: _tabController,
                indicatorColor: Theme.of(context).primaryColor,
                indicatorWeight: 3,
                labelColor: Theme.of(context).primaryColor,
                unselectedLabelColor: Theme.of(context).disabledColor,
                unselectedLabelStyle: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall),
                labelStyle: robotoBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),
                labelPadding: const EdgeInsets.symmetric(horizontal: Dimensions.radiusDefault, vertical: 0 ),
                isScrollable: true,
                indicatorSize: TabBarIndicatorSize.tab,
                tabs: _tabs,
                onTap: (int ? value) {
                  setState(() {});
                },
              ),
            ),
          ]),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          Row(children: [

            Expanded(
              child: Column( children: [
                CustomTextField(
                  titleText: '${'store_name'.tr} (${_languageList![_tabController!.index].value!})',
                  controller: _nameController,
                  focusNode: _nameFocus[_tabController!.index],
                  nextFocus: _tabController!.index != _languageList!.length-1 ? _addressFocus[_tabController!.index] : _addressFocus[0],
                  inputType: TextInputType.name,
                  capitalization: TextCapitalization.words,
                  showTitle: true,
                ),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                CustomTextField(
                  titleText: '${'store_address'.tr} (${_languageList![_tabController!.index].value!})',
                  controller: _storeAddressController,
                  focusNode: _addressFocus[_tabController!.index],
                  nextFocus: _tabController!.index != _languageList!.length-1 ? _addressFocus[_tabController!.index+1] : _vatFocus,
                  inputType: TextInputType.text,
                  capitalization: TextCapitalization.sentences,
                  maxLines: 3,
                  showTitle: ResponsiveHelper.isDesktop(context),
                ),
                ],
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            Expanded(
              child: Column( children: [
                const SizedBox(height: Dimensions.paddingSizeSmall),
                authController.zoneList != null ? const SelectLocationView(fromView: true, mapView: true) : const Center(child: CircularProgressIndicator()),
                ],
              ),
            )
            ],
          ),
         // const SizedBox(height: Dimensions.paddingSizeSmall),
        ]),
      ),

      Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1)],
        ),
        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
        margin: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
        child: Column(children: [

          Row(children: [
            const Icon(Icons.person),
            Text('general_information'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall))
          ]),
          const Divider(),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          Row(children: [
            Expanded(child: Column(children: [
              Row(children: [
                Expanded(child: CustomTextField(
                  titleText: 'vat_tax'.tr,
                  controller: _vatController,
                  focusNode: _vatFocus,
                  inputAction: TextInputAction.done,
                  inputType: TextInputType.number,
                  isAmount: true,
                  showTitle: true,
                )),
                const SizedBox(width: Dimensions.paddingSizeDefault),

                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('delivery_time'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  InkWell(
                      onTap: () {
                        Get.dialog(const CustomTimePicker());
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                          border: Border.all(color: Theme.of(context).primaryColor, width: 0.5),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                        child: Row(children: [
                          Expanded(child: Text(
                            '${authController.storeMinTime} : ${authController.storeMaxTime} ${authController.storeTimeUnit}',
                            style: robotoMedium,
                          )),
                          Icon(Icons.access_time_filled, color: Theme.of(context).primaryColor,)
                        ]),
                      ),
                    ),
                ])),
              ]),
              const SizedBox(height: Dimensions.paddingSizeSmall),
              authController.zoneList != null ? const SelectLocationView(fromView: true, zoneModuleView : true) : const Center(child: CircularProgressIndicator()),
            ])),

            Expanded(child:  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Expanded(flex: 4, child:  Align(alignment: Alignment.center, child: Column( crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(mainAxisSize: MainAxisSize.min, children: [Text('logo'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall)), Text(' (1:1)', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).primaryColor)) ]),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                Stack(children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                      child: authController.pickedLogo != null ? GetPlatform.isWeb ? Image.network(
                        authController.pickedLogo!.path, width: 150, height: 120, fit: BoxFit.cover,
                      ) : Image.file(
                        File(authController.pickedLogo!.path), width: 150, height: 120, fit: BoxFit.cover,
                      ) : SizedBox(
                        width: 150, height: 120,
                        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

                          Icon(Icons.file_upload, size: 38, color: Theme.of(context).disabledColor),
                          const SizedBox(height: Dimensions.paddingSizeSmall),

                          Text(
                            'upload_store_logo'.tr,
                            style: robotoMedium.copyWith(color: Theme.of(context).disabledColor), textAlign: TextAlign.center,
                          ),
                        ]),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0, right: 0, top: 0, left: 0,
                    child: InkWell(
                      onTap: () => authController.pickImage(1, false),
                      child: DottedBorder(
                        color: Theme.of(context).primaryColor,
                        strokeWidth: 1,
                        strokeCap: StrokeCap.butt,
                        dashPattern: const [5, 5],
                        padding: const EdgeInsets.all(0),
                        borderType: BorderType.RRect,
                        radius: const Radius.circular(Dimensions.radiusDefault),
                        child: Center(
                          child: Visibility(
                            visible: authController.pickedLogo != null,
                            child: Container(
                              padding: const EdgeInsets.all(25),
                              decoration: BoxDecoration(
                                border: Border.all(width: 2, color: Colors.white),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.file_upload, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ])],
              ))),
              const SizedBox(width: Dimensions.paddingSizeSmall),

              Expanded(flex: 6, child: Column(  crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(mainAxisSize: MainAxisSize.min, children: [Text('cover_image'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall)), Text(' (2:1)', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).primaryColor)) ]),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                Stack(children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                      child: authController.pickedCover != null ? GetPlatform.isWeb ? Image.network(
                        authController.pickedCover!.path, width: context.width, height: 120, fit: BoxFit.cover,
                      ) : Image.file(
                        File(authController.pickedCover!.path), width: context.width, height: 120, fit: BoxFit.cover,
                      ) : SizedBox(
                        width: context.width, height: 120,
                        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

                          Icon(Icons.file_upload, size: 38, color: Theme.of(context).disabledColor),
                          const SizedBox(height: Dimensions.paddingSizeSmall),

                          Text(
                            'upload_store_cover'.tr,
                            style: robotoMedium.copyWith(color: Theme.of(context).disabledColor), textAlign: TextAlign.center,
                          ),
                        ]),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0, right: 0, top: 0, left: 0,
                    child: InkWell(
                      onTap: () => authController.pickImage(2, false),
                      child: DottedBorder(
                        color: Theme.of(context).primaryColor,
                        strokeWidth: 1,
                        strokeCap: StrokeCap.butt,
                        dashPattern: const [5, 5],
                        padding: const EdgeInsets.all(0),
                        borderType: BorderType.RRect,
                        radius: const Radius.circular(Dimensions.radiusDefault),
                        child: Center(
                          child: Visibility(
                            visible: authController.pickedCover != null,
                            child: Container(
                              padding: const EdgeInsets.all(25),
                              decoration: BoxDecoration(
                                border: Border.all(width: 3, color: Colors.white),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.file_upload, color: Colors.white, size: 50),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ])],
              )),
            ])),

          ]),

        ]),
      ),

      Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1)],
        ),
        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
        margin: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
        child: Column(children: [
          Row(children: [
            const Icon(Icons.person),
            Text('owner_information'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall))
          ]),
          const Divider(),
          const SizedBox(height: Dimensions.paddingSizeLarge),

          Row(children: [
            Expanded(child: CustomTextField(
              titleText: 'first_name'.tr,
              controller: _fNameController,
              focusNode: _fNameFocus,
              nextFocus: _lNameFocus,
              inputType: TextInputType.name,
              capitalization: TextCapitalization.words,
              showTitle: ResponsiveHelper.isDesktop(context),
            )),
            const SizedBox(width: Dimensions.paddingSizeSmall),

            Expanded(child: CustomTextField(
              titleText: 'last_name'.tr,
              controller: _lNameController,
              focusNode: _lNameFocus,
              nextFocus: _phoneFocus,
              inputType: TextInputType.name,
              capitalization: TextCapitalization.words,
              showTitle: ResponsiveHelper.isDesktop(context),
            )),
            const SizedBox(width: Dimensions.paddingSizeSmall),

            Expanded(
              child: CustomTextField(
                titleText: 'phone'.tr,
                controller: _phoneController,
                focusNode: _phoneFocus,
                nextFocus: _emailFocus,
                inputType: TextInputType.phone,
                isPhone: true,
                showTitle: ResponsiveHelper.isDesktop(context),
                onCountryChanged: (CountryCode countryCode) {
                  _countryDialCode = countryCode.dialCode;
                },
                countryDialCode: _countryDialCode != null ? CountryCode.fromCountryCode(Get.find<SplashController>().configModel!.country!).code
                    : Get.find<LocalizationController>().locale.countryCode,
              ),
            ),

          ]),
          const SizedBox(height: Dimensions.paddingSizeLarge),

        ]),
      ),

      Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1)],
        ),
        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
        margin: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
        child: Column(children: [
          Row(children: [
            const Icon(Icons.lock),
            Text('login_info'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall))
          ]),
          const Divider(),
          const SizedBox(height: Dimensions.paddingSizeLarge),

          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
              child: CustomTextField(
                titleText: 'email'.tr,
                controller: _emailController,
                focusNode: _emailFocus,
                nextFocus: _passwordFocus,
                inputType: TextInputType.emailAddress,
                showTitle: ResponsiveHelper.isDesktop(context),
              ),
            ),
            const SizedBox(width: Dimensions.paddingSizeSmall),

            Expanded(
              child: Column(
                children: [
                  CustomTextField(
                    titleText: 'password'.tr,
                    controller: _passwordController,
                    focusNode: _passwordFocus,
                    nextFocus: _confirmPasswordFocus,
                    inputType: TextInputType.visiblePassword,
                    isPassword: true,
                    onChanged: (value){
                      if(value != null && value.isNotEmpty){
                        if(!authController.showPassView){
                          authController.showHidePass();
                        }
                        authController.validPassCheck(value);
                      }else{
                        if(authController.showPassView){
                          authController.showHidePass();
                        }
                      }
                    },
                    showTitle: ResponsiveHelper.isDesktop(context),
                  ),

                  authController.showPassView ? const PassView() : const SizedBox(),
                ],
              ),
            ),
            const SizedBox(width: Dimensions.paddingSizeSmall),

            Expanded(child: CustomTextField(
              titleText: 'confirm_password'.tr,
              controller: _confirmPasswordController,
              focusNode: _confirmPasswordFocus,
              inputType: TextInputType.visiblePassword,
              inputAction: TextInputAction.done,
              isPassword: true,
              showTitle: ResponsiveHelper.isDesktop(context),
            )),


          ]),
          const SizedBox(height: Dimensions.paddingSizeLarge),
        ]),
      ),

      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              border: Border.all(color: Theme.of(context).hintColor)
          ),
          width: 165,
          child: CustomButton(
            transparent: true,
            textColor: Theme.of(context).hintColor,
            radius: Dimensions.radiusSmall,
            onPressed: () {
              _phoneController.text = '';
              _emailController.text = '';
              _websiteController.text = '';
              _fNameController.text = '';
              _lNameController.text = '';
              _lNameController.text = '';
              _vatController.text = '';
              _passwordController.text = '';
              _locationLinkController.text = '';
              _descriptionController.text = '';
              _confirmPasswordController.text = '';
              _storeNameController.text = '';



              authController.resetStoreRegistration();

              //userController.initData(isUpdate: true);
            },
            buttonText: 'reset'.tr,
            isBold: false,
            fontSize: Dimensions.fontSizeSmall,
          ),
        ),

        const SizedBox( width: Dimensions.paddingSizeLarge),
        SizedBox(width: 165, child: buttonView()),
      ])


    ]);
  }

  Widget buttonView(){
    return GetBuilder<AuthController>(builder: (authController){
      return CustomButton(
        isBold: ResponsiveHelper.isDesktop(context) ? false : true,
        radius: ResponsiveHelper.isDesktop(context) ? Dimensions.radiusSmall : Dimensions.radiusDefault,
        isLoading: authController.isLoading,
        margin: EdgeInsets.all((ResponsiveHelper.isDesktop(context) || ResponsiveHelper.isWeb()) ? 0 : Dimensions.paddingSizeSmall),
        buttonText: authController.storeStatus != 0.9 && !ResponsiveHelper.isDesktop(context) ? 'next'.tr : 'submit'.tr,
        onPressed: () {
          String vat = _vatController.text.trim();
          String locationLink = _locationLinkController.text.trim();
          String storeName = _storeNameController.text.trim();
          String description = _descriptionController.text.trim();
          String storeAddress = _storeAddressController.text.trim();
          String minTime = authController.storeMinTime;
          String maxTime = authController.storeMaxTime;
          String fName = _fNameController.text.trim();
          String lName = _lNameController.text.trim();
          String phone = _phoneController.text.trim();
          String email = _emailController.text.trim();
          String website = _websiteController.text.trim();
          String password = _passwordController.text.trim();
          String offerPercentage = _offerDiscountController.text.trim();
          String offerPercentageDescription = _offerDiscountDiscriptionController.text.trim();
          String gmpLink = _locationLinkController.text.trim();
          String discPer = _offerDiscountController.text.trim();
          String discDesc = _offerDiscountDiscriptionController.text.trim();
          int? userid = Get.find<UserController>().userInfoModel?.id!;

          String userId = userid.toString();
          bool valid = false;
          try {
            double.parse(maxTime);
            double.parse(minTime);
            valid = true;
          } on FormatException {
            valid = false;
          }

          if(authController.storeStatus == 0.4 && !ResponsiveHelper.isDesktop(context)){
            if(authController.pickedLogo == null) {
              showCustomSnackBar('select_store_logo'.tr);
            }

            else{
                authController.storeStatusChange(0.6);
                firstTime = true;

            }
          }
          else if(authController.storeStatus == 0.6 && !ResponsiveHelper.isDesktop(context)){
            if(ResponsiveHelper.isDesktop(context)){

            }
            if(fName.isEmpty) {
              showCustomSnackBar('Enter owner name');
            }

            else{
              authController.storeStatusChange(0.8);
              firstTime = true;

            }
          }
          else if(authController.storeStatus == 0.8 && !ResponsiveHelper.isDesktop(context)){
            if(ResponsiveHelper.isDesktop(context)){
              if(offerPercentage.isEmpty) {
                showCustomSnackBar('Enter Discount % between 0-100');
              }/*else if(address.isEmpty) {
                showCustomSnackBar('enter_store_address'.tr);
              }*/else if(vat.isEmpty) {
                showCustomSnackBar('enter_vat_amount'.tr);
              }else if(minTime.isEmpty) {
                showCustomSnackBar('enter_minimum_delivery_time'.tr);
              }else if(maxTime.isEmpty) {
                showCustomSnackBar('enter_maximum_delivery_time'.tr);
              }else if(!valid) {
                showCustomSnackBar('please_enter_the_max_min_delivery_time'.tr);
              }else if(valid && double.parse(minTime) > double.parse(maxTime)) {
                showCustomSnackBar('maximum_delivery_time_can_not_be_smaller_then_minimum_delivery_time'.tr);
              }else if(authController.pickedLogo == null) {
                showCustomSnackBar('select_store_logo'.tr);
              }else if(authController.pickedCover == null) {
                showCustomSnackBar('select_store_cover_photo'.tr);
              }else if(authController.restaurantLocation == null) {
                showCustomSnackBar('set_store_location'.tr);
              }
            }
            if(offerPercentage.isEmpty || int.tryParse(offerPercentage)! > 100) {
              showCustomSnackBar('Enter discount percentage (Between 0-100)');
            }
            else{
              authController.storeStatusChange(0.9);
              firstTime = true;

            }
        }
          else if(authController.storeStatus == 0.9 && !ResponsiveHelper.isDesktop(context)){
            if(ResponsiveHelper.isDesktop(context)){
              // if(offerPercentage.isEmpty) {
              //   showCustomSnackBar('Enter Discount % between 0-100');
              // }/*else if(address.isEmpty) {
              //   showCustomSnackBar('enter_store_address'.tr);
              // }*/else if(vat.isEmpty) {
              //   showCustomSnackBar('enter_vat_amount'.tr);
              // }else if(minTime.isEmpty) {
              //   showCustomSnackBar('enter_minimum_delivery_time'.tr);
              // }else if(maxTime.isEmpty) {
              //   showCustomSnackBar('enter_maximum_delivery_time'.tr);
              // }else if(!valid) {
              //   showCustomSnackBar('please_enter_the_max_min_delivery_time'.tr);
              // }else if(valid && double.parse(minTime) > double.parse(maxTime)) {
              //   showCustomSnackBar('maximum_delivery_time_can_not_be_smaller_then_minimum_delivery_time'.tr);
              // }else if(authController.pickedLogo == null) {
              //   showCustomSnackBar('select_store_logo'.tr);
              // }else if(authController.pickedCover == null) {
              //   showCustomSnackBar('select_store_cover_photo'.tr);
              // }else if(authController.restaurantLocation == null) {
              //   showCustomSnackBar('set_store_location'.tr);
              // }
            }
            // if(offerPercentage.isEmpty || int.tryParse(offerPercentage)! > 100) {
            //   showCustomSnackBar('Enter discount percentage (Between 0-100)');
            // }
            else {
              List<Translation> translation = [];

              authController.registerStore(StoreBody(

                translation: jsonEncode(translation),storeName: storeName, storeAddress: storeAddress, cityId : selectedCityValue, areaId : selectedAreaValue, email: email, fName: fName, phone: phone, website: website,
                password: password, description: description, category: selectedCategoryValue, gmpLink: gmpLink, discPer: discPer, discDesc: discDesc, userId:userId, active : selectedStatus,
              ));
            }
          }
        },
      );
    });
  }
}

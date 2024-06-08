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
import '../../../data/model/body/job_body.dart';
import '../../../data/model/body/post_body.dart';

class JobCreateScreen extends StatefulWidget {
  const JobCreateScreen({Key? key}) : super(key: key);

  @override
  State<JobCreateScreen> createState() => _JobCreateScreenState();
}

class _JobCreateScreenState extends State<JobCreateScreen>
    with TickerProviderStateMixin {
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _jobTitleController = TextEditingController();
  final TextEditingController _jobDescriptionController = TextEditingController();
  final TextEditingController _designationController = TextEditingController();
  final TextEditingController _minSalaryController = TextEditingController();
  final TextEditingController _maxSalaryController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _educationController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _contactPersonController = TextEditingController();
  final TextEditingController _contactNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();

  final List<Language>? _languageList =
      Get.find<SplashController>().configModel!.language;
  List<Map<String, dynamic>> jobTypeData = [{'id': 1,'name': 'Full Time','checked': false},{'id': 2,'name': 'Part Time','checked': false},{'id': 3,'name': 'Freelance','checked': false}];
  List<Map<String, dynamic>> jobShiftData = [{'id': 1,'name': 'Day Shift','checked': false},{'id': 2,'name': 'Night Shift','checked': false},{'id': 3,'name': 'Rotational Shift','checked': false}];

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


    _languageList?.forEach((language) {
      _tabs.add(Tab(text: language.value));
    });

    if (Get.find<AuthController>().showPassView) {
      Get.find<AuthController>().showHidePass(isUpdate: false);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: CustomAppBar(
          title: 'Add Job/Vacancy',
          onBackPressed: () {

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
                              ? 'We utilize this information to identify the most suitable candidates for the position.'
                                      : 'Job Creation',
                          style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeSmall,
                              color: Theme.of(context).hintColor),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeSmall),

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
                    /// Form
                    Visibility(
                      visible: authController.storeStatus == 0.4,
                      child: Column(children: [
                        /// Company Name
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
                                      'Company Name',
                                  controller: _companyNameController,
                                  inputType: TextInputType.name,
                                  capitalization: TextCapitalization.words,
                                ),
                              );
                            }),
                        /// Company Logo
                        Row(children: [
                          Expanded(flex: 4, child:  Align(alignment: Alignment.center, child: Stack(children: [
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                child: authController.pickedLogo != null ? GetPlatform.isWeb ? Image.network(
                                  authController.pickedLogo!.path, width: 180, height: 120, fit: BoxFit.cover,
                                ) : Image.file(
                                  File(authController.pickedLogo!.path), width: 180, height: 120, fit: BoxFit.cover,
                                ) : SizedBox(
                                  width: 180, height: 120,
                                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

                                    Icon(Icons.file_upload, size: 38, color: Theme.of(context).disabledColor),
                                    const SizedBox(height: Dimensions.paddingSizeSmall),

                                    Text(
                                      'Upload Company Logo',
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

                        ]),
                        const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                        /// Job Title
                        ListView.builder(
                          itemCount: _languageList!.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                  bottom: Dimensions.paddingSizeExtraLarge),
                              child: Container(
                                child: CustomTextField(
                                  titleText:
                                      'Job Title',
                                  controller: _jobTitleController,
                                  inputType: TextInputType
                                      .name, // Use multiline input type for a textarea-like behavior
                                  capitalization: TextCapitalization
                                      .sentences, // You can change this to your preferred capitalization style
                                   // Allow the text field to expand vertically as needed
                                ),
                              ),
                            );
                          },
                        ),
                        /// JOb Description
                        ListView.builder(
                            itemCount: _languageList!.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    bottom: Dimensions.paddingSizeExtraLarge),
                                child: CustomTextField(
                                  titleText: 'Job Description',
                                  controller: _jobDescriptionController,
                                  inputType: TextInputType.multiline,
                                  capitalization: TextCapitalization.words,
                                  maxLines: 3,

                                ),
                              );
                            }),
                        /// Job Designation
                        ListView.builder(
                            itemCount: _languageList!.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    bottom: Dimensions.paddingSizeExtraLarge),
                                child: CustomTextField(
                                  titleText: 'Job Designation',
                                  controller: _designationController,
                                  inputType: TextInputType.name,
                                  capitalization: TextCapitalization.words,

                                ),
                              );
                            }),
                        /// Min Salary & Max Salary
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.all(8.0), // Add margin for spacing
                                child: ListView.builder(
                                  itemCount: _languageList!.length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: Dimensions.paddingSizeExtraLarge),
                                      child: CustomTextField(
                                        titleText: 'Salary(Min)',
                                        controller: _minSalaryController,
                                        inputType: TextInputType.number,
                                        capitalization: TextCapitalization.words,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.all(8.0), // Add margin for spacing
                                child: ListView.builder(
                                  itemCount: _languageList!.length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: Dimensions.paddingSizeExtraLarge),
                                      child: CustomTextField(
                                        titleText: 'Salary(Max)',
                                        controller: _maxSalaryController,
                                        inputType: TextInputType.number,
                                        capitalization: TextCapitalization.sentences,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        /// Location/Area
                        ListView.builder(
                            itemCount: _languageList!.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    bottom: Dimensions.paddingSizeExtraLarge),
                                child: CustomTextField(
                                  titleText: 'Location/Area',
                                  controller: _locationController,
                                  inputType: TextInputType.name,
                                  capitalization: TextCapitalization.sentences,
                                ),
                              );
                            }),
                        /// Education
                        ListView.builder(
                            itemCount: _languageList!.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    bottom: Dimensions.paddingSizeExtraLarge),
                                child: CustomTextField(
                                  titleText: 'Education',
                                  controller: _educationController,
                                  inputType: TextInputType.name,
                                  capitalization: TextCapitalization.sentences,
                                ),
                              );
                            }),
                        /// Experience
                        ListView.builder(
                            itemCount: _languageList!.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    bottom: Dimensions.paddingSizeExtraLarge),
                                child: CustomTextField(
                                  titleText: 'Experience(months)',
                                  controller: _experienceController,
                                  inputType: TextInputType.number,
                                  capitalization: TextCapitalization.sentences,
                                ),
                              );
                            }),
                        /// Contact Person Name
                        ListView.builder(
                            itemCount: _languageList!.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    bottom: Dimensions.paddingSizeExtraLarge),
                                child: CustomTextField(
                                  titleText: 'Contact Person',
                                  controller: _contactPersonController,
                                  inputType: TextInputType.name,
                                  capitalization: TextCapitalization.sentences,
                                  maxLines: 1,
                                ),
                              );
                            }),
                        /// Contact Number
                        ListView.builder(
                            itemCount: _languageList!.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    bottom: Dimensions.paddingSizeExtraLarge),
                                child: CustomTextField(
                                  titleText: 'Contact Number',
                                  controller: _contactNumberController,
                                  inputType: TextInputType.number,
                                  capitalization: TextCapitalization.sentences,
                                ),
                              );
                            }),
                        /// Email
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
                        /// Website
                        ListView.builder(
                            itemCount: _languageList!.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    bottom: Dimensions.paddingSizeExtraLarge),
                                child: CustomTextField(
                                  titleText: 'Website',
                                  controller: _websiteController,
                                  inputType: TextInputType.text,
                                  capitalization: TextCapitalization.sentences,
                                  maxLines: 1,
                                ),
                              );
                            }),
                        /// Select Job Type
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start, // Align children to the start (left)
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Select Job Type',
                                  style: TextStyle(
                                    fontSize: 16, // Adjust the font size as needed
                                    fontWeight: FontWeight.bold, // You can customize the style
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              child: Column(
                                children: jobTypeData.map((jobType) {
                                  return CheckboxListTile(
                                    title: Text(jobType['name']),
                                    value: jobType['checked'],
                                    onChanged: (bool? value) {
                                      setState(() {
                                        jobType['checked'] = value!;
                                      });
                                    },
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                        /// Select Job Shift
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start, // Align children to the start (left)
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Select Job Shift',
                                  style: TextStyle(
                                    fontSize: 16, // Adjust the font size as needed
                                    fontWeight: FontWeight.bold, // You can customize the style
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              child: Column(
                                children: jobShiftData.map((jobShift) {
                                  return CheckboxListTile(
                                    title: Text(jobShift['name']),
                                    value: jobShift['checked'],
                                    onChanged: (bool? value) {
                                      setState(() {
                                        jobShift['checked'] = value!;
                                      });
                                    },
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        )

                      ]),

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
        buttonText: 'submit'.tr,
        onPressed: () {
          String companyName = _companyNameController.text.trim();
          String jobTitle = _jobTitleController.text.trim();
          String jobDescription = _jobDescriptionController.text.trim();
          String designation = _designationController.text.trim();
          String minSalary = _minSalaryController.text.trim();
          String maxSalary = _maxSalaryController.text.trim();
          String location = _locationController.text.trim();
          String education = _educationController.text.trim();
          String experience = _experienceController.text.trim();
          String contactPerson = _contactPersonController.text.trim();
          String contactNumber = _contactNumberController.text.trim();
          String email = _emailController.text.trim();
          String website = _websiteController.text.trim();
          int? userid = Get.find<UserController>().userInfoModel?.id!;

          String userId = userid.toString();

          // String confirmPassword = _confirmPasswordController.text.trim();

          if (authController.storeStatus == 0.4 &&
              !ResponsiveHelper.isDesktop(context)) {




            List<Translation> translation = [];

            List<int> jobType = [];
            List<int> jobShift = [];

            for (final jobTypes in jobTypeData) {
              if (jobTypes['checked']) {
                jobType.add(jobTypes['id']);
              }
            }
            for (final jobShifts in jobShiftData) {
              if (jobShifts['checked']) {
                jobShift.add(jobShifts['id']);
              }
            }

            authController.createJob(JobBody(
              translation: jsonEncode(translation),
              id: '0',
              companyName: companyName,
              jobTitle: jobTitle,
              jobDescription: jobDescription,
              designation: designation,
              minSalary: minSalary,
              maxSalary: maxSalary,
              location: location,
              education: education,
              experience: experience,
              contactPerson: contactPerson,
              contactNumber: contactNumber,
                email: email,
                website: website,
                jobType: jobType,
                jobShift: jobShift,
                userId:userId
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

    // if (response.statusCode == 200) {
    //   final data = json.decode(response.body);
    //   if (data is List) {
    //     amenityData = data.map((item) {
    //       return {
    //         'id': item['id'],
    //         'name': item['name'],
    //         'checked': false, // You can set the initial state as needed
    //       };
    //     }).toList();
    //
    //     setState(() {}); // Trigger a rebuild to display the data
    //   }
    // } else {
    //   // Handle errors or show a message
    // }
  }
}


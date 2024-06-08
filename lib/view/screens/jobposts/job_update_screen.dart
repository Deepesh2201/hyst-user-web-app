import 'dart:convert';
import 'dart:io';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/controller/auth_controller.dart';
import 'package:sixam_mart/controller/jobs_controller.dart';
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
import '../../../data/model/response/jobs_model.dart';

class JobUpdateScreen extends StatefulWidget {
  final Jobs? jobs;
  final bool fromModule;
  final String slug;
  const JobUpdateScreen(
      {Key? key, required this.jobs, required this.fromModule, this.slug = ''})
      : super(key: key);

  @override
  State<JobUpdateScreen> createState() => _JobUpdateScreenState();
}

class _JobUpdateScreenState extends State<JobUpdateScreen>
    with TickerProviderStateMixin {
  List<TextEditingController> _companyNameController = [];
  List<TextEditingController> _jobTitleController = [];
  List<TextEditingController> _jobDescriptionController = [];
  List<TextEditingController> _designationController = [];
  List<TextEditingController> _minSalaryController = [];
  List<TextEditingController> _maxSalaryController = [];
  List<TextEditingController> _locationController = [];
  List<TextEditingController> _educationController = [];
  List<TextEditingController> _experienceController = [];
  List<TextEditingController> _contactPersonController = [];
  List<TextEditingController> _contactNumberController = [];
  List<TextEditingController> _emailController = [];
  List<TextEditingController> _websiteController = [];

  List<String> initialCheckedJobType = [];
  List<String> initialCheckedJobShift = [];
  String? jobId = '0';
  final List<Language>? _languageList =
      Get.find<SplashController>().configModel!.language;
  List<Map<String, dynamic>> jobTypeData = [
    {'id': 1, 'name': 'Full Time', 'checked': false},
    {'id': 2, 'name': 'Part Time', 'checked': false},
    {'id': 3, 'name': 'Freelance', 'checked': false}
  ];
  List<Map<String, dynamic>> jobShiftData = [
    {'id': 1, 'name': 'Day Shift', 'checked': false},
    {'id': 2, 'name': 'Night Shift', 'checked': false},
    {'id': 3, 'name': 'Rotational Shift', 'checked': false}
  ];

  TabController? _tabController;

  final List<Tab> _tabs = [];

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
    Future<void> initDataCall(Jobs jobData) async {
      try {
        // Process the data here
        jobId = jobData.id.toString();

        // Initialize controllers based on jobData
        _companyNameController
            .add(TextEditingController(text: jobData.company_name));
        _jobTitleController.add(TextEditingController(text: jobData.job_title));
        _jobDescriptionController
            .add(TextEditingController(text: jobData.job_description ?? ''));
        _designationController
            .add(TextEditingController(text: jobData.designation ?? ''));
        _minSalaryController
            .add(TextEditingController(text: jobData.salary_min ?? ''));
        _maxSalaryController
            .add(TextEditingController(text: jobData.salary_max ?? ''));
        _locationController
            .add(TextEditingController(text: jobData.location ?? ''));
        _educationController
            .add(TextEditingController(text: jobData.min_education ?? ''));
        _experienceController
            .add(TextEditingController(text: jobData.experience ?? ''));
        _contactPersonController.add(
            TextEditingController(text: jobData.contact_person_name ?? ''));
        _contactNumberController
            .add(TextEditingController(text: jobData.contact_no ?? ''));
        _emailController
            .add(TextEditingController(text: jobData.contact_email ?? ''));
        _websiteController
            .add(TextEditingController(text: jobData.website ?? ''));

        String? jobTypeDataValue = jobData.job_type;
        List<String> jobTypeValues = jobTypeDataValue!.split(',');
        for (int i = 0; i < jobTypeData.length; i++) {
          jobTypeData[i]['checked'] =
              jobTypeValues.contains(jobTypeData[i]['id'].toString());
        }

        String? jobShiftDataValue = jobData.shift;
        List<String> jobShiftValues = jobShiftDataValue!.split(',');
        for (int i = 0; i < jobShiftData.length; i++) {
          jobShiftData[i]['checked'] =
              jobShiftValues.contains(jobShiftData[i]['id'].toString());
        }
      } catch (e) {
        print('Error processing data: $e');
      }
    }

    // Call initDataCall after fetching the data from the API
    Future<void> fetchDataAndInitializeFields() async {
      try {
        final jobData = await Get.find<JobsController>().getJobDetails(
          Jobs(id: widget.jobs!.id),
          widget.fromModule,
          slug: widget.slug,
        );

        if (jobData != null) {
          // Call initDataCall with the fetched data
          initDataCall(jobData);
        } else {
          print('Post data not available');
        }
      } catch (e) {
        print('Error fetching data: $e');
      }
    }
    fetchDataAndInitializeFields(); // Fetch data and initialize fields
    return Scaffold(

      appBar: CustomAppBar(title: 'Add Job/Vacancy', onBackPressed: () {}),
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
                                  titleText: 'Company Name',
                                  controller: _companyNameController.isNotEmpty
                                      ? _companyNameController[0]
                                      : null,
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
                                child: CustomTextField(
                                  titleText: 'Job Title',
                                  controller: _jobTitleController.isNotEmpty
                                      ? _jobTitleController[0]
                                      : null,
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
                                  controller:
                                      _jobDescriptionController.isNotEmpty
                                          ? _jobDescriptionController[0]
                                          : null,
                                  inputType: TextInputType.multiline,
                                  capitalization: TextCapitalization.words,
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
                                  titleText: 'Job Designation',
                                  controller: _designationController.isNotEmpty
                                      ? _designationController[0]
                                      : null,
                                  inputType: TextInputType.name,
                                  capitalization: TextCapitalization.words,
                                ),
                              );
                            }),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.all(
                                    8.0), // Add margin for spacing
                                child: ListView.builder(
                                  itemCount: _languageList!.length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          bottom:
                                              Dimensions.paddingSizeExtraLarge),
                                      child: CustomTextField(
                                        titleText: 'Salary(Min)',
                                        controller:
                                            _minSalaryController.isNotEmpty
                                                ? _minSalaryController[0]
                                                : null,
                                        inputType: TextInputType.number,
                                        capitalization:
                                            TextCapitalization.words,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.all(
                                    8.0), // Add margin for spacing
                                child: ListView.builder(
                                  itemCount: _languageList!.length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          bottom:
                                              Dimensions.paddingSizeExtraLarge),
                                      child: CustomTextField(
                                        titleText: 'Salary(Max)',
                                        controller:
                                            _maxSalaryController.isNotEmpty
                                                ? _maxSalaryController[0]
                                                : null,
                                        inputType: TextInputType.number,
                                        capitalization:
                                            TextCapitalization.sentences,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
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
                                  titleText: 'Location/Area',
                                  controller: _locationController.isNotEmpty
                                      ? _locationController[0]
                                      : null,
                                  inputType: TextInputType.name,
                                  capitalization: TextCapitalization.sentences,
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
                                  titleText: 'Education',
                                  controller: _educationController.isNotEmpty
                                      ? _educationController[0]
                                      : null,
                                  inputType: TextInputType.name,
                                  capitalization: TextCapitalization.sentences,
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
                                  titleText: 'Experience(months)',
                                  controller: _experienceController.isNotEmpty
                                      ? _experienceController[0]
                                      : null,
                                  inputType: TextInputType.number,
                                  capitalization: TextCapitalization.sentences,
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
                                  titleText: 'Contact Person',
                                  controller:
                                      _contactPersonController.isNotEmpty
                                          ? _contactPersonController[0]
                                          : null,
                                  inputType: TextInputType.name,
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
                                  titleText: 'Contact Number',
                                  controller:
                                      _contactNumberController.isNotEmpty
                                          ? _contactNumberController[0]
                                          : null,
                                  inputType: TextInputType.number,
                                  capitalization: TextCapitalization.sentences,
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
                                  controller: _emailController.isNotEmpty
                                      ? _emailController[0]
                                      : null,
                                  inputType: TextInputType.emailAddress,
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
                                  titleText: 'Website',
                                  controller: _websiteController.isNotEmpty
                                      ? _websiteController[0]
                                      : null,
                                  inputType: TextInputType.text,
                                  capitalization: TextCapitalization.sentences,
                                  maxLines: 1,
                                ),
                              );
                            }),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment
                              .start, // Align children to the start (left)
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Select Job Type',
                                  style: TextStyle(
                                    fontSize:
                                        16, // Adjust the font size as needed
                                    fontWeight: FontWeight
                                        .bold, // You can customize the style
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment
                              .start, // Align children to the start (left)
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Select Job Shift',
                                  style: TextStyle(
                                    fontSize:
                                        16, // Adjust the font size as needed
                                    fontWeight: FontWeight
                                        .bold, // You can customize the style
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
          String companyName = _jobTitleController[0].text;
          String jobTitle = _jobDescriptionController[0].text;
          String jobDescription = _jobDescriptionController[0].text;
          String designation = _designationController[0].text;
          String minSalary = _minSalaryController[0].text;
          String maxSalary = _maxSalaryController[0].text;
          String location = _locationController[0].text;
          String education = _educationController[0].text;
          String experience = _experienceController[0].text;
          String contactPerson = _contactPersonController[0].text;
          String contactNumber = _contactNumberController[0].text;
          String email = _emailController[0].text;
          String website = _websiteController[0].text;
          int? userid = Get.find<UserController>().userInfoModel?.id!;

          String userId = userid.toString();

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
                id: widget.jobs!.id.toString(),
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
                userId: userId));
            // }
          }
        },
      );
    });
  }
}

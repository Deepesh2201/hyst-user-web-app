import 'dart:convert';

import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controller/auth_controller.dart';
import '../../../../controller/location_controller.dart';
import '../../../../controller/splash_controller.dart';
import '../../../../helper/custom_validator.dart';
import '../../../base/custom_snackbar.dart';

class GuestButton extends StatelessWidget {
  const GuestButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        minimumSize: const Size(1, 20),
      ),
      onPressed: () {
        Navigator.pushNamed(context, RouteHelper.getInitialRoute());
        //  _login();
      },
      child: RichText(text: TextSpan(children: [
        TextSpan(text: '${'continue_as'.tr} ', style: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: 18)),
        TextSpan(text: 'guest'.tr, style: robotoMedium.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color, fontSize: 20)),

      ])),
    );
  }
}
void _login() async {
  String phone = "";
  String password = "1234567890";
  String numberWithCountryCode = "+44$phone";
  PhoneValid phoneValid = await CustomValidator.isPhoneValid(numberWithCountryCode);
  numberWithCountryCode = phoneValid.phone;

  if (phone.isEmpty) {
    showCustomSnackBar('enter_phone_number'.tr);
  } else if (!phoneValid.isValid) {
    showCustomSnackBar('invalid_phone_number'.tr);
  } else if (password.isEmpty) {
    showCustomSnackBar('enter_password'.tr);
  } else if (password.length < 6) {
    showCustomSnackBar('password_should_be'.tr);
  } else {
        // if (Get.find<SplashController>().configModel!.customerVerification! && int.parse(status.message![0]) == 0) {
          List<int> encoded = utf8.encode(password);
          String data = base64Encode(encoded);
          Get.toNamed(RouteHelper.getVerificationRoute(numberWithCountryCode, "token", RouteHelper.signUp, data));

  }
}

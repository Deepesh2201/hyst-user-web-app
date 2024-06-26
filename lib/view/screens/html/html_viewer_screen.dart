import 'package:sixam_mart/controller/splash_controller.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/html_type.dart';
import 'package:sixam_mart/view/base/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/view/base/footer_view.dart';
import 'package:sixam_mart/view/base/menu_drawer.dart';
import 'package:sixam_mart/view/base/web_page_title_widget.dart';
import 'package:universal_html/html.dart' as html;
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class HtmlViewerScreen extends StatefulWidget {
  final HtmlType htmlType;
  const HtmlViewerScreen({Key? key, required this.htmlType}) : super(key: key);

  @override
  State<HtmlViewerScreen> createState() => _HtmlViewerScreenState();
}

class _HtmlViewerScreenState extends State<HtmlViewerScreen> {
  @override
  void initState() {
    super.initState();

    Get.find<SplashController>().getHtmlText(widget.htmlType);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.htmlType == HtmlType.termsAndCondition
            ? 'terms_conditions'.tr
            : widget.htmlType == HtmlType.aboutUs
            ? 'about_us'.tr
            : widget.htmlType == HtmlType.privacyPolicy
            ? 'privacy_policy'.tr
            : widget.htmlType == HtmlType.shippingPolicy
            ? 'shipping_policy'.tr
            : widget.htmlType == HtmlType.refund
            ? 'refund_policy'.tr
            : widget.htmlType == HtmlType.cancellation
            ? 'cancellation_policy'.tr
            : 'no_data_found'.tr,
      ),
      endDrawer: const MenuDrawer(),
      endDrawerEnableOpenDragGesture: false,
      body: GetBuilder<SplashController>(builder: (splashController) {
        return Center(
          child: splashController.htmlText != null
              ? SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                WebScreenTitleWidget(
                  title: widget.htmlType == HtmlType.termsAndCondition
                      ? 'terms_conditions'.tr
                      : widget.htmlType == HtmlType.aboutUs
                      ? 'about_us'.tr
                      : widget.htmlType == HtmlType.privacyPolicy
                      ? 'privacy_policy'.tr
                      : widget.htmlType == HtmlType.shippingPolicy
                      ? 'shipping_policy'.tr
                      : widget.htmlType == HtmlType.refund
                      ? 'refund_policy'.tr
                      : widget.htmlType == HtmlType.cancellation
                      ? 'cancellation_policy'.tr
                      : 'no_data_found'.tr,
                ),
                FooterView(
                  child: Ink(
                    width: Dimensions.webMaxWidth,
                    color: Theme.of(context).cardColor,
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        HtmlWidget(
                          splashController.htmlText ?? '',
                          key: Key(widget.htmlType.toString()),
                          // onTapUrl: (url) async {
                          //   if (await canLaunch(url)) {
                          //     await launch(url);
                          //   }
                          // },
                        // )
                        //     : SelectableHtml(
                        //   data: splashController.htmlText,
                        //   shrinkWrap: true,
                        //   onLinkTap: (url) async {
                        //     if (url!.startsWith('www.')) {
                        //       url = 'https://$url';
                        //     }
                        //     if (await canLaunch(url)) {
                        //       await launch(url);
                        //     }
                        //   },
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
              : const CircularProgressIndicator(),
        );
      }),
    );
  }
}

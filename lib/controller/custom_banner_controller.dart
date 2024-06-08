import 'package:sixam_mart/controller/location_controller.dart';
import 'package:sixam_mart/data/api/api_checker.dart';
import 'package:sixam_mart/data/model/response/banner_model.dart';
import 'package:sixam_mart/data/model/response/zone_response_model.dart';
import 'package:sixam_mart/data/repository/banner_repo.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';

class CustomBannerController extends GetxController implements GetxService {
  final BannerRepo bannerRepo;
  CustomBannerController({required this.bannerRepo});

  List<String?>? _bannerImageList;
  List<String?>? _featuredBannerList;
  List<dynamic>? _bannerDataList;
  List<dynamic>? _featuredBannerDataList;
  int _currentIndex = 0;

  List<String?>? get bannerImageList => _bannerImageList;
  List<String?>? get featuredBannerList => _featuredBannerList;
  List<dynamic>? get bannerDataList => _bannerDataList;
  List<dynamic>? get featuredBannerDataList => _featuredBannerDataList;
  int get currentIndex => _currentIndex;

  Future<void> getFeaturedBanner() async {
    Response response = await bannerRepo.getFeaturedBannerList();
    if (response.statusCode == 200) {
      _featuredBannerList = [];
      _featuredBannerDataList = [];
      BannerModel bannerModel = BannerModel.fromJson(response.body);

      for (var campaign in bannerModel.campaigns!) {
        _featuredBannerList!.add(campaign.image);
        _featuredBannerDataList!.add(campaign);
      }
      for (var banner in bannerModel.banners!) {
        _featuredBannerList!.add(banner.image);

          _featuredBannerDataList!.add(banner.item);

          _featuredBannerDataList!.add(banner.store);
        if(banner.type == 'default') {
          _featuredBannerDataList!.add(banner.link);
        }else{
          _featuredBannerDataList!.add(null);
        }
      }
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> getBannerList(bool reload) async {

    // if(_bannerImageList == null || reload) {
      _bannerImageList = null;
      Response response = await bannerRepo.getBannerList();
// print('testinggg');
// print(response.body);
// print('done');
      if (response.statusCode == 200) {
        _bannerImageList = [];
        _bannerDataList = [];
        BannerModel bannerModel = BannerModel.fromJson(response.body);
        // for (var campaign in bannerModel.campaigns!) {
        //   _bannerImageList!.add(campaign.image);
        //   _bannerDataList!.add(campaign);
        // }
        for (var banner in bannerModel.banners!) {
          _bannerImageList!.add(banner.image);
          if(banner.item != null) {
            _bannerDataList!.add(banner.item);
          }else if(banner.store != null){
            _bannerDataList!.add(banner.store);
          }else if(banner.type == 'default'){
            _bannerDataList!.add(banner.link);
          }else{
            _bannerDataList!.add(null);
          }
        }
        if(ResponsiveHelper.isDesktop(Get.context) && _bannerImageList!.length % 2 != 0){
          _bannerImageList!.add(_bannerImageList![0]);
          _bannerDataList!.add(_bannerDataList![0]);
        }

      } else {
        ApiChecker.checkApi(response);
      }
      update();
    // }
  }

  void setCurrentIndex(int index, bool notify) {
    _currentIndex = index;
    if(notify) {
      update();
    }
  }
}

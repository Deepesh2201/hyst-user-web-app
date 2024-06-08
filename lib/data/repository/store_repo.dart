
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sixam_mart/controller/localization_controller.dart';
import 'package:sixam_mart/controller/location_controller.dart';
import 'package:sixam_mart/controller/splash_controller.dart';
import 'package:sixam_mart/data/api/api_client.dart';
import 'package:sixam_mart/data/model/response/address_model.dart';
import 'package:sixam_mart/util/app_constants.dart';

import '../model/response/userinfo_model.dart';

class StoreRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  StoreRepo({required this.sharedPreferences, required this.apiClient});

  Future<Response> getStoreList(int offset, String filterBy) async {
    return await apiClient.getData('${AppConstants.storeUri}/$filterBy?offset=$offset&limit=12');
  }

  Future<Response> getJobList(int offset, String filterBy) async {
    return await apiClient.getData('${AppConstants.jobListUri}/$filterBy?offset=$offset&limit=12');
  }

  Future<Response> getPopularStoreList(String type) async {
    return await apiClient.getData('${AppConstants.popularStoreUri}?type=$type');
  }

  Future<Response> getLatestStoreList(String type) async {
    return await apiClient.getData('${AppConstants.latestStoreUri}?type=$type');
  }

  Future<Response> getFeaturedStoreList() async {
    return await apiClient.getData('${AppConstants.storeUri}/all?featured=1&offset=1&limit=50');
  }

  Future<Response> getStoreDetails(String storeID, bool fromCart, String slug) async {
    Map<String, String>? header ;
    if(fromCart){
      AddressModel? addressModel = Get.find<LocationController>().getUserAddress();
      header = apiClient.updateHeader(
        sharedPreferences.getString(AppConstants.token), addressModel?.zoneIds, addressModel?.areaIds,
        Get.find<LocalizationController>().locale.languageCode,
        Get.find<SplashController>().module == null ? Get.find<SplashController>().cacheModule!.id : Get.find<SplashController>().module!.id,
        addressModel?.latitude, addressModel?.longitude, setHeader: false,
      );
    }
    if(slug.isNotEmpty){
      header = apiClient.updateHeader(
        sharedPreferences.getString(AppConstants.token), [], [],
        Get.find<LocalizationController>().locale.languageCode,
        0, '', '', setHeader: false,
      );
    }
    return await apiClient.getData('${AppConstants.storeDetailsUri}${slug.isNotEmpty ? slug : storeID}', headers: header);
  }

  Future<Response> getPostDetails(String postID, bool fromCart, String slug) async {
    Map<String, String>? header ;

    return await apiClient.getData('${AppConstants.postDetailsUri}/${slug.isNotEmpty ? slug : postID}', headers: header);
  }

  Future<Response> getJobDetails(String jobID, bool fromCart, String slug) async {
    Map<String, String>? header ;

    return await apiClient.getData('${AppConstants.jobDetailsUri}/${slug.isNotEmpty ? slug : jobID}', headers: header);
  }

  Future<Response> getStoreItemList(int? storeID, int offset, int? categoryID, String type) async {
    return await apiClient.getData(
      '${AppConstants.storeItemUri}?store_id=$storeID&category_id=$categoryID&offset=$offset&limit=13&type=$type',
    );
  }

  Future<Response> getStoreSearchItemList(String searchText, String? storeID, int offset, String type, int? categoryID) async {
    return await apiClient.getData(
      '${AppConstants.searchUri}items/search?store_id=$storeID&name=$searchText&offset=$offset&limit=10&type=$type&category_id=${categoryID ?? ''}',
    );
  }

  Future<Response> getStoreReviewList(String? storeID) async {
    // return await apiClient.getData('${AppConstants.storeReviewUri}?store_id=$storeID');
    return await apiClient.getData('${AppConstants.storeReviewNew}$storeID');
  }
/// Get List of Business By UserId
  Future<Response> getAllRegisteredStoresList(int? user) async {
    return await apiClient.getData('${AppConstants.allRegisteredStoreByUserUri}/$user');
  }
  Future<Response> getAllPostsList(int? user) async {
    return await apiClient.getData('${AppConstants.postListUri}/$user');
  }
  Future<Response> getAllJobsList(int? user) async {
    return await apiClient.getData('${AppConstants.jobListUri}/$user');
  }
  Future<Response> getStoreRecommendedItemList(int? storeId) async {
    return await apiClient.getData('${AppConstants.storeRecommendedItemUri}?store_id=$storeId&offset=1&limit=50');
  }

  Future<Response> getStoreUpdateDetails(int? storeId) async {
    return await apiClient.getData('${AppConstants.storeUpdateDetailsUri}/$storeId');
  }

  Future<Response> getCartStoreSuggestedItemList(int? storeId) async {
    AddressModel? addressModel = Get.find<LocationController>().getUserAddress();
    Map<String, String> header = apiClient.updateHeader(
      sharedPreferences.getString(AppConstants.token), addressModel?.zoneIds, addressModel?.areaIds,
      Get.find<LocalizationController>().locale.languageCode,
      Get.find<SplashController>().module == null ? Get.find<SplashController>().cacheModule!.id : Get.find<SplashController>().module!.id,
      addressModel?.latitude, addressModel?.longitude, setHeader: false,
    );
    return await apiClient.getData('${AppConstants.cartStoreSuggestedItemsUri}?recommended=1&store_id=$storeId&offset=1&limit=50', headers: header);
  }

  // Future<Response> changePassword(UserInfoModel userInfoModel) async {
  //   return await apiClient.postData(AppConstants.updateProfileUri, {'f_name': userInfoModel.fName, 'l_name': userInfoModel.lName,
  //     'email': userInfoModel.email, 'password': userInfoModel.password});
  // }
 
    // final headers = {
    //   'Content-Type': 'application/json', // Adjust the content type as needed
    //   'Token' : AppConstants.token,
    // };
    //
    // final body = jsonEncode({
    //   'rating': userRating,
    //   'review': description,
    //   'userid': int.parse(Get.parameters['user']!),
    //   // 'token' : Get.find<AuthController>().getUserToken(),
    // });
    //
    // try {
    //   final response = await http.post(
    //     Uri.parse(apiUrl),
    //     headers: headers,
    //     body: body,
    //   );
    //
    //   if (response.statusCode == 200) {
    //     // Successfully submitted the rating and review
    //     // You can handle any response data or UI updates here
    //     print(response.body);
    //   } else {
    //     // Handle API errors or display an error message to the user
    //     print('Error submitting rating and review: ${response.statusCode}');
    //   }
    // } catch (error) {
    //   // Handle network errors or other exceptions
    //   print('Error submitting rating and review: $error');
    // }
  // }

}
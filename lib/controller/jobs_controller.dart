import 'package:sixam_mart/data/api/api_checker.dart';
import 'package:sixam_mart/data/model/response/posts_model.dart';
import 'package:sixam_mart/data/repository/store_repo.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/view/base/custom_snackbar.dart';

import '../data/model/response/jobs_model.dart';

class JobsController extends GetxController implements GetxService {
  final StoreRepo storeRepo;
  JobsController({required this.storeRepo});

  JobsModel? _jobsModel;
  Jobs? _jobs;
  int _categoryIndex = 0;
  bool _isLoading = false;
  String _storeType = 'all';
  String _type = 'all';
  String _searchType = 'all';
  String _searchText = '';
  bool _currentState = true;
  bool _showFavButton = true;
  bool _isSearching = false;
  List<Jobs>? _allJobsList;
  List<Jobs>? get allJobsList => _allJobsList;
  // List<Posts>? _allRegisteredStoresList;
  // List<Posts>? get allRegisteredStoresList => _allRegisteredStoresList;
  JobsModel? get jobsModel => _jobsModel;
  Jobs? get jobs => _jobs;
  int get categoryIndex => _categoryIndex;
  bool get isLoading => _isLoading;
  String get storeType => _storeType;

  String get type => _type;
  String get searchType => _searchType;
  String get searchText => _searchText;
  bool get currentState => _currentState;
  bool get showFavButton => _showFavButton;
  bool get isSearching => _isSearching;

  String filteringUrl(String slug){
    List<String> routes = Get.currentRoute.split('?');
    String replace = '';
    if(slug.isNotEmpty){
      replace = '${routes[0]}?slug=$slug';
    }else {
      replace = '${routes[0]}?slug=${_jobs!.id}';
    }
    return replace;
  }


  void changeFavVisibility(){
    _showFavButton = !_showFavButton;
    update();
  }

  void hideAnimation(){
    _currentState = false;
  }

  void showButtonAnimation(){
    Future.delayed(const Duration(seconds: 3), () {
      _currentState = true;
      update();
    });
  }


  Future<void> getRestaurantRecommendedItemList(int? storeId, bool reload) async {
    if(reload) {
      _jobsModel= null;
      update();
    }

  }



  Future<void> getStoreUpdate(int? storeID) async {

    Response response = await storeRepo.getStoreUpdateDetails(storeID);

    if (response.statusCode == 200) {

      _jobs = Jobs.fromJson(response.body);


    } else {
      showCustomSnackBar('api failed',isError: false);
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> getJobList(int offset, bool reload) async {
    if(reload) {
      _jobsModel = null;
      update();
    }
    Response response = await storeRepo.getJobList(offset, _storeType);
    if (response.statusCode == 200) {
      if (offset == 1) {
        _jobsModel = JobsModel.fromJson(response.body);
      }else {
        _jobsModel!.totalSize = PostsModel.fromJson(response.body).totalSize;
        _jobsModel!.offset = PostsModel.fromJson(response.body).offset;
        _jobsModel!.jobs!.addAll(JobsModel.fromJson(response.body).jobs!);
      }
      update();
    } else {
      ApiChecker.checkApi(response);
    }
  }

  void setStoreType(String type) {
    _storeType = type;
    getJobList(1, true);
  }


  Future<Jobs?> getJobDetails(Jobs jobs, bool fromModule, {bool fromCart = false, String slug = ''}) async {
    _categoryIndex = 0;

    if(jobs?.company_name != null) {
      _jobs = jobs;
    }else {
      _isLoading = true;
      _jobs = null;
      Response response = await storeRepo.getJobDetails(jobs.id.toString(), fromCart, slug);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.body; // Remove jsonDecode
        print('test api data : ${response.body}');
        if (responseData['status'] == 'success') {
          final Map<String, dynamic> jobData = responseData['data'];
          _jobs = Jobs.fromJson(jobData);
        } else {
          // Handle the case where the status is not 'success'
          // You might want to show an error message or take appropriate action.
        }
      } else {
        _isLoading = false;
        ApiChecker.checkApi(response);
      }


      _isLoading = false;
      update();
    }
    return _jobs;
  }

  void changeSearchStatus({bool isUpdate = true}) {
    _isSearching = !_isSearching;
    if(isUpdate) {
      update();
    }
  }

  Future<void> getAllJobsList(int? user) async {
    _allJobsList = null;
    Response response = await storeRepo.getAllJobsList(user);
    if (response.statusCode == 200) {
      _allJobsList = [];

        response.body.forEach((jobs) => _allJobsList!.add(Jobs.fromJson(jobs)));


    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }



}
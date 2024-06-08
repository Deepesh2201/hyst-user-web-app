import 'package:sixam_mart/data/api/api_checker.dart';
import 'package:sixam_mart/data/model/response/posts_model.dart';
import 'package:sixam_mart/data/repository/store_repo.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/view/base/custom_snackbar.dart';

class PostsController extends GetxController implements GetxService {
  final StoreRepo storeRepo;
  PostsController({required this.storeRepo});

  PostsModel? _postModel;
  Posts? _posts;
  int _categoryIndex = 0;
  bool _isLoading = false;
  String _storeType = 'all';
  String _type = 'all';
  String _searchType = 'all';
  String _searchText = '';
  bool _currentState = true;
  bool _showFavButton = true;
  bool _isSearching = false;
  List<Posts>? _allPostsList;
  List<Posts>? get allPostsList => _allPostsList;
  // List<Posts>? _allRegisteredStoresList;
  // List<Posts>? get allRegisteredStoresList => _allRegisteredStoresList;
  PostsModel? get postModel => _postModel;
  Posts? get posts => _posts;
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
      replace = '${routes[0]}?slug=${_posts!.id}';
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
      _postModel = null;
      update();
    }

  }



  Future<void> getStoreUpdate(int? storeID) async {

    Response response = await storeRepo.getStoreUpdateDetails(storeID);

    if (response.statusCode == 200) {

      _posts = Posts.fromJson(response.body);


    } else {
      showCustomSnackBar('api failed',isError: false);
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> getStoreList(int offset, bool reload) async {
    if(reload) {
      _postModel = null;
      update();
    }
    Response response = await storeRepo.getStoreList(offset, _storeType);
    if (response.statusCode == 200) {
      if (offset == 1) {
        _postModel = PostsModel.fromJson(response.body);
      }else {
        _postModel!.totalSize = PostsModel.fromJson(response.body).totalSize;
        _postModel!.offset = PostsModel.fromJson(response.body).offset;
        _postModel!.posts!.addAll(PostsModel.fromJson(response.body).posts!);
      }
      update();
    } else {
      ApiChecker.checkApi(response);
    }
  }

  void setStoreType(String type) {
    _storeType = type;
    getStoreList(1, true);
  }


  Future<Posts?> getPostDetails(Posts posts, bool fromModule, {bool fromCart = false, String slug = ''}) async {
    _categoryIndex = 0;

    if(posts.title != null) {
      _posts = posts;
    }else {
      _isLoading = true;
      _posts = null;
      Response response = await storeRepo.getPostDetails(posts.id.toString(), fromCart, slug);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.body; // Remove jsonDecode

        if (responseData['status'] == 'success') {
          final Map<String, dynamic> postData = responseData['data'];
          _posts = Posts.fromJson(postData);
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
    return _posts;
  }

  void changeSearchStatus({bool isUpdate = true}) {
    _isSearching = !_isSearching;
    if(isUpdate) {
      update();
    }
  }

  Future<void> getAllPostsList(int? user) async {
    _allPostsList = null;
    Response response = await storeRepo.getAllPostsList(user);
    if (response.statusCode == 200) {
      _allPostsList = [];
      // print('23456789');
      // print(response.body.length);
      // print('123456789');
      // if (response.body['status'] != 'error') {
        response.body.forEach((posts) =>
            _allPostsList!.add(Posts.fromJson(posts)));
      // }

    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }


}
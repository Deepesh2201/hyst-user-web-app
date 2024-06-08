import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sixam_mart/controller/auth_controller.dart';
import 'package:sixam_mart/controller/user_controller.dart';
import 'package:sixam_mart/data/api/api_client.dart';


import '../../../../data/model/response/coupon_model.dart';
import '../../../../data/model/response/userinfo_model.dart';
import '../../../../data/repository/store_repo.dart';

class StarRatingPopup extends StatefulWidget {
  final String storeID;

  StarRatingPopup({required this.storeID});

  @override
  _StarRatingPopupState createState() => _StarRatingPopupState();
}

class _StarRatingPopupState extends State<StarRatingPopup> {
  double rating = 0;
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  Widget contentBox(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'Rate This Store',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16.0),
          RatingBar.builder(
            initialRating: rating,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: false,
            itemCount: 5,
            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (newRating) {
              setState(() {
                rating = newRating;
              });
            },
          ),
          const SizedBox(height: 16.0),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(
              hintText: 'Enter your review...',
              border: OutlineInputBorder(),
            ),
            maxLines: 3, // Adjust the number of lines as needed
          ),
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Handle the cancel action here
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  // int storeId = storeID;
                  double userRating = rating;
                  String description = descriptionController.text;
                  UserInfoModel user = Get.find<UserController>().userInfoModel!;
                  // Use the widget.storeID to access the storeID
                  String storeID = widget.storeID;

                  Get.find<UserController>().submitStoreRatings(user, userRating, description, storeID);


                  // Close the popup
                  Navigator.pop(context);
                },
                child: Text('Submit'),
              ),

            ],
          ),
        ],
      ),
    );
  }

}


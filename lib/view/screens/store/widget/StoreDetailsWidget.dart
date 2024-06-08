import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class StoreDetailsWidget extends StatelessWidget {
  final String phone;
  final String email;
  final String address;
  final String description;
  final Uri gmap;
  final String offerBanner;
  final String? offerDescription;

  const StoreDetailsWidget({
    Key? key,
    required this.address,
    required this.phone,
    required this.email,
    required this.description,
    required this.gmap,
    required this.offerBanner,
    this.offerDescription,
  }) : super(key: key);

  _launchPhone() async {
    final phoneNumber = 'tel:$phone';
    if (await canLaunch(phoneNumber)) {
      await launch(phoneNumber);
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Add an Image widget
        ClipRRect(
          borderRadius: BorderRadius.circular(10), // Adjust the radius as needed
          child: Image.network(
            offerBanner, // Assuming offerBanner is the image URL
            width: double.infinity, // Adjust the width as needed
            height: 200, // Set the height as per your design
            fit: BoxFit.cover, // Adjust the fit as needed
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0,top: 8.0),
          child: RichText(
            text: TextSpan(
              children: <TextSpan>[
                const TextSpan(
                  text: '',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    color: Colors.black,
                  ),
                ),
                TextSpan(
                  text: offerDescription,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ),
        InkWell(
          onTap: _launchPhone,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              children: <Widget>[
                const Icon(
                  Icons.phone,
                  size: 16.0,
                  color: Colors.black,
                ),
                const SizedBox(width: 8.0),
                Text(
                  'Phone: $phone',
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: RichText(
            text: TextSpan(
              children: <TextSpan>[
                const TextSpan(
                  text: 'Email: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    color: Colors.black,
                  ),
                ),
                TextSpan(
                  text: email,
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: RichText(
            text: TextSpan(
              children: <TextSpan>[
                const TextSpan(
                  text: 'Description: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    color: Colors.black,
                  ),
                ),
                TextSpan(
                  text: '$description',
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
        InkWell(
          onTap: () {
            if (gmap != null) {
              launch(gmap.toString());
            }
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              children: <Widget>[
                const Icon(
                  Icons.location_on,
                  size: 16.0,
                  color: Colors.black,
                ),
                const SizedBox(width: 8.0),
                Text(
                  'Google Map Link',
                  style: const TextStyle(
                    fontSize: 16.0,
                    decoration: TextDecoration.underline,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: RichText(
            text: TextSpan(
              children: <TextSpan>[
                const TextSpan(
                  text: 'Address: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    color: Colors.black,
                  ),
                ),
                TextSpan(
                  text: address,
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

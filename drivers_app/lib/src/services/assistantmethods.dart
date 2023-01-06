// ignore_for_file: prefer_const_declarations

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:drivers_app/src/models/address_model.dart';
import 'package:drivers_app/src/models/alll_users.dart';
import 'package:drivers_app/src/models/directdetails_models.dart';
import 'package:drivers_app/src/providers/appdata_provider.dart';
import 'package:drivers_app/src/services/config_maps.dart';
import 'package:drivers_app/src/services/requestservices.dart';

final geoApi = 'AIzaSyApwinFv_OIvuidlzMMGYOm830Cz7UVQqg';
final _urlgeo = 'https://maps.googleapis.com/maps/api/geocode';

class AssistantMethods {
  searchCoordinatesAddress(Position position, context) async {
    String placeAdress = '';
    final url = Uri.parse(
        '$_urlgeo/json?latlng=${position.latitude},${position.longitude}&key=$geoApi');
    final response = await RequestAssistant.getRequest(url);
    if (response != 'failed') {
      placeAdress = response["results"][0]["formatted_address"];
      AddressModel userPickUpAddress = AddressModel();
      userPickUpAddress.longitude = position.longitude;
      userPickUpAddress.latitude = position.latitude;
      userPickUpAddress.placeName = placeAdress;
      Provider.of<AppDataProvider>(context, listen: false)
          .updatePickUpLocationAddress(userPickUpAddress);
    }
    return placeAdress;
  }

  Future<DirectionDetails> obtainPlacesDirectionDetails(
      LatLng initialPosition, LatLng finalPosition) async {
    final _urldirection =
        'https://maps.googleapis.com/maps/api/directions/json';
    final directionUrl = Uri.parse(
        '$_urldirection?origin=${initialPosition.latitude},${initialPosition.longitude}&destination=${finalPosition.latitude},${finalPosition.longitude}&key=$geoApi');

    final res = await RequestAssistant.getRequest(directionUrl);

    if (res == 'failed') {}
    DirectionDetails directionDetails = DirectionDetails();
    directionDetails.encodePoints =
        res["routes"][0]["overview_polyline"]["points"];
    directionDetails.distanceText =
        res["routes"][0]["legs"][0]["distance"]["text"];

    directionDetails.distanceValue =
        res["routes"][0]["legs"][0]["distance"]["value"];
    directionDetails.durationText =
        res["routes"][0]["legs"][0]["duration"]["text"];
    directionDetails.durationValue =
        res["routes"][0]["legs"][0]["duration"]["value"];
    return directionDetails;
  }

  int calculateFare(DirectionDetails directionDetails) {
    double timeTravelFare = (directionDetails.durationValue! / 60) * 0;
    double distanceTravelFare = (directionDetails.distanceValue! / 1000) * 1;

    double totalFarePrice = timeTravelFare + distanceTravelFare;

    return totalFarePrice.truncate();
  }

  getCurrentOnlineUserInfo() async {
    // ignore: await_only_futures
    firebaseUser = await FirebaseAuth.instance.currentUser;
    String userId = firebaseUser!.uid;
    DatabaseReference reference =
        FirebaseDatabase.instance.reference().child("users").child(userId);
    reference.once().then((DataSnapshot dataSnapshot) {
      if (dataSnapshot.value != null) {
        // ignore: unused_local_variable
        userCurrentInfo = Users.fromSnapshot(dataSnapshot);
      }
    });
  }
}

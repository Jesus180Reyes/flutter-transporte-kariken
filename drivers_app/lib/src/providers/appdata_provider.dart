import 'package:drivers_app/src/models/address_model.dart';
import 'package:flutter/cupertino.dart';

class AppDataProvider extends ChangeNotifier {
  AddressModel? pickUpLocation, dropOffLocation;
  updatePickUpLocationAddress(AddressModel pickUpAddress) {
    pickUpLocation = pickUpAddress;
    notifyListeners();
  }

  updateDropOffLocationAddress(AddressModel dropOffAddress) {
    dropOffLocation = dropOffAddress;
    notifyListeners();
  }
}

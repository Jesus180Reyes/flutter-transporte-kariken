// ignore_for_file: prefer_const_declarations, avoid_unnecessary_containers

import 'package:drivers_app/src/models/place_predictions_model.dart';
import 'package:drivers_app/src/providers/appdata_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';
import 'package:drivers_app/src/models/address_model.dart';
import 'package:drivers_app/src/services/assistantmethods.dart';
import 'package:drivers_app/src/services/requestservices.dart';
import 'package:drivers_app/src/widgets/utilities/progress_dialog.dart';

// ignore: must_be_immutable
class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<PlacePredictions> placePredictionsList = [];
  @override
  Widget build(BuildContext context) {
    // final results = Provider.of<AppDataProvider>(context).pickUpLocation ?? "";

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Elige un destino',
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                decoration: _cardDecoration(),
                child: const _Destinations(),
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(22),
        bottomRight: Radius.circular(22),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black26,
          blurRadius: 16,
          spreadRadius: 0.5,
          offset: Offset(0.5, 0.5),
        ),
      ],
    );
  }
}

class _Destinations extends StatefulWidget {
  const _Destinations({Key? key}) : super(key: key);

  @override
  __DestinationsState createState() => __DestinationsState();
}

class __DestinationsState extends State<_Destinations> {
  TextEditingController pickUptextEditingController = TextEditingController();
  TextEditingController dropOfftextEditingController = TextEditingController();
  List<PlacePredictions> placePredictionsList = [];

  @override
  Widget build(BuildContext context) {
    final results =
        Provider.of<AppDataProvider>(context).pickUpLocation!.placeName ?? "";
    pickUptextEditingController.text = results;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
      ),
      child: Form(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: pickUptextEditingController,
                autocorrect: false,
                keyboardType: TextInputType.streetAddress,
                decoration: InputDecoration(
                  hintText: 'Punto de Llegada',
                  fillColor: Colors.grey[300],
                  filled: true,
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: const EdgeInsets.all(10),
                  icon: const Icon(
                    Icons.location_pin,
                    size: 34,
                    color: Colors.red,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                onChanged: (value) => findPlaces(value),
                controller: dropOfftextEditingController,
                autocorrect: false,
                keyboardType: TextInputType.streetAddress,
                decoration: InputDecoration(
                  // label: Text('Hola Mundo'),
                  hintText: 'A Donde Quieres Ir?',
                  fillColor: Colors.grey[300],
                  filled: true,
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: const EdgeInsets.all(10),
                  icon: const Icon(
                    Icons.location_pin,
                    size: 34,
                    color: Colors.green,
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: placePredictionsList.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return PredictionTile(
                    placePredictions: placePredictionsList[index],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  final _url = "https://maps.googleapis.com/maps/api/place/autocomplete/json?";
  final country = "hn";
  void findPlaces(String placeName) async {
    // PlacePredictions placePredictionstile;
    if (placeName.length > 1) {
      final autoCompleareurl = Uri.parse(
          '$_url/parameters=null&sessiontoken=123456789&key=$geoApi&input=$placeName&components=country:$country');

      final res = await RequestAssistant.getRequest(autoCompleareurl);
      if (res == 'failed') {
        return;
      }
      final predictions = res["predictions"];
      final placesList = (predictions as List)
          .map((e) => PlacePredictions.fromJson(e))
          .toList();
      setState(() {
        placePredictionsList = placesList;
      });
    }
  }
}

class PredictionTile extends StatelessWidget {
  final PlacePredictions placePredictions;
  const PredictionTile({Key? key, required this.placePredictions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => getPlacesAddressDetails(placePredictions.place_id, context),
      child: Row(
        children: [
          const SizedBox(
            width: 14,
          ),
          const Icon(
            Icons.location_pin,
            size: 32,
            color: Colors.green,
          ),
          const SizedBox(
            width: 25,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  placePredictions.main_text!,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 2,
                ),
                Text(
                  placePredictions.secondary_text!,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 14,
          ),
        ],
      ),
    );
  }

  void getPlacesAddressDetails(String placeId, context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) => const ProgressDialog(
        message: "Espere Un Momento...",
      ),
    );
    final _url = "https://maps.googleapis.com/maps/api/place/details";
    final placeDetailsUrl =
        Uri.parse("$_url/json?place_id=$placeId&key=$geoApi");
    final res = await RequestAssistant.getRequest(placeDetailsUrl);
    Navigator.pop(context);
    if (res == 'failed') {
      return;
    }
    AddressModel address = AddressModel();
    address.placeName = res["result"]["name"];
    address.placeId = placeId;
    address.latitude = res["result"]["geometry"]["location"]["lat"];
    address.longitude = res["result"]["geometry"]["location"]["lng"];

    Provider.of<AppDataProvider>(context, listen: false)
        .updateDropOffLocationAddress(address);
    // print('This is DropOff::  ${address.placeName}');

    Navigator.pop(context, "obtainDirection");
  }
}

// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:ui';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:drivers_app/src/models/directdetails_models.dart';
import 'package:drivers_app/src/providers/appdata_provider.dart';
import 'package:drivers_app/src/services/assistantmethods.dart';
import 'package:drivers_app/src/services/config_maps.dart';
import 'package:drivers_app/src/widgets/utilities/drawer.dart';
import 'package:drivers_app/src/widgets/utilities/progress_dialog.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  bool drawerOpen = true;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  DirectionDetails? tripDirectionDetails;
  //Espacios Argumentos
  late final GoogleMapController googleMapController;
  double bottomPadding = 0;
  List<LatLng> pLineCoordinates = [];
  Set<Polyline> polylineSet = {};
  Set<Marker> markersSet = {};
  Set<Circle> circleSet = {};

  double rideDetailsContainer = 0;
  double requestRideDetailsContainer = 0;
  double payMethodRideDetailsContainer = 0;

  double searchContainerHeight = 255;
  DatabaseReference? rideRequestRef;

  @override
  void initState() {
    super.initState();
    AssistantMethods().getCurrentOnlineUserInfo();
  }

  resetApp() {
    setState(() {
      payMethodRideDetailsContainer = 0;
      drawerOpen = true;
      searchContainerHeight = 255;
      rideDetailsContainer = 0;
      requestRideDetailsContainer = 0;
      bottomPadding = 253;
      polylineSet.clear();
      markersSet.clear();
      pLineCoordinates.clear();
      payMethodRideDetailsContainer = 0;
    });
  }

  displayRideDetailsContainer() async {
    await getPlacesDirections();
    setState(() {
      payMethodRideDetailsContainer = 0;
      searchContainerHeight = 0;
      rideDetailsContainer = 335;
      bottomPadding = 340;
      drawerOpen = false;
    });
  }

// ------------------------------------------------------------
  //Localizar mi Posicion
  final Completer<GoogleMapController> _controller = Completer();
  late final Position currentPosition;
  locatePosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    currentPosition = position;
    LatLng latLngPosition = LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition = CameraPosition(
      target: latLngPosition,
      zoom: 14,
    );
    googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(
        cameraPosition,
      ),
    );
    String address =
        await AssistantMethods().searchCoordinatesAddress(position, context);
    print('Ubicacion: : $address');
  }

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    // final results = Provider.of<AppDataProvider>(context).pickUpLocation;
    // final resultsDropOff =
    //     Provider.of<AppDataProvider>(context).dropOffLocation;

    return Scaffold(
      key: scaffoldKey,
      drawer: Container(
        color: Colors.white,
        width: 255,
        child: const Drawers(),
      ),
      body: Stack(
        children: [
          GoogleMap(
            padding: EdgeInsets.only(bottom: bottomPadding),
            zoomControlsEnabled: true,
            zoomGesturesEnabled: true,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            markers: markersSet,
            circles: circleSet,
            polylines: polylineSet,
            // trafficEnabled: true,
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              setState(
                () {
                  _controller.complete(controller);
                  locatePosition();
                  googleMapController = controller;
                  bottomPadding = 253.0;
                },
              );
            },
          ),
          Positioned(
            top: 45,
            left: 22,
            child: GestureDetector(
              onTap: () {
                if (drawerOpen) {
                  scaffoldKey.currentState!.openDrawer();
                }
                resetApp();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 6.0,
                      spreadRadius: 0.5,
                      offset: Offset(0.7, 0.7),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(
                    (drawerOpen == true) ? Icons.menu : Icons.close,
                    color: Colors.black,
                  ),
                  radius: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  getPlacesDirections() async {
    final initialPos =
        Provider.of<AppDataProvider>(context, listen: false).pickUpLocation;
    final finalPos =
        Provider.of<AppDataProvider>(context, listen: false).dropOffLocation;

    final pickUpLatLng = LatLng(initialPos!.latitude!, initialPos.longitude!);
    final dropOffLatLng = LatLng(finalPos!.latitude!, finalPos.longitude!);

    showDialog(
      context: context,
      builder: (BuildContext context) =>
          const ProgressDialog(message: "Espere un Momento..."),
    );
    final details = await AssistantMethods()
        .obtainPlacesDirectionDetails(pickUpLatLng, dropOffLatLng);
    setState(() {
      tripDirectionDetails = details;
    });
    Navigator.pop(context);
    print('this is encodedpoint ::: ${details.encodePoints}');
    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodedPolyLineResult =
        polylinePoints.decodePolyline(details.encodePoints!);
    pLineCoordinates.clear();
    if (decodedPolyLineResult.isNotEmpty) {
      // ignore: avoid_function_literals_in_foreach_calls
      decodedPolyLineResult.forEach(
        (PointLatLng pointLatLng) {
          pLineCoordinates.add(
            LatLng(pointLatLng.latitude, pointLatLng.longitude),
          );
        },
      );

      setState(() {
        polylineSet.clear();
        Polyline polyline = Polyline(
          color: Colors.indigo,
          polylineId: const PolylineId("PolylineID"),
          jointType: JointType.round,
          points: pLineCoordinates,
          width: 7,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
          geodesic: true,
        );
        polylineSet.add(polyline);
      });
      LatLngBounds latLngBounds;
      if (pickUpLatLng.latitude > dropOffLatLng.latitude &&
          pickUpLatLng.longitude > dropOffLatLng.longitude) {
        latLngBounds =
            LatLngBounds(southwest: dropOffLatLng, northeast: pickUpLatLng);
      } else if (pickUpLatLng.longitude > dropOffLatLng.longitude) {
        latLngBounds = LatLngBounds(
            southwest: LatLng(pickUpLatLng.latitude, dropOffLatLng.longitude),
            northeast: LatLng(dropOffLatLng.latitude, pickUpLatLng.longitude));
      } else if (pickUpLatLng.latitude > dropOffLatLng.latitude) {
        latLngBounds = LatLngBounds(
            southwest: LatLng(dropOffLatLng.latitude, pickUpLatLng.longitude),
            northeast: LatLng(pickUpLatLng.latitude, dropOffLatLng.longitude));
      } else {
        latLngBounds = latLngBounds =
            LatLngBounds(southwest: pickUpLatLng, northeast: dropOffLatLng);
      }
      googleMapController.animateCamera(
        CameraUpdate.newLatLngBounds(latLngBounds, 100),
      );
      Marker pickUpMarker = Marker(
        markerId: const MarkerId("pickUpId"),
        // icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow:
            InfoWindow(title: initialPos.placeName, snippet: "Mi Ubicacion"),
        consumeTapEvents: true,
        position: pickUpLatLng,
      );
      Marker dropOffMarker = Marker(
        flat: true,
        markerId: const MarkerId("dropOffId"),
        // icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: InfoWindow(
          title: finalPos.placeName,
          snippet: "Destino",
        ),

        position: dropOffLatLng,
      );
      setState(() {
        markersSet.add(pickUpMarker);
        markersSet.add(dropOffMarker);
      });
    }
  }

  displayRequestRide() {
    setState(() {
      requestRideDetailsContainer = 240;
      rideDetailsContainer = 0;
      drawerOpen = true;
      bottomPadding = 250;
      payMethodRideDetailsContainer = 0;
    });
    saveRideRequest();
  }

  displayPayRide() {
    setState(() {
      payMethodRideDetailsContainer = 230;
      requestRideDetailsContainer = 0;
      rideDetailsContainer = 0;
      drawerOpen = false;
      bottomPadding = 250;
    });
  }

  saveRideRequest() {
    rideRequestRef =
        FirebaseDatabase.instance.reference().child("Ride Requests").push();
    final pickUp =
        Provider.of<AppDataProvider>(context, listen: false).pickUpLocation;
    final dropOff =
        Provider.of<AppDataProvider>(context, listen: false).dropOffLocation;

    Map pickUpLocMap = {
      "latitude": pickUp!.latitude.toString(),
      "longitude": pickUp.longitude.toString(),
    };
    Map dropOffLocMap = {
      "latitude": dropOff!.latitude.toString(),
      "longitude": dropOff.longitude.toString(),
    };
    Map rideInfoMap = {
      "driver_id": "waiting",
      "payment method": "cash",
      "pickup": pickUpLocMap,
      "dropoff": dropOffLocMap,
      "created at": DateTime.now().toString(),
      "rider_name": userCurrentInfo!.name,
      "rider_lastName": userCurrentInfo!.lastName,
      "rider_phone": userCurrentInfo!.phone,
      "pickUp_address": pickUp.placeName,
      "dropOff_address": dropOff.placeName,
    };

    rideRequestRef!.set(rideInfoMap);
  }

  cancelRideRequest() {
    rideRequestRef!.remove();
  }
}

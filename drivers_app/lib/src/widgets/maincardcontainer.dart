// // ignore_for_file: must_be_immutable

// import 'package:flutter/material.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:provider/provider.dart';
// import 'package:taxi_app/src/providers/appdata_provider.dart';
// import 'package:taxi_app/src/services/assistantmethods.dart';
// import 'package:taxi_app/src/widgets/widgets.dart';

// class CardContainerMain extends StatelessWidget {
//   const CardContainerMain({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 255,
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(22),
//           topRight: Radius.circular(22),
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black45,
//             blurRadius: 16,
//             spreadRadius: 0.5,
//             offset: Offset(0.5, 0.5),
//           ),
//         ],
//       ),
//       child: const Detalles(),
//     );
//   }
// }


// class Detalles extends StatefulWidget {
//   // List<LatLng> pLineCoordinates = [];

//   // Set<Polyline> polylineSet = {};
//   const Detalles({
//     Key? key,
//   }) : super(key: key);

//   @override
//   State<Detalles> createState() => _DetallesState();
// }

// class _DetallesState extends State<Detalles> {
//   List<LatLng> pLineCoordinates = [];

//   Set<Polyline> polylineSet = {};
//   @override
//   Widget build(BuildContext context) {
    // final results = Provider.of<AppDataProvider>(context).pickUpLocation;
    // return Padding(
    //   padding: const EdgeInsets.symmetric(
    //     horizontal: 24,
    //     vertical: 18,
    //   ),
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       Center(
    //         child: Container(
    //           height: 6,
    //           width: 43,
    //           color: Colors.grey[200],
    //         ),
    //       ),
    //       const SizedBox(height: 6.0),
    //       const Text(
    //         'Hola Luis,',
    //         style: TextStyle(
    //           fontSize: 15,
    //         ),
    //       ),
    //       const Text(
    //         '¿Donde Vas?',
    //         style: TextStyle(
    //           fontSize: 20,
    //           fontWeight: FontWeight.bold,
    //         ),
    //       ),
    //       const SizedBox(height: 20.0),
    //       GestureDetector(
    //         onTap: () async {
    //           final res = await Navigator.pushNamed(context, 'search');
    //           if (res == "obtainDirection") {
    //             await getPlacesDirections(context);
    //           }
    //         },
    //         child: Container(
    //           height: 50,
    //           decoration: BoxDecoration(
    //             color: Colors.white,
    //             borderRadius: BorderRadius.circular(5),
    //             boxShadow: const [
    //               BoxShadow(
    //                 color: Colors.black38,
    //                 blurRadius: 6,
    //                 spreadRadius: 0.5,
    //                 offset: Offset(0.5, 0.5),
    //               ),
    //             ],
    //           ),
    //           child: Padding(
    //             padding: const EdgeInsets.all(8.0),
    //             child: Row(
    //               children: const [
    //                 Icon(
    //                   Icons.search,
    //                   color: Colors.indigo,
    //                   size: 30,
    //                 ),
    //                 SizedBox(
    //                   width: 10,
    //                 ),
    //                 Text(
    //                   '¿Donde Quieres ir?',
    //                   style: TextStyle(
    //                     fontSize: 16,
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ),
    //       ),
    //       const SizedBox(
    //         height: 23,
    //       ),
    //       const Divider(
    //         height: 10,
    //         thickness: 1,
    //       ),
    //       const SizedBox(
    //         height: 5,
    //       ),
    //       Row(
    //         children: [
    //           const Icon(
    //             Icons.home,
    //             color: Colors.grey,
    //             size: 30,
    //           ),
    //           const SizedBox(
    //             width: 12.0,
    //           ),
    //           Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               Text(
    //                 // ignore: unnecessary_null_comparison
    //                 (results != null)
    //                     ? results.placeName.toString()
    //                     : 'Add Home',
    //                 style: const TextStyle(
    //                   fontWeight: FontWeight.bold,
    //                   overflow: TextOverflow.ellipsis,
    //                 ),
    //               ),
    //               const SizedBox(
    //                 height: 4.0,
    //               ),
    //               Text(
    //                 'Tu Ubicacion actual',
    //                 style: TextStyle(
    //                   color: Colors.grey[400],
    //                   fontSize: 16,
    //                 ),
    //               )
    //             ],
    //           )
    //         ],
    //       )
    //     ],
    //   ),
    // );
  // }

  // dynamic getPlacesDirections(context) async {
  //   final initialPos =
  //       Provider.of<AppDataProvider>(context, listen: false).pickUpLocation;
  //   final finalPos =
  //       Provider.of<AppDataProvider>(context, listen: false).dropOffLocation;

  //   final pickUpLatLng = LatLng(initialPos!.latitude!, initialPos.longitude!);
  //   final dropOffLatLng = LatLng(finalPos!.latitude!, finalPos.longitude!);

  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) =>
  //         const ProgressDialog(message: "Espere un Momento..."),
  //   );
  //   final details = await AssistantMethods()
  //       .obtainPlacesDirectionDetails(pickUpLatLng, dropOffLatLng);
  //   Navigator.pop(context);
  //   print('this is encodedpoint ::: ${details.encodePoints}');
  //   PolylinePoints polylinePoints = PolylinePoints();
  //   List<PointLatLng> decodedPolyLineResult =
  //       polylinePoints.decodePolyline(details.encodePoints!);
  //   pLineCoordinates.clear();
  //   if (decodedPolyLineResult.isNotEmpty) {
  //     decodedPolyLineResult.forEach(
  //       (PointLatLng pointLatLng) {
  //         pLineCoordinates.add(
  //           LatLng(pointLatLng.latitude, pointLatLng.longitude),
  //         );
  //       },
  //     );

  //     setState(() {
  //       polylineSet.clear();
  //       Polyline polyline = Polyline(
  //         color: Colors.indigo,
  //         polylineId: const PolylineId("PolylineID"),
  //         jointType: JointType.round,
  //         points: pLineCoordinates,
  //         width: 5,
  //         startCap: Cap.roundCap,
  //         endCap: Cap.roundCap,
  //         geodesic: true,
  //       );
  //       polylineSet.add(polyline);
  //     });
  //   }
  // }
// }

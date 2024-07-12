// import 'package:dars_73/services/location_services.dart';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_places_flutter/model/prediction.dart';
// import 'package:location/location.dart';
// import 'package:provider/provider.dart';
// import 'admin_screen.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   late GoogleMapController mapController;
//   LocationData? myLocation;

//   LatLng najotTalim = const LatLng(41.2856806, 69.2034646);
//   LatLng najotTalimOldidagiMagazin = const LatLng(41.2856806, 69.2045946);
//   LatLng? meningJoylashuvim;
//   List<LatLng> myPositions = [];
//   Set<Marker> myMarkers = {};
//   Set<Polyline> polylines = {};
//   Set<Marker> restaurantMarkers = {};

//   void onMapCreated(GoogleMapController controller) {
//     setState(() {
//       mapController = controller;
//     });
//   }

//   void onCameraMove(CameraPosition position) {
//     meningJoylashuvim = position.target;
//     setState(() {});
//   }

//   void addMarker() async {
//     if (meningJoylashuvim == null) return;

//     myMarkers.add(
//       Marker(
//         markerId: MarkerId(UniqueKey().toString()),
//         icon: BitmapDescriptor.defaultMarkerWithHue(
//           BitmapDescriptor.hueRed,
//         ),
//         position: meningJoylashuvim!,
//       ),
//     );

//     myPositions.add(meningJoylashuvim!);

//     if (myPositions.length == 2) {
//       final points = await LocationService.getPolylines(
//         myPositions[0],
//         myPositions[1],
//       );

//       polylines.add(
//         Polyline(
//           polylineId: PolylineId(UniqueKey().toString()),
//           color: Colors.blue,
//           width: 5,
//           points: points,
//         ),
//       );
//     }

//     setState(() {});
//   }

//   void resetMarkers() {
//     myMarkers.clear();
//     myPositions.clear();
//     polylines.clear();
//     restaurantMarkers.clear();
//     setState(() {});
//   }

//   void handlePlaceSelected(Prediction prediction) async {
//     if (prediction.placeId != null) {
//       final placeDetails =
//           await LocationService.getPlaceDetails(prediction.placeId!);
//       final location = placeDetails.geometry?.location;
//       if (location != null) {
//         final position = LatLng(location.lat, location.lng);
//         mapController.animateCamera(CameraUpdate.newLatLng(position));
//         setState(() {
//           meningJoylashuvim = position;
//         });
//       }
//     }
//   }

//   void addRestaurant(String name, String address, String phone, double rating) {
//     if (meningJoylashuvim == null) return;

//     final restaurantMarker = Marker(
//       markerId: MarkerId(UniqueKey().toString()),
//       icon: BitmapDescriptor.defaultMarkerWithHue(
//         BitmapDescriptor.hueYellow,
//       ),
//       position: meningJoylashuvim!,
//       infoWindow: InfoWindow(
//         title: name,
//         snippet: address,
//       ),
//       onTap: () {
//         // Display restaurant details
//         showModalBottomSheet(
//           context: context,
//           builder: (context) => RestaurantDetails(
//             position: meningJoylashuvim!,
//             name: name,
//             address: address,
//             phone: phone,
//             rating: rating,
//           ),
//         );
//       },
//     );

//     restaurantMarkers.add(restaurantMarker);
//     setState(() {});
//   }

//   void editRestaurant(
//       Marker marker, String name, String address, String phone, double rating) {
//     restaurantMarkers.remove(marker);
//     final editedMarker = Marker(
//       markerId: marker.markerId,
//       icon: BitmapDescriptor.defaultMarkerWithHue(
//         BitmapDescriptor.hueYellow,
//       ),
//       position: marker.position,
//       infoWindow: InfoWindow(
//         title: name,
//         snippet: address,
//       ),
//       onTap: () {
//         // Display restaurant details
//         showModalBottomSheet(
//           context: context,
//           builder: (context) => RestaurantDetails(
//             position: marker.position,
//             name: name,
//             address: address,
//             phone: phone,
//             rating: rating,
//           ),
//         );
//       },
//     );

//     restaurantMarkers.add(editedMarker);
//     setState(() {});
//   }

//   void deleteRestaurant(Marker marker) {
//     restaurantMarkers.remove(marker);
//     setState(() {});
//   }

//   void addRestaurantDialog() {
//     showDialog(
//       context: context,
//       builder: (context) {
//         String name = '';
//         String address = '';
//         String phone = '';
//         double rating = 0.0;

//         return AlertDialog(
//           title: Text('Add Restaurant'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 decoration: InputDecoration(labelText: 'Name'),
//                 onChanged: (value) => name = value,
//               ),
//               TextField(
//                 decoration: InputDecoration(labelText: 'Address'),
//                 onChanged: (value) => address = value,
//               ),
//               TextField(
//                 decoration: InputDecoration(labelText: 'Phone'),
//                 onChanged: (value) => phone = value,
//               ),
//               TextField(
//                 decoration: InputDecoration(labelText: 'Rating'),
//                 keyboardType: TextInputType.number,
//                 onChanged: (value) => rating = double.parse(value),
//               ),
//             ],
//           ),
//           actions: [
//             ElevatedButton(
//               onPressed: () {
//                 addRestaurant(name, address, phone, rating);
//                 Navigator.pop(context);
//               },
//               child: Text('Add'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Restaurant'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.menu),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => AdminScreen(
//                     restaurantMarkers: restaurantMarkers,
//                     addRestaurant: addRestaurant,
//                     editRestaurant: editRestaurant,
//                     deleteRestaurant: deleteRestaurant,
//                   ),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//       body: Stack(
//         children: [
//           GoogleMap(
//             initialCameraPosition: CameraPosition(
//               target: najotTalim,
//               zoom: 15,
//             ),
//             mapType: MapType.normal,
//             onMapCreated: onMapCreated,
//             myLocationEnabled: true,
//             myLocationButtonEnabled: true,
//             markers: myMarkers.union(restaurantMarkers),
//             polylines: polylines,
//             onCameraMove: onCameraMove,
//           ),
//         ],
//       ),
//       floatingActionButton: Column(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           if (meningJoylashuvim != null) // Agar joylashuvingiz mavjud bo'lsa
//             FloatingActionButton(
//               heroTag: 'add_marker',
//               onPressed: addMarker,
//               child: const Icon(Icons.add_location),
//             ),
//           const SizedBox(height: 10),
//           FloatingActionButton(
//             heroTag: 'reset_markers',
//             onPressed: resetMarkers,
//             child: const Icon(Icons.clear),
//           ),
//           const SizedBox(height: 10),
//           FloatingActionButton(
//             heroTag: 'add_restaurant',
//             onPressed: addRestaurantDialog,
//             child: const Icon(Icons.add_business),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class RestaurantDetails extends StatelessWidget {
//   final LatLng position;
//   final String name;
//   final String address;
//   final String phone;
//   final double rating;

//   const RestaurantDetails({
//     Key? key,
//     required this.position,
//     required this.name,
//     required this.address,
//     required this.phone,
//     required this.rating,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Text(
//             name,
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           SizedBox(height: 8),
//           Text('Address: $address'),
//           Text('Phone: $phone'),
//           Text('Rating: $rating'),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'admin_screen.dart';
import 'package:dars_73/services/location_services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'admin_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late GoogleMapController mapController;
  LocationData? myLocation;

  LatLng najotTalim = const LatLng(41.2856806, 69.2034646);
  LatLng najotTalimOldidagiMagazin = const LatLng(41.2856806, 69.2045946);
  LatLng? meningJoylashuvim;
  List<LatLng> myPositions = [];
  Set<Marker> myMarkers = {};
  Set<Polyline> polylines = {};
  Set<Marker> restaurantMarkers = {};

  void onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  void onCameraMove(CameraPosition position) {
    meningJoylashuvim = position.target;
    setState(() {});
  }

  void addMarker() async {
    if (meningJoylashuvim == null) return;

    myMarkers.add(
      Marker(
        markerId: MarkerId(UniqueKey().toString()),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueRed,
        ),
        position: meningJoylashuvim!,
      ),
    );

    myPositions.add(meningJoylashuvim!);

    if (myPositions.length == 2) {
      final points = await LocationService.getPolylines(
        myPositions[0],
        myPositions[1],
      );

      polylines.add(
        Polyline(
          polylineId: PolylineId(UniqueKey().toString()),
          color: Colors.blue,
          width: 5,
          points: points,
        ),
      );
    }

    setState(() {});
  }

  void resetMarkers() {
    myMarkers.clear();
    myPositions.clear();
    polylines.clear();
    restaurantMarkers.clear();
    setState(() {});
  }

  void handlePlaceSelected(Prediction prediction) async {
    if (prediction.placeId != null) {
      final placeDetails =
          await LocationService.getPlaceDetails(prediction.placeId!);
      final location = placeDetails.geometry?.location;
      if (location != null) {
        final position = LatLng(location.lat, location.lng);
        mapController.animateCamera(CameraUpdate.newLatLng(position));
        setState(() {
          meningJoylashuvim = position;
        });
      }
    }
  }

  void addRestaurant(String name, String address, String phone, double rating) {
    if (meningJoylashuvim == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: RestaurantDetails(
          position: meningJoylashuvim!,
          name: name,
          address: address,
          phone: phone,
          rating: rating,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close'),
          ),
        ],
      ),
    );

    final restaurantMarker = Marker(
      markerId: MarkerId(UniqueKey().toString()),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueYellow,
      ),
      position: meningJoylashuvim!,
      infoWindow: InfoWindow(
        title: name,
        snippet: address,
      ),
      onTap: () {
        // Show dialog again when marker is tapped
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: RestaurantDetails(
              position: meningJoylashuvim!,
              name: name,
              address: address,
              phone: phone,
              rating: rating,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Close'),
              ),
            ],
          ),
        );
      },
    );

    restaurantMarkers.add(restaurantMarker);
    setState(() {});
  }

  void editRestaurant(
      Marker marker, String name, String address, String phone, double rating) {
    restaurantMarkers.remove(marker);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: RestaurantDetails(
          position: marker.position,
          name: name,
          address: address,
          phone: phone,
          rating: rating,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close'),
          ),
        ],
      ),
    );

    final editedMarker = Marker(
      markerId: marker.markerId,
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueYellow,
      ),
      position: marker.position,
      infoWindow: InfoWindow(
        title: name,
        snippet: address,
      ),
      onTap: () {
        // Show dialog again when marker is tapped
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: RestaurantDetails(
              position: marker.position,
              name: name,
              address: address,
              phone: phone,
              rating: rating,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Close'),
              ),
            ],
          ),
        );
      },
    );

    restaurantMarkers.add(editedMarker);
    setState(() {});
  }

  void deleteRestaurant(Marker marker) {
    restaurantMarkers.remove(marker);
    setState(() {});
  }

  void addRestaurantDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String name = '';
        String address = '';
        String phone = '';
        double rating = 0.0;

        return AlertDialog(
          title: Text('Add Restaurant'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Name'),
                onChanged: (value) => name = value,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Address'),
                onChanged: (value) => address = value,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Phone'),
                onChanged: (value) => phone = value,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Rating'),
                keyboardType: TextInputType.number,
                onChanged: (value) => rating = double.parse(value),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                addRestaurant(name, address, phone, rating);
                Navigator.pop(context);
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant Map'),
        actions: [
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AdminScreen(
                    restaurantMarkers: restaurantMarkers,
                    addRestaurant: addRestaurant,
                    editRestaurant: editRestaurant,
                    deleteRestaurant: deleteRestaurant,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: najotTalim,
              zoom: 15,
            ),
            mapType: MapType.normal,
            onMapCreated: onMapCreated,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            markers: myMarkers.union(restaurantMarkers),
            polylines: polylines,
            onCameraMove: onCameraMove,
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (meningJoylashuvim != null) // If current location is available
            FloatingActionButton(
              heroTag: 'add_marker',
              onPressed: addMarker,
              child: const Icon(Icons.add_location),
            ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: 'reset_markers',
            onPressed: resetMarkers,
            child: const Icon(Icons.clear),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: 'add_restaurant',
            onPressed: addRestaurantDialog,
            child: const Icon(Icons.add_business),
          ),
        ],
      ),
    );
  }
}

class RestaurantDetails extends StatelessWidget {
  final LatLng position;
  final String name;
  final String address;
  final String phone;
  final double rating;

  const RestaurantDetails({
    Key? key,
    required this.position,
    required this.name,
    required this.address,
    required this.phone,
    required this.rating,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            name,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text('Address: $address'),
          SizedBox(height: 4),
          Text('Phone: $phone'),
          SizedBox(height: 4),
          Text('Rating: $rating'),
          SizedBox(height: 8),
      
        ],
      ),
    );
  }
}


import 'package:dars_73/models/location_view_model.dart';
import 'package:dars_73/services/location_services.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:google_places_flutter/google_places_flutter.dart';

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

  @override
  Widget build(BuildContext context) {
    var locationViewModel = context.watch<LocationViewModel>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        title: GooglePlaceAutoCompleteTextField(
          textEditingController: TextEditingController(),
          googleAPIKey: 'AIzaSyC_QSwHlHXbLrprGX1NpXevP948eY8FtXM',
          inputDecoration: InputDecoration(
            hintText: "Manzil izlash..",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.all(16),
          ),
          debounceTime: 800,
          countries: ['uz'],
          isLatLngRequired: true,
          getPlaceDetailWithLatLng: (Prediction prediction) {
            handlePlaceSelected(prediction);
          },
          itemClick: (Prediction prediction) {
            handlePlaceSelected(prediction);
          },
        ),
        actions: [
          PopupMenuButton<MapType>(
            onSelected: (MapType type) {
              locationViewModel.changeMapType(type);
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: MapType.normal,
                child: Text("Normal Ko'rinish"),
              ),
              PopupMenuItem(
                value: MapType.satellite,
                child: Text("Satellite Ko'rinish"),
              ),
              PopupMenuItem(
                value: MapType.terrain,
                child: Text("Terrain Ko'rinish"),
              ),
              PopupMenuItem(
                value: MapType.hybrid,
                child: Text("Hybrid Ko'rinish"),
              ),
            ],
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            buildingsEnabled: true,
            onCameraMove: onCameraMove,
            onMapCreated: onMapCreated,
            initialCameraPosition: CameraPosition(
              target: najotTalim,
              zoom: 15,
            ),
            mapType: locationViewModel.currentMapType,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            markers: {
              Marker(
                markerId: MarkerId("MeningJoylashuvim"),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueAzure,
                ),
                position: meningJoylashuvim ?? najotTalim,
                infoWindow: const InfoWindow(
                  title: "Salom",
                  snippet: "Siz bu orqali Joy belgilab yo'l topishingiz mumkun",
                ),
              ),
              ...myMarkers
            },
            polylines: polylines,
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: addMarker,
            child: const Icon(Icons.add),
          ),
          SizedBox(height: 8),
          FloatingActionButton(
            onPressed: resetMarkers,
            child: const Icon(Icons.refresh),
          ),
        ],
      ),
    );
  }
}

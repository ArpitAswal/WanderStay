import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../view_model/models_provider.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with WidgetsBindingObserver {
  //It provides an interface which is used by WidgetsBinding.addObserver and WidgetsBinding.removeObserver to notify objects of changes in the environment, such as changes to the device metrics or accessibility settings.
  late ModelsProvider provider; // Instance of ModelsProvider for state management.
  late GoogleMapController googleMapController; // Controller for the GoogleMap widget.

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // adding observer
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Called when the system puts the app in the background or returns the app to the foreground.
    if (state == AppLifecycleState.resumed) {
      // Check location permission when app resumes
      Provider.of<ModelsProvider>(context, listen: false).getLocationPermission();
    }
  }

  @override
  void dispose() {
    super.dispose();
    googleMapController.dispose(); // remove google map controller
    WidgetsBinding.instance.removeObserver(this); // remove observer
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size; // Get the screen size.
    return Scaffold(
        body: Selector<ModelsProvider, Set<Marker>>( // Rebuilds only when the marker set changes.
            selector: (_, provider) {
              this.provider = provider; // Keep a reference to the provider.
              return Set<Marker>.from(provider.markerSet); // Create a NEW Set.  This is crucial for the Selector to work correctly.
              // Selector rebuilds the UI only if the selected value changes. By default, it uses == (equality check).
              // If Set<Marker> reference doesn’t change, it won’t rebuild!. So, Modify the selector to return a new Set<Marker> instance:
            },
            builder: (BuildContext context, Set<Marker> markerSet, Widget? child) {
              return Stack( // Use a Stack to overlay the map and info window.
                children: [
                  GoogleMap( // The Google Map widget.
                    initialCameraPosition: CameraPosition( // Initial camera position.
                        target: provider.currentLocation ?? const LatLng(20.5937, 78.9629), // Use current location or default.
                        zoom: 3), // Initial zoom level.
                    compassEnabled: true, // Enable the compass.
                    trafficEnabled: true, // Enable traffic overlay.
                    tiltGesturesEnabled: true, // Enable tilt gestures.
                    scrollGesturesEnabled: true, // Enable scroll gestures.
                    zoomGesturesEnabled: true, // Enable zoom gestures.
                    zoomControlsEnabled: false, // Disable default zoom controls (consider custom controls).
                    onMapCreated: (GoogleMapController controller) { // Called when the map is created.
                      googleMapController = controller; // Store the map controller.
                      provider.windowController.googleMapController = controller; // Pass the controller to the info window controller.
                      if (provider.currentLocation != null) { //prevents the location listener from being called if permissions haven't been granted or location isn't available.
                        provider.locationListener(googleMapController); // Start listening for location changes.
                      }
                    },
                    onTap: (argument) { // Called when the map is tapped.
                      provider.windowController.hideInfoWindow?.call(); // Hide the info window.
                    },
                    onCameraMove: (position) { // Called when the camera moves.
                      provider.windowController.onCameraMove?.call(); // Call the camera move callback in the info window controller.
                    },
                    markers: markerSet, // Set of markers to display on the map.
                  ),
                  CustomInfoWindow( // Custom info window widget.
                    controller: provider.windowController, // Controller for the info window.
                    height: size.height * 0.3, // Height of the info window.
                    width: size.width * 0.8, // Width of the info window.
                    offset: 50, // Offset of the info window from the marker.
                  ),
                ],
              );
            }));
  }
}

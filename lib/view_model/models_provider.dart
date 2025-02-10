import 'dart:async';

import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:wander_stay/model/category_model.dart';
import 'package:wander_stay/model/place_model.dart';
import 'package:wander_stay/service/firestore_database_service.dart';
import 'package:wander_stay/utils/singleton/bottom_sheet.dart';
import 'package:wander_stay/utils/singleton/snackbar.dart';

import '../utils/widgets/places_marker.dart';

class ModelsProvider extends ChangeNotifier {
  final Set<Marker> _markerSet = {}; // Set to store markers on the map.

  late final FirestoreDatabaseService _instance; // Instance of Firestore database service.
  late final CustomInfoWindowController _windowController; // Controller for custom info windows.
  late final Location _userLoc; // Instance of the Location package.
  late final SingletonSnackbar _snackbarInstance; // Instance of snackbar
  late final SingletonBottomSheet _sheetInstance; // Instance of snackbar
  late final AssetMapBitmap placeIcon; // store the custom marker image

  LatLng? _currentLocation; // Current location of the user.
  List<PlaceModel> _places = []; // List to store place data.
  List<CategoryModel> _categories = []; // List to store category data.
  int _selectedCategory = 0; // Index of the selected category.
  bool _isSwitch = false; // Boolean value for a switch (purpose not clear from code).
  bool _isPlacesLoading = false; // indicate whether the places data loading or not
  bool _isCategoriesLoading = false; // indicate whether the categories data loading or not
  CustomInfoWindowController get windowController => _windowController; // window controller access for custom info windows

  // Getters for the private variables.
  LatLng? get currentLocation => _currentLocation;
  int get selectedCategory => _selectedCategory;
  bool get isSwitch => _isSwitch;
  bool get isPlacesLoading => _isPlacesLoading;
  bool get isCategoriesLoading => _isCategoriesLoading;
  List<PlaceModel> get places => _places;
  List<CategoryModel> get categories => _categories;
  Set<Marker> get markerSet => _markerSet;

  // Constructor for the ModelsProvider.
  ModelsProvider() {
    _instance = FirestoreDatabaseService(); // Initialize Firestore database service instance.
    _currentLocation = null; // Initialize current location to null.
    _windowController = CustomInfoWindowController(); // Initialize window controller
    _snackbarInstance = SingletonSnackbar(); // Initialize the instance of snackbar
    _sheetInstance = SingletonBottomSheet(); // Initialize the instance of bottomSheet
    _userLoc = Location(); // Initialize the plugin for location
    getLocationPermission(); // Request location permissions.
    customPlaceIcon(); // call the method to generate custom place icon
    _fetchAllData(); // Fetch data from Firestore.
  }

  // Changes the selected category.
  void changeCategory(int index) {
    _selectedCategory = index; // Update the selected category index.
    notifyListeners(); // Notify listeners about the change.
  }

  // Toggles the switch value.
  void switchChange() {
    _isSwitch = !_isSwitch; // Toggle the boolean value.
    notifyListeners(); // Notify listeners about the change.
  }

  // To determine the status whether the places data is currently fetching or not
  void placesLoadingStatus(){
    _isPlacesLoading = !_isPlacesLoading;
    notifyListeners();
  }

 // To determine the status whether the category data is currently fetching or not
  void categoriesLoadingStatus(){
    _isCategoriesLoading = !_isCategoriesLoading;
    notifyListeners();
  }

  void customPlaceIcon(){ // set the custom icon by image
    BitmapDescriptor.asset(
        ImageConfiguration.empty, "asset/images/marker.png",
        width: 28, height: 28)
        .then((icon) {
      placeIcon = icon;
    });
  }

  // Initializes the markers on the map.
  void initializeMarkers() {
    _markerSet.clear(); // Clear existing markers.

    // Add a marker for the user's current location if available.
    if (currentLocation != null) {
      _markerSet.add(Marker(
        markerId: const MarkerId("User Marker"), // Unique ID for the marker.
        position: currentLocation!, // Position of the marker.
        infoWindow: const InfoWindow( // Info window displayed when marker is tapped.
          title: 'Initial Location',
          snippet: "user device",
        ),
      ));
    }

    // Add markers for each place.
    _markerSet.addAll(_places.map((place) => Marker(
      markerId: MarkerId(place.id), // Unique ID for the marker.
      position: LatLng(place.latitude, place.longitude), // Position of the marker.
      icon: placeIcon,
      infoWindow: InfoWindow( // Info window displayed when marker is tapped.
        title: place.vendor,
        snippet: place.address,
        onTap: () {
          // Show custom info window when marker is tapped.
          _windowController.addInfoWindow?.call(
            PlacesMarker(place: place), // Your custom info window widget.
            LatLng(place.latitude, place.longitude), // Position of the info window.
          );
        },
      ),
    )));

    notifyListeners(); // Notify listeners about the added markers.
  }

  // Listens for changes in the user's location.
  void locationListener(GoogleMapController googleMapController) {
    _userLoc.onLocationChanged.listen((change) {
      _currentLocation = LatLng(change.latitude!, change.longitude!);
      /* googleMapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: _currentLocation!, zoom: 11)));*/
    });
  }

  // Requests location permissions from the user.
  Future<void> getLocationPermission() async {
    try {
      // Check if location services are enabled and request if necessary.
      bool serviceEnabled = await _userLoc.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _userLoc.requestService();
        if (!serviceEnabled) {
          _sheetInstance.permissionBottomSheet(permissionStatus: "Device location not enabled",
          permissionMsg: "Enable the location service to get the feature of Google map service on this app.");
          return;
        }
      }

      // Check and request location permissions.
      PermissionStatus permission = await _userLoc.hasPermission();
      if (permission == PermissionStatus.denied ||
          permission == PermissionStatus.deniedForever) {
        permission = await _userLoc.requestPermission();
        if (permission == PermissionStatus.denied ||
            permission == PermissionStatus.deniedForever) {
          _sheetInstance.permissionBottomSheet(permissionStatus: "Location permission denied",
              permissionMsg: "Enable your device location to see the location difference between your current and certain place location.");
          return;
        }
      }
      // Get position
      getPosition();
    } catch (e) {
      // Handle exceptions
      _snackbarInstance.showSnackbar("Permission Error: $e");
    }
  }

  // Gets the current location of the user.
  void getPosition() {
    // Get the current position
    _userLoc.changeSettings(
        accuracy: LocationAccuracy.high, distanceFilter: 0.1, interval: 1000);
    _userLoc.getLocation().then((location) {
      _currentLocation = LatLng(location.latitude!, location.longitude!);
      _markerSet.add(Marker(
        markerId: const MarkerId("User Marker"),
        position: LatLng(location.latitude!, location.longitude!),
        infoWindow: const InfoWindow(
          title: 'Initial Location',
          snippet: "user stationary address",
        ),
      ));
      initializeMarkers(); // initialize the markers again after getting user location
    }).onError((error, stack) {
      throw ("Location Error: ${error.toString()}");
    });
  }

  // Fetches place and category data from Firestore.
  Future<void> _fetchAllData() async {
    try {
      placesLoadingStatus();
      categoriesLoadingStatus();

      // Listen to changes in the "WanderStay_Places" collection.
      _instance.getSnapshots("WanderStay_Places").listen((snapshot) {
        // Map the documents to PlaceModel objects.
        _places = snapshot.docs.map((doc) {
          return PlaceModel.fromMap(doc.data());
        }).toList();
      });

      // Listen to changes in the "WanderStay_Categories" collection.
      _instance.getSnapshots("WanderStay_Categories").listen((snapshot) {
        // Map the documents to CategoryModel objects.
        _categories = snapshot.docs.map((doc) {
          return CategoryModel.fromMap(doc.data());
        }).toList();
      });

      await Future.delayed(const Duration(seconds: 3)); // delay for 3 seconds to display the data being fetched from server or database
      initializeMarkers(); // Initialize markers on the map.
      notifyListeners(); // Notify listeners that the data has changed.

    } catch (e) {
      _snackbarInstance.showSnackbar("Error fetching data: $e"); // Print any errors that occur.
    } finally{
      placesLoadingStatus();
      categoriesLoadingStatus();
    }
  }
}

/*
      // Use Future.wait to fetch multiple collections concurrently
      final results = await Future.wait([
        _instance.getCollection('WanderStay_Places'),
        _instance.getCollection('WanderStay_Categories'),
      ]);

      // Process places data
      final placesSnapshot = results[0];
      _places = placesSnapshot.docs
          .map((doc) => PlaceModel.fromMap(doc.data()))
          .toList();

      // Process categories data
      final categoriesSnapshot = results[1];
      _categories = categoriesSnapshot.docs
          .map((doc) => CategoryModel.fromMap(doc.data()))
          .toList();
      */

import 'package:flutter/material.dart';
import 'package:wander_stay/model/favorite_model.dart';
import 'package:wander_stay/service/firestore_database_service.dart';
import 'package:wander_stay/utils/singleton/snackbar.dart';

import '../model/place_model.dart';

class FavouriteProvider extends ChangeNotifier {
  late SingletonSnackbar _snackbarInstance; // Instance of SingletonSnackbar for displaying snackbars.
  late FirestoreDatabaseService _fireInst; // Instance of Firestore database service.

  bool _isLoading = false; // Boolean to track loading state.
  List<FavoriteModel> _favoritePlaces = []; // List to store favorite places.

  // Getters for private variables.
  bool get isLoading => _isLoading;
  List<FavoriteModel> get favoritePlaces => _favoritePlaces;

  // Constructor for the FavouriteProvider.
  FavouriteProvider() {
    _fireInst = FirestoreDatabaseService(); // Initialize Firestore service.
    _snackbarInstance = SingletonSnackbar(); // Initialize SingletonSnackbar.
    loadFavorite(); // Load favorite places from Firestore.
  }

  // Toggles the loading state.
  void toggleLoading() {
    _isLoading = !_isLoading; // Toggle the loading boolean.
    notifyListeners(); // Notify listeners about the change.
  }

  // Toggles the favorite status of a place.
  Future<void> toggleFavorite(PlaceModel place) async {
    final fav = FavoriteModel( // Create a FavoriteModel instance from the PlaceModel.
        favID: place.id,
        favTitle: place.title,
        favImageUrls: place.imageUrls,
        vendorName: place.vendor,
        vendorProfile: place.vendorProfile,
        latitude: place.latitude,
        longitude: place.longitude);

    if (isExist(place)) { // Check if the place is already a favorite.
      _favoritePlaces.remove(fav); // Remove the place from favorites.
      await _removeFavorite(fav.favID); // Remove the place from favorites in Firestore.
    } else {
      _favoritePlaces.add(fav); // Add the place to favorites.
      await _addFavorites(fav); // Add the place to favorites in Firestore.
    }
    notifyListeners(); // Notify listeners about the change in favorites.
  }

  // Checks if a place is already in the user's favorites.
  bool isExist(PlaceModel place) {
    return _favoritePlaces.any((fav) { // Check if any favorite place matches the given place's ID.
      return fav.favID == place.id;
    });
  }

  // Adds a place to the user's favorites in Firestore.
  Future<void> _addFavorites(FavoriteModel favPlace) async {
    try {
      await _fireInst.createDocument( // Create a document in the "WanderStay_Favorites" collection.
          "WanderStay_Favorites", favPlace.favID, favPlace.toMap());
    } catch (e) {
      _snackbarInstance.showSnackbar(e.toString()); // Show a snackbar message if an error occurs.
    }
  }

  // Removes a place from the user's favorites in Firestore.
  Future<void> _removeFavorite(String favId) async {
    try {
      await _fireInst.deleteDocument( // Delete a document from the "WanderStay_Favorites" collection.
          "WanderStay_Favorites", favId);
    } catch (e) {
      _snackbarInstance.showSnackbar(e.toString()); // Show a snackbar message if an error occurs.
    }
  }

  // Loads the user's favorite places from Firestore.
  Future<void> loadFavorite() async {
    try {
      toggleLoading(); // Set loading to true.
      _fireInst.getSnapshots("WanderStay_Favorites").listen((snapshot) { // Listen for changes in the "WanderStay_Favorites" collection.
        _favoritePlaces = snapshot.docs.map((doc) { // Map the documents to FavoriteModel objects.
          return FavoriteModel.fromMap(doc.data());
        }).toList();
      });
      await Future.delayed(const Duration(seconds: 3),(){}); // delay for 3 seconds to display the data being fetched from server or database
      notifyListeners(); // Notify listeners that the favorite places have been loaded.
    } catch (e) {
      _snackbarInstance.showSnackbar(e.toString()); // Show a snackbar message if an error occurs.
    } finally {
      toggleLoading(); // Set loading to false regardless of success or failure.
    }
  }
}

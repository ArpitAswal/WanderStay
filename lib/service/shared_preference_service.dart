import 'dart:convert';

import 'package:encrypt_shared_preferences/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wander_stay/service/firebase_auth_service.dart';
import 'package:wander_stay/utils/singleton/snackbar.dart';

const key = "XKeyAuthenTicate";
typedef AuthCallback = void Function(bool success, String? errorMessage); // Define a callback function for authentication.

class SharedPreferenceService {
  late EncryptedSharedPreferences sharedPref; // Instance of EncryptedSharedPreferences
  static final SharedPreferenceService _instance = SharedPreferenceService._internal(); // Singleton instance
  SharedPreferenceService._internal(); // Private constructor
  factory SharedPreferenceService() => _instance; // Factory constructor

  late Map<String, dynamic> _data; // Map to store user data
  late SingletonSnackbar _snackbarInstance; // Instance of SingletonSnackbar

  Map<String, dynamic> get data => _data; // Getter for user data

  // Initializes EncryptedSharedPreferences and SingletonSnackbar.
  Future<void> initialize() async {
    await EncryptedSharedPreferences.initialize(key); // Initialize encryption
    sharedPref = EncryptedSharedPreferences.getInstance(); // Get instance
    _snackbarInstance = SingletonSnackbar(); // Initialize SingletonSnackbar
  }

  // Initializes the user data map based on the provided email.
  // Checks if the user has logged in with Facebook (without email) and retrieves data accordingly.
  void dataInitialize({String? email}) {
    _data = checkFacebookLogIn(email);
  }

  // Sets user information in shared preferences.
  Future<void> setUserInfo({required User authUser, String? pass, required String provider}) async {
    final date = DateTime.now().toIso8601String(); // Get current date and time

    if (_data.isEmpty) { // If no user information is saved for the email
      for (final providerProfile in authUser.providerData) { // Iterate through provider data
        _data = {
          authUser.email ?? date: { // Use email or date as key (for Facebook login without email)
            "providerId": providerProfile.providerId,
            "email": providerProfile.email,
            "password": pass,
            "displayName": providerProfile.displayName,
            "photoURL": providerProfile.photoURL,
            "linkProviders": <String>[provider] // List of linked providers
          }
        };
      }
    } else { // If user information already exists
      for (final providerProfile in authUser.providerData) { // Iterate through provider data
        String email = _data.keys.elementAt(0); // Get the email from the data map
        List<String> providers = (_data[email]['linkProviders'] as List<dynamic>).cast<String>(); // Get linked providers

        _data[email]["providerId"] = providerProfile.providerId; // Update provider ID
        _data[email]["email"] = providerProfile.email ?? email; // Update email (use existing if new is null)
        if (_data[email]["password"] == null && pass != null) { // Update password if not already set
          _data[email]["password"] = pass;
        }
        if (_data[email]["displayName"] == null && providerProfile.displayName != null) { // Update display name if not already set
          _data[email]["displayName"] = providerProfile.displayName;
        }
        if (_data[email]["photoURL"] == null && providerProfile.photoURL != null) { // Update photo URL if not already set
          _data[email]["photoURL"] = providerProfile.photoURL;
        }
        if (!providers.contains(provider)) { // Add provider to linked providers if not already present
          providers.add(provider);
          _data[email]["linkProviders"] = providers;
        }
      }
    }
    String encodedMap = jsonEncode(_data); // Encode the map to JSON string
    await sharedPref.setString(authUser.email ?? date, encodedMap, notify: true); // Save the data to shared preferences
  }

  // Retrieves user information from shared preferences based on email.
  Map<String, dynamic> getUserInfo({required String email}) {
    if (sharedPref.getString(email) == null) {
      return {}; // Return empty map if no data is found
    }
    return jsonDecode(sharedPref.getString(email)!) as Map<String, dynamic>; // Decode the JSON string and return the map
  }

  // Updates user information in shared preferences.
  Future<Map<String, dynamic>> updateUserInfo(AuthCallback call,
      {required String email, required String displayName}) async {
    try {
      var existInfo = checkFacebookLogIn(FirebaseAuthServices().auth!.email); // Check if data exists for Facebook login (without email)
      if (email != existInfo.keys.elementAt(0)) { // If email is different, remove old data (for Facebook login case)
        sharedPref.remove(existInfo.keys.elementAt(0));
      }
      existInfo = { // Create updated user info map
        email: {
          "providerId": existInfo.values.elementAt(0)['providerId'],
          "email": email,
          "password": existInfo.values.elementAt(0)['password'],
          "displayName": displayName,
          "photoURL": existInfo.values.elementAt(0)['photoURL'],
          "linkProviders": existInfo.values.elementAt(0)['linkProviders']
        }
      };

      String encodedMap = jsonEncode(existInfo); // Encode to JSON string
      await sharedPref.setString(email, encodedMap, notify: true); // Save to shared preferences
      call(true, null); // Call the callback with success
      return existInfo; // Return updated user info
    } catch (e) {
      _snackbarInstance.showSnackbar(e.toString()); // Show snackbar error
      call(false, e.toString()); // Call callback with error
      return {}; // Return empty map
    }
  }

  // Checks if the user has logged in with Facebook (without email) and retrieves data accordingly.
  Map<String, dynamic> checkFacebookLogIn(String? email) {
    if (email == null || email.isEmpty) { // If email is null or empty (Facebook login case)
      final keys = sharedPref.getKeys().toList(); // Get all keys from shared preferences
      for (String key in keys) { // Iterate through keys
        Map<String, dynamic> res = jsonDecode(sharedPref.getString(key)!); // Decode the JSON string
        if (FirebaseAuthServices().auth!.photoURL == res.values.elementAt(0)['photoURL']) { // Compare photo URLs to identify user
          return res; // Return the user data
        }
      }
    }
    return getUserInfo(email: email ?? ""); // Return data based on email if available
  }
}

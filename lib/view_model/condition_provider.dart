import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:wander_stay/service/shared_preference_service.dart';

import '../service/firebase_auth_service.dart';
import '../utils/colors/app_colors.dart';
import '../utils/singleton/snackbar.dart';
import '../view/explore_screen.dart';
import '../view/account_screen.dart';
import '../view/map_screen.dart';
import '../view/message_screen.dart';
import '../view/profile_screen.dart';
import '../view/wishlist_screen.dart';

typedef AuthCallback = void Function(bool success, String? errorMessage); // Define a callback function for authentication.

class ConditionProvider extends ChangeNotifier {
  late SingletonSnackbar _snackbar; // Instance of SingletonSnackbar for displaying snackbars.
  late FirebaseAuthServices _firebaseAuth; // Instance of FirebaseAuthServices for authentication.
  late SharedPreferenceService _prefInstance; // Instance of SharedPreferenceService for local storage.

  late List<Widget> _screens; // List of widgets for the bottom navigation bar screens.
  late List<PersistentBottomNavBarItem> _navBarItems; // List of PersistentBottomNavBarItems for the bottom navigation bar.
  late PersistentTabController _controller; // Controller for the PersistentTabView.
  late Map<String, dynamic> _saveInfo; // Map to store user information.

  bool _isLoggedIn = false; // Tracks whether the user is logged in.
  bool _isLoading = false; // Tracks whether a process is currently loading (e.g., authentication).
  bool _passVisible = false; // Tracks the visibility state of the password.
  bool _isPreferenceInit = false; // Flag to track shared preference initialization.
  BtnType _btnType = BtnType.dummy; // Tracks the type of button that was last pressed (email, google, facebook).

  // Getters for the private variables.
  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  bool get passVisible => _passVisible;
  BtnType get btnType => _btnType;
  Map<String, dynamic> get saveInfo => _saveInfo;
  List<Widget> get screens => _screens;
  List<PersistentBottomNavBarItem> get navBarItems => _navBarItems;
  PersistentTabController get ctrl => _controller;

  ConditionProvider() {
    _prefInstance = SharedPreferenceService(); // Initialize shared preferences.
    _firebaseAuth = FirebaseAuthServices(); // Initialize Firebase authentication service.
    _snackbar = SingletonSnackbar(); // Initialize the singleton snackbar.

    // Initialize screens and navigation bar items. These will be updated later based on login status.
    _initializeScreensAndItems(); // Call the initialization method

    _controller = PersistentTabController(initialIndex: 0); // Initialize the tab controller.

    // Initialize shared preferences and then get user info.
    _preferenceInitialize(() {
      getUserInfo(); // Get user info after shared preferences are initialized.
    });
  }

  // Initializes shared preferences asynchronously.
  Future<void> _preferenceInitialize(VoidCallback onComplete) async {
    await _prefInstance.initialize(); // Initialize shared preferences.
    _isPreferenceInit = true; // Set the initialization flag to true.
    onComplete(); // Execute the callback function after initialization.
  }

  // Jumps to a specific tab index.
  void jumpIndex(int ind) {
    _controller.jumpToTab(ind);
    notifyListeners(); // Notify listeners about the change.
  }

  // Toggles the visibility of the password.
  void togglePassword() {
    _passVisible = !_passVisible;
    notifyListeners(); // Notify listeners about the change.
  }

  // Toggles the loading state.
  void toggleLoading() {
    _isLoading = !_isLoading;
    notifyListeners(); // Notify listeners about the change.
  }

  // Sets the current button type.
  void setBtnType(BtnType value) {
    _btnType = value;
    notifyListeners(); // Notify listeners about the change.
  }

  // Updates the login state and related UI elements.
  void updateLoginState(bool value) {
    _isLoggedIn = value; // Update the login state.
    _firebaseAuth.authState(); // Update Firebase auth state.
    _controller.jumpToTab(0); // Jump to the first tab.
    _initializeScreensAndItems(); // Update the screens and navigation bar items.
  }

  // Initializes or updates the screens and navigation bar items based on login status.
  void _initializeScreensAndItems() {
    _screens = [
      const ExploreScreen(), // Always include the Explore screen.
      if (_isLoggedIn) const WishlistScreen(), // Include Wishlist screen if logged in.
      if (_isLoggedIn) const MapScreen(), // Include Map Screen if logged in.
      if (_isLoggedIn) const MessageScreen(), // Include Message screen if logged in.
      _isLoggedIn ? const ProfileScreen() : const AccountScreen(), // Show Profile if logged in, otherwise Account.
    ];

    _navBarItems = [
      PersistentBottomNavBarItem( // Explore tab.
        icon: const Icon(Icons.explore_sharp),
        title: 'Explore',
        activeColorPrimary: AppColors.whiteColor,
        activeColorSecondary: AppColors.redAccentColor,
        inactiveColorPrimary: AppColors.whiteColor,
      ),
      if (_isLoggedIn) // Wishlist tab (only if logged in).
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.favorite),
          title: 'Wishlists',
          activeColorPrimary: AppColors.whiteColor,
          activeColorSecondary: AppColors.redAccentColor,
          inactiveColorPrimary: AppColors.whiteColor,
        ),
      if (_isLoggedIn) // Message tab (only if logged in).
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.map),
          title: 'GoogleMap',
          activeColorPrimary: AppColors.whiteColor,
          activeColorSecondary: AppColors.redAccentColor,
          inactiveColorPrimary: AppColors.whiteColor,
        ),
      if (_isLoggedIn) // Message tab (only if logged in).
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.message_rounded),
          title: 'Inbox',
          activeColorPrimary: AppColors.whiteColor,
          activeColorSecondary: AppColors.redAccentColor,
          inactiveColorPrimary: AppColors.whiteColor,
        ),
      PersistentBottomNavBarItem( // Profile/Account tab.
        icon: const Icon(Icons.account_circle),
        title: 'Profile',
        activeColorPrimary: AppColors.whiteColor,
        activeColorSecondary: AppColors.redAccentColor,
        inactiveColorPrimary: AppColors.whiteColor,
      ),
    ];

    notifyListeners(); // Notify listeners about the changes to screens and navBarItems.
  }

  // Handles Google authentication.
  Future<void> googleAuth(AuthCallback callback) async {
    try {
      toggleLoading(); // Show loading indicator.
      await _firebaseAuth.signInWithGoogle(); // Perform Google sign-in.
      getUserInfo(); // Get user information.
      _snackbar.showSnackbar("Successful SignIn"); // Show success message.
      callback(true, null); // Call the callback with success.
    } catch (e) {
      _snackbar.showSnackbar(e.toString()); // Show error message.
      callback(false, e.toString()); // Call the callback with error.
    } finally {
      toggleLoading(); // Hide loading indicator.
    }
  }

  // Handles email authentication.
  Future<void> emailAuth({required String email, required String pass}) async {
    try {
      toggleLoading(); // Show loading indicator.
      await _firebaseAuth.emailAccountAuth(email: email, password: pass); // Perform email sign-in.
      getUserInfo(); // Get user information.
      _snackbar.showSnackbar("Successful SignIn"); // Show success message.
    } catch (e) {
      _snackbar.showSnackbar(e.toString()); // Show error message.
    } finally {
      toggleLoading(); // Hide loading indicator.
    }
  }

  // Handles Facebook authentication.
  Future<void> facebookAuth(AuthCallback callback) async {
    try {
      toggleLoading(); // Show loading indicator.
      await _firebaseAuth.signInWithFacebook(); // Perform Facebook sign-in.
      getUserInfo(); // Get user information.
      _snackbar.showSnackbar("Successful SignIn"); // Show success message.
      callback(true, null); // Call the callback with success.
    } catch (e) {
      _snackbar.showSnackbar(e.toString()); // Show error message.
      callback(false, e.toString()); // Call the callback with error.
    } finally {
      toggleLoading(); // Hide loading indicator.
    }
  }

  // Retrieves user information from shared preferences.
  void getUserInfo([String? email]) {
    if (_isLoggedIn && _isPreferenceInit) { // Ensure user is logged in and preferences are initialized.
      _saveInfo = _prefInstance.checkFacebookLogIn(email ?? _firebaseAuth.auth!.email); // Get user info.
      notifyListeners(); // Notify listeners about the updated user information.
    }
  }
}

enum BtnType { email, google, facebook, dummy } // Enum to represent different button types.

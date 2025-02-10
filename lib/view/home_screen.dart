import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

import 'package:provider/provider.dart';
import 'package:wander_stay/utils/singleton/bottom_sheet.dart';

import '../utils/colors/app_colors.dart';
import '../utils/singleton/snackbar.dart';
import '../view_model/condition_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize the SingletonSnackbar with the context. This allows showing Snackbars from anywhere in the app.
    SingletonSnackbar().init(context);
    SingletonBottomSheet().init(context);
      // Listen for authentication state changes. This updates the login state in the ConditionProvider.
      FirebaseAuth.instance.authStateChanges().listen((user) {
      // Check if the widget is mounted to prevent errors after dispose.
      if (mounted) {
        Provider.of<ConditionProvider>(context, listen: false)
            .updateLoginState(user != null); // Update the login state in the ConditionProvider based on whether a user is logged in.
      }});
  }

  @override
  Widget build(BuildContext context) {
    // Consumer widget rebuilds when the ConditionProvider changes.
    return Consumer<ConditionProvider>(
        builder: (BuildContext context, ConditionProvider provider, Widget? child) {
          return Scaffold(
            body: PersistentTabView( // PersistentTabView for the bottom navigation bar.
              context, // The build context.
              controller: provider.ctrl, // Controller for the PersistentTabView, provided by ConditionProvider.
              screens: provider.screens, // List of screens to display, provided by ConditionProvider.
              items: provider.navBarItems, // List of NavBarItems for the bottom navigation bar, provided by ConditionProvider.
              handleAndroidBackButtonPress: true, // Handles back button presses on Android.
              resizeToAvoidBottomInset: true, // Resizes the screen when the keyboard appears.
              stateManagement: true, // Maintains the state of each tab.
              hideNavigationBarWhenKeyboardAppears: true, // Hides the navigation bar when the keyboard is visible.
              popBehaviorOnSelectedNavBarItemPress: PopBehavior.all, // Defines the pop behavior when a selected tab is pressed.
              backgroundColor: AppColors.peachColor, // Background color of the PersistentTabView.
              isVisible: true, // Whether the navigation bar is visible.
              animationSettings: const NavBarAnimationSettings( // Animation settings for the navigation bar.
                navBarItemAnimation: ItemAnimationSettings( // Animation settings for the navigation bar items.
                  duration: Duration(milliseconds: 400), // Animation duration.
                  curve: Curves.easeInOut, // Animation curve.
                ),
                screenTransitionAnimation: ScreenTransitionAnimationSettings( // Animation settings for screen transitions.
                  animateTabTransition: true, // Whether to animate tab transitions.
                  duration: Duration(milliseconds: 300), // Animation duration.
                  curve: Curves.easeInOut, // Animation curve.
                  screenTransitionAnimationType: // Type of screen transition animation.
                  ScreenTransitionAnimationType.fadeIn, // Fade-in animation.
                ),
              ),
              confineToSafeArea: true, // Confines the navigation bar to the safe area.
              navBarHeight: kBottomNavigationBarHeight, // Height of the navigation bar.
              navBarStyle: NavBarStyle // Style of the navigation bar.
                  .style7, // Using style 7.
            ),
          );
        });
  }
}

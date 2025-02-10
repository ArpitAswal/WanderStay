import 'package:flutter/material.dart';
import 'package:wander_stay/utils/widgets/permission_alert.dart';

class SingletonBottomSheet {
  static final SingletonBottomSheet _instance = SingletonBottomSheet._internal(); //static variable holds the single instance of the class.
  SingletonBottomSheet._internal(); //private constructor. This prevents direct instantiation of the class from outside.
  factory SingletonBottomSheet() => _instance; // A public factory constructor provides the only way to obtain an instance of the class. It returns the existing instance if it already exists, or creates a new one if it doesn't.
  BuildContext? _context;

  void init(BuildContext context) {
    _context = context; // initialize the home screen context so it can access from anywhere in the app
  }

  void permissionBottomSheet({required String permissionStatus, required String permissionMsg}) {
    // Handle the case where context is not available (e.g., background tasks)
    if(_context != null) {
      showModalBottomSheet(context: _context!,
          elevation: 8.0, // elevation of sheet
          backgroundColor: Colors.transparent, // background color of modal sheet
          isDismissible: false, // specifies whether the bottom sheet will be dismissed when user taps on the scrim.
          enableDrag: true, // specifies whether the bottom sheet can be dragged up and down and dismissed by swiping downwards.
          useSafeArea: true, // parameter specifies whether the sheet will avoid system intrusions on the top, left, and right
          builder: (BuildContext context) {
        return LocationAlert( // modal sheet widget
          status: permissionStatus,
          msg: permissionMsg
        );
      });
    }
  }
}
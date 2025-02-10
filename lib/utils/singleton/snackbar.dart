
import 'package:flutter/material.dart';

class SingletonSnackbar {
  static final SingletonSnackbar _instance = SingletonSnackbar._internal(); //static variable holds the single instance of the class.
  SingletonSnackbar._internal(); //private constructor. This prevents direct instantiation of the class from outside.
  factory SingletonSnackbar() => _instance; // A public factory constructor provides the only way to obtain an instance of the class. It returns the existing instance if it already exists, or creates a new one if it doesn't.
  BuildContext? _context;

  void init(BuildContext context) {
    _context = context; // initialize the home screen context so it can access from anywhere in the app
  }

  void showSnackbar(String message) {
    if (_context != null) {
      ScaffoldMessenger.of(_context!).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
    } else {
      // Handle the case where context is not available (e.g., background tasks)
      ScaffoldMessenger.of(_context!).showSnackBar(
        const SnackBar(
          content: Text("Error: Context not initialized for SnackbarService"),
        ),
      );
    }
  }
}
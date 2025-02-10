import 'package:flutter/material.dart';
import 'package:wander_stay/service/firestore_database_service.dart';

import '../model/message_model.dart';
import '../utils/singleton/snackbar.dart';

class MessageProvider extends ChangeNotifier {
  final List<String> _messagesScreenType = [ // List of message screen types.
    "All",
    "Support Team",
    "Friends",
    "Vendor",
    "WanderStay"
  ];

  late FirestoreDatabaseService _fireInst; // Instance of Firestore database service.
  late SingletonSnackbar _snackbar; // Instance of SingletonSnackbar for displaying snackbars.

  int _typeIndex = 0; // Index of the currently selected message screen type.
  bool _isLoading = false;
  List<MessageModel> _allMessages = []; // List to store all messages.

  // Getters for private variables.
  int get typeIndex => _typeIndex;
  bool get isLoading => _isLoading;
  List<String> get messagesScreenType => _messagesScreenType;
  List<MessageModel> get allMessages => _allMessages;

  // Constructor for the MessageProvider.
  MessageProvider() {
    _fireInst = FirestoreDatabaseService(); // Initialize Firestore service.
    _snackbar = SingletonSnackbar(); // Initialize SingletonSnackbar.
    initializeMessages(); // Initialize the messages list.
  }

  // To determine the status whether the data is currently fetching or not
  void loadingStatus(){
    _isLoading = !_isLoading;
    notifyListeners();
  }

  // Changes the selected message screen type index.
  void changeIndex(int value) {
    _typeIndex = value; // Update the selected index.
    notifyListeners(); // Notify listeners about the change.
  }

  // Initializes the messages list by fetching data from Firestore.
  Future<void> initializeMessages() async {
    try {
      loadingStatus(); // change the loading status of data
      // Listen for changes in the "WanderStay_Messages" collection.
      _fireInst.getSnapshots("WanderStay_Messages").listen((snapshot) {
        // Map the documents to MessageModel objects.
        _allMessages = snapshot.docs.map((doc) {
          return MessageModel.fromMap(doc.data());
        }).toList();
      });

      await Future.delayed(const Duration(seconds: 3),(){}); // delay for 3 seconds to display the data being fetched from server or database
      notifyListeners(); // Notify listeners that the messages list has been updated.
    } catch (e) {
      // Show a snackbar message if an error occurs during data fetching.
      _snackbar.showSnackbar("Firebase error: ${e.toString()}");
    } finally{
      loadingStatus(); // change the loading status of data
    }
  }
}


import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreDatabaseService {
  // Singleton instance to ensure only one instance of the service exists.
  static final FirestoreDatabaseService _instance =
  FirestoreDatabaseService._internal();

  // Firestore instance to interact with the Firestore database.
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Private constructor to prevent direct instantiation from outside the class.
  // This is part of the singleton pattern.
  FirestoreDatabaseService._internal();

  // Factory constructor to return the singleton instance.
  factory FirestoreDatabaseService() {
    return _instance;
  }

  // Gets a collection reference for performing queries.
  Future<QuerySnapshot<Map<String, dynamic>>> getCollection(String collection) {
    return _firestore.collection(collection).get();
  }

  // CRUD (Create, Read, Update, Delete) Operations

  // Creates a new document in the specified collection with the given data.
  // If the document ID (doc) already exists, it will be overwritten.
  Future<void> createDocument(
      String collection, String doc, Map<String, dynamic> data) async {
    await _firestore.collection(collection).doc(doc).set(data);
  }

  // Reads a document from the specified collection using its ID.
  Future<DocumentSnapshot<Map<String, dynamic>>> readDocument(String collection, String docId) async {
    return await _firestore.collection(collection).doc(docId).get();
  }

  // Updates an existing document in the specified collection with the given data.
  Future<void> updateDocument(
      String collection, String docId, Map<String, dynamic> data) async {
    await _firestore.collection(collection).doc(docId).update(data);
  }

  // Deletes a document from the specified collection using its ID.
  Future<void> deleteDocument(String collection, String docId) async {
    await _firestore.collection(collection).doc(docId).delete();
  }

  // Gets a stream of QuerySnapshots for the specified collection.
  // This allows listening for real-time updates to the collection.
  Stream<QuerySnapshot<Map<String, dynamic>>> getSnapshots(String collection) {
    return _firestore.collection(collection).snapshots();
  }
}
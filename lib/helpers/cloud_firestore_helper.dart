import 'package:cloud_firestore/cloud_firestore.dart';

class CloudFirestoreHelper {
  CloudFirestoreHelper._();
  static final CloudFirestoreHelper cloudFirestoreHelper =
      CloudFirestoreHelper._();

  static final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  late CollectionReference authorRef;

  void connectionWithCollection() {
    authorRef = firebaseFirestore.collection('authors');
  }

  Future<void> insertRecord(
      {required String id,
      required String authorName,
      required String bookName,
      required String imageURL}) async {
    connectionWithCollection();

    Map<String, dynamic> data = {
      'name': authorName,
      'book': bookName,
      'imageURL': imageURL,
    };

    await authorRef.doc(id).set(data);
  }

  Future<void> updateRecord(
      {required String id,
      required String authorName,
      required String bookName,
      required String imageURL}) async {
    connectionWithCollection();

    Map<String, dynamic> updatedData = {
      'name': authorName,
      'book': bookName,
      'imageURL': imageURL,
    };

    await authorRef.doc(id).update(updatedData);
  }

  deleteRecord({required String id}) async {
    connectionWithCollection();

    await authorRef.doc(id).delete();
  }

  Stream<QuerySnapshot> fetchAllRecords() {
    connectionWithCollection();

    return authorRef.snapshots();
  }
}

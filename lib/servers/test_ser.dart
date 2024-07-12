import 'package:cloud_firestore/cloud_firestore.dart';

class TestFirebase {
  final _testsCollection = FirebaseFirestore.instance.collection("test");

  Stream<QuerySnapshot> getTests() async* {
    yield* _testsCollection.snapshots();
  }
}
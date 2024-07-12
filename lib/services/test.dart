


import 'package:cloud_firestore/cloud_firestore.dart';

class Test {
  final String id;
  String misol;
  String javob;

  Test({
    required this.id,
    required this.misol,
    required this.javob,
  });

  factory Test.fromMap(DocumentSnapshot map) {
    return Test(
      id: map.id,
      misol: map["misol"],
      javob: map["javob"],
    );
  }
}
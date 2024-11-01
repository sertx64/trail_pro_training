// import 'package:firebase_database/firebase_database.dart';
//
// Future<void> sendData(List<Map<String, String>> data) async {
//   final dbRef = FirebaseDatabase.instance.ref('week_plan_path');
//   await dbRef.set(data);
// }
//
// Future<List<Map<String, String>>> getData(String path) async {
//   final ref = FirebaseDatabase.instance.ref(path);
//   DataSnapshot snapshot = (await ref.once()) as DataSnapshot;
//   return snapshot.value as List<Map<String, String>>;
// }

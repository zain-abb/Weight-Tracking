import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:weight_tracker/data/models/weight.dart';

class WeightProvider with ChangeNotifier {
  final weightRef = FirebaseFirestore.instance.collection('weights');

  List<Weight> _weights = [];

  List<Weight> get getWeights => [..._weights];

  Stream<QuerySnapshot> fetchOrDisplayWeights() {
    final docs = weightRef.orderBy("timestamp", descending: true).snapshots();
    return docs;
  }

  Future<String> createWeight(String weight, String unit, String userId) async {
    String id = Uuid().v4();
    try {
      await weightRef.doc(id).set(
        {
          'id': id,
          'userId': userId,
          'weight': weight,
          'unit': unit,
          'timestamp': Timestamp.now(),
        },
      );
      notifyListeners();
      return 'Weight Created!';
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> editWeight(String id, String weight, String unit) async {
    await weightRef.doc(id).set({
      'weight': weight,
      'unit': unit,
      'timestamp': Timestamp.now(),
    }, SetOptions(merge: true));
    notifyListeners();
    print('Weight Updated!');
  }

  Future<void> deletWeight(String id) async {
    await weightRef.doc(id).delete();
    notifyListeners();
    print('Weight Deleted!');
  }
}

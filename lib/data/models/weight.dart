import 'package:cloud_firestore/cloud_firestore.dart';

class Weight {
  final String id;
  final String userId;
  final String weight;
  final String unit;
  final Timestamp timestamp;

  Weight({
    required this.id,
    required this.userId,
    required this.weight,
    required this.unit,
    required this.timestamp,
  });

  factory Weight.fromDocument(DocumentSnapshot doc) {
    return Weight(
      id: doc['id'],
      userId: doc['userId'],
      weight: doc['weight'],
      unit: doc['unit'],
      timestamp: doc['timestamp'],
    );
  }
}

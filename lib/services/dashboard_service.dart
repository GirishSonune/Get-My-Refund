import 'package:cloud_firestore/cloud_firestore.dart';

class DashboardService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<QuerySnapshot> watchCasesForUser(String uid) {
    return _db.collection('cases').where('userId', isEqualTo: uid).snapshots();
  }

  Stream<QuerySnapshot> watchNews() =>
      _db.collection('news').orderBy('publishAt', descending: true).snapshots();

  Stream<QuerySnapshot> watchStories() => _db
      .collection('stories')
      .orderBy('publishAt', descending: true)
      .snapshots();
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_my_refund/models/case_model.dart';

// This service class handles all communication with the Firestore database.
// Keeping this logic separate makes your UI code cleaner and easier to manage.
class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Stream to get real-time updates of all cases.
  // The UI will listen to this stream to automatically update when data changes.
  Stream<List<CaseModel>> getCases() {
    return _db.collection('cases')
           .orderBy('caseOpenDate', descending: true) // Show newest cases first
           .snapshots()
           .map((snapshot) => snapshot.docs
               .map((doc) => CaseModel.fromFirestore(doc))
               .toList());
  }

  // Example function to update a case status (you can expand this)
  Future<void> updateCaseStatus(String caseId, String newStatus) {
    return _db.collection('cases').doc(caseId).update({'status': newStatus});
  }
}

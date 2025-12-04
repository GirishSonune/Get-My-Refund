import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> setUserProfile(
    String uid, {
    String? email,
    String? phone,
    String? aadhar,
  }) async {
    final data = {
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (aadhar != null) 'aadhar': aadhar,
      'updatedAt': FieldValue.serverTimestamp(),
    };

    await _db.collection('users').doc(uid).set(data, SetOptions(merge: true));

    // Also update user_details for the new structure
    if (phone != null || email != null || aadhar != null) {
      await _db.collection('user_details').doc(uid).set({
        if (phone != null) 'phone': phone,
        if (email != null) 'email': email,
        if (aadhar != null) 'aadhar': aadhar,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }
  }

  Future<Map<String, dynamic>?> getUserDetails(String uid) async {
    final snap = await _db.collection('user_details').doc(uid).get();
    if (!snap.exists) return null;
    return snap.data();
  }

  Future<Map<String, dynamic>?> getUserProfile(String uid) async {
    final snap = await _db.collection('users').doc(uid).get();
    if (!snap.exists) return null;
    return snap.data();
  }
}

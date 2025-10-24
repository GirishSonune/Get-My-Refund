import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> setLocaleForUser(String uid, String locale) async {
    await _db.collection('users').doc(uid).set({
      'locale': locale,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<String?> getLocaleForUser(String uid) async {
    final snap = await _db.collection('users').doc(uid).get();
    if (!snap.exists) return null;
    final data = snap.data();
    if (data == null) return null;
    return (data['locale'] as String?)?.toString();
  }

  Future<void> setUserProfile(
    String uid, {
    required String name,
    required String email,
    required String mobile,
    String? locale,
  }) async {
    final data = <String, dynamic>{
      'name': name,
      'email': email,
      'mobile': mobile,
      'updatedAt': FieldValue.serverTimestamp(),
    };
    if (locale != null) data['locale'] = locale;
    await _db.collection('users').doc(uid).set(data, SetOptions(merge: true));
  }

  Future<Map<String, dynamic>?> getUserProfile(String uid) async {
    final snap = await _db.collection('users').doc(uid).get();
    if (!snap.exists) return null;
    return snap.data();
  }
}

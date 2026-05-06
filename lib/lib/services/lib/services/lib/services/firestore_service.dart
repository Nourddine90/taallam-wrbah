import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createUser(String uid, Map<String, dynamic> data) async {
    await _firestore.collection('users').doc(uid).set({
      ...data,
      'trialStartDate': FieldValue.serverTimestamp(),
      'isSubscribed': false,
      'balance': 0,
      'products_sold': 0,
    });
  }

  Future<DocumentSnapshot> getUser(String uid) async {
    return await _firestore.collection('users').doc(uid).get();
  }

  Future<void> updateUserBalance(String uid, int amount) async {
    await _firestore.collection('users').doc(uid).update({
      'balance': FieldValue.increment(amount),
    });
  }

  Stream<QuerySnapshot> getSkills() {
    return _firestore.collection('skills').snapshots();
  }

  Future<void> addProduct(Map<String, dynamic> data) async {
    await _firestore.collection('products').add({
      ...data,
      'created_at': FieldValue.serverTimestamp(),
      'status': 'active',
    });
  }

  Stream<QuerySnapshot> getMarketProducts(String city) {
    return _firestore.collection('products').where('city', isEqualTo: city).where('status', isEqualTo: 'active').snapshots();
  }

  Future<int> getDaysLeftInTrial(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (!doc.exists) return 0;
    final trialStart = (doc['trialStartDate'] as Timestamp).toDate();
    final daysLeft = 30 - DateTime.now().difference(trialStart).inDays;
    return daysLeft < 0 ? 0 : daysLeft;
  }
}

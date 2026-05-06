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

  Future<void> updateUserProductCount(String uid) async {
    await _firestore.collection('users').doc(uid).update({
      'products_sold': FieldValue.increment(1),
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
    return _firestore
        .collection('products')
        .where('city', isEqualTo: city)
        .where('status', isEqualTo: 'active')
        .snapshots();
  }

  Future<void> markProductSold(String productId) async {
    await _firestore.collection('products').doc(productId).update({
      'status': 'sold',
      'sold_at': FieldValue.serverTimestamp(),
    });
  }

  Future<int> getDaysLeftInTrial(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (!doc.exists) return 0;
    final trialStart = (doc['trialStartDate'] as Timestamp).toDate();
    final now = DateTime.now();
    final daysUsed = now.difference(trialStart).inDays;
    final daysLeft = 30 - daysUsed;
    return daysLeft < 0 ? 0 : daysLeft;
  }

  Future<bool> canSellProduct(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (!doc.exists) return false;
    final isSubscribed = doc['isSubscribed'] ?? false;
    final productsSold = doc['products_sold'] ?? 0;
    final trialStart = (doc['trialStartDate'] as Timestamp).toDate();
    final daysUsed = DateTime.now().difference(trialStart).inDays;
    if (daysUsed < 30 && productsSold < 4) return true;
    return isSubscribed;
  }
}

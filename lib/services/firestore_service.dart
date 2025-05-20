import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class FirestoreService {
  // ändere 'users' → 'customers'
  final _customers = FirebaseFirestore.instance.collection('customers');

  Future<void> createUser(UserModel user) =>
    _customers.doc(user.uid).set(user.toMap());

  Future<UserModel?> getUser(String uid) async {
    final doc = await _customers.doc(uid).get();
    return doc.exists ? UserModel.fromMap(doc.data()!) : null;
  }
}


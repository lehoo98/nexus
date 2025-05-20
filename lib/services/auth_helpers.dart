import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import 'firestore_service.dart';

Future<void> handleUserCreation({
  required String name,
  required String address,
  required String phone,
}) async {
  final user = FirebaseAuth.instance.currentUser!;
  final newUser = UserModel(
    uid: user.uid,
    name: name,
    email: user.email!,
    address: address,
    phone: phone,
    createdAt: DateTime.now(),
  );
  await FirestoreService().createUser(newUser);
}


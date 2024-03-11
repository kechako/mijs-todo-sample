import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter/material.dart';

final usersRef =
    FirebaseFirestore.instance.collection("users").withConverter<User>(
          fromFirestore: (snapshots, _) =>
              User.fromJson(snapshots.id, snapshots.data()!),
          toFirestore: (user, _) => user.toJson(),
        );

@immutable
class User {
  const User({required this.uid});

  const User.fromJson(String uid, Map<String, Object?> json) : this(uid: uid);

  final String uid;

  firebase.User get firebaseUser => firebase.FirebaseAuth.instance.currentUser!;

  Map<String, Object?> toJson() {
    return {};
  }
}

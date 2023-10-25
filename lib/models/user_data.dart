// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  final String? id;
  final String? name;
  final String? email;
  final String? photoUrl;
  final String? location;
  final String? fcmToken;
  final Timestamp? addTime;

  UserData({
    this.id,
    this.name,
    this.email,
    this.photoUrl,
    this.location,
    this.fcmToken,
    this.addTime,
  });
  factory UserData.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return UserData(
      id: data?['id'],
      name: data?['name'],
      email: data?['email'],
      photoUrl: data?['photoUrl'],
      location: data?['location'],
      fcmToken: data?['fcmToken'],
      addTime: data?['addTime'],
    );
  }
  Map<String, dynamic> toFirestore() {
    return {
      if (id != null) "id": id,
      if (name != null) "name": name,
      if (email != null) "email": email,
      if (photoUrl != null) "photoUrl": photoUrl,
      if (location != null) "location": location,
      if (fcmToken != null) "fcmToken": fcmToken,
      if (addTime != null) "addTime": addTime,
    };
  }
}

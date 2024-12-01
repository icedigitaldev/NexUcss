import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firestoreManagerProvider = Provider((ref) => FirestoreManager());

class FirestoreManager {
  bool _isOffline = true;

  void setOfflineMode(bool offline) {
    _isOffline = offline;
    if (_isOffline) {
      FirebaseFirestore.instance.disableNetwork();
    } else {
      FirebaseFirestore.instance.enableNetwork();
    }
  }

  bool get isOffline => _isOffline;

  Future<void> syncData() async {
    if (_isOffline) {
      await FirebaseFirestore.instance.enableNetwork();
      await Future.delayed(const Duration(seconds: 5));
      await FirebaseFirestore.instance.disableNetwork();
    }
  }
}

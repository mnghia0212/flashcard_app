import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashcard_app/data/data.dart';

class DefaultCardsDatasource {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  
  Future<List<DefaultCards>> fetchDefaultCards(String setId) async {
    try {
      final QuerySnapshot snapshot = await firestore
          .collection('defaultCards')
          .where('setId', isEqualTo: setId)
          .get();

      final List<DefaultCards> defaultCards = snapshot.docs.map((doc) {
        return DefaultCards.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();

      return defaultCards;
    } catch (e) {
      log("Error fetching default sets: $e");
      return [];
    }
  }
}
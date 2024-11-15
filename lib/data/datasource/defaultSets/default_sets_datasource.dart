import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashcard_app/data/data.dart';

class DefaultSetsDatasource {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<DefaultSets>> fetchDefaultSets() async {
    try {
      final QuerySnapshot snapshot =
          await firestore.collection('defaultSets').orderBy("unitNumber").get();

      final List<DefaultSets> defaultSets = snapshot.docs.map((doc) {
        return DefaultSets.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();

      return defaultSets;
    } catch (e) {
      log("Error fetching default sets: $e");
      return [];
    }
  }

  Future<int> getCardNumber(String setId) async {
    try {
      final QuerySnapshot snapshot = await firestore
          .collection('defaultCards')
          .where('setId', isEqualTo: setId)
          .get();

      final List<DefaultCards> defaultCardsInSet = snapshot.docs.map((doc) {
        return DefaultCards.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();

      return defaultCardsInSet.length;
    } catch (e) {
      log("Error getting flashcard number: $e");
      return 0;
    }
  }

  Future<int> getCardNumberByInstance(DefaultSets set) async {
    try {
      final QuerySnapshot snapshot = await firestore
          .collection('defaultCards')
          .where('setId', isEqualTo: set.setId)
          .get();

      final List<DefaultCards> defaultCardsInSet = snapshot.docs.map((doc) {
        return DefaultCards.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();

      return defaultCardsInSet.length;
    } catch (e) {
      log("Error getting flashcard number: $e");
      return 0;
    }
  }
}

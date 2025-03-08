import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashcard_app/data/data.dart';

class TestCardDatasource {
  final firestore = FirebaseFirestore.instance;

  Future<void> getTestCards(TestCards testCard) async {
    try {
      final newCardDoc = firestore.collection("testCards").doc();
      final newCardId = newCardDoc.id;

      await firestore
          .collection("testCards")
          .doc(newCardId)
          .set(testCard.toMap());
      log("ok");
    } catch (e) {
      log("defeat");
    }
  }

  Future<List<TestCards>> getCardsToTest() async {
    try {
      final QuerySnapshot snapshot = await firestore
          .collection('testCards')
          .get();

      final List<TestCards> testCards = snapshot.docs.map((doc) {
        return TestCards.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();

      return testCards;
    } catch (e) {
      log("Error fetching default sets: $e");
      return [];
    }
  }
}

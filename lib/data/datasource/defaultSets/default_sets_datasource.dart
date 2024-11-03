import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashcard_app/data/data.dart';

class DefaultSetsDatasource {
  Future<List<DefaultSets>> fetchDefaultSets() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

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
      List<DefaultSets> defaultSets = await fetchDefaultSets();  
      return defaultSets.length;  
    } catch (e) {  
      log("Error getting flashcard number: $e");  
      return 0;  
    }  
  }  
}

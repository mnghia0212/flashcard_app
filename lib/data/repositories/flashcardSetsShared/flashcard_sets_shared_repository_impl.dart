import 'dart:developer';

import 'package:flashcard_app/data/data.dart';

class FlashcardSetsSharedRepositoryImpl
    implements FlashcardSetsSharedRepositories {
      
  final FlashcardSetsSharedDatasource datasource;
  FlashcardSetsSharedRepositoryImpl(this.datasource);

  @override
  Future<void> shareSet(FlashcardSetsShared flashcardSetsShared) async{
    try {
      await datasource.shareSet(flashcardSetsShared);
    } catch (e) {
      log("$e");
    }
  }

  @override
  Future<void> deleteSharedSet(String flashcardSetsSharedId) async{
     try {
      await datasource.deleteSharedSet(flashcardSetsSharedId);
    } catch (e) {
      log("$e");
    }
  }
}

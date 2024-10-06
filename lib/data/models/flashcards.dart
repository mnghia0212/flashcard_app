// ignore_for_file: public_member_api_docs, sort_constructors_first
class Flashcards {
  final int flashcardId;
  final int userId;
  final String frontContent;
  final String backContent;
  final String? audioPath;
  final String? videoPath;
  final String createdAt;
  final String? updatedAt;
  Flashcards({
    required this.flashcardId,
    required this.userId,
    required this.frontContent,
    required this.backContent,
    this.audioPath,
    this.videoPath,
    required this.createdAt,
    this.updatedAt,
  });
}

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class AppSounds {
  static Future<void> playRightAnswerSound(AudioPlayer audioPlayer) async {
    try {
      await audioPlayer.play(AssetSource('audio/right_answer.mp3'), volume: 1);
    } catch (e) {
      debugPrint('Error playing right answer sound: $e');
    }
  }

  static Future<void> playWrongAnswerSound(AudioPlayer audioPlayer) async {
    try {
      await audioPlayer.play(AssetSource('audio/wrong_answer.mp3'), volume: 1);
    } catch (e) {
      debugPrint('Error playing wrong answer sound: $e');
    }
  }

  static void playSoundRightWrong(bool isCorrect, AudioPlayer audioPlayer) {
    isCorrect
        ? playRightAnswerSound(audioPlayer)
        : playWrongAnswerSound(audioPlayer);
  }

  static Future<void> playEndSessionSound(AudioPlayer audioPlayer) async {
    String audioPath = "audio/end_study_session.wav";
    await audioPlayer.play(AssetSource(audioPath));
  }

  static Future<void> playSoundSignUpInOut(AudioPlayer audioPlayer) async {
    String audioPath = "audio/signUpInOut.wav";
    await audioPlayer.play(AssetSource(audioPath));
  }

  static Future<void> playSoundCreate(AudioPlayer audioPlayer) async {
    String audioPath = "audio/create.mp3";
    await audioPlayer.play(AssetSource(audioPath));
  }

}

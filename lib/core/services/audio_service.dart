// lib/core/services/audio_service.dart
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal() {
    debugPrint("AudioService: Instance created!");
    init();
  }

  late AudioPlayer _audioPlayer;
  bool _isInitialized = false;
  bool _isPlaying = false;
  double _volume = 1.0;
  Uint8List? _currentAudioData;

  final _playerStateController = StreamController<PlayerState>.broadcast();
  Stream<PlayerState> get onPlayerStateChanged => _playerStateController.stream;

  bool isInitialized() => _isInitialized;
  bool isPlaying() => _isPlaying;

  Future<void> init() async {
    if (!_isInitialized) {
      _audioPlayer = AudioPlayer();
      _isInitialized = true;
    }
  }

  Future<void> start(Uint8List audioData) async {
    if (!_isInitialized) {
       await init();
    }

    try {
      await _audioPlayer.play(BytesSource(audioData));
      _isPlaying = true;
      _currentAudioData = audioData;
      _playerStateController.add(PlayerState.playing);
    } catch (e) {
      debugPrint('AudioService: Error playing audio: $e');
      _playerStateController.add(PlayerState.stopped); // Or a custom error state
      throw Exception('Failed to play audio. Please check your audio settings.');
    }
  }

  Future<void> stop() async {
    if (!_isPlaying) {
      return;
    }
    try {
      await _audioPlayer.stop();
    } finally {
      _isPlaying = false;
      _playerStateController.add(PlayerState.stopped);
    }
  }

  Future<void> pause() async {
    if (!_isPlaying) {
      return;
    }
    try {
      await _audioPlayer.pause();
      _playerStateController.add(PlayerState.paused);
    } catch (e) {
      debugPrint('AudioService: Error pausing audio: $e');
      _playerStateController.add(PlayerState.stopped); // Consider custom error state
      throw Exception('Failed to pause audio.');
    }
  }

  Future<void> resume() async {
    if (!_isInitialized) {
       await init();
    }
    try {
      await _audioPlayer.resume();
      _isPlaying = true;
      _playerStateController.add(PlayerState.playing);
    } catch (e) {
      debugPrint('AudioService: Error resuming audio: $e');
      _playerStateController.add(PlayerState.stopped);  // Consider custom error state
      throw Exception('Failed to resume audio.');
    }
  }

  void setVolume(double volume) {
    _volume = volume;
    _audioPlayer.setVolume(_volume);
  }

  Future<void> replay() async {
    if (_currentAudioData == null) {
      throw Exception("No audio data available to replay.");
    }
    await start(_currentAudioData!);
  }

  Future<void> dispose() async {
  }
}
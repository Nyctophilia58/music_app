import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:music_app/models/song.dart';

class PlayListProvider extends ChangeNotifier {
  final List<Song> _playList = [
    Song(
      songName: 'Summertime Sadness',
      artistName: 'Lana Del rey',
      albumArtImagePath: 'assets/images/summertime_sadness.jpg',
      audioPath: 'audios/summertime_sadness.mp3',
    ),
    Song(
      songName: 'Never Enough',
      artistName: 'Loren Allred',
      albumArtImagePath: 'assets/images/never_enough.jpg',
      audioPath: 'audios/never_enough.mp3',
    ),
    Song(
      songName: 'Until I Found You',
      artistName: 'Stephen Sanchez',
      albumArtImagePath: 'assets/images/until_i_found_you.jpg',
      audioPath: 'audios/until_i_found_you.mp3',
    ),
  ];

  int? _currentSongIndex = 0;

  // audio player
  final AudioPlayer _audioPlayer = AudioPlayer();

  // duration
  Duration _currentDuration = Duration.zero;
  Duration _totalDuration = Duration.zero;

  PlayListProvider() {
    listenToDuration();
  }

  bool _isPlaying = false;

  void play() async{
    final String path = _playList[_currentSongIndex!].audioPath;

    await _audioPlayer.stop();
    await _audioPlayer.play(AssetSource(path));

    _isPlaying = true;
    notifyListeners();
  }

  void pause() async{
    await _audioPlayer.pause();
    _isPlaying = false;
    notifyListeners();
  }

  void resume() async{
    await _audioPlayer.resume();
    _isPlaying = true;
    notifyListeners();
  }

  void pauseOrResume() async {
    if (_isPlaying) {
      pause();
    } else {
      resume();
    }
    notifyListeners();
  }

  void seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  void playNextSong() {
    if (_currentSongIndex != null) {
      if (_currentSongIndex! < _playList.length - 1) {
        currentSongIndex = _currentSongIndex! + 1;
      } else {
        currentSongIndex = 0;
      }
    }
  }

  void playPreviousSong() async {
    if (_currentDuration.inSeconds > 2) {
      seek(Duration.zero);
    } else {
      if (_currentSongIndex! > 0) {
        currentSongIndex = _currentSongIndex! - 1;
      } else {
        currentSongIndex = _playList.length - 1;
      }
    }
  }

  void listenToDuration() {
    _audioPlayer.onDurationChanged.listen((newDuration) {
      _totalDuration = newDuration;
      notifyListeners();
    });

    _audioPlayer.onPositionChanged.listen((newPosition) {
      _currentDuration = newPosition;
      notifyListeners();
    });

    _audioPlayer.onPlayerComplete.listen((event) {
      playNextSong();
    });
  }

  List<Song> get playList => _playList;
  int? get currentSongIndex => _currentSongIndex;
  bool get isPlaying => _isPlaying;
  Duration get currentDuration => _currentDuration;
  Duration get totalDuration => _totalDuration;


  set currentSongIndex(int? newIndex) {
    _currentSongIndex = newIndex;

    if (newIndex != null) {
      play();
    }

    notifyListeners();
  }
}
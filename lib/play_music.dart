// ignore_for_file: library_private_types_in_public_api

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class AudioPlayerUrl extends StatefulWidget {
  const AudioPlayerUrl({super.key});

  @override
  _AudioPlayerUrlState createState() => _AudioPlayerUrlState();
}

class _AudioPlayerUrlState extends State<AudioPlayerUrl> {
  AudioPlayer player = AudioPlayer();
  PlayerState audioState = PlayerState.paused;
  String audioUrl =
      'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-13.mp3';
  Source sourceUrl = UrlSource(
      'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-13.mp3');

  int timeProgress = 0;
  int audioDuration = 0;

  Widget slider() {
    return SizedBox(
      width: 300.0,
      child: Slider.adaptive(
          value: timeProgress.toDouble(),
          max: audioDuration.toDouble(),
          onChanged: (value) {
            seekToSec(value.toInt());
          }),
    );
  }

  @override
  void initState() {
    super.initState();

    player.onPlayerStateChanged
        .listen((PlayerState state) => setState(() => audioState = state));
    player.setSourceUrl(audioUrl);
    player.onDurationChanged.listen((Duration duration) =>
        setState(() => audioDuration = duration.inSeconds));
    player.onPositionChanged.listen((Duration duration) =>
        setState(() => timeProgress = duration.inSeconds));
  }

  @override
  void dispose() {
    super.dispose();
    player.release();
    player.dispose();
  }

  play() async {
    await player.play(sourceUrl);
  }

  paused() async {
    await player.pause();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(getTimeString(timeProgress)),
                const SizedBox(width: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 200,
                  child: slider(),
                ),
                const SizedBox(width: 20),
                Text(getTimeString(audioDuration))
              ],
            ),
            IconButton(
              iconSize: 50,
              onPressed: () {
                audioState == PlayerState.playing ? paused() : play();
              },
              icon: Icon(
                audioState == PlayerState.playing
                    ? Icons.pause_rounded
                    : Icons.play_arrow_rounded,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void seekToSec(int sec) {
    Duration newPosition = Duration(seconds: sec);
    player.seek(newPosition);
  }

  String getTimeString(int seconds) {
    String minuteString =
        '${(seconds / 60).floor() < 10 ? 0 : ''}${(seconds / 60).floor()}';
    String secondString = '${seconds % 60 < 10 ? 0 : ''}${seconds % 60}';
    return '$minuteString:$secondString'; // Returns a string with the format mm:ss
  }
}

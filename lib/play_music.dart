import 'package:audio_test/player_img.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class PlayMusic extends StatefulWidget {
  const PlayMusic({Key? key}) : super(key: key);

  @override
  State<PlayMusic> createState() => _PlayMusicState();
}

class _PlayMusicState extends State<PlayMusic> {
  AudioPlayer audioPlayer = AudioPlayer();
  PlayerState audioPlayerState = PlayerState.paused;
  String audioUrl =
      'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-13.mp3';
  Source sourceUrl = UrlSource(
      'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-13.mp3');
  int timeProgress = 0;
  int audioDuration = 0;

  Widget slider() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(getTimeString(timeProgress)),
              Text(getTimeString(audioDuration)),
            ],
          ),
        ),
        SizedBox(
          width: 300,
          child: Slider(
            value: timeProgress.toDouble(),
            max: audioDuration.toDouble(),
            onChanged: (value) {
              seekTiSec(value.toInt());
            },
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    audioPlayer.onPlayerStateChanged.listen((PlayerState s) {
      setState(() {
        audioPlayerState = s;
      });
    });
    audioPlayer.setSourceUrl(audioUrl);
    audioPlayer.onDurationChanged.listen((Duration duration) {
      setState(() {
        audioDuration = duration.inMilliseconds;
      });
    });
    audioPlayer.onPositionChanged.listen((Duration duration) {
      setState(() {
        timeProgress = duration.inMilliseconds;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    audioPlayer.release();
    audioPlayer.dispose();
  }

  playMusic() async {
    await audioPlayer.play(sourceUrl);
  }

  pausedMusic() async {
    await audioPlayer.pause();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PlayedImg(),
          SizedBox(height: size.height * 0.05),
          slider(),
          SizedBox(height: size.height * 0.05),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.keyboard_double_arrow_left),
              ),
              IconButton(
                onPressed: () {
                  ///
                  audioPlayerState == PlayerState.playing
                      ? pausedMusic()
                      : playMusic();

                  ///
                },
                icon: Icon(
                  audioPlayerState == PlayerState.playing
                      ? Icons.pause
                      : Icons.play_arrow_rounded,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.keyboard_double_arrow_right),
              ),
            ],
          )
        ],
      ),
    );
  }

  void seekTiSec(int sec) {
    Duration newPosition = Duration(seconds: sec);
    audioPlayer.seek(newPosition);
  }

  String getTimeString(int seconds) {
    String minuteString =
        '${(seconds / 60).floor() < 10 ? 0 : ''}${(seconds / 60).floor()}';
    String secondString = '${seconds % 60 < 10 ? 0 : ''}${seconds % 60}';
    return '$minuteString:$secondString'; // Returns a string with the format mm:ss
  }
}

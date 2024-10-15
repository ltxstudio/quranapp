import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:alquranbd/readable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:assets_audio_player/assets_audio_player.dart';

class Ayat extends StatefulWidget {
  final int surahNumber, ayatNumber;
  const Ayat({Key? key, required this.surahNumber, required this.ayatNumber})
      : super(key: key);

  @override
  State<Ayat> createState() => _AyatState();
}

class _AyatState extends State<Ayat> {
  final ayatAudioPlayer = AssetsAudioPlayer();
  bool isPlayingAudio = false;
  bool isPlayable = false;
  bool isLoading = false;

  @override
  void initState() {
    _getAudio();
    ayatAudioPlayer.isPlaying.listen((isPlaying) {
      if (mounted) {
        setState(() {
          isPlayingAudio = isPlaying;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    ayatAudioPlayer.stop();
    super.dispose();
  }

  Future<AyatAudio> fetchAlbum() async {
    try {
      String surahNumber = widget.surahNumber.toString();
      String ayatNumber = widget.ayatNumber.toString();
      String url =
          'https://api.alquran.cloud/v1/ayah/$surahNumber:$ayatNumber/ar.alafasy';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return AyatAudio.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load album');
      }
    } catch (e) {
      print('Error fetching album: $e');
      throw Exception('Failed to load album');
    }
  }

  _getAudio() async {
    setState(() {
      isLoading = true;
    });
    await fetchAlbum().then((value) async {
      try {
        await ayatAudioPlayer
            .open(Audio.network(value.audioUrl), autoStart: false)
            .then((value) {
          setState(() {
            isPlayable = true;
            isLoading = false;
          });
        });
      } catch (t) {
        print('Error loading audio: $t');
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  _playorPauseAudio() async {
    if (isPlayable) {
      if (!isPlayingAudio) {
        ayatAudioPlayer.play();
        setState(() {
          isPlayingAudio = true;
        });
      } else {
        ayatAudioPlayer.pause();
        setState(() {
          isPlayingAudio = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Al Quran BD'),
      ),
      body: Readable.QuranData != null
          ? Column(
              children: [
                Text(
                  Readable.QuranData!['data'][widget.surahNumber - 1]
                      ['ayahs'][widget.ayatNumber - 1]['text'],
                  style: GoogleFonts.ubuntu(fontSize: 24),
                ),
                SizedBox(height: 20),
                isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _playorPauseAudio,
                        child: isPlayingAudio
                            ? Text('Pause')
                            : Text('Play'),
                      ),
              ],
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}

class AyatAudio {
  final String audioUrl;

  AyatAudio({required this.audioUrl});

  factory AyatAudio.fromJson(Map<String, dynamic> json) {
    return AyatAudio(audioUrl: json['data']['audio']);
  }
}

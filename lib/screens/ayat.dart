// lib/screens/ayat.dart
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
    var ayat = Readable.QuranData[widget.surahNumber - 1]['verses']
        [widget.ayatNumber - 1];
    var surah = Readable.QuranData[widget.surahNumber - 1];
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              surah['name'],
              style: GoogleFonts.lateef(
                textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
            ),
            Container(
              margin: EdgeInsets.all(8),
              width: 3,
              height:  25,
              color: Theme.of(context).highlightColor,
            ),
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    surah['transliteration'],
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'আয়াত ' + ayat['id'].toString(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ]),
          ],
        ),
        actions: [
          isLoading
              ? CircularProgressIndicator()
              : IconButton(
                  icon: (isPlayingAudio)
                      ? Icon(Icons.pause)
                      : Icon(Icons.play_circle),
                  onPressed: () {
                    _playorPauseAudio();
                  },
                ),
          IconButton(
              onPressed: () {
                String url =
                    'https://quran-bd.web.app/quran?surah=${widget.surahNumber}&&ayat=${widget.ayatNumber}';
                Clipboard.setData(ClipboardData(text: url)).then((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Link copied to clipboard")));
                });
              },
              icon: Icon(CupertinoIcons.link_circle_fill)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              SelectableText(
                surah['name'],
                textAlign: TextAlign.center,
                style: GoogleFonts.lateef(
                  textStyle:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 45),
                ),
              ),
              SelectableText(
                'بسم الله الرحمن الرحيم',
                textAlign: TextAlign.center,
                style: GoogleFonts.lateef(
                  textStyle:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 45),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SelectableText(
                        surah['transliteration'],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SelectableText(
                        'আয়াত ' + ayat['id'].toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.all(16),
                    width: 3,
                    height: 25,
                    color: Theme.of(context).highlightColor,
                  ),
                  Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SelectableText(
                          ayat['text'],
                          textAlign: TextAlign.end,
                          style: GoogleFonts.lateef(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 60),
                          ),
                        ),
                        SelectableText(
                          ayat['translation'],
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ]),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('কপিরাইট '),
                      TextButton(
                          onPressed: () {
                            launchUrl(
                                Uri.parse('https://facebook.com/abduzzami'));
                          },
                          child:
                              Text('আব্দুজ জামি', textAlign: TextAlign.center))
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

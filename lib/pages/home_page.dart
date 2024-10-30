import 'package:flutter/material.dart';
import 'package:music_app/components/my_drawer.dart';
import 'package:music_app/models/playlist_provider.dart';
import 'package:music_app/pages/song_page.dart';
import 'package:provider/provider.dart';
import '../models/song.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late final dynamic playListProvider;

  @override
  void initState() {
    super.initState();
    playListProvider = Provider.of<PlayListProvider>(context, listen: false);
  }

  void goToSong(int songIndex) {
    playListProvider.currentSongIndex = songIndex;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SongPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('P L A Y L I S T'),
        centerTitle: true,
      ),
      drawer: const MyDrawer(),
      body: Consumer<PlayListProvider>(
        builder: (context, value, child) {
          final List<Song> playList = value.playList;

          return ListView.builder(
            itemCount: playList.length,
            itemBuilder: (context, index) {
              final Song song = playList[index];

              return ListTile(
                title: Text(song.songName),
                subtitle: Text(song.artistName),
                leading: Image.asset(
                  song.albumArtImagePath,
                  width: 50,
                  height: 50,
                ),
                onTap: () => goToSong(index),
              );
            },
          );
        },
      ),
    );
  }
}
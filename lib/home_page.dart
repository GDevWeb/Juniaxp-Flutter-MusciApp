import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/albums_provider.dart';
import './providers/artists_provider.dart';
import './providers/auth_providers.dart';
import './providers/songs_provider.dart';
import './widgets/mini_player.dart';
import './widgets/sections/artists_section.dart';
import './widgets/sections/trends_section.dart';
import 'widgets/sections/albums_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      // Charge les données dès l'ouverture de la page
      Provider.of<AlbumsProvider>(context, listen: false).fetchAlbums();
      Provider.of<ArtistsProvider>(context, listen: false).fetchArtists();
      Provider.of<SongsProvider>(context, listen: false)
          .fetchSongs(1); // Page 1

      // Vérifie si l'utilisateur est auth
      if (!authProvider.isAuthenticated()) {
        _showLoginOverlay();
      }
    });
  }

  void _showLoginOverlay() {
    showDialog(
      context: context,
      barrierDismissible: false, // Empêche le clic hors overlay
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Connexion requise',
            style: TextStyle(color: Colors.orange),
          ),
          content: const Text(
              'Pour accéder à toutes les fonctionnalités, veuillez vous connecter ou créer un compte.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/login');
              },
              child: const Text(
                'Se connecter',
                style: TextStyle(color: Colors.orange),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/signup');
              },
              child: const Text(
                'Créer un compte',
                style: TextStyle(color: Colors.orange),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Music App'),
        actions: [
          Consumer<AuthProvider>(
            builder: (context, authProvider, _) {
              if (authProvider.isAuthenticated()) {
                return IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () {
                    authProvider.logout();
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/login', (route) => false);
                  },
                );
              } else {
                return IconButton(
                  icon: const Icon(Icons.login),
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: const [
                AlbumsSection(),
                SizedBox(height: 20),
                ArtistsSection(),
                SizedBox(height: 20),
                TrendsSection(),
              ],
            ),
          ),
          const MiniPlayer(
            audioUrl:
                'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
          ),
        ],
      ),
    );
  }
}

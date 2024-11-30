import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/auth_providers.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Music App'),
        actions: [
          Consumer<AuthProvider>(
            builder: (context, authProvider, _) {
              if (authProvider.isAuthenticated()) {
                // Afficher l'icône de déconnexion si l'utilisateur est authentifié
                return IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () {
                    authProvider.logout(); // Déconnexion
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/login',
                      (route) => false,
                    );
                  },
                );
              } else {
                // Afficher l'icône de connexion si l'utilisateur n'est pas authentifié
                return IconButton(
                  icon: const Icon(Icons.login),
                  onPressed: () {
                    Navigator.pushNamed(
                        context, '/login'); // Aller à la page de connexion
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
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Section Albums
          const Text(
            'Albums',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 200,
            child: PageView.builder(
              itemCount: 10, // afficher les 10 derniers albums
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.orangeAccent,
                  child: Center(child: Text('Album $index')),
                );
              },
            ),
          ),
          const SizedBox(height: 20),

          // Section Artistes
          const Text(
            'Artistes',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 10, // Exemple : 10 artistes
              itemBuilder: (context, index) {
                return CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.blueAccent,
                  child: Text('Artiste $index'),
                );
              },
            ),
          ),
          const SizedBox(height: 20),

          // Section Tendances
          const Text(
            'Tendances',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: 10, //10 chansons tendances
            itemBuilder: (context, index) {
              return Card(
                color: Colors.purpleAccent,
                child: Center(child: Text('Tendance $index')),
              );
            },
          ),
        ],
      ),
    );
  }
}

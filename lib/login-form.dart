import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Endpoint API
  final String _apiUrl =
      "https://s3-4987.nuage-peda.fr/music/api/authentication_token";

  // soumettre le formulaire
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final Map<String, String> body = {
        "email": _emailController.text.trim(),
        "password": _passwordController.text.trim(),
      };

      try {
        // Envoi du POST
        final response = await http.post(
          Uri.parse(_apiUrl),
          headers: {"Content-Type": "application/ld+json"},
          body: jsonEncode(body),
        );

        if (response.statusCode == 200) {
          // Succès : Récupérer le token
          final Map<String, dynamic> responseData = jsonDecode(response.body);
          final String token = responseData["token"];

          // Sauvegarder le token localement
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Connexion réussie ! Token : $token')),
          );

          // Redirection vers home
          Navigator.pushNamed(context, '/');
        } else {
          // erreur
          final Map<String, dynamic> responseData = jsonDecode(response.body);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'Erreur : ${responseData['message'] ?? 'Erreur inconnue'}')),
          );
        }
      } catch (e) {
        // Gestion des erreurs réseau
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur réseau : $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connexion'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Email
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un email.';
                  }
                  if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value)) {
                    return 'Veuillez entrer un email valide.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              // Mot de passe
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Mot de passe'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un mot de passe.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Bouton de connexion
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Se connecter'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

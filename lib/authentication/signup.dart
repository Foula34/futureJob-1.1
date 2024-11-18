import 'package:flutter/material.dart';
import 'package:future_job/services/auth_service.dart';
import 'package:future_job/widget/custom_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Importer Firebase Auth

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService(); // Instance de AuthService
  bool isLoading = false; // Ajouter un état de chargement

  void _signUp() async {
    if (_formKey.currentState!.validate()) {
      String email = emailController.text.trim();
      String password = passwordController.text.trim();

      setState(() {
        isLoading = true; // Début du chargement
      });

      try {
        // Vérification si l'email est déjà utilisé
        List<String> signInMethods =
            await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);

        if (signInMethods.isNotEmpty) {
          // Si des méthodes sont retournées, cela signifie que l'email est déjà utilisé
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Cet email est déjà utilisé')),
          );
        } else {
          // Si l'email est disponible, on tente l'inscription
          final user = await _authService.signUpWithEmail(email, password);

          if (user != null) {
            // Succès de l'inscription
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Bienvenue, ${user.email}!')),
            );
            Navigator.pushNamed(
                context, '/home'); // Naviguer vers la page d'accueil
          } else {
            // Échec de l'inscription
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Cette adresse email existe deja")),
            );
          }
        }
      } catch (e) {
        // Si une erreur se produit, afficher un message d'erreur générique
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur : ${e.toString()}')),
        );
      } finally {
        setState(() {
          isLoading = false; // Fin du chargement
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.chevron_left,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 3.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "S'inscrire ",
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w700,
                    fontSize: 30.0,
                  ),
                ),
                Text(
                  "Entrez vos informations ou continuez\navec vos réseaux sociaux",
                  style: GoogleFonts.roboto(
                    color: Colors.grey,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 25.0),
                // Nom d'utilisateur
                TextFormField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person, color: Colors.grey),
                    hintText: "Nom d'utilisateur",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Veuillez entrer un nom d'utilisateur";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 25.0),
                // Adresse email
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.email, color: Colors.grey),
                    hintText: "Adresse email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Veuillez entrer une adresse email";
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return "Veuillez entrer une adresse email valide";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 25.0),
                // Mot de passe
                TextFormField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    suffixIcon: Icon(Icons.visibility_off, color: Colors.grey),
                    prefixIcon: Icon(Icons.lock, color: Colors.grey),
                    hintText: "Mot de passe",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Veuillez entrer un mot de passe";
                    }
                    if (value.length < 6) {
                      return "Le mot de passe doit contenir au moins 6 caractères";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 25.0),
                // Bouton d'inscription
                Center(
                  child: isLoading
                      ? CircularProgressIndicator() // Affichage du chargement
                      : CustomButton(
                          text: "S'inscrire",
                          onPressed:
                              _signUp, // Appel de la méthode d'inscription
                        ),
                ),
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text("Ou continuer avec",
                          style: GoogleFonts.roboto()),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 25.0),

                // Icônes de réseaux sociaux
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Image.asset(
                        'assets/images/google.jpg',
                        width: 50,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Image.asset(
                        'assets/images/facebook.png',
                        width: 50,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Vous avez déja un compte ?',
                      style: GoogleFonts.roboto(
                          color: Colors.grey, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(width: 3.0),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/sign');
                      },
                      child: Text(
                        ' Se connecter ',
                        style: GoogleFonts.roboto(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

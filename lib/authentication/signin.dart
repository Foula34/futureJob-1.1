import 'package:flutter/material.dart';
import 'package:future_job/services/auth_service.dart';
import 'package:future_job/widget/custom_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignScreen extends StatefulWidget {
  const SignScreen({super.key});

  @override
  State<SignScreen> createState() => _SignScreenState();
}

class _SignScreenState extends State<SignScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool isLoading = false; // Variable pour afficher un indicateur de chargement

  // Méthode pour gérer la connexion
  void signIn() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true; // Afficher l'indicateur de chargement
      });

      String email = emailController.text;
      String password = passwordController.text;

      try {
        // Appel de la méthode de connexion
        User? user = await AuthService().signInWithEmail(email, password);

        setState(() {
          isLoading = false; // Masquer l'indicateur de chargement
        });

        if (user != null) {
          // Si la connexion réussit, rediriger vers l'écran d'accueil
          Navigator.pushNamed(context, '/home');
        } else {
          // Si l'utilisateur est null, cela signifie qu'il y a eu une erreur
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Address email ou mot de passe incorrect.')),
          );
        }
      } catch (e) {
        setState(() {
          isLoading = false; // Masquer l'indicateur de chargement
        });

        // Vérification des erreurs de connexion
        if (e is FirebaseAuthException) {
          // En fonction du code d'erreur, afficher un message spécifique
          if (e.code == 'user-not-found') {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text('Aucun utilisateur trouvé pour cet email.')),
            );
          } else if (e.code == 'wrong-password') {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Mot de passe incorrect.')),
            );
          } else {
            // Autres erreurs
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text('Erreur lors de la connexion : ${e.message}')),
            );
          }
        } else {
          // Gérer les autres types d'erreurs (par exemple, perte de connexion)
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erreur réseau ou autre problème.')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(right: 28.0, left: 28.0, top: 5.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Bon retour ! ",
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w700,
                    fontSize: 30.0,
                  ),
                ),
                Text(
                  "Entrez vos informations ou continuer\n avec vos réseaux sociaux",
                  style: GoogleFonts.roboto(
                      color: Colors.grey,
                      fontSize: 15.0,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 25.0),

                // Adresse Email
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.email,
                      color: Colors.grey,
                    ),
                    hintText: "Adresse Email",
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
                    suffixIcon: Icon(
                      Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Colors.grey,
                    ),
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

                // Bouton de connexion
                isLoading
                    ? Center(
                        child:
                            CircularProgressIndicator()) // Affichage d'un indicateur de chargement
                    : CustomButton(
                        text: "Se connecter", // Texte du bouton
                        onPressed: signIn, // Appel de la fonction signIn
                      ),
                const SizedBox(height: 25.0),

                // Divider avec texte
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
                      'Nouveau ?',
                      style: GoogleFonts.roboto(
                          color: Colors.grey, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(width: 3.0),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: Text(
                        ' S\'inscrire ',
                        style: GoogleFonts.roboto(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

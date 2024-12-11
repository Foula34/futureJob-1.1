import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatelessWidget {
  final String text; // Texte du bouton
  final VoidCallback onPressed; // Callback lorsqu'on appuie sur le bouton

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    required bool isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed, // Appelle la fonction lors de l'appui
      child: Container(
        width: 250.0,
        height: 50.0,
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text.toUpperCase(), // Affiche le texte en majuscules
              style: GoogleFonts.roboto(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

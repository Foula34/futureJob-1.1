import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
//     _Login() {

// }
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(bottom: 20.0, left: 20.0, right: 20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: SvgPicture.asset(
                  'assets/images/welcome.svg',
                  semanticsLabel: 'Description de l\'image',
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
               Text(
                'Trouve le parfait\nJob En un Clic ',
                style: GoogleFonts.roboto(fontWeight: FontWeight.w700, fontSize: 35.0,),
                textAlign: TextAlign.left,
              ),
               Text('Trouvez votre job de reve devient facile et simple avec future job',
                  style: GoogleFonts.roboto(
                      fontSize: 15.0,
                      color: Colors.grey,
                      fontWeight: FontWeight.w700),
                  textAlign: TextAlign.center),
              const SizedBox(height: 30.0),
              
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/sign');
                  // Navigator.pop(context);
                },
                child: Container(
                  width: 250.0,
                  height: 50.0,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child:  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Commençons",
                        style: GoogleFonts.roboto(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(width: 10.0),
                      const Icon(Icons.arrow_forward, color: Colors.white),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
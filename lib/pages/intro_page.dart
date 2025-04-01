import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rgit_apparels/auth/main_page.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //logo
                Image.asset('lib/images/ecommerce-app.png',
                    height: 150, width: 150),

                const SizedBox(height: 25),
                //title
                Text("RGIT Apparels",
                    style: GoogleFonts.dmSerifDisplay(
                      fontSize: 24,
                      color: Theme.of(context).colorScheme.primary,
                    )
                  ),

                //subtitle
                Text("Buy some affordable Apparels",
                    style: GoogleFonts.dmSerifDisplay(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    )
                  ),

                const SizedBox(height: 25),
                //button

                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MainPage(),
                      )
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(20.0),
                        child: const Center(
                          child: Text(
                            "Get Started",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )),
                  ),
                )
              ],
            )
          )
        );
  }
}

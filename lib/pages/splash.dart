import 'package:ai_buddy/pages/Chat.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _splashScreenState();
}

class _splashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 94, 162, 240),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: AnimatedTextKit(
              onFinished: () {
                Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => FirebaseAuth.instance.currentUser != null
                ? const HomeScreen()
                : const signIn(),
          ));
              },
              animatedTexts: [
                TypewriterAnimatedText(
                  'Hi...',
                  cursor: ".",
                  textAlign: TextAlign.center,
                  textStyle: const TextStyle(
                      fontSize: 34.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  speed: const Duration(milliseconds: 150),
                ),
                TypewriterAnimatedText('I am AI_BUDDY',
                    textAlign: TextAlign.center,
                    curve: Curves.ease,
                    textStyle: const TextStyle(
                      fontSize: 34.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    speed: const Duration(milliseconds: 150),
                    cursor: "!"),
                TypewriterAnimatedText(
                  'Lets Resolve your queries!',
                  textAlign: TextAlign.center,
                  curve: Curves.ease,
                  textStyle: const TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  speed: const Duration(milliseconds: 150),
                  cursor: "!",
                ),
              ],
              isRepeatingAnimation: false,
              displayFullTextOnTap: true,
              stopPauseOnTap: true,
            ),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'dart:async'; // buat Timer

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Setelah 3 detik, pindah ke halaman Home
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/login'); 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(   
      // Menggunakan warna latar belakang yang sama
      backgroundColor: const Color.fromARGB(255, 109, 199, 255),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/Library_Books.png', 
              width: 200,
              height: 200, 
            ),
          ],
        ),
      ),
    );
  }
}
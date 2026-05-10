import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'Hello Flutter!',
              style: TextStyle(
                  letterSpacing: 2,
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                  color: Color(0xFF2196F3)
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Ini teks biasa dengan ukuran kecil',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    ),
  ));
}
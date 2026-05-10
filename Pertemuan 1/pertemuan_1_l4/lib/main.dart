import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      body: const Center(
        child: Text(
          'Konten Halaman Utama',
          style: TextStyle(fontSize: 20, color: Colors.grey),
        ),
      ),

      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Ikon 1: Home
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.home, size: 24, color: Colors.red),
                Text('Home', style: TextStyle(fontSize: 12)),
              ],
            ),

            // Ikon 2: Explore
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.explore, size: 32, color: Colors.blue),
                Text('Eksplor', style: TextStyle(fontSize: 12)),
              ],
            ),

            // Ikon 3: Receipt
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.receipt_long, size: 48, color: Colors.green),
                Text('Transaksi', style: TextStyle(fontSize: 12)),
              ],
            ),

            // Ikon 4: Person
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.person, size: 64, color: Colors.purple),
                Text('Profil', style: TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    ),
  ));
}
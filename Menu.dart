
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MenuPage(),
  ));
}

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    const menuStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Campus Connect"),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.indigo, Colors.blueGrey],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.symmetric(
                vertical: 18,
                horizontal: 10,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Icon(Icons.home, color: Colors.white),
                      SizedBox(height: 5),
                      Text("Home", style: menuStyle),
                    ],
                  ),
                  Column(
                    children: [
                      Icon(Icons.school, color: Colors.white),
                      SizedBox(height: 5),
                      Text("Courses", style: menuStyle),
                    ],
                  ),
                  Column(
                    children: [
                      Icon(Icons.info_outline, color: Colors.white),
                      SizedBox(height: 5),
                      Text("About", style: menuStyle),
                    ],
                  ),
                  Column(
                    children: [
                      Icon(Icons.call, color: Colors.white),
                      SizedBox(height: 5),
                      Text("Contact", style: menuStyle),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 55),
            const Icon(
              Icons.account_balance,
              size: 90,
              color: Colors.white,
            ),
            const SizedBox(height: 20),
            const Text(
              "Welcome to Campus Connect",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Your learning journey starts here.",
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}

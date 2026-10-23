
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: DashboardPage(),
  ));
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Student Dashboard"),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              radius: 35,
              child: Icon(Icons.person, size: 40),
            ),
            const SizedBox(height: 10),
            const Text(
              "Welcome, Student!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text("B.Tech - Computer Science"),
            const SizedBox(height: 25),
            const Text(
              "My Subjects",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            subjectCard("Java Programming", Icons.code),
            subjectCard("Database Management", Icons.storage),
            subjectCard("Web Development", Icons.web),
          ],
        ),
      ),
    );
  }

  Widget subjectCard(String name, IconData icon) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: Colors.teal),
        title: Text(name),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}

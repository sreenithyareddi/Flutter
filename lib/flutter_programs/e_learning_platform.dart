
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: LearningDashboard(),
  ));
}

class LearningDashboard extends StatefulWidget {
  const LearningDashboard({super.key});

  @override
  State<LearningDashboard> createState() => _LearningDashboardState();
}

class _LearningDashboardState extends State<LearningDashboard> {
  int selected = 0;

  final titles = ['Dashboard', 'My Courses', 'Progress', 'Profile'];
  final icons = [
    Icons.home,
    Icons.book,
    Icons.bar_chart,
    Icons.person
  ];

  final courses = [
    ['Flutter Development', '12 Lessons', '0.6'],
    ['Java Programming', '15 Lessons', '0.4'],
    ['Web Development', '10 Lessons', '0.8'],
  ];

  @override
  Widget build(BuildContext context) {
    bool tablet = MediaQuery.of(context).size.width >= 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(titles[selected]),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Row(
        children: [
          if (tablet)
            NavigationRail(
              selectedIndex: selected,
              onDestinationSelected: (i) {
                setState(() => selected = i);
              },
              labelType: NavigationRailLabelType.all,
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.home), label: Text('Home')),
                NavigationRailDestination(
                  icon: Icon(Icons.book), label: Text('Courses')),
                NavigationRailDestination(
                  icon: Icon(Icons.bar_chart), label: Text('Progress')),
                NavigationRailDestination(
                  icon: Icon(Icons.person), label: Text('Profile')),
              ],
            ),
          Expanded(child: page()),
        ],
      ),
      bottomNavigationBar: tablet
          ? null
          : BottomNavigationBar(
              currentIndex: selected,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Colors.teal,
              onTap: (i) => setState(() => selected = i),
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.book), label: 'Courses'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.bar_chart), label: 'Progress'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person), label: 'Profile'),
              ],
            ),
    );
  }

  Widget page() {
    if (selected == 3) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 40,
              child: Icon(Icons.person, size: 45),
            ),
            SizedBox(height: 12),
            Text('Student', style: TextStyle(fontSize: 22)),
            Text('student@example.com'),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          selected == 0
              ? 'Welcome, Student!'
              : selected == 1
                  ? 'My Courses'
                  : 'Your Progress',
          style: const TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        if (selected == 0) const Text('Continue learning every day!'),
        const SizedBox(height: 16),
        if (selected == 0)
          const Card(
            color: Colors.teal,
            child: Padding(
              padding: EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Overall Progress',
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                  SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: 0.65,
                    backgroundColor: Colors.white38,
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
                  SizedBox(height: 8),
                  Text('65% completed',
                      style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ),
        for (final course in courses)
          Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.menu_book, color: Colors.teal),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          course[0],
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(course[1]),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: double.parse(course[2]),
                    color: Colors.teal,
                  ),
                  const SizedBox(height: 5),
                  Text('${(double.parse(course[2]) * 100).toInt()}% completed'),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

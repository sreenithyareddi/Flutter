
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: WaterTracker(),
  ));
}

class WaterTracker extends StatefulWidget {
  const WaterTracker({super.key});

  @override
  State<WaterTracker> createState() => _WaterTrackerState();
}

class _WaterTrackerState extends State<WaterTracker>
    with SingleTickerProviderStateMixin {
  int water = 0;
  final int goal = 2000;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
      lowerBound: 0.8,
      upperBound: 1.2,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void addWater(int amount) {
    setState(() {
      water += amount;
      if (water > goal) water = goal;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Water Tracker Effects'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: controller,
              child: const Icon(
                Icons.water_drop,
                size: 90,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '$water / $goal ml',
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 250,
              child: LinearProgressIndicator(
                value: water / goal,
                minHeight: 12,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 25),
            Wrap(
              spacing: 10,
              children: [
                ElevatedButton(
                  onPressed: () => addWater(200),
                  child: const Text('+200 ml'),
                ),
                ElevatedButton(
                  onPressed: () => addWater(500),
                  child: const Text('+500 ml'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () => setState(() => water = 0),
              child: const Text('Reset'),
            ),
            if (water == goal)
              const Text(
                'Goal Completed!',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

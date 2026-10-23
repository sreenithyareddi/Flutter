
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: WaterPage(),
  ));
}

class WaterPage extends StatefulWidget {
  const WaterPage({super.key});

  @override
  State<WaterPage> createState() => _WaterPageState();
}

class _WaterPageState extends State<WaterPage> {
  int water = 0;
  final int goal = 2000;

  void addWater(int amount) {
    setState(() {
      water += amount;
      if (water > goal) water = goal;
    });
  }

  @override
  Widget build(BuildContext context) {
    double progress = water / goal;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Water Tracker'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Today’s Summary'),
                  content: Text(
                    'Consumed: $water ml\nRemaining: ${goal - water} ml',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text(
                'Stay Hydrated!',
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              const SizedBox(height: 25),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 170,
                    height: 170,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 13,
                      backgroundColor: Colors.teal.shade50,
                      color: Colors.teal,
                    ),
                  ),
                  Column(
                    children: [
                      const Icon(Icons.water_drop,
                          size: 32, color: Colors.teal),
                      Text(
                        '$water ml',
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text('of $goal ml'),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Text('Add Water',
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              Wrap(
                spacing: 10,
                children: [
                  waterButton(200),
                  waterButton(300),
                  waterButton(500),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                '${(progress * 100).toInt()}% of daily goal completed',
                style: const TextStyle(color: Colors.teal),
              ),
              const SizedBox(height: 15),
              if (water >= goal)
                const Text(
                  'Daily goal completed!',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              const SizedBox(height: 15),
              OutlinedButton.icon(
                onPressed: () => setState(() => water = 0),
                icon: const Icon(Icons.refresh),
                label: const Text('Reset Intake'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget waterButton(int amount) {
    return ElevatedButton(
      onPressed: () => addWater(amount),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      child: Text('+$amount ml'),
    );
  }
}

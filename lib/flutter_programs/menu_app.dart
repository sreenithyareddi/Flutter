
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Menu App',
      theme: ThemeData(
        colorSchemeSeed: Colors.deepPurple,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void openPage(BuildContext context, Widget page) {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Dashboard'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              height: 190,
              color: Colors.deepPurple,
              padding: const EdgeInsets.all(20),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 35,
                      color: Colors.deepPurple,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Welcome User!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Explore your options',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: const Icon(Icons.dashboard_outlined),
              title: const Text('Dashboard'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.build_outlined),
              title: const Text('Our Services'),
              onTap: () => openPage(context, const ServicesPage()),
            ),
            ListTile(
              leading: const Icon(Icons.rate_review_outlined),
              title: const Text('Feedback'),
              onTap: () => openPage(context, const FeedbackPage()),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('About App'),
              onTap: () {
                Navigator.pop(context);
                showAboutDialog(
                  context: context,
                  applicationName: 'My Dashboard',
                  applicationVersion: '1.0.0',
                );
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.dashboard_customize,
                size: 90,
                color: Colors.deepPurple,
              ),
              const SizedBox(height: 20),
              const Text(
                'Welcome!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Open the menu to explore services and share feedback.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => Scaffold.of(context).openDrawer(),
                icon: const Icon(Icons.menu),
                label: const Text('Explore Menu'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Our Services')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          Card(
            child: ListTile(
              leading: Icon(Icons.support_agent, color: Colors.deepPurple),
              title: Text('Customer Support'),
              subtitle: Text('Get help when you need it.'),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.computer, color: Colors.deepPurple),
              title: Text('Technical Assistance'),
              subtitle: Text('Support for technical issues.'),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.cloud_outlined, color: Colors.deepPurple),
              title: Text('Online Services'),
              subtitle: Text('Access services conveniently.'),
            ),
          ),
        ],
      ),
    );
  }
}

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final TextEditingController feedbackController = TextEditingController();
  String message = '';

  void submitFeedback() {
    if (feedbackController.text.trim().isEmpty) {
      setState(() {
        message = 'Please enter your feedback.';
      });
      return;
    }

    setState(() {
      message = 'Thank you for your feedback!';
    });

    feedbackController.clear();
  }

  @override
  void dispose() {
    feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Share Feedback')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Icon(
              Icons.rate_review,
              size: 65,
              color: Colors.deepPurple,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: feedbackController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Your feedback',
                hintText: 'Tell us what you think...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: submitFeedback,
              icon: const Icon(Icons.send),
              label: const Text('Submit Feedback'),
            ),
            const SizedBox(height: 15),
            Text(
              message,
              style: const TextStyle(
                color: Colors.deepPurple,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

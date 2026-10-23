import 'package:flutter/material.dart';

void main() {
  runApp(const SmartWaterIntakeApp());
}

const Color blue = Color(0xFF2878F0);
const Color navy = Color(0xFF172B4D);
const Color pageColor = Color(0xFFF4F7FC);

class SmartWaterIntakeApp extends StatefulWidget {
  const SmartWaterIntakeApp({super.key});

  @override
  State<SmartWaterIntakeApp> createState() =>
      _SmartWaterIntakeAppState();
}

class _SmartWaterIntakeAppState extends State<SmartWaterIntakeApp> {
  bool darkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AquaFlow',
      themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: pageColor,
        colorScheme: ColorScheme.fromSeed(seedColor: blue),
        cardColor: Colors.white,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: blue,
          brightness: Brightness.dark,
        ),
      ),
      home: WaterHome(
        darkMode: darkMode,
        onThemeChanged: (value) {
          setState(() => darkMode = value);
        },
      ),
    );
  }
}

class Drink {
  final int amount;
  final DateTime time;

  Drink(this.amount) : time = DateTime.now();
}

class WaterHome extends StatefulWidget {
  final bool darkMode;
  final ValueChanged<bool> onThemeChanged;

  const WaterHome({
    super.key,
    required this.darkMode,
    required this.onThemeChanged,
  });

  @override
  State<WaterHome> createState() => _WaterHomeState();
}

class _WaterHomeState extends State<WaterHome> {
  int intake = 0;
  int goal = 2500;
  int selectedPage = 0;
  bool reminderEnabled = true;
  final List<Drink> drinks = [];

  double get progress => (intake / goal).clamp(0.0, 1.0);

  int get remaining => (goal - intake).clamp(0, goal);

  void addWater(int amount) {
    if (amount <= 0) return;

    setState(() {
      intake += amount;
      drinks.insert(0, Drink(amount));
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added $amount ml of water 💧'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void undoDrink() {
    if (drinks.isEmpty) return;

    setState(() {
      final lastDrink = drinks.removeAt(0);
      intake = (intake - lastDrink.amount).clamp(0, intake);
    });
  }

  void resetDay() {
    setState(() {
      intake = 0;
      drinks.clear();
    });
  }

  Future<void> addCustomWater() async {
    final controller = TextEditingController();

    final amount = await showDialog<int>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Add custom amount'),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Water in millilitres',
            hintText: 'e.g. 350',
            suffixText: 'ml',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final value = int.tryParse(controller.text.trim());
              if (value != null && value > 0 && value <= 5000) {
                Navigator.pop(dialogContext, value);
              }
            },
            child: const Text('Add water'),
          ),
        ],
      ),
    );

    controller.dispose();

    if (amount != null && mounted) {
      addWater(amount);
    }
  }

  Future<void> editGoal() async {
    final controller = TextEditingController(text: '$goal');

    final value = await showDialog<int>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Daily water goal'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Goal in millilitres',
            suffixText: 'ml',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final value = int.tryParse(controller.text.trim());
              if (value != null && value >= 250 && value <= 10000) {
                Navigator.pop(dialogContext, value);
              }
            },
            child: const Text('Save goal'),
          ),
        ],
      ),
    );

    controller.dispose();

    if (value != null && mounted) {
      setState(() => goal = value);
    }
  }

  String get pageTitle {
    if (selectedPage == 1) return 'Water History';
    if (selectedPage == 2) return 'Your Progress';
    return 'Dashboard';
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final desktop = constraints.maxWidth >= 850;

        final page = IndexedStack(
          index: selectedPage,
          children: [
            dashboardPage(),
            historyPage(),
            insightsPage(),
          ],
        );

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: blue.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.water_drop_rounded,
                    color: blue,
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'AquaFlow',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                tooltip: 'Toggle theme',
                onPressed: () =>
                    widget.onThemeChanged(!widget.darkMode),
                icon: Icon(
                  widget.darkMode
                      ? Icons.light_mode_rounded
                      : Icons.dark_mode_rounded,
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: Row(
            children: [
              if (desktop)
                NavigationRail(
                  selectedIndex: selectedPage,
                  onDestinationSelected: (index) {
                    setState(() => selectedPage = index);
                  },
                  labelType: NavigationRailLabelType.all,
                  leading: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Icon(Icons.spa_rounded, color: blue, size: 30),
                  ),
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.grid_view_rounded),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.history_rounded),
                      label: Text('History'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.insights_rounded),
                      label: Text('Insights'),
                    ),
                  ],
                ),
              if (desktop) const VerticalDivider(width: 1),
              Expanded(
                child: Column(
                  children: [
                    if (desktop)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(28, 18, 28, 0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            pageTitle,
                            style: const TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    Expanded(
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1120),
                          child: page,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: desktop
              ? null
              : NavigationBar(
                  selectedIndex: selectedPage,
                  onDestinationSelected: (index) {
                    setState(() => selectedPage = index);
                  },
                  destinations: const [
                    NavigationDestination(
                      icon: Icon(Icons.grid_view_rounded),
                      label: 'Home',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.history_rounded),
                      label: 'History',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.insights_rounded),
                      label: 'Insights',
                    ),
                  ],
                ),
        );
      },
    );
  }

  Widget dashboardPage() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 650;
        final horizontalPadding = constraints.maxWidth < 380 ? 14.0 : 24.0;

        return SingleChildScrollView(
          padding: EdgeInsets.all(horizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello, Hydrator! 👋',
                          style: TextStyle(
                            fontSize: constraints.maxWidth < 380 ? 23 : 28,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.8,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Small sips, big difference.",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton.filledTonal(
                    onPressed: () {
                      setState(() {
                        reminderEnabled = !reminderEnabled;
                      });
                    },
                    tooltip: 'Toggle reminder preference',
                    icon: Icon(
                      reminderEnabled
                          ? Icons.notifications_active_rounded
                          : Icons.notifications_off_rounded,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // STACK: layered decorative circles and hero content.
              heroCard(wide),

              const SizedBox(height: 22),

              // Responsive statistic cards.
              Wrap(
                spacing: 14,
                runSpacing: 14,
                children: [
                  statCard(
                    'Daily goal',
                    '${(goal / 1000).toStringAsFixed(1)} L',
                    Icons.flag_rounded,
                    const Color(0xFFE8F0FF),
                    wide,
                    () => editGoal(),
                  ),
                  statCard(
                    'Remaining',
                    '${(remaining / 1000).toStringAsFixed(2)} L',
                    Icons.water_drop_rounded,
                    const Color(0xFFDDF7F1),
                    wide,
                    null,
                  ),
                  statCard(
                    'Completed',
                    '${(progress * 100).round()}%',
                    Icons.bolt_rounded,
                    const Color(0xFFFFEFD9),
                    wide,
                    null,
                  ),
                ],
              ),

              const SizedBox(height: 28),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Quick add',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: addCustomWater,
                    icon: const Icon(Icons.add_rounded),
                    label: const Text('Custom'),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              const Text(
                'How much water did you drink?',
                style: TextStyle(color: Colors.blueGrey),
              ),
              const SizedBox(height: 16),

              // ROW: quick-add cards adapt to available width.
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  quickAddCard(150, constraints.maxWidth),
                  quickAddCard(250, constraints.maxWidth),
                  quickAddCard(500, constraints.maxWidth),
                ],
              ),

              const SizedBox(height: 28),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recent drinks',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  TextButton(
                    onPressed: () => setState(() => selectedPage = 1),
                    child: const Text('View all'),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              if (drinks.isEmpty)
                emptyCard(
                  Icons.local_drink_rounded,
                  'Your day starts here',
                  'Add your first glass of water above.',
                )
              else
                ...drinks.take(3).map((drink) => drinkTile(drink)),

              const SizedBox(height: 22),

              // Hydration tip.
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFE7F3FF), Color(0xFFF1EDFF)],
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.tips_and_updates_rounded,
                      size: 34,
                      color: Color(0xFF386CE0),
                    ),
                    SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Your daily tip',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: navy,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Keep a water bottle nearby and drink '
                            'regularly throughout the day.',
                            style: TextStyle(
                              color: Color(0xFF526681),
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
              Center(
                child: TextButton.icon(
                  onPressed: drinks.isEmpty ? null : undoDrink,
                  icon: const Icon(Icons.undo_rounded),
                  label: const Text('Undo last drink'),
                ),
              ),
              Center(
                child: TextButton(
                  onPressed: drinks.isEmpty
                      ? null
                      : () => showResetDialog(),
                  child: const Text('Reset today'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget heroCard(bool wide) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF3689FF), Color(0xFF3156D9)],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: blue.withOpacity(0.22),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          children: [
            // Decorative circles layered behind the content.
            Positioned(
              top: -65,
              right: -35,
              child: circleDecoration(190),
            ),
            Positioned(
              bottom: -95,
              left: wide ? 250 : 100,
              child: circleDecoration(190),
            ),
            Padding(
              padding: EdgeInsets.all(wide ? 30 : 22),
              child: wide
                  ? Row(
                      children: [
                        Expanded(child: heroText()),
                        const SizedBox(width: 20),
                        progressRing(156),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        heroText(),
                        const SizedBox(height: 22),
                        Center(child: progressRing(142)),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget heroText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.water_drop_rounded, color: Colors.white70, size: 18),
            SizedBox(width: 7),
            Text(
              "TODAY'S HYDRATION",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.4,
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            '${(intake / 1000).toStringAsFixed(2)} L',
            style: const TextStyle(
              fontSize: 44,
              color: Colors.white,
              fontWeight: FontWeight.w900,
              letterSpacing: -1.5,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'of ${(goal / 1000).toStringAsFixed(1)} L daily goal',
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.17),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            progress >= 1
                ? '🎉 Daily goal reached!'
                : '💧 ${(remaining / 1000).toStringAsFixed(2)} L to go',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget progressRing(double size) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: progress),
      duration: const Duration(milliseconds: 700),
      builder: (context, value, child) {
        return SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: size,
                height: size,
                child: CircularProgressIndicator(
                  value: 1,
                  strokeWidth: 11,
                  color: Colors.white.withOpacity(0.22),
                ),
              ),
              SizedBox(
                width: size,
                height: size,
                child: CircularProgressIndicator(
                  value: value,
                  strokeWidth: 11,
                  strokeCap: StrokeCap.round,
                  backgroundColor: Colors.transparent,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Colors.white,
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.water_drop_rounded,
                    color: Colors.white,
                    size: 25,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${(value * 100).round()}%',
                    style: TextStyle(
                      fontSize: size * 0.19,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    'completed',
                    style: TextStyle(fontSize: 11, color: Colors.white70),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget circleDecoration(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.07),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
    );
  }

  Widget statCard(
    String title,
    String value,
    IconData icon,
    Color iconColor,
    bool wide,
    VoidCallback? onTap,
  ) {
    return SizedBox(
      width: wide ? 210 : 150,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: BorderSide(
            color: Theme.of(context).dividerColor.withOpacity(0.12),
          ),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(22),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: iconColor,
                  foregroundColor: navy,
                  child: Icon(icon),
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 5),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    value,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                if (onTap != null)
                  const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(
                      'Tap to edit',
                      style: TextStyle(color: blue, fontSize: 11),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget quickAddCard(int amount, double availableWidth) {
    final width = availableWidth < 380
        ? (availableWidth - 24) / 3
        : 160.0;

    return SizedBox(
      width: width.clamp(85.0, 180.0),
      child: Material(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: () => addWater(amount),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Theme.of(context).dividerColor.withOpacity(0.15),
              ),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5F2FF),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Icon(
                    Icons.water_drop_rounded,
                    color: blue,
                    size: 25,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '$amount ml',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  '+ Add water',
                  style: TextStyle(color: blue, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget drinkTile(Drink drink) {
    final time =
        '${drink.time.hour.toString().padLeft(2, '0')}:'
        '${drink.time.minute.toString().padLeft(2, '0')}';

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(11),
          decoration: BoxDecoration(
            color: const Color(0xFFE5F2FF),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(Icons.water_drop_rounded, color: blue),
        ),
        title: Text(
          '${drink.amount} ml of water',
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle: Text(time),
        trailing: const Icon(Icons.check_circle_rounded, color: blue),
      ),
    );
  }

  Widget emptyCard(IconData icon, String title, String subtitle) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Icon(icon, size: 36, color: blue),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget historyPage() {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          'Today’s drinks',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Text('${drinks.length} drinks recorded'),
        const SizedBox(height: 20),
        Card(
          elevation: 0,
          child: ListTile(
            leading: const Icon(Icons.water_drop_rounded, color: blue),
            title: const Text('Total consumed'),
            trailing: Text(
              '${(intake / 1000).toStringAsFixed(2)} L',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(height: 12),
        if (drinks.isEmpty)
          emptyCard(
            Icons.history_rounded,
            'No drinks yet',
            'Your water entries will appear here.',
          )
        else
          ...drinks.map((drink) => drinkTile(drink)),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: drinks.isEmpty ? null : undoDrink,
          icon: const Icon(Icons.undo_rounded),
          label: const Text('Undo last entry'),
        ),
        OutlinedButton.icon(
          onPressed: drinks.isEmpty ? null : showResetDialog,
          icon: const Icon(Icons.delete_outline_rounded),
          label: const Text('Clear today’s history'),
        ),
      ],
    );
  }

  Widget insightsPage() {
    final percentage = (progress * 100).round();

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          'Your progress',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        const Text('A snapshot of your hydration today.'),
        const SizedBox(height: 24),
        Card(
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              children: [
                const Icon(Icons.insights_rounded, color: blue, size: 40),
                const SizedBox(height: 12),
                Text(
                  '$percentage%',
                  style: const TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const Text('of your daily goal completed'),
                const SizedBox(height: 18),
                LinearProgressIndicator(
                  value: progress,
                  minHeight: 10,
                  borderRadius: BorderRadius.circular(10),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
        statCard(
          'Water consumed',
          '${(intake / 1000).toStringAsFixed(2)} L',
          Icons.water_drop_rounded,
          const Color(0xFFE5F2FF),
          true,
          null,
        ),
        const SizedBox(height: 12),
        statCard(
          'Drinks recorded',
          '${drinks.length}',
          Icons.local_drink_rounded,
          const Color(0xFFDDF7F1),
          true,
          null,
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 0,
          child: SwitchListTile(
            value: reminderEnabled,
            onChanged: (value) {
              setState(() => reminderEnabled = value);
            },
            title: const Text('Reminder preference'),
            subtitle: const Text(
              'Toggle your hydration reminder preference.',
            ),
            secondary: const Icon(
              Icons.notifications_active_rounded,
              color: blue,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 0,
          child: ListTile(
            leading: const Icon(Icons.flag_rounded, color: blue),
            title: const Text('Daily goal'),
            subtitle: const Text('Tap to customise your target'),
            trailing: Text('${goal} ml'),
            onTap: editGoal,
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 16),
          child: Text(
            'Note: These statistics are calculated from entries '
            'recorded during this app session. They are not saved '
            'permanently yet.',
            style: TextStyle(color: Colors.blueGrey, height: 1.5),
          ),
        ),
      ],
    );
  }

  Future<void> showResetDialog() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Reset today?'),
        content: const Text(
          'This clears your current intake and drink history.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      resetDay();
    }
  }
}
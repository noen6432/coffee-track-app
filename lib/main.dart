import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(const CoffeeTrackApp());

class CoffeeTrackApp extends StatelessWidget {
  const CoffeeTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Coffee Track',
      theme: ThemeData(primarySwatch: Colors.brown, scaffoldBackgroundColor: const Color(0xFFF7EBE1)),
      home: const GameScreen(),
    );
  }
}

class MenuItem {
  final String name;
  final String icon;
  MenuItem(this.name, this.icon);
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final List<MenuItem> menu = [
    MenuItem('Espresso', '☕'),
    MenuItem('Cappuccino', '🥛☕'),
    MenuItem('Iced Latte', '🧊☕'),
    MenuItem('Croissant', '🥐'),
    MenuItem('Cheesecake', '🍰'),
  ];

  final List<String> customers = ['Alex', 'Sarah', 'David', 'Emma'];
  int score = 0;
  int timeLeft = 45;
  Timer? timer;
  bool isPlaying = false;
  late MenuItem currentOrder;
  late String currentCustomer;

  @override
  void initState() {
    super.initState();
    _newOrder();
  }

  void _startGame() {
    setState(() {
      score = 0;
      timeLeft = 45;
      isPlaying = true;
    });
    _newOrder();
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (timeLeft > 0) {
        setState(() => timeLeft--);
      } else {
        t.cancel();
        setState(() => isPlaying = false);
      }
    });
  }

  void _newOrder() {
    final rand = Random();
    setState(() {
      currentOrder = menu[rand.nextInt(menu.length)];
      currentCustomer = customers[rand.nextInt(customers.length)];
    });
  }

  void _serve(MenuItem item) {
    if (!isPlaying) return;
    if (item.name == currentOrder.name) {
      setState(() => score += 10);
      _newOrder();
    } else {
      setState(() => score = max(0, score - 5));
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('☕ Coffee Track - Barista Rush'), backgroundColor: const Color(0xFF5D4037)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Score: $score', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text('Time: ${timeLeft}s', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red)),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.brown)),
              child: Column(
                children: [
                  Text('Customer: $currentCustomer', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('Wants: ${currentOrder.icon} ${currentOrder.name}', style: const TextStyle(fontSize: 22, color: Colors.brown, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            if (!isPlaying)
              ElevatedButton(
                onPressed: _startGame,
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF5D4037)),
                child: const Text('Start Shift (Play)', style: TextStyle(color: Colors.white)),
              ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: const FlutterGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 1.5),
                itemCount: menu.length,
                itemBuilder: (ctx, i) => InkWell(
                  onTap: () => _serve(menu[i]),
                  child: Container(
                    decoration: BoxDecoration(color: const Color(0xFFD7CCC8), borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(menu[i].icon, style: const TextStyle(fontSize: 24)),
                        Text(menu[i].name, style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

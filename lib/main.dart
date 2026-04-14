import 'package:flutter/material.dart';

void main() {
  runApp(const RightNowApp());
}

class RightNowApp extends StatelessWidget {
  const RightNowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
      ),
      home: const MainJobScreen(),
    );
  }
}

class MainJobScreen extends StatelessWidget {
  const MainJobScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: const Text('RIGHT NOW', 
          style: TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.w900, fontSize: 24)),
        centerTitle: false,
      ),
      body: ListView(
        children: [
          _buildHeader(),
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: Text('Emergency Jobs 🔥', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          _jobCard('Gangnam Station Cafe', '12,000 KRW', '18:00 - 22:00', 'Gangnam'),
          _jobCard('Delivery Assistant', '15,000 KRW', 'ASAP', 'Seocho'),
          _jobCard('Event Staff', '100,000 KRW', 'Tomorrow', 'Songpa'),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.deepOrange,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'My'),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Need a Job?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          const Text('Find it Right Now!', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(color: Colors.orange[50], borderRadius: BorderRadius.circular(10)),
            child: const Row(
              children: [
                Icon(Icons.bolt, color: Colors.orange),
                SizedBox(width: 10),
                Text('Quick matching in 10 minutes!', style: TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _jobCard(String title, String pay, String time, String loc) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(pay, style: const TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 4),
            Text('$time | $loc', style: const TextStyle(color: Colors.grey, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}

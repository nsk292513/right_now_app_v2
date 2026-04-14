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
        fontFamily: 'Roboto',
      ),
      home: const RightNowHomeScreen(),
    );
  }
}

class RightNowHomeScreen extends StatelessWidget {
  const RightNowHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('RIGHT NOW', 
          style: TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.w900, fontSize: 26, letterSpacing: -1)),
        actions: [
          IconButton(icon: const Icon(Icons.search, color: Colors.black, size: 28), onPressed: () {}),
          IconButton(icon: const Icon(Icons.notifications_none, color: Colors.black, size: 28), onPressed: () {}),
          const SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeroBanner(),
            _buildCategorySection(),
            _buildSectionTitle('Real-time Urgent Jobs 🔥'),
            _buildJobCard('Cafe Staff (3hrs)', '15,000 KRW/hr', 'Today 18:00 - 21:00', 'Gangnam-gu'),
            _buildJobCard('Warehouse Assistant', '65,000 KRW/task', 'Tomorrow 09:00', 'Seocho-gu'),
            _buildJobCard('Event Support Staff', '12,000 KRW/hr', '4/16(Thu) All day', 'Songpa-gu'),
            const SizedBox(height: 100), // 여백
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.deepOrange,
        unselectedItemColor: Colors.grey[400],
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.location_on_outlined), label: 'Near Me'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Status'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'My Page'),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: Colors.deepOrange,
        icon: const Icon(Icons.add_circle_outline, color: Colors.white),
        label: const Text('Post a Job', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ),
    );
  }

  Widget _buildHeroBanner() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.orange[400]!, Colors.deepOrange]),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.orange.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Need help\nRight Now?', 
            style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold, height: 1.2)),
          SizedBox(height: 10),
          Text('Connect with nearby part-timers instantly.', 
            style: TextStyle(color: Colors.white70, fontSize: 15)),
        ],
      ),
    );
  }

  Widget _buildCategorySection() {
    return SizedBox(
      height: 110,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        children: [
          _buildCategoryItem(Icons.restaurant, 'F&B'),
          _buildCategoryItem(Icons.local_shipping, 'Delivery'),
          _buildCategoryItem(Icons.store, 'Retail'),
          _buildCategoryItem(Icons.cleaning_services, 'Cleaning'),
          _buildCategoryItem(Icons.event, 'Events'),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(color: Colors.orange[50], shape: BoxShape.circle),
            child: Icon(icon, color: Colors.deepOrange, size: 28),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 25, 20, 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const Text('See all', style: TextStyle(color: Colors.grey, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildJobCard(String title, String pay, String time, String loc) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
              Container(padding: const EdgeInsets.all(5), color: Colors.red[50], child: const Text('Urgent', style: TextStyle(color: Colors.red, fontSize: 10, fontWeight: FontWeight.bold))),
            ],
          ),
          const SizedBox(height: 12),
          Text(pay, style: const TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.w800, fontSize: 18)),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.access_time, size: 14, color: Colors.grey[400]),
              const SizedBox(width: 5),
              Text(time, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
              const SizedBox(width: 15),
              Icon(Icons.location_on_outlined, size: 14, color: Colors.grey[400]),
              const SizedBox(width: 5),
              Text(loc, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
            ],
          ),
        ],
      ),
    );
  }
}

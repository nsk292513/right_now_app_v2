import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.orange),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        color: Colors.orange,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.bolt, size: 100, color: Colors.white),
            const Text('RIGHT NOW', style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold)),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black, minimumSize: const Size(double.infinity, 50)),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const MainPage())),
                child: const Text('START APP', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _idx = 0;
  bool _isOrder = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(_isOrder ? 'Order Mode' : 'Worker Mode', style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
        actions: [
          Switch(value: _isOrder, onChanged: (v) => setState(() => _isOrder = v), activeColor: Colors.orange),
        ],
      ),
      body: _idx == 3 ? _profile() : _home(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _idx,
        onTap: (i) => setState(() => _idx = i),
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _home() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.verified_user, size: 80, color: Colors.blue[200]),
          const SizedBox(height: 10),
          const Text('Verified User Only', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Text(_isOrder ? 'Ready to Order' : 'Ready to Work', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          const Text('Escrow System Active', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _profile() {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        children: [
          const CircleAvatar(radius: 50, backgroundColor: Colors.orange, child: Icon(Icons.person, color: Colors.white, size: 60)),
          const SizedBox(height: 20),
          const Text('VIP Member', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const Divider(height: 40),
          _box(_isOrder ? 'Deposit' : 'Settlement', _isOrder ? '50,000 KRW' : '12,500 KRW'),
        ],
      ),
    );
  }

  Widget _box(String t, String v) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.orange[50], borderRadius: BorderRadius.circular(15)),
      child: Column(children: [Text(t), const SizedBox(height: 10), Text(v, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.orange))]),
    );
  }
}

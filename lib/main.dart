import 'package:flutter/material.dart';

void main() => runApp(const DangJangApp());

class DangJangApp extends StatelessWidget {
  const DangJangApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.orange, fontFamily: 'Pretendard'),
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});
  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isLoggedIn = false;
  void _enter() => setState(() => _isLoggedIn = true);
  void _exit() => setState(() => _isLoggedIn = false);

  @override
  Widget build(BuildContext context) {
    return _isLoggedIn 
      ? MainNavigation(onLogout: _exit) 
      : LoginScreen(onLogin: _enter);
  }
}

class LoginScreen extends StatelessWidget {
  final VoidCallback onLogin;
  const LoginScreen({super.key, required this.onLogin});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(30),
        width: double.infinity,
        decoration: const BoxDecoration(gradient: LinearGradient(colors: [Colors.orange, Colors.deepOrange])),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.bolt, size: 80, color: Colors.white),
            const Text('\ub2f9\uc7a5', style: TextStyle(color: Colors.white, fontSize: 42, fontWeight: FontWeight.bold)),
            const SizedBox(height: 40),
            _input("ID"),
            const SizedBox(height: 10),
            _input("Password", obscure: true),
            const SizedBox(height: 20),
            _btn("\ub85c\uadf8\uc778", Colors.black, onLogin),
            TextButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const RegisterScreen())),
              child: const Text('\ud68c\uc6d0\uac00\uc785 \ud558\uae30', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _input(String h, {bool obscure = false}) {
    return TextField(obscureText: obscure, decoration: InputDecoration(filled: true, fillColor: Colors.white, hintText: h, border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))));
  }

  Widget _btn(String t, Color c, VoidCallback f) {
    return SizedBox(width: double.infinity, height: 55, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: c, shape: BorderRadius.circular(15)), onPressed: f, child: Text(t, style: const TextStyle(color: Colors.white, fontSize: 18))));
  }
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _v1 = false;
  bool _v2 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('\ud68c\uc6d0\uac00\uc785 \ubc0f \uc778\uc99d')),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('\ubcf4\uc548 \uc778\uc99d\uc744\n\uc9c4\ud589\ud574\uc9c0\uc138\uc694.', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            const TextField(decoration: InputDecoration(labelText: '\ub2nick\ub124\uc784 \uc124\uc815', border: OutlineInputBorder())),
            const SizedBox(height: 20),
            _authTile("\uc2e0\ubd84\uc99d \uc778\uc99d", _v1, () => setState(() => _v1 = true)),
            _authTile("\ud734\ub300\ud3ec \ubcf8\uc778 \uc778\uc99d", _v2, () => setState(() => _v2 = true)),
            const Spacer(),
            SizedBox(width: double.infinity, height: 55, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: (_v1 && _v2) ? Colors.orange : Colors.grey), onPressed: (_v1 && _v2) ? () => Navigator.pop(context) : null, child: const Text('\uac00\uc785 \uc644\ub8cc', style: TextStyle(color: Colors.white)))),
          ],
        ),
      ),
    );
  }

  Widget _authTile(String t, bool d, VoidCallback f) {
    return ListTile(leading: Icon(d ? Icons.check_circle : Icons.circle_outlined, color: d ? Colors.blue : Colors.grey), title: Text(t), trailing: OutlinedButton(onPressed: f, child: Text(d ? "\uc644\ub8cc" : "\uc778\uc99d")));
  }
}

class MainNavigation extends StatefulWidget {
  final VoidCallback onLogout;
  const MainNavigation({super.key, required this.onLogout});
  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _tab = 0;
  bool _isOrder = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(children: [const Text('\ub2f9\uc7a5', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)), const SizedBox(width: 8), _badge()]),
        actions: [
          Switch(value: _isOrder, onChanged: (v) => setState(() => _isOrder = v), activeColor: Colors.orange),
          IconButton(icon: const Icon(Icons.logout, color: Colors.grey), onPressed: widget.onLogout),
        ],
      ),
      body: IndexedStack(index: _tab, children: [_home(), _map(), _chat(), _profile()]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tab,
        onTap: (i) => setState(() => _tab = i),
        selectedItemColor: Colors.orange,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.bolt), label: '\ub2f9\uc7a5\uc2e0\uccad'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: '\uc8fc\ubcc0\uc9c0\ub3c4'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: '\ucc44\ud305'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '\ub0b4\uc815\ubcf4'),
        ],
      ),
    );
  }

  Widget _badge() => Container(padding: const EdgeInsets.all(4), decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(5)), child: const Text('\uc778\uc99d\ud68c\uc6d0', style: TextStyle(color: Colors.blue, fontSize: 10, fontWeight: FontWeight.bold)));

  Widget _home() {
    return SingleChildScrollView(
      child: Column(children: [
        _banner(),
        _itemCard(_isOrder ? "\uc74c\ub8cc\uc218 \uc0ac\ub2e4\uc8fc\uae30" : "\ud3b8\uc758\uc810 \ub300\ud589", _isOrder ? "3,000\uc6d0" : "4,000\uc6d0", _isOrder ? "\uc608\uce58\uae08\uc561 \ud655\uc778" : "200m \uc774\ub0b4"),
      ]),
    );
  }

  Widget _banner() => Container(width: double.infinity, margin: const EdgeInsets.all(15), padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(15)), child: const Text('\uc5d0\uc2a4\ud06c\ub85c\uc6b0 \uc548\uc2ec \uacb0\uc81c \uc2dc\uc2a4\ud15c', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)));

  Widget _itemCard(String t, String p, String s) => ListTile(title: Text(t), subtitle: Text(s), trailing: Text(p, style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)));

  Widget _map() => Column(children: [
    Container(height: 150, color: Colors.orange[50], child: const Center(child: Icon(Icons.location_on, color: Colors.orange, size: 40))),
    const ListTile(title: Text('\uc548\uc2ec\ubc88\ud638 \ud1b5\ud654 \uac00\ub2a5 \uc774\uc6c3'), trailing: Icon(Icons.call, color: Colors.green)),
  ]);

  Widget _chat() => Column(children: [
    const Expanded(child: Center(child: Text('\ucc44\ud305 \uc2dc\ubbac\ub808\uc774\uc158 \uc900\ube44 \uc644\ub8cc'))),
    Container(padding: const EdgeInsets.all(10), color: Colors.white, child: const Row(children: [Icon(Icons.add), Expanded(child: TextField()), Icon(Icons.call, color: Colors.green)])),
  ]);

  Widget _profile() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(children: [
        const CircleAvatar(radius: 40, backgroundColor: Colors.orange, child: Icon(Icons.person, color: Colors.white, size: 50)),
        const SizedBox(height: 10),
        const Text('\ub2d9\ub124\uc784: \ub2f9\uc7a5\ub9e4\ub2c8\uc544', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        _moneyBox(_isOrder ? "\ubbf8\ub9ac \uc608\uce58\ud55c \uae08\uc561" : "\uc815\uc0b0 \uac00\ub2a5\ud55c \uae08\uc561", _isOrder ? "50,000\uc6d0" : "12,500\uc6d0"),
        const ListTile(leading: Icon(Icons.verified, color: Colors.blue), title: Text('\uc2e0\ubd84\uc99d/\ud734\ub300\ud3ec \uc778\uc99d \uc644\ub8cc')),
      ]),
    );
  }

  Widget _moneyBox(String t, String v) => Container(width: double.infinity, padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.orange[50], borderRadius: BorderRadius.circular(15)), child: Column(children: [Text(t), Text(v, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.orange))]));
}

import 'package:flutter/material.dart';

void main() => runApp(const DangJangApp());

class DangJangApp extends StatelessWidget {
  const DangJangApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.orange),
      home: const AuthBridge(),
    );
  }
}

class AuthBridge extends StatefulWidget {
  const AuthBridge({super.key});
  @override
  State<AuthBridge> createState() => _AuthBridgeState();
}

class _AuthBridgeState extends State<AuthBridge> {
  bool _isLogged = false;
  void _login() => setState(() => _isLogged = true);
  void _logout() => setState(() => _isLogged = false);

  @override
  Widget build(BuildContext context) {
    return _isLogged 
        ? MainPlatform(onLogout: _logout) 
        : LoginScreen(onSuccess: _login);
  }
}

class LoginScreen extends StatelessWidget {
  final VoidCallback onSuccess;
  const LoginScreen({super.key, required this.onSuccess});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(30),
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Colors.orange, Colors.deepOrange])
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.bolt, size: 90, color: Colors.white),
            const Text('\ub2f9\uc7a5', style: TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.bold)),
            const SizedBox(height: 50),
            _field("ID"),
            const SizedBox(height: 10),
            _field("Password", obs: true),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity, height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black, shape: BorderRadius.circular(15)),
                onPressed: onSuccess,
                child: const Text('\ub85c\uadf8\uc778', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const JoinScreen())),
              child: const Text('\ud68c\uc6d0\uac00\uc785 \ubc0f \ubcf8\uc778\uc778\uc99d', style: TextStyle(color: Colors.white70)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(String h, {bool obs = false}) {
    return TextField(
      obscureText: obs,
      decoration: InputDecoration(filled: true, fillColor: Colors.white, hintText: h, border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
    );
  }
}

class JoinScreen extends StatefulWidget {
  const JoinScreen({super.key});
  @override
  State<JoinScreen> createState() => _JoinScreenState();
}

class _JoinScreenState extends State<JoinScreen> {
  bool v1 = false;
  bool v2 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('\ud1b5\ud569 \ubcf8\uc778 \uc778\uc99d')),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('\uc2e0\ub8b0 \uc778\uc99d \uc2dc\uc2a4\ud15c', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            const TextField(decoration: InputDecoration(labelText: '\ub2nick\ub124\uc784 \uc124\uc815', border: OutlineInputBorder())),
            const SizedBox(height: 20),
            _authRow("\uc2e0\ubd84\uc99d \uc778\uc99d", v1, () => setState(() => v1 = true)),
            _authRow("\ud734\ub300\ud3ec \ubcf8\uc778 \uc778\uc99d", v2, () => setState(() => v2 = true)),
            const Spacer(),
            SizedBox(
              width: double.infinity, height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: (v1 && v2) ? Colors.orange : Colors.grey),
                onPressed: (v1 && v2) ? () => Navigator.pop(context) : null,
                child: const Text('\uc778\uc99d \ubc0f \uac00\uc785 \uc644\ub8cc', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _authRow(String t, bool d, VoidCallback f) {
    return ListTile(
      leading: Icon(d ? Icons.check_circle : Icons.circle_outlined, color: d ? Colors.blue : Colors.grey),
      title: Text(t),
      trailing: ElevatedButton(onPressed: f, child: Text(d ? "\uc644\ub8cc" : "\uc778\uc99d")),
    );
  }
}

class MainPlatform extends StatefulWidget {
  final VoidCallback onLogout;
  const MainPlatform({super.key, required this.onLogout});
  @override
  State<MainPlatform> createState() => _MainPlatformState();
}

class _MainPlatformState extends State<MainPlatform> {
  int _tab = 0;
  bool _mode = true; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Row(children: [
          const Text('\ub2f9\uc7a5', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 26)),
          const SizedBox(width: 8),
          _verifiedBadge(),
        ]),
        actions: [
          Switch(value: _mode, onChanged: (v) => setState(() => _mode = v), activeColor: Colors.orange),
          IconButton(icon: const Icon(Icons.exit_to_app, color: Colors.grey), onPressed: widget.onLogout),
        ],
      ),
      body: _buildPage(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tab,
        onTap: (i) => setState(() => _tab = i),
        selectedItemColor: Colors.orange[900],
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.bolt), label: '\ub2f9\uc7a5\uc2e0\uccad'),
          BottomNavigationBarItem(icon: Icon(Icons.map_sharp), label: '\uc2e4\uc2dc\uac04\uc9c0\ub3c4'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble), label: '\ucc44\ud305'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '\ub0b4\uc815\ubcf4'),
        ],
      ),
    );
  }

  Widget _verifiedBadge() => Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(5)), child: const Row(children: [Icon(Icons.verified, size: 12, color: Colors.blue), SizedBox(width: 4), Text('\uc778\uc99d\ud68c\uc6d0', style: TextStyle(color: Colors.blue, fontSize: 10, fontWeight: FontWeight.bold))]));

  Widget _buildPage() {
    if (_tab == 1) return _map();
    if (_tab == 2) return _chat();
    if (_tab == 3) return _profile();
    return _home();
  }

  Widget _home() {
    return SingleChildScrollView(
      child: Column(children: [
        _banner(),
        _item(_mode ? "\uc74c\ub8cc\uc218 \uad6c\ub9e4 \ub300\ud589" : "\uc0dd\uc218 \ubc30\ub2ec", _mode ? "\uc608\uce58\uae08\uc561: 3,000\uc6d0" : "\uc218\uc775: 3,000\uc6d0", _mode ? "\ub9e4\ching \uc911" : "150m"),
        _item(_mode ? "\ud0dd\ubc30 \ub300\ud589 \uc218\ub839" : "\uc74c\uc2dd \ubc30\ub2ec", _mode ? "\uc608\uce58\uae08\uc561: 5,000\uc6d0" : "\uc218\uc775: 6,000\uc6d0", _mode ? "\uc218\ud589 \uc911" : "300m"),
      ]),
    );
  }

  Widget _banner() => Container(width: double.infinity, margin: const EdgeInsets.all(15), padding: const EdgeInsets.all(20), decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.orange, Colors.orangeAccent]), borderRadius: BorderRadius.circular(15)), child: const Text('\uc5d0\uc2a4\ud06c\ub85c\uc6b0 \uc548\uc2ec \uacb0\uc81c \uc2dc\uc2a4\ud15c \uac00\ub3d9 \uc911', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)));

  Widget _item(String t, String p, String s) => ListTile(title: Text(t), subtitle: Text(s), trailing: Text(p, style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)));

  Widget _map() => Column(children: [
    Container(height: 250, width: double.infinity, color: Colors.orange[50], child: const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.my_location, size: 50, color: Colors.orange), Text('\uc2e4\uc2dc\uac04 \uc704\uce58 \uae30\ubc18 \uc774\uc6c3 \ub9e4\uce6d \uc911...', style: TextStyle(color: Colors.grey, fontSize: 12))]))),
    const ListTile(title: Text('\uc8fc\ubcc0 \uc548\uc2ec\ubc88\ud638 \ud1b5\ud654 \uac00\ub2a5 \uc774\uc6c3'), trailing: Icon(Icons.call, color: Colors.green)),
  ]);

  Widget _chat() => Column(children: [
    Container(padding: const EdgeInsets.all(10), color: Colors.blue[50], child: const Text('\uc608\uce58\uae08\uc774 \uc548\uc804\ud558\uac8c \ubcf4\ud638 \uc911\uc785\ub2c8\ub2e4.', style: TextStyle(color: Colors.blue, fontSize: 12, fontWeight: FontWeight.bold))),
    const Expanded(child: Center(child: Text('\ucc44\ud305 \uc2dc\ubbac\ub808\uc774\uc158'))),
    Container(padding: const EdgeInsets.all(15), color: Colors.white, child: const Row(children: [Icon(Icons.add), Expanded(child: TextField()), Icon(Icons.call, color: Colors.green)])),
  ]);

  Widget _profile() {
    return Padding(
      padding: const EdgeInsets.all(25),
      child: Column(children: [
        const CircleAvatar(radius: 40, backgroundColor: Colors.orange, child: Icon(Icons.person, color: Colors.white, size: 50)),
        const SizedBox(height: 10),
        const Text('\ub2d9\ub124\uc784: \ub2f9\uc7a5\ub9e4\ub2c8\uc544', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 25),
        _money(_mode ? "\ub098\uc758 \uc608\uce58\uae08\uc561" : "\uc815\uc0b0 \uac00\ub2a5 \uc218\uc775", _mode ? "50,000\uc6d0" : "12,500\uc6d0"),
        const ListTile(leading: Icon(Icons.verified, color: Colors.blue), title: Text('\uc2e0\ubd84\uc99d \ubc0f \ubcf8\uc778\uc778\uc99d \uc644\ub8cc')),
      ]),
    );
  }

  Widget _money(String t, String v) => Container(width: double.infinity, padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.orange[50], borderRadius: BorderRadius.circular(15)), child: Column(children: [Text(t), Text(v, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.orange))]));
}

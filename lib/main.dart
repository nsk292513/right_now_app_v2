import 'package:flutter/material.dart';

void main() => runApp(const DangJangApp());

class DangJangApp extends StatelessWidget {
  const DangJangApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RightNow',
      theme: ThemeData(primarySwatch: Colors.orange),
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
  void _onEnter() => setState(() => _isLoggedIn = true);
  void _onExit() => setState(() => _isLoggedIn = false);

  @override
  Widget build(BuildContext context) {
    return _isLoggedIn 
        ? MainFrame(onLogout: _onExit) 
        : LoginFrame(onLogin: _onEnter);
  }
}

class LoginFrame extends StatelessWidget {
  final VoidCallback onLogin;
  const LoginFrame({super.key, required this.onLogin});

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
            const Icon(Icons.bolt, size: 80, color: Colors.white),
            const Text('DANG JANG', style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold)),
            const SizedBox(height: 50),
            _inputField("ID"),
            const SizedBox(height: 10),
            _inputField("Password", obs: true),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black, shape: BorderRadius.circular(15)),
                onPressed: onLogin,
                child: const Text('LOG IN', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const JoinFrame())),
              child: const Text('Sign Up & Identity Verification', style: TextStyle(color: Colors.white70)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputField(String h, {bool obs = false}) {
    return TextField(
      obscureText: obs,
      decoration: InputDecoration(
        filled: true, fillColor: Colors.white, hintText: h,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))
      ),
    );
  }
}

class JoinFrame extends StatefulWidget {
  const JoinFrame({super.key});
  @override
  State<JoinFrame> createState() => _JoinFrameState();
}

class _JoinFrameState extends State<JoinFrame> {
  bool v1 = false;
  bool v2 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Identity Verification'), elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Security Auth', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text('Identity & Phone Verification required.'),
            const SizedBox(height: 30),
            const TextField(decoration: InputDecoration(labelText: 'Nickname', border: OutlineInputBorder())),
            const SizedBox(height: 20),
            _vTile("ID Card Verification", v1, () => setState(() => v1 = true)),
            _vTile("Phone Number Auth", v2, () => setState(() => v2 = true)),
            const Spacer(),
            SizedBox(
              width: double.infinity, height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: (v1 && v2) ? Colors.orange : Colors.grey),
                onPressed: (v1 && v2) ? () => Navigator.pop(context) : null,
                child: const Text('COMPLETE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _vTile(String t, bool d, VoidCallback f) {
    return ListTile(
      leading: Icon(d ? Icons.check_circle : Icons.circle_outlined, color: d ? Colors.blue : Colors.grey),
      title: Text(t),
      trailing: ElevatedButton(onPressed: f, child: Text(d ? "DONE" : "AUTH")),
    );
  }
}

class MainFrame extends StatefulWidget {
  final VoidCallback onLogout;
  const MainFrame({super.key, required this.onLogout});
  @override
  State<MainFrame> createState() => _MainFrameState();
}

class _MainFrameState extends State<MainFrame> {
  int _tabIdx = 0;
  bool _isOrder = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(children: [
          const Text('DANG JANG', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          _authBadge(),
        ]),
        actions: [
          Switch(value: _isOrder, onChanged: (v) => setState(() => _isOrder = v), activeColor: Colors.orange),
          IconButton(icon: const Icon(Icons.logout, color: Colors.grey), onPressed: widget.onLogout),
        ],
      ),
      body: _buildPage(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tabIdx,
        onTap: (i) => setState(() => _tabIdx = i),
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.bolt), label: 'Apply'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _authBadge() => Container(padding: const EdgeInsets.all(4), decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(5)), child: const Text('VERIFIED', style: TextStyle(color: Colors.blue, fontSize: 10, fontWeight: FontWeight.bold)));

  Widget _buildPage() {
    if (_tabIdx == 1) return _mapPage();
    if (_tabIdx == 2) return _chatPage();
    if (_tabIdx == 3) return _profilePage();
    return _homePage();
  }

  Widget _homePage() {
    return SingleChildScrollView(
      child: Column(children: [
        _banner(),
        _item("Beverage Delivery", _isOrder ? "Deposit: 3,000" : "Earn: 3,000", _isOrder ? "Waiting" : "200m"),
        _item("Parcel Pickup", _isOrder ? "Deposit: 5,000" : "Earn: 5,000", _isOrder ? "Active" : "450m"),
      ]),
    );
  }

  Widget _banner() => Container(width: double.infinity, margin: const EdgeInsets.all(15), padding: const EdgeInsets.all(25), decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(15)), child: const Text('ESCROW PROTECTION ACTIVE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)));

  Widget _item(String t, String p, String s) => ListTile(title: Text(t), subtitle: Text(s), trailing: Text(p, style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)));

  Widget _mapPage() => Column(children: [
    Container(height: 180, width: double.infinity, color: Colors.orange[50], child: const Icon(Icons.location_on, size: 50, color: Colors.orange)),
    const ListTile(title: Text('Nearby Verified Users'), trailing: Icon(Icons.call, color: Colors.green)),
    const ListTile(title: Text('Anonymous Call Support'), subtitle: Text('Privacy Protected')),
  ]);

  Widget _chatPage() => Column(children: [
    Container(padding: const EdgeInsets.all(10), color: Colors.blue[50], child: const Text('Escrow: Money is safe until you confirm.')),
    const Expanded(child: Center(child: Text('Chat Simulator'))),
    Container(padding: const EdgeInsets.all(15), color: Colors.white, child: const Row(children: [Icon(Icons.add), Expanded(child: TextField()), Icon(Icons.call, color: Colors.green)])),
  ]);

  Widget _profilePage() {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(children: [
        const CircleAvatar(radius: 40, backgroundColor: Colors.orange, child: Icon(Icons.person, color: Colors.white, size: 50)),
        const SizedBox(height: 15),
        const Text('Nickname: DangJangMania', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 30),
        _moneyBox(_isOrder ? "My Deposit" : "Settlement Available", _isOrder ? "50,000" : "12,500"),
        const SizedBox(height: 20),
        const ListTile(leading: Icon(Icons.verified, color: Colors.blue), title: Text('ID & Phone Verified')),
      ]),
    );
  }

  Widget _moneyBox(String t, String v) => Container(width: double.infinity, padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.orange[50], borderRadius: BorderRadius.circular(15)), child: Column(children: [Text(t), Text('$v KRW', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.orange))]));
}

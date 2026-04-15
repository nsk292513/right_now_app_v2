import 'package:flutter/material.dart';

void main() => runApp(const RightNowApp());

class RightNowApp extends StatelessWidget {
  const RightNowApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        fontFamily: 'Pretendard',
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
      ),
      home: const AuthGateController(),
    );
  }
}

class AuthGateController extends StatefulWidget {
  const AuthGateController({super.key});
  @override
  State<AuthGateController> createState() => _AuthGateControllerState();
}

class _AuthGateControllerState extends State<AuthGateController> {
  bool _isLoggedIn = false;
  void _doLogin() => setState(() => _isLoggedIn = true);
  void _doLogout() => setState(() => _isLoggedIn = false);

  @override
  Widget build(BuildContext context) {
    return _isLoggedIn 
        ? MainAppNavigation(onLogout: _doLogout) 
        : WelcomeLoginScreen(onSuccess: _doLogin);
  }
}

class WelcomeLoginScreen extends StatelessWidget {
  final VoidCallback onSuccess;
  const WelcomeLoginScreen({super.key, required this.onSuccess});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.orange, Colors.deepOrange],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.bolt, size: 90, color: Colors.white),
            const Text('\ub2f9\uc7a5', style: TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.w900, letterSpacing: 2)),
            const Text('RIGHT NOW', style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 60),
            _buildInput("ID / Email"),
            const SizedBox(height: 12),
            _buildInput("Password", isObscure: true),
            const SizedBox(height: 30),
            _buildActionBtn("\ub85c\uadf8\uc778", Colors.black, onSuccess),
            const SizedBox(height: 15),
            TextButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const IdentityAuthScreen())),
              child: const Text('\ud68c\uc6d0\uac00\uc785 \ubc0f \ubcf8\uc778\uc778\uc99d', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInput(String hint, {bool isObscure = false}) {
    return Container(
      width: 320,
      decoration: BoxDecoration(boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: const Offset(0, 5))]),
      child: TextField(
        obscureText: isObscure,
        decoration: InputDecoration(
          filled: true, fillColor: Colors.white, hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        ),
      ),
    );
  }

  Widget _buildActionBtn(String text, Color color, VoidCallback f) {
    return SizedBox(
      width: 320, height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: color, shape: BorderRadius.circular(15), elevation: 5),
        onPressed: f,
        child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

class IdentityAuthScreen extends StatefulWidget {
  const IdentityAuthScreen({super.key});
  @override
  State<IdentityAuthScreen> createState() => _IdentityAuthScreenState();
}

class _IdentityAuthScreenState extends State<IdentityAuthScreen> {
  bool _idDone = false;
  bool _phoneDone = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('\ud1b5\ud569 \ubcf8\uc778 \uc778\uc99d'), centerTitle: true, elevation: 0, backgroundColor: Colors.white, foregroundColor: Colors.black),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('\uc2e0\ub8b0\ud560 \uc218 \uc788\ub294 \uac70\ub798\ub9bc \uc704\ud574\n\uc778\uc99d\uc744 \uc644\ub8cc\ud574\uc9c0\uc138\uc694.', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, height: 1.4)),
            const SizedBox(height: 40),
            const TextField(decoration: InputDecoration(labelText: '\ud65c\ub3d9 \ub2nick\ub124\uc784 \uc124\uc815', border: OutlineInputBorder(), hintText: '\uc2e4\uba85 \ub300\uc2e0 \ub178\ucd9c\ub420 \uc774\ub984\uc785\ub2c8\ub2e4.')),
            const SizedBox(height: 30),
            _buildAuthRow("\uc2e0\ubd84\uc99d \uc9c4\uc704 \ud655\uc778 \uc778\uc99d", _idDone, () => setState(() => _idDone = true)),
            const Divider(),
            _buildAuthRow("\ubcf8\uc778 \uba85\uc758 \ud734\ub300\ud3ec \uc778\uc99d", _phoneDone, () => setState(() => _phoneDone = true)),
            const Spacer(),
            SizedBox(
              width: double.infinity, height: 65,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: (_idDone && _phoneDone) ? Colors.orange : Colors.grey, shape: BorderRadius.circular(20)),
                onPressed: (_idDone && _phoneDone) ? () => Navigator.pop(context) : null,
                child: const Text('\uc778\uc99d \ubc0f \uac00\uc785 \uc644\ub8cc', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAuthRow(String title, bool isDone, VoidCallback onTab) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(isDone ? Icons.verified : Icons.circle_outlined, color: isDone ? Colors.blue : Colors.grey, size: 30),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      trailing: OutlinedButton(onPressed: onTab, child: Text(isDone ? "\uc644\ub8cc" : "\uc778\uc99d\ud558\uae30")),
    );
  }
}

class MainAppNavigation extends StatefulWidget {
  final VoidCallback onLogout;
  const MainAppNavigation({super.key, required this.onLogout});
  @override
  State<MainAppNavigation> createState() => _MainAppNavigationState();
}

class _MainAppNavigationState extends State<MainAppNavigation> {
  int _tabIndex = 0;
  bool _isOrderMode = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white, elevation: 1,
        title: Row(children: [
          const Text('\ub2f9\uc7a5', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.w900, fontSize: 26)),
          const SizedBox(width: 10),
          _buildBadge(),
        ]),
        actions: [
          const Center(child: Text('\ubaa8\ub4dc\uc804\ud658', style: TextStyle(color: Colors.grey, fontSize: 11))),
          Switch(value: _isOrderMode, onChanged: (v) => setState(() => _isOrderMode = v), activeColor: Colors.orange),
          IconButton(icon: const Icon(Icons.logout, color: Colors.grey), onPressed: widget.onLogout),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tabIndex,
        onTap: (i) => setState(() => _tabIndex = i),
        selectedItemColor: Colors.orange[900], unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.bolt_rounded), label: '\ub2f9\uc7a5\uc2e0\uccad'),
          BottomNavigationBarItem(icon: Icon(Icons.location_on_outlined), label: '\uc2e4\uc2dc\uac04\uc9c0\ub3c4'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: '\ucc44\ud305'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: '\ub0b4\uc815\ubcf4'),
        ],
      ),
      floatingActionButton: _isOrderMode ? FloatingActionButton.extended(
        onPressed: () {}, backgroundColor: Colors.orange,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('\uc2ec\ubd84\ub984 \uc694\uccad', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ) : null,
    );
  }

  Widget _buildBadge() => Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(5)), child: const Row(children: [Icon(Icons.verified, size: 12, color: Colors.blue), SizedBox(width: 4), Text('\uc778\uc99d\ud68c\uc6d0', style: TextStyle(color: Colors.blue, fontSize: 10, fontWeight: FontWeight.bold))]));

  Widget _buildBody() {
    switch (_tabIndex) {
      case 1: return _mapView();
      case 2: return _chatView();
      case 3: return _profileView();
      default: return _homeView();
    }
  }

  Widget _homeView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _buildBanner(),
        const SizedBox(height: 25),
        Text(_isOrderMode ? "\ub098\uc758 \uc2e4\uc2dc\uac04 \uc694\uccad \ud604\ud669" : "\uc218\ud589 \uac00\ub2a5\ud55c \uc8fc\ubcc0 \uc2ec\ubd84\ub984", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 15),
        _buildErrandCard(_isOrderMode ? "\ud3b8\uc758\uc810 \uc140\ub809\ud2b8 \uc74c\ub8cc 2\uce90" : "\uc0dd\uc218 \ubc30\ub2ec \ub300\ud589", _isOrderMode ? "\uc608\uce58\uae08\uc561: 3,500\uc6d0" : "\uc218\uc775: 4,000\uc6d0", _isOrderMode ? "\ub9e4\ucching \uc91d" : "250m \uac70\ub9ac"),
        _buildErrandCard(_isOrderMode ? "\uc6b0\uccb4\uad6d \ud0dd\ubc30 \ub300\uae08 \uc120\uacb0\uc81c" : "\uc4f0\ub808\uae30 \ubd84\ub9ac\uc218\uac70 \ub300\ud589", _isOrderMode ? "\uc608\uce58\uae08\uc561: 15,000\uc6d0" : "\uc218\uc775: 3,000\uc6d0", _isOrderMode ? "\uc218\ud589\uc790 \uc774\ub3d9 \uc91d" : "400m \uac70\ub9ac"),
      ]),
    );
  }

  Widget _buildBanner() {
    return Container(
      width: double.infinity, padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.orange, Colors.orangeAccent]), borderRadius: BorderRadius.circular(25), boxShadow: [BoxShadow(color: Colors.orange.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))]),
      child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('\uc5d0\uc2a4\ud06c\ub85c\uc6b0 \uc548\uc2ec \uacb0\uc81c \uc2dc\uc2a4\ud15c \uc801\uc6a9', style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Text('\uc2e0\ubd84\uc99d \uc778\uc99d \uc644\ub8cc\ub41c \uc774\uc6c3\uacfc\ub9cc\n\uc548\uc804\ud558\uac8c \uac70\ub798\ud558\uc138\uc694!', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, height: 1.4)),
      ]),
    );
  }

  Widget _buildErrandCard(String t, String p, String s) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15), padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)]),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(t, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
          const SizedBox(height: 5),
          Text(s, style: const TextStyle(color: Colors.grey, fontSize: 13)),
        ]),
        Text(p, style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.w900, fontSize: 17)),
      ]),
    );
  }

  Widget _mapView() {
    return Column(children: [
      Expanded(flex: 3, child: Container(width: double.infinity, color: Colors.orange[50], child: const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.my_location, size: 50, color: Colors.orange), SizedBox(height: 10), Text('\uc2e4\uc2dc\uac04 \uc704\uce58 \uae30\ubc18 \uc774\uc6c3 \ub9e4\ucching \uc91d...', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold))])))),
      Expanded(flex: 4, child: ListView(padding: const EdgeInsets.all(20), children: [
        const Text('\uc8fc\ubcc0 \uc548\uc2ec\ubc88\ud638 \ud1b5\ud654 \uac00\ub2a5 \uc774\uc6c3', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
        const SizedBox(height: 15),
        _neighborRow('\ud64d\uae38\ub3d9 (\uc778\uc99d\uc218\ud589\uc790)', '150m', '5.0'),
        _neighborRow('\uc774\uc774\uc6c3 (\uc778\uc99d\uc8fc\ubb38\uc790)', '320m', '4.9'),
      ])),
    ]);
  }

  Widget _neighborRow(String n, String d, String r) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const CircleAvatar(backgroundColor: Colors.grey, child: Icon(Icons.person, color: Colors.white)),
      title: Text(n, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text('\uac70\ub9ac: $d | \ubcc4\uc810: $r'),
      trailing: const Icon(Icons.call, color: Colors.green, size: 30),
    );
  }

  Widget _chatView() {
    return Column(children: [
      Container(width: double.infinity, padding: const EdgeInsets.all(12), color: Colors.blue[50], child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.lock, size: 14, color: Colors.blue), SizedBox(width: 8), Text('\uc5d0\uc2a4\ud06c\ub85c\uc6b0 \ubcf4\ud638: \uac70\ub798 \uc644\ub8cc \uc2dc\uc5d0\ub9cc \uc790\uae08\uc774 \uc9c0\uae08\ub429\ub2c8\ub2e4.', style: TextStyle(fontSize: 12, color: Colors.blue, fontWeight: FontWeight.bold))])),
      const Expanded(child: Center(child: Text('\ucc44\ud305 \uc2dc\ubbac\ub808\uc774\uc158 \ud654\uba74'))),
      Container(padding: const EdgeInsets.all(15), decoration: const BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Color(0xFFEEEEEE)))), child: Row(children: [const Icon(Icons.add_circle_outline, color: Colors.grey), const Expanded(child: Padding(padding: EdgeInsets.symmetric(horizontal: 10), child: TextField(decoration: InputDecoration(hintText: '\uba54\uc2dc\uc9c0\ub9bc \uc785\ub825\ud558\uc138\uc694...', border: InputBorder.none)))), const Icon(Icons.call, color: Colors.green), const SizedBox(width: 15), const Icon(Icons.send, color: Colors.orange)]))
    ]);
  }

  Widget _profileView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(25),
      child: Column(children: [
        const CircleAvatar(radius: 45, backgroundColor: Colors.orange, child: Icon(Icons.person, color: Colors.white, size: 55)),
        const SizedBox(height: 15),
        const Text('\ub2d9\ub124\uc784: \ub2f9\uc7a5\ub9e4\ub2c8\uc544', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 30),
        _moneyBox(_isOrderMode ? "\ub098\uc758 \ucd1d \uc608\uce58\uae08\uc561" : "\ub098\uc758 \uc815\uc0b0 \uac00\ub2a5 \uc218\uc775", _isOrderMode ? "50,000\uc6d0" : "12,500\uc6d0"),
        const SizedBox(height: 30),
        _profileInfoRow(Icons.verified, "\uc2e0\ubd84\uc99d \uc9c4\uc704 \ud655\uc778 \uc644\ub8cc"),
        _profileInfoRow(Icons.phone_android, "\ubcf8\uc778 \uba85\uc758 \ud734\ub300\ud3ec \uc778\uc99d \uc644\ub8cc"),
        _profileInfoRow(Icons.security, "\uac1c\uc778\uc815\ubcf4 \uc554\ud638\ud654 \ubcf4\ud638 \uc91d"),
      ]),
    );
  }

  Widget _moneyBox(String t, String v) {
    return Container(
      width: double.infinity, padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(color: Colors.orange[50], borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.orange[100]!)),
      child: Column(children: [Text(t, style: const TextStyle(fontSize: 14, color: Colors.orange)), const SizedBox(height: 10), Text(v, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.orange))]),
    );
  }

  Widget _profileInfoRow(IconData i, String t) {
    return ListTile(contentPadding: EdgeInsets.zero, leading: Icon(i, color: Colors.blue), title: Text(t, style: const TextStyle(fontWeight: FontWeight.w500)), trailing: const Icon(Icons.check_circle, color: Colors.blue, size: 20));
  }
}

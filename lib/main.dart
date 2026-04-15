import 'package:flutter/material.dart';

void main() => runApp(const DangJangApp());

class DangJangApp extends StatelessWidget {
  const DangJangApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.orange),
      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});
  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool _isLoggedIn = false;
  void _enter() => setState(() => _isLoggedIn = true);
  void _exit() => setState(() => _isLoggedIn = false);

  @override
  Widget build(BuildContext context) {
    return _isLoggedIn 
        ? MainNavigation(onLogout: _exit) 
        : LoginScreen(onLoginSuccess: _enter);
  }
}

class LoginScreen extends StatelessWidget {
  final VoidCallback onLoginSuccess;
  const LoginScreen({super.key, required this.onLoginSuccess});

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
            const Text('당장', style: TextStyle(color: Colors.white, fontSize: 42, fontWeight: FontWeight.bold)),
            const SizedBox(height: 50),
            _inputField("아이디(ID)"),
            const SizedBox(height: 10),
            _inputField("비밀번호(Password)", obscure: true),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black, shape: BorderRadius.circular(15)),
                onPressed: onLoginSuccess,
                child: const Text('로그인', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const JoinScreen())),
              child: const Text('회원가입 및 본인인증하기', style: TextStyle(color: Colors.white70)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputField(String hint, {bool obscure = false}) {
    return TextField(
      obscureText: obscure,
      decoration: InputDecoration(
        filled: true, fillColor: Colors.white, hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))
      ),
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
      appBar: AppBar(title: const Text('회원가입 및 인증'), elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('보안 인증 필수', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            const TextField(decoration: InputDecoration(labelText: '사용할 닉네임', border: OutlineInputBorder())),
            const SizedBox(height: 20),
            _authRow("신분증 인증하기", v1, () => setState(() => v1 = true)),
            _authRow("휴대폰 본인인증", v2, () => setState(() => v2 = true)),
            const Spacer(),
            SizedBox(
              width: double.infinity, height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: (v1 && v2) ? Colors.orange : Colors.grey),
                onPressed: (v1 && v2) ? () => Navigator.pop(context) : null,
                child: const Text('가입 완료', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _authRow(String title, bool done, VoidCallback func) {
    return ListTile(
      leading: Icon(done ? Icons.check_circle : Icons.circle_outlined, color: done ? Colors.blue : Colors.grey),
      title: Text(title),
      trailing: OutlinedButton(onPressed: func, child: Text(done ? "완료" : "인증하기")),
    );
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
        title: Row(children: [
          const Text('당장', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 24)),
          const SizedBox(width: 8),
          _verifiedBadge(),
        ]),
        actions: [
          Switch(value: _isOrder, onChanged: (v) => setState(() => _isOrder = v), activeColor: Colors.orange),
          IconButton(icon: const Icon(Icons.exit_to_app, color: Colors.grey), onPressed: widget.onLogout),
        ],
      ),
      body: _buildPage(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tab,
        onTap: (i) => setState(() => _tab = i),
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.bolt), label: '당장신청'),
          BottomNavigationBarItem(icon: Icon(Icons.map_outlined), label: '주변지도'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: '채팅'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: '내정보'),
        ],
      ),
    );
  }

  Widget _verifiedBadge() => Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(5)), child: const Row(children: [Icon(Icons.verified, size: 12, color: Colors.blue), SizedBox(width: 4), Text('인증회원', style: TextStyle(color: Colors.blue, fontSize: 10, fontWeight: FontWeight.bold))]));

  Widget _buildPage() {
    if (_tab == 1) return _mapView();
    if (_tab == 2) return _chatView();
    if (_tab == 3) return _profileView();
    return _homeView();
  }

  Widget _homeView() {
    return SingleChildScrollView(
      child: Column(children: [
        _banner(),
        _errandCard(_isOrder ? "편의점 음료수 2캔" : "생수 배달 대행", _isOrder ? "예치금: 3,000원" : "수익: 4,000원", _isOrder ? "매칭 중" : "거리 250m"),
        _errandCard(_isOrder ? "택배 대행" : "분리수거 대행", _isOrder ? "예치금: 5,000원" : "수익: 3,000원", _isOrder ? "진행 중" : "거리 150m"),
      ]),
    );
  }

  Widget _banner() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.orange, Colors.orangeAccent]), borderRadius: BorderRadius.circular(15)),
      child: const Text('에스크로우 안심 결제 시스템 가동 중', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
    );
  }

  Widget _errandCard(String t, String p, String s) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey[200]!)),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(t, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(s, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ]),
        Text(p, style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
      ]),
    );
  }

  Widget _mapView() {
    return Column(children: [
      Container(height: 200, width: double.infinity, color: Colors.orange[50], child: const Center(child: Icon(Icons.location_on, size: 50, color: Colors.orange))),
      Expanded(child: ListView(children: [
        _neighborRow('사용자A (인증수행자)', '200m'),
        _neighborRow('사용자B (인증주문자)', '450m'),
      ])),
    ]);
  }

  Widget _neighborRow(String n, String d) {
    return ListTile(leading: const Icon(Icons.account_circle, size: 40), title: Text(n), subtitle: Text('거리: $d'), trailing: const Icon(Icons.call, color: Colors.green));
  }

  Widget _chatView() {
    return Column(children: [
      Container(padding: const EdgeInsets.all(10), color: Colors.blue[50], child: const Text('예치금이 안전하게 보관 중입니다.', style: TextStyle(fontSize: 12, color: Colors.blue, fontWeight: FontWeight.bold))),
      const Expanded(child: Center(child: Text('채팅 화면'))),
      Container(padding: const EdgeInsets.all(15), color: Colors.white, child: const Row(children: [Icon(Icons.add), Expanded(child: TextField()), Icon(Icons.call, color: Colors.green)])),
    ]);
  }

  Widget _profileView() {
    return Padding(
      padding: const EdgeInsets.all(25),
      child: Column(children: [
        const CircleAvatar(radius: 40, backgroundColor: Colors.orange, child: Icon(Icons.person, color: Colors.white, size: 50)),
        const SizedBox(height: 10),
        const Text('닉네임: 당장매니아', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 25),
        _moneyBox(_isOrder ? "예치금액" : "정산수익", _isOrder ? "50,000원" : "12,500원"),
        const SizedBox(height: 20),
        _infoRow(Icons.verified, "신분증 인증 완료"),
        _infoRow(Icons.phone_android, "휴대폰 인증 완료"),
      ]),
    );
  }

  Widget _moneyBox(String t, String v) {
    return Container(width: double.infinity, padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.orange[50], borderRadius: BorderRadius.circular(15)), child: Column(children: [Text(t), Text(v, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.orange))]));
  }

  Widget _infoRow(IconData i, String t) => ListTile(leading: Icon(i, color: Colors.blue), title: Text(t), trailing: const Icon(Icons.check_circle, color: Colors.blue));
}

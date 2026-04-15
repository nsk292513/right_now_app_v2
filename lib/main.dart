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
  void _login() => setState(() => _isLoggedIn = true);
  void _logout() => setState(() => _isLoggedIn = false);

  @override
  Widget build(BuildContext context) {
    return _isLoggedIn 
      ? MainNav(onLogout: _logout) 
      : LoginScr(onLogin: _login);
  }
}

class LoginScr extends StatelessWidget {
  final VoidCallback onLogin;
  const LoginScr({super.key, required this.onLogin});

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
            const Text('\ub2f9\uc7a5', style: TextStyle(color: Colors.white, fontSize: 42, fontWeight: FontWeight.bold)), // '당장'
            const SizedBox(height: 40),
            _input("ID"),
            const SizedBox(height: 10),
            _input("Password", obscure: true),
            const SizedBox(height: 20),
            _btn("\ub85c\uadf8\uc778", Colors.black, onLogin), // '로그인'
            TextButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const JoinScr())),
              child: const Text('\ud68c\uc6d0\uac00\uc785 \ud558\uae30', style: TextStyle(color: Colors.white)), // '회원가입 하기'
            ),
          ],
        ),
      ),
    );
  }

  Widget _input(String h, {bool obscure = false}) {
    return TextField(
      obscureText: obscure,
      decoration: InputDecoration(filled: true, fillColor: Colors.white, hintText: h, border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
    );
  }

  Widget _btn(String t, Color c, VoidCallback f) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: c, shape: BorderRadius.circular(15)), onPressed: f, child: Text(t, style: const TextStyle(color: Colors.white, fontSize: 18))),
    );
  }
}

class JoinScr extends StatefulWidget {
  const JoinScr({super.key});
  @override
  State<JoinScr> createState() => _JoinScrState();
}

class _JoinScrState extends State<JoinScr> {
  bool _idV = false;
  bool _phV = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('\ud68c\uc6d0\uac00\uc785 \ubc0f \uc778\uc99d'), elevation: 0), // '회원가입 및 인증'
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('\ubcf4\uc548\uc744 \uc704\ud574\n\ubcf8\uc778 \uc778\uc99d\uc744 \uc9c4\ud589\ud574\uc9c0\uc138\uc694.', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)), // '보안을 위해 본인 인증을...'
            const SizedBox(height: 30),
            const TextField(decoration: InputDecoration(labelText: '\ub2nick\ub124\uc784', border: OutlineInputBorder())), // '닉네임'
            const SizedBox(height: 20),
            _auth("\uc2e0\ubd84\uc99d \uc778\uc99d", _idV, () => setState(() => _idV = true)), // '신분증 인증'
            _auth("\ud734\ub300\ud3ec \ubcf8\uc778 \uc778\uc99d", _phV, () => setState(() => _phV = true)), // '휴대폰 본인 인증'
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: (_idV && _phV) ? Colors.orange : Colors.grey),
                onPressed: (_idV && _phV) ? () => Navigator.pop(context) : null,
                child: const Text('\uac00\uc785 \uc644\ub8cc', style: TextStyle(color: Colors.white)), // '가입 완료'
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _auth(String t, bool d, VoidCallback f) {
    return ListTile(
      leading: Icon(d ? Icons.check_circle : Icons.circle_outlined, color: d ? Colors.blue : Colors.grey),
      title: Text(t),
      trailing: OutlinedButton(onPressed: f, child: Text(d ? "\uc644\ub8cc" : "\uc778\uc99d")), // '완료', '인증'
    );
  }
}

class MainNav extends StatefulWidget {
  final VoidCallback onLogout;
  const MainNav({super.key, required this.onLogout});
  @override
  State<MainNav> createState() => _MainNavState();
}

class _MainNavState extends State<MainNav> {
  int _idx = 0;
  bool _isOrd = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(children: [const Text('\ub2f9\uc7a5', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)), const SizedBox(width: 8), _badge()]), // '당장'
        actions: [
          Switch(value: _isOrd, onChanged: (v) => setState(() => _isOrd = v), activeColor: Colors.orange),
          IconButton(icon: const Icon(Icons.logout, color: Colors.grey), onPressed: widget.onLogout),
        ],
      ),
      body: _idx == 3 ? _profile() : Center(child: Text(_isOrd ? "\uc8fc\ubb38\uc790 \ubaa8\ub4dc" : "\uc218\ud589\uc790 \ubaa8\ub4dc", style: const TextStyle(fontSize: 20))), // '주문자 모드', '수행자 모드'
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _idx,
        onTap: (i) => setState(() => _idx = i),
        selectedItemColor: Colors.orange[900],
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.bolt), label: '\ub2f9\uc7a5\uc2e0\uccad'), // '당장신청'
          BottomNavigationBarItem(icon: Icon(Icons.map), label: '\uc8fc\ubcc0\uc9c0\ub3c4'), // '주변지도'
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: '\ucc44\ud305'), // '채팅'
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '\ub0b4\uc815\ubcf4'), // '내정보'
        ],
      ),
    );
  }

  Widget _badge() => Container(padding: const EdgeInsets.all(4), decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(5)), child: const Text('\uc778\uc99d\ud68c\uc6d0', style: TextStyle(color: Colors.blue, fontSize: 10, fontWeight: FontWeight.bold))); // '인증회원'

  Widget _profile() {
    return Padding(
      padding: const EdgeInsets.all(25),
      child: Column(
        children: [
          const CircleAvatar(radius: 40, backgroundColor: Colors.orange, child: Icon(Icons.person, color: Colors.white, size: 45)),
          const SizedBox(height: 15),
          const Text('\ub2f9\uc7a5\ub9e4\ub2c8\uc544 \ub2d8', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), // '당장매니아 님'
          const SizedBox(height: 30),
          _box(_isOrd ? "\ubbf8\ub9ac \uc608\uce58\ud55c \uae08\uc561" : "\uc815\uc0b0 \uac00\ub2a5\ud55c \uae08\uc561", _isOrd ? "50,000\uc6d0" : "12,500\uc6d0"), // '미리 예치한 금액', '정산 가능한 금액'
          const SizedBox(height: 20),
          const ListTile(leading: Icon(Icons.verified, color: Colors.blue), title: Text('\uc2e0\ubd84\uc99d \ubc0f \ubcf8\uc778\uc778\uc99d \uc644\ub8cc')), // '신분증 및 본인인증 완료'
        ],
      ),
    );
  }

  Widget _box(String t, String v) {
    return Container(width: double.infinity, padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.orange[50], borderRadius: BorderRadius.circular(15)), child: Column(children: [Text(t), const SizedBox(height: 10), Text(v, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.orange))]));
  }
}

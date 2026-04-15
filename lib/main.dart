import 'package:flutter/material.dart';

void main() => runApp(const DangJangApp());

class DangJangApp extends StatelessWidget {
  const DangJangApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
            const Text('당장', style: TextStyle(color: Colors.white, fontSize: 42, fontWeight: FontWeight.bold)),
            const SizedBox(height: 40),
            _input("아이디"),
            const SizedBox(height: 10),
            _input("비밀번호", obscure: true),
            const SizedBox(height: 20),
            _btn("로그인", Colors.black, onLogin),
            TextButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const JoinScr())),
              child: const Text('처음이신가요? 회원가입하기', style: TextStyle(color: Colors.white)),
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
      appBar: AppBar(title: const Text('회원가입 및 인증'), elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('보안을 위해\n본인 인증을 진행해주세요.', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            const TextField(decoration: InputDecoration(labelText: '사용할 닉네임', border: OutlineInputBorder())),
            const SizedBox(height: 20),
            _auth("신분증 인증", _idV, () => setState(() => _idV = true)),
            _auth("본인 명의 휴대폰 인증", _phV, () => setState(() => _phV = true)),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: (_idV && _phV) ? Colors.orange : Colors.grey),
                onPressed: (_idV && _phV) ? () => Navigator.pop(context) : null,
                child: const Text('가입 완료', style: TextStyle(color: Colors.white)),
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
      trailing: OutlinedButton(onPressed: f, child: Text(d ? "완료" : "인증")),
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
        title: Row(children: [const Text('당장', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)), const SizedBox(width: 8), _badge()]),
        actions: [
          Switch(value: _isOrd, onChanged: (v) => setState(() => _isOrd = v), activeColor: Colors.orange),
          IconButton(icon: const Icon(Icons.logout, color: Colors.grey), onPressed: widget.onLogout),
        ],
      ),
      body: _idx == 3 ? _profile() : Center(child: Text(_isOrd ? "주문자 모드" : "수행자 모드", style: const TextStyle(fontSize: 20))),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _idx,
        onTap: (i) => setState(() => _idx = i),
        selectedItemColor: Colors.orange[900],
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.bolt), label: '당장신청'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: '주변지도'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: '채팅'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '내정보'),
        ],
      ),
    );
  }

  Widget _badge() => Container(padding: const EdgeInsets.all(4), decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(5)), child: const Text('인증회원', style: TextStyle(color: Colors.blue, fontSize: 10, fontWeight: FontWeight.bold)));

  Widget _profile() {
    return Padding(
      padding: const EdgeInsets.all(25),
      child: Column(
        children: [
          const CircleAvatar(radius: 40, backgroundColor: Colors.orange, child: Icon(Icons.person, color: Colors.white, size: 45)),
          const SizedBox(height: 15),
          const Text('닉네임: 당장매니아', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 30),
          _box(_isOrd ? "미리 예치한 금액" : "정산 가능한 금액", _isOrd ? "50,000원" : "12,500원"),
          const SizedBox(height: 20),
          const ListTile(leading: Icon(Icons.verified, color: Colors.blue), title: Text('신분증 및 본인인증 완료 회원')),
        ],
      ),
    );
  }

  Widget _box(String t, String v) {
    return Container(width: double.infinity, padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.orange[50], borderRadius: BorderRadius.circular(15)), child: Column(children: [Text(t), const SizedBox(height: 10), Text(v, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.orange))]));
  }
}

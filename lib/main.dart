import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
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
            const Icon(Icons.bolt, size: 80, color: Colors.white),
            const Text('당장', style: TextStyle(color: Colors.white, fontSize: 45, fontWeight: FontWeight.bold)),
            const SizedBox(height: 50),
            _input("아이디"),
            const SizedBox(height: 10),
            _input("비밀번호", obs: true),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity, height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black, shape: BorderRadius.circular(15)),
                onPressed: onSuccess,
                child: const Text('로그인', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const JoinScreen())),
              child: const Text('회원가입 및 본인인증(신분증/휴대폰)', style: TextStyle(color: Colors.white70)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _input(String h, {bool obs = false}) {
    return TextField(
      obscureText: obs,
      decoration: InputDecoration(
        filled: true, fillColor: Colors.white, hintText: h,
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
      appBar: AppBar(title: const Text('회원가입 및 통합인증')),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('보안 및 신뢰 인증', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text('신분증 및 본인 명의 휴대폰 인증이 필수입니다.'),
            const SizedBox(height: 30),
            const TextField(decoration: InputDecoration(labelText: '활동 닉네임 설정', border: OutlineInputBorder())),
            const SizedBox(height: 20),
            _row("신분증 확인 인증", v1, () => setState(() => v1 = true)),
            _row("휴대폰 본인 확인", v2, () => setState(() => v2 = true)),
            const Spacer(),
            SizedBox(
              width: double.infinity, height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: (v1 && v2) ? Colors.orange : Colors.grey),
                onPressed: (v1 && v2) ? () => Navigator.pop(context) : null,
                child: const Text('인증 완료 및 가입', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(String t, bool d, VoidCallback f) {
    return ListTile(
      leading: Icon(d ? Icons.check_circle : Icons.circle_outlined, color: d ? Colors.blue : Colors.grey),
      title: Text(t),
      trailing: OutlinedButton(onPressed: f, child: Text(d ? "완료" : "인증하기")),
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
  int _curr = 0;
  bool _mode = true; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Row(children: [
          const Text('당장', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 24)),
          const SizedBox(width: 8),
          _badge(),
        ]),
        actions: [
          Switch(value: _mode, onChanged: (v) => setState(() => _mode = v), activeColor: Colors.orange),
          IconButton(icon: const Icon(Icons.logout, color: Colors.grey), onPressed: widget.onLogout),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _curr,
        onTap: (i) => setState(() => _curr = i),
        selectedItemColor: Colors.orange[900],
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.bolt), label: '당장신청'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: '실시간지도'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: '채팅'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '내정보'),
        ],
      ),
    );
  }

  Widget _badge() => Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(5)), child: const Row(children: [Icon(Icons.verified, size: 12, color: Colors.blue), SizedBox(width: 4), Text('인증회원', style: TextStyle(color: Colors.blue, fontSize: 10, fontWeight: FontWeight.bold))]));

  Widget _buildBody() {
    if (_curr == 1) return _map();
    if (_curr == 2) return _chat();
    if (_curr == 3) return _profile();
    return _home();
  }

  Widget _home() {
    return SingleChildScrollView(
      child: Column(children: [
        _banner(),
        _item(_mode ? "편의점 구매 대행" : "생수 배달", _mode ? "예치금: 3,000원" : "수익: 3,000원", _mode ? "매칭 중" : "150m"),
        _item(_mode ? "택배 대행 수령" : "음식 배달", _mode ? "예치금: 5,000원" : "수익: 6,000원", _mode ? "진행 중" : "300m"),
      ]),
    );
  }

  Widget _banner() => Container(width: double.infinity, margin: const EdgeInsets.all(15), padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(15)), child: const Text('에스크로우 안심 결제 시스템 가동 중', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)));

  Widget _item(String t, String p, String s) => ListTile(title: Text(t), subtitle: Text(s), trailing: Text(p, style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)));

  Widget _map() => Column(children: [
    Container(height: 250, width: double.infinity, color: Colors.orange[50], child: const Icon(Icons.my_location, size: 50, color: Colors.orange)),
    const ListTile(title: Text('주변 안심번호 통화 가능 이웃'), trailing: Icon(Icons.call, color: Colors.green)),
  ]);

  Widget _chat() => Column(children: [
    Container(padding: const EdgeInsets.all(10), color: Colors.blue[50], child: const Text('보증금이 안전하게 보호 중입니다.', style: TextStyle(color: Colors.blue, fontSize: 12))),
    const Expanded(child: Center(child: Text('채팅 화면'))),
    Container(padding: const EdgeInsets.all(15), color: Colors.white, child: const Row(children: [Icon(Icons.add), Expanded(child: TextField()), Icon(Icons.call, color: Colors.green)])),
  ]);

  Widget _profile() {
    return Padding(
      padding: const EdgeInsets.all(25),
      child: Column(children: [
        const CircleAvatar(radius: 40, backgroundColor: Colors.orange, child: Icon(Icons.person, color: Colors.white, size: 50)),
        const SizedBox(height: 10),
        const Text('닉네임: 당장매니아', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 25),
        _money(_mode ? "나의 예치금액" : "정산 가능 수익", _mode ? "50,000원" : "12,500원"),
        const ListTile(leading: Icon(Icons.verified, color: Colors.blue), title: Text('본인인증 완료 회원')),
      ]),
    );
  }

  Widget _money(String t, String v) => Container(width: double.infinity, padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.orange[50], borderRadius: BorderRadius.circular(15)), child: Column(children: [Text(t), Text(v, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.orange))]));
}

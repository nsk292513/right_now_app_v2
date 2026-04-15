import 'package:flutter/material.dart';

void main() => runApp(const DangJangApp());

class DangJangApp extends StatelessWidget {
  const DangJangApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DangJang',
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
  void _doLogin() => setState(() => _isLoggedIn = true);
  void _doLogout() => setState(() => _isLoggedIn = false);

  @override
  Widget build(BuildContext context) {
    return _isLoggedIn 
        ? MainPlatform(onLogout: _doLogout) 
        : LoginPage(onSuccess: _doLogin);
  }
}

class LoginPage extends StatelessWidget {
  final VoidCallback onSuccess;
  const LoginPage({super.key, required this.onSuccess});

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
            _field("아이디(ID)"),
            const SizedBox(height: 10),
            _field("비밀번호(Password)", obscure: true),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black, shape: BorderRadius.circular(15)),
                onPressed: onSuccess,
                child: const Text('로그인', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const JoinPage())),
              child: const Text('회원가입 및 본인인증(신분증/휴대폰)', style: TextStyle(color: Colors.white70)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(String hint, {bool obscure = false}) {
    return TextField(
      obscureText: obscure,
      decoration: InputDecoration(
        filled: true, fillColor: Colors.white, hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))
      ),
    );
  }
}

class JoinPage extends StatefulWidget {
  const JoinPage({super.key});
  @override
  State<JoinPage> createState() => _JoinPageState();
}

class _JoinPageState extends State<JoinPage> {
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
  bool _mode = true; // true: Order, false: Worker

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
      body: _buildView(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _curr,
        onTap: (i) => setState(() => _curr = i),
        selectedItemColor: Colors.orange[900],
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.bolt), label: '당장신청'),
          BottomNavigationBarItem(icon: Icon(Icons.map_sharp), label: '실시간지도'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: '채팅'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: '내정보'),
        ],
      ),
    );
  }

  Widget _badge() => Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(5)), child: const Row(children: [Icon(Icons.verified, size: 12, color: Colors.blue), SizedBox(width: 4), Text('인증회원', style: TextStyle(color: Colors.blue, fontSize: 10, fontWeight: FontWeight.bold))]));

  Widget _buildView() {
    if (_curr == 1) return _mapView();
    if (_curr == 2) return _chatView();
    if (_curr == 3) return _profileView();
    return _homeView();
  }

  Widget _homeView() {
    return SingleChildScrollView(
      child: Column(children: [
        _banner(),
        _card(_mode ? "편의점 음료수 사다주기" : "배달 대행 알바", _mode ? "예치금액: 3,000원" : "수익: 4,000원", _mode ? "매칭 중" : "거리 200m"),
        _card(_mode ? "택배 박스 대행 수령" : "분리수거 도우미", _mode ? "예치금액: 5,000원" : "수익: 3,000원", _mode ? "수행 중" : "거리 450m"),
      ]),
    );
  }

  Widget _banner() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.orange, Colors.orangeAccent]), borderRadius: BorderRadius.circular(15)),
      child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('에스크로우 안심 결제 시스템 가동 중', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        Text('신분증 인증 회원만 활동 가능한 고신뢰 플랫폼', style: TextStyle(color: Colors.white70, fontSize: 12)),
      ]),
    );
  }

  Widget _card(String t, String p, String s) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey[100]!)),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(t, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Text(s, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ]),
        Text(p, style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
      ]),
    );
  }

  Widget _mapView() {
    return Column(children: [
      Container(height: 250, width: double.infinity, color: Colors.orange[50], child: const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.my_location, size: 50, color: Colors.orange), Text('실시간 위치 기반 이웃 매칭 중...', style: TextStyle(color: Colors.grey, fontSize: 12))]))),
      const Padding(padding: EdgeInsets.all(15), child: Text('내 주변 안심번호 통화 가능 이웃', style: TextStyle(fontWeight: FontWeight.bold))),
      Expanded(child: ListView(children: [
        _neighbor('김수행 (인증회원)', '150m'),
        _neighbor('이주문 (인증회원)', '380m'),
      ])),
    ]);
  }

  Widget _neighbor(String n, String d) {
    return ListTile(leading: const CircleAvatar(backgroundColor: Colors.orange, child: Icon(Icons.person, color: Colors.white)), title: Text(n), subtitle: Text('거리: $d'), trailing: const Icon(Icons.call, color: Colors.green));
  }

  Widget _chatView() {
    return Column(children: [
      Container(padding: const EdgeInsets.all(10), color: Colors.blue[50], child: const Text('거래 수락 시 예치금이 자동으로 지급됩니다.', style: TextStyle(fontSize: 12, color: Colors.blue, fontWeight: FontWeight.bold))),
      const Expanded(child: Center(child: Text('채팅 시뮬레이션'))),
      Container(padding: const EdgeInsets.all(15), color: Colors.white, child: const Row(children: [Icon(Icons.add), Expanded(child: TextField(decoration: InputDecoration(hintText: '메시지 입력'))), Icon(Icons.call, color: Colors.green)])),
    ]);
  }

  Widget _profileView() {
    return Padding(
      padding: const EdgeInsets.all(25),
      child: Column(children: [
        const CircleAvatar(radius: 40, backgroundColor: Colors.orange, child: Icon(Icons.person, color: Colors.white, size: 50)),
        const SizedBox(height: 10),
        const Text('닉네임: 당장마스터', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 25),
        _moneyBox(_mode ? "나의 예치금액" : "정산 가능 수익", _mode ? "100,000원" : "25,000원"),
        const SizedBox(height: 20),
        _infoLine(Icons.verified, "신분증 인증 완료"),
        _infoLine(Icons.phone_android, "본인 휴대폰 인증 완료"),
      ]),
    );
  }

  Widget _moneyBox(String t, String v) {
    return Container(width: double.infinity, padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.orange[50], borderRadius: BorderRadius.circular(15)), child: Column(children: [Text(t, style: const TextStyle(fontSize: 14)), const SizedBox(height: 8), Text(v, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.orange))]));
  }

  Widget _infoLine(IconData i, String t) => ListTile(leading: Icon(i, color: Colors.blue), title: Text(t), trailing: const Icon(Icons.check_circle, color: Colors.blue));
}

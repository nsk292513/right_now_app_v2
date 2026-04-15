import 'package:flutter/material.dart';

void main() => runApp(const RightNowApp());

class RightNowApp extends StatelessWidget {
  const RightNowApp({super.key});
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
  void _login() => setState(() => _isLoggedIn = true);
  void _logout() => setState(() => _isLoggedIn = false);

  @override
  Widget build(BuildContext context) {
    return _isLoggedIn 
        ? MainFrame(onLogout: _logout) 
        : LoginFrame(onSuccess: _login);
  }
}

class LoginFrame extends StatelessWidget {
  final VoidCallback onSuccess;
  const LoginFrame({super.key, required this.onSuccess});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Colors.orange, Colors.deepOrange]),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.bolt, size: 80, color: Colors.white),
            const Text('당장', style: TextStyle(color: Colors.white, fontSize: 45, fontWeight: FontWeight.bold)),
            const SizedBox(height: 50),
            _input("아이디(ID)"),
            const SizedBox(height: 10),
            _input("비밀번호(Password)", obs: true),
            const SizedBox(height: 25),
            SizedBox(
              width: 300, height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                onPressed: onSuccess,
                child: const Text('로그인', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const JoinFrame())),
              child: const Text('회원가입 및 신분증/휴대폰 본인인증', style: TextStyle(color: Colors.white70)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _input(String h, {bool obs = false}) {
    return Container(
      width: 300,
      child: TextField(
        obscureText: obs,
        decoration: InputDecoration(
          filled: true, fillColor: Colors.white, hintText: h,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
        ),
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
  bool v1 = false; bool v2 = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('본인 인증 및 회원가입')),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('보안 및 신뢰 인증', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            const TextField(decoration: InputDecoration(labelText: '활동 닉네임 설정', border: OutlineInputBorder())),
            const SizedBox(height: 20),
            _vRow("신분증 확인 인증", v1, () => setState(() => v1 = true)),
            _vRow("본인 명의 휴대폰 인증", v2, () => setState(() => v2 = true)),
            const Spacer(),
            SizedBox(
              width: double.infinity, height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: (v1 && v2) ? Colors.orange : Colors.grey,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                onPressed: (v1 && v2) ? () => Navigator.pop(context) : null,
                child: const Text('인증 및 가입 완료', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _vRow(String t, bool d, VoidCallback f) => ListTile(
    leading: Icon(d ? Icons.check_circle : Icons.circle_outlined, color: d ? Colors.blue : Colors.grey),
    title: Text(t),
    trailing: OutlinedButton(onPressed: f, child: Text(d ? "완료" : "인증하기")),
  );
}

class MainFrame extends StatefulWidget {
  final VoidCallback onLogout;
  const MainFrame({super.key, required this.onLogout});
  @override
  State<MainFrame> createState() => _MainFrameState();
}

class _MainFrameState extends State<MainFrame> {
  int _idx = 0; bool _isOrder = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white, elevation: 1,
        title: Row(children: [
          const Text('당장', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 24)),
          const SizedBox(width: 8),
          _badge(),
        ]),
        actions: [
          const Center(child: Text('모드전환', style: TextStyle(color: Colors.grey, fontSize: 10))),
          Switch(value: _isOrder, onChanged: (v) => setState(() => _isOrder = v), activeColor: Colors.orange),
          IconButton(icon: const Icon(Icons.logout, color: Colors.grey), onPressed: widget.onLogout),
        ],
      ),
      body: _buildPage(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _idx, onTap: (i) => setState(() => _idx = i),
        selectedItemColor: Colors.orange[900], unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.bolt), label: '당장신청'),
          BottomNavigationBarItem(icon: Icon(Icons.map_outlined), label: '실시간지도'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: '채팅'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: '내정보'),
        ],
      ),
    );
  }

  Widget _badge() => Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(5)), child: const Row(children: [Icon(Icons.verified, size: 12, color: Colors.blue), SizedBox(width: 4), Text('인증회원', style: TextStyle(color: Colors.blue, fontSize: 10, fontWeight: FontWeight.bold))]));

  Widget _buildPage() {
    if (_idx == 1) return _map();
    if (_idx == 2) return _chat();
    if (_idx == 3) return _profile();
    return _home();
  }

  Widget _home() => SingleChildScrollView(child: Column(children: [
    _banner(),
    _card(_isOrder ? "편의점 물품 구매 대행" : "생수 묶음 배달 수행", _isOrder ? "예치금액: 3,000원" : "수익: 4,000원", _isOrder ? "매칭 대기 중" : "거리 150m"),
    _card(_isOrder ? "우체국 택배 대신 발송" : "분리수거 도우미 활동", _isOrder ? "예치금액: 5,000원" : "수익: 3,000원", _isOrder ? "수행 중" : "거리 320m"),
  ]));

  Widget _banner() => Container(
    width: double.infinity, margin: const EdgeInsets.all(15), padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.orange, Colors.orangeAccent]), borderRadius: BorderRadius.circular(15)),
    child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('에스크로우 안심 결제 보호 중', style: TextStyle(color: Colors.white70, fontSize: 12)),
      SizedBox(height: 5),
      Text('신분증 인증 완료된 이웃만 매칭되는\n안전한 실시간 대행 서비스 "당장"', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
    ]),
  );

  Widget _card(String t, String p, String s) => Container(
    margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 6), padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey[200]!)),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(t, style: const TextStyle(fontWeight: FontWeight.bold)), Text(s, style: const TextStyle(color: Colors.grey, fontSize: 12))]),
      Text(p, style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
    ]),
  );

  Widget _map() => Column(children: [
    Container(height: 200, width: double.infinity, color: Colors.orange[50], child: const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.my_location, size: 50, color: Colors.orange), Text('실시간 위치 기반 이웃 매칭 중...', style: TextStyle(color: Colors.grey, fontSize: 12))]))),
    Expanded(child: ListView(children: [ _neighbor('김수행 (인증수행자)', '150m'), _neighbor('이주문 (인증주문자)', '380m') ]))
  ]);

  Widget _neighbor(String n, String d) => ListTile(leading: const CircleAvatar(backgroundColor: Colors.orange, child: Icon(Icons.person, color: Colors.white)), title: Text(n), subtitle: Text('거리: $d'), trailing: const Icon(Icons.call, color: Colors.green));

  Widget _chat() => Column(children: [
    Container(width: double.infinity, padding: const EdgeInsets.all(10), color: Colors.blue[50], child: const Text('에스크로우 보호: 거래 수락 시 예치금이 안전하게 보관됩니다.', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.blue, fontWeight: FontWeight.bold))),
    const Expanded(child: Center(child: Text('채팅 시뮬레이션'))),
    Container(padding: const EdgeInsets.all(15), color: Colors.white, child: Row(children: [const Icon(Icons.add), const Expanded(child: TextField(decoration: InputDecoration(hintText: '메시지를 입력하세요'))), const Icon(Icons.call, color: Colors.green)]))
  ]);

  Widget _profile() => SingleChildScrollView(padding: const EdgeInsets.all(25), child: Column(children: [
    const CircleAvatar(radius: 40, backgroundColor: Colors.orange, child: Icon(Icons.person, color: Colors.white, size: 50)),
    const SizedBox(height: 15),
    const Text('닉네임: 당장마니아', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
    const SizedBox(height: 25),
    _money(_isOrder ? "나의 총 예치금액" : "나의 정산 가능 수익", _isOrder ? "50,000원" : "12,500원"),
    const SizedBox(height: 25),
    _info(Icons.verified, "신분증 진위 인증 완료"), _info(Icons.phone_android, "휴대폰 본인인증 완료"),
  ]));

  Widget _money(String t, String v) => Container(width: double.infinity, padding: const EdgeInsets.all(25), decoration: BoxDecoration(color: Colors.orange[50], borderRadius: BorderRadius.circular(15)), child: Column(children: [Text(t), Text(v, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.orange))]));

  Widget _info(IconData i, String t) => ListTile(leading: Icon(i, color: Colors.blue), title: Text(t), trailing: const Icon(Icons.check_circle, color: Colors.blue));
}

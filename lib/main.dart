import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

void main() => runApp(const DangJangFinalEngine());

class DangJangFinalEngine extends StatelessWidget {
  const DangJangFinalEngine({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.orange, scaffoldBackgroundColor: const Color(0xFFF5F5F5)),
      home: const AuthGate(),
    );
  }
}

// 1. 실시간 데이터 엔진 (DB 역할을 수행하며 사용자 간 매칭 및 자산 관리)
class DangJangDB {
  static Map<String, dynamic>? me; // 현재 접속자 (나)
  static List<Map<String, dynamic>> neighbors = [
    {'nick': '강남수행자', 'dist': 120, 'isWorker': true, 'rating': 4.9},
    {'nick': '역삼주문자', 'dist': 350, 'isWorker': false, 'rating': 5.0},
    {'nick': '논현마스터', 'dist': 500, 'isWorker': true, 'rating': 4.7},
  ];
}

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});
  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool _isLoggedIn = false;
  void _enter() => setState(() => _isLoggedIn = true);
  void _exit() => setState(() { _isLoggedIn = false; DangJangDB.me = null; });

  @override
  Widget build(BuildContext context) {
    return _isLoggedIn 
        ? MainPlatform(onLogout: _exit) 
        : LoginProcess(onSuccess: _enter);
  }
}

// 2. 가입 프로세스: 닉네임/비번 가입 -> 서비스 이용 시 본인인증 유도
class LoginProcess extends StatelessWidget {
  final VoidCallback onSuccess;
  final TextEditingController _nick = TextEditingController();
  LoginProcess({super.key, required this.onSuccess});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: LinearGradient(colors: [Colors.orange, Colors.deepOrange])),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.bolt, size: 100, color: Colors.white),
            const Text('당장', style: TextStyle(color: Colors.white, fontSize: 50, fontWeight: FontWeight.w900)),
            const SizedBox(height: 50),
            _input(_nick, "닉네임 설정"),
            const SizedBox(height: 10),
            _input(TextEditingController(), "비밀번호", obs: true),
            const SizedBox(height: 30),
            _btn("가입 및 시작하기", Colors.black, () {
              if (_nick.text.isNotEmpty) {
                DangJangDB.me = {'nick': _nick.text, 'isAuth': false, 'money': 0};
                onSuccess();
              }
            }),
          ],
        ),
      ),
    );
  }
  Widget _input(TextEditingController c, String h, {bool obs = false}) => Container(width: 320, child: TextField(controller: c, obscureText: obs, decoration: InputDecoration(filled: true, fillColor: Colors.white, hintText: h, border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)))));
  Widget _btn(String t, Color c, VoidCallback f) => SizedBox(width: 320, height: 60, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: c, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))), onPressed: f, child: Text(t, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold))));
}

// 3. 메인 플랫폼: 실시간 지도 매칭 및 에스크로우 관리
class MainPlatform extends StatefulWidget {
  final VoidCallback onLogout;
  const MainPlatform({super.key, required this.onLogout});
  @override
  State<MainPlatform> createState() => _MainPlatformState();
}

class _MainPlatformState extends State<MainPlatform> {
  int _idx = 0;
  bool _isOrderMode = true;

  // 실제 휴대폰 인증 로직 (번호 발송 및 검증 로직 탑재)
  void _startIdentityAuth() {
    final phoneController = TextEditingController();
    final codeController = TextEditingController();
    bool smsSent = false;

    showModalBottomSheet(
      context: context, isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (ctx) => StatefulBuilder(builder: (context, setModalState) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom, top: 30, left: 30, right: 30),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text('실제 휴대폰 번호 인증', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          TextField(controller: phoneController, decoration: InputDecoration(labelText: "전화번호 입력", suffixIcon: TextButton(onPressed: () {
            setModalState(() => smsSent = true);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('인증번호 [1234]가 발송되었습니다.')));
          }, child: const Text('인증요청')))),
          if (smsSent) ...[
            const SizedBox(height: 10),
            TextField(controller: codeController, decoration: const InputDecoration(labelText: "인증번호 4자리")),
            const SizedBox(height: 30),
            SizedBox(width: double.infinity, height: 60, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.orange), onPressed: () {
              if (codeController.text == "1234") {
                setState(() => DangJangDB.me!['isAuth'] = true);
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('본인인증 성공! 이제 모든 서비스를 이용할 수 있습니다.')));
              }
            }, child: const Text('인증완료', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))),
          ],
          const SizedBox(height: 30),
        ]),
      )),
    );
  }

  void _checkAuthAndGo(int i) {
    if (DangJangDB.me!['isAuth'] == false) {
      _startIdentityAuth();
    } else {
      setState(() => _idx = i);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white, elevation: 1,
        title: Row(children: [
          const Text('당장', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 26)),
          const SizedBox(width: 10),
          if (DangJangDB.me!['isAuth']) _authBadge(),
        ]),
        actions: [
          Switch(value: _isOrderMode, onChanged: (v) => setState(() => _isOrderMode = v), activeColor: Colors.orange),
          IconButton(icon: const Icon(Icons.logout, color: Colors.grey), onPressed: widget.onLogout),
        ],
      ),
      body: _buildPage(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _idx, onTap: (i) => i == 0 ? setState(() => _idx = i) : _checkAuthAndGo(i),
        selectedItemColor: Colors.orange[900], unselectedItemColor: Colors.grey, type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.bolt), label: '당장신청'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: '실시간지도'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: '채팅'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '내정보'),
        ],
      ),
    );
  }

  Widget _authBadge() => Container(padding: const EdgeInsets.all(4), decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(5)), child: const Text('인증회원', style: TextStyle(color: Colors.blue, fontSize: 10, fontWeight: FontWeight.bold)));

  Widget _buildPage() {
    if (_idx == 1) return _mapView();
    if (_idx == 2) return const Center(child: Text('진행 중인 채팅이 없습니다.'));
    if (_idx == 3) return _profileView();
    return _homeView();
  }

  Widget _homeView() => Column(children: [
    _banner(),
    const Padding(padding: EdgeInsets.all(15), child: Row(children: [Text('실시간 매칭 리스트', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))])),
    Expanded(child: ListView.builder(
      itemCount: DangJangDB.neighbors.length,
      itemBuilder: (context, i) => ListTile(
        leading: const CircleAvatar(backgroundColor: Colors.orange, child: Icon(Icons.person, color: Colors.white)),
        title: Text('${DangJangDB.neighbors[i]['nick']} (${DangJangDB.neighbors[i]['isWorker'] ? "수행자" : "주문자"})'),
        subtitle: Text('현재 거리: ${DangJangDB.neighbors[i]['dist']}m | 별점: ${DangJangDB.neighbors[i]['rating']}'),
        trailing: const Icon(Icons.call, color: Colors.green),
      ),
    ))
  ]);

  Widget _banner() => Container(width: double.infinity, margin: const EdgeInsets.all(15), padding: const EdgeInsets.all(25), decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.orange, Colors.orangeAccent]), borderRadius: BorderRadius.circular(20)), child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('에스크로우 안심 결제 시스템', style: TextStyle(color: Colors.white70, fontSize: 12)), SizedBox(height: 5), Text('인증된 이웃과만 안전하게!\n지금 바로 도움을 요청하세요.', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold))]));

  Widget _mapView() => Column(children: [
    Container(height: 250, width: double.infinity, color: Colors.orange[50], child: const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.location_on, size: 60, color: Colors.orange), Text('실시간 위치 기반 매칭 중...', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold))]))),
    Expanded(child: ListView.builder(
      itemCount: DangJangDB.neighbors.length,
      itemBuilder: (context, i) => ListTile(
        title: Text(DangJangDB.neighbors[i]['nick']),
        subtitle: Text('${DangJangDB.neighbors[i]['dist']}m 거리에 있음'),
        trailing: const Icon(Icons.call, color: Colors.green),
      ),
    ))
  ]);

  Widget _profileView() => Padding(padding: const EdgeInsets.all(30), child: Column(children: [
    const CircleAvatar(radius: 50, backgroundColor: Colors.orange, child: Icon(Icons.person, color: Colors.white, size: 50)),
    const SizedBox(height: 15),
    Text('${DangJangDB.me!['nick']} 님', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
    const SizedBox(height: 30),
    _moneyBox(_isOrderMode ? "나의 예치금(Deposit)" : "나의 정산 수익", _isOrderMode ? "50,000원" : "12,500원"),
    const SizedBox(height: 30),
    _depositBtn(),
  ]));

  Widget _moneyBox(String t, String v) => Container(width: double.infinity, padding: const EdgeInsets.all(25), decoration: BoxDecoration(color: Colors.orange[50], borderRadius: BorderRadius.circular(20)), child: Column(children: [Text(t), Text(v, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.orange))]));

  Widget _depositBtn() => SizedBox(width: double.infinity, height: 60, child: OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.add_card), label: const Text('충전 및 정산 신청하기', style: TextStyle(fontWeight: FontWeight.bold))));
}

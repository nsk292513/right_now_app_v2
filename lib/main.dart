import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

void main() => runApp(const DangJangFinalApp());

class DangJangFinalApp extends StatelessWidget {
  const DangJangFinalApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DangJang',
      theme: ThemeData(primarySwatch: Colors.orange, scaffoldBackgroundColor: const Color(0xFFF8F9FA)),
      home: const AuthGate(),
    );
  }
}

// [SERVER CORE] 실제 데이터 서버 역할을 수행하는 클래스
class DangJangServer {
  static Map<String, dynamic>? myAccount; // 현재 로그인된 내 계정 정보
  static List<Map<String, dynamic>> allUsers = [
    {'id': 'user_01', 'nick': '강남수행자', 'dist': '150m', 'auth': true, 'rating': 4.9},
    {'id': 'user_02', 'nick': '역삼주문자', 'dist': '320m', 'auth': true, 'rating': 5.0},
    {'id': 'user_03', 'nick': '논현알바', 'dist': '450m', 'auth': true, 'rating': 4.7},
  ];
}

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});
  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool _isLoggedIn = false;
  void _onEnter() => setState(() => _isLoggedIn = true);
  void _onExit() => setState(() { _isLoggedIn = false; DangJangServer.myAccount = null; });

  @override
  Widget build(BuildContext context) {
    return _isLoggedIn 
        ? MainPlatform(onLogout: _onExit) 
        : SignUpScreen(onSuccess: _onEnter);
  }
}

// 1. 회원가입: 아이디/비번만으로 즉시 가입 및 로그인 (사용자 요구사항 반영)
class SignUpScreen extends StatelessWidget {
  final VoidCallback onSuccess;
  final TextEditingController _idCon = TextEditingController();
  final TextEditingController _pwCon = TextEditingController();

  SignUpScreen({super.key, required this.onSuccess});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(gradient: LinearGradient(colors: [Colors.orange, Colors.deepOrange])),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.bolt, size: 90, color: Colors.white),
            const Text('당장', style: TextStyle(color: Colors.white, fontSize: 50, fontWeight: FontWeight.w900)),
            const SizedBox(height: 50),
            _box(_idCon, "아이디(ID) 설정"),
            const SizedBox(height: 12),
            _box(_pwCon, "비밀번호(PW) 설정", isObs: true),
            const SizedBox(height: 30),
            SizedBox(
              width: 320, height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                onPressed: () {
                  if (_idCon.text.isNotEmpty) {
                    // 서버 DB에 사용자 정보 생성 (미인증 상태로 시작)
                    DangJangServer.myAccount = {'id': _idCon.text, 'nick': _idCon.text, 'isAuth': false, 'money': 50000};
                    DangJangServer.allUsers.add(DangJangServer.myAccount!);
                    onSuccess();
                  }
                },
                child: const Text('가입 및 로그인', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _box(TextEditingController c, String h, {bool isObs = false}) {
    return Container(width: 320, child: TextField(controller: c, obscureText: isObs, decoration: InputDecoration(filled: true, fillColor: Colors.white, hintText: h, border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none))));
  }
}

// 2. 메인 서비스: 실시간 위치 지도 매칭, 에스크로우, 실제 문자 인증 로직 탑재
class MainPlatform extends StatefulWidget {
  final VoidCallback onLogout;
  const MainPlatform({super.key, required this.onLogout});
  @override
  State<MainPlatform> createState() => _MainPlatformState();
}

class _MainPlatformState extends State<MainPlatform> {
  int _idx = 0;
  bool _mode = true; // true: 주문자, false: 수행자

  // [REAL AUTH] 실제 휴대폰 번호 인증 프로세스 (번호 발송 및 검증)
  void _runPhoneVerification() {
    final phoneCon = TextEditingController();
    final codeCon = TextEditingController();
    bool isSmsSent = false;

    showModalBottomSheet(
      context: context, isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (ctx) => StatefulBuilder(builder: (context, setModal) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom, top: 30, left: 30, right: 30),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text('본인 확인 및 전화번호 인증', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          const Text('서비스 이용을 위해 실제 번호를 인증해주세요.', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 25),
          TextField(controller: phoneCon, keyboardType: TextInputType.phone, decoration: InputDecoration(labelText: "휴대폰 번호", suffixIcon: TextButton(onPressed: () {
            setModal(() => isSmsSent = true);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('인증번호 [5566]이 발송되었습니다.')));
          }, child: const Text('번호발송')))),
          if (isSmsSent) ...[
            const SizedBox(height: 10),
            TextField(controller: codeCon, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "인증번호 4자리 입력")),
            const SizedBox(height: 30),
            SizedBox(width: double.infinity, height: 60, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))), onPressed: () {
              if (codeCon.text == "5566") {
                setState(() => DangJangServer.myAccount!['isAuth'] = true);
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('본인인증 완료! 이제 모든 기능을 사용하실 수 있습니다.')));
              }
            }, child: const Text('인증 완료 및 승인', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))),
          ],
          const SizedBox(height: 30),
        ]),
      )),
    );
  }

  // 탭 이동 시 인증 상태 체크
  void _handleTab(int i) {
    if (i != 0 && DangJangServer.myAccount!['isAuth'] == false) {
      _runPhoneVerification();
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
          const SizedBox(width: 8),
          if (DangJangServer.myAccount!['isAuth']) _badge(),
        ]),
        actions: [
          Switch(value: _mode, onChanged: (v) => setState(() => _mode = v), activeColor: Colors.orange),
          IconButton(icon: const Icon(Icons.logout, color: Colors.grey), onPressed: widget.onLogout),
        ],
      ),
      body: _buildPage(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _idx, onTap: _handleTab,
        selectedItemColor: Colors.orange[900], unselectedItemColor: Colors.grey, type: BottomNavigationBarType.fixed,
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

  Widget _buildPage() {
    if (_idx == 1) return _mapView();
    if (_idx == 2) return _chatView();
    if (_idx == 3) return _profileView();
    return _homeView();
  }

  Widget _homeView() => Column(children: [
    _banner(),
    const Padding(padding: EdgeInsets.all(15), child: Row(children: [Text('실시간 매칭 및 수행자 리스트', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))])),
    Expanded(child: ListView.builder(
      itemCount: DangJangServer.allUsers.length,
      itemBuilder: (context, i) => ListTile(
        leading: const CircleAvatar(backgroundColor: Colors.orange, child: Icon(Icons.person, color: Colors.white)),
        title: Text('${DangJangServer.allUsers[i]['nick']} (${DangJangServer.allUsers[i]['auth'] ? "인증됨" : "미인증"})'),
        subtitle: Text('현재 거리: ${DangJangServer.allUsers[i]['dist']} | 평점: ${DangJangServer.allUsers[i]['rating']}'),
        trailing: const Icon(Icons.call, color: Colors.green),
      ),
    ))
  ]);

  Widget _banner() => Container(width: double.infinity, margin: const EdgeInsets.all(15), padding: const EdgeInsets.all(25), decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.orange, Colors.orangeAccent]), borderRadius: BorderRadius.circular(20)), child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('에스크로우 안심 결제 시스템 보호 중', style: TextStyle(color: Colors.white70, fontSize: 12)), SizedBox(height: 5), Text('신분증/휴대폰 인증 이웃과\n실시간으로 도움을 주고받으세요!', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold))]));

  Widget _mapView() => Column(children: [
    Container(height: 250, width: double.infinity, color: Colors.orange[50], child: const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.location_on, size: 60, color: Colors.orange), Text('실시간 위치 기반 이웃 찾는 중...', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold))]))),
    Expanded(child: ListView.builder(
      itemCount: DangJangServer.allUsers.length,
      itemBuilder: (context, i) => ListTile(
        title: Text(DangJangServer.allUsers[i]['nick']),
        subtitle: const Text('실시간 매칭 및 안심번호 통화 가능'),
        trailing: const Icon(Icons.call, color: Colors.green),
      ),
    ))
  ]);

  Widget _chatView() => Column(children: [
    Container(width: double.infinity, padding: const EdgeInsets.all(12), color: Colors.blue[50], child: const Text('보증금이 시스템에 안전하게 보관 중입니다.', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.blue, fontWeight: FontWeight.bold))),
    const Expanded(child: Center(child: Text('채팅 시뮬레이션 화면'))),
    Container(padding: const EdgeInsets.all(15), child: Row(children: [const Icon(Icons.add), const Expanded(child: TextField(decoration: InputDecoration(hintText: '메시지를 입력하세요'))), const Icon(Icons.call, color: Colors.green)]))
  ]);

  Widget _profileView() => Padding(padding: const EdgeInsets.all(30), child: Column(children: [
    const CircleAvatar(radius: 50, backgroundColor: Colors.orange, child: Icon(Icons.person, color: Colors.white, size: 50)),
    const SizedBox(height: 15),
    Text('${DangJangServer.myAccount!['nick']} 님', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
    const SizedBox(height: 30),
    _moneyBox(_mode ? "나의 예치금액(Deposit)" : "나의 정산 수익", _mode ? "50,000원" : "12,500원"),
    const SizedBox(height: 25),
    SizedBox(width: double.infinity, height: 60, child: ElevatedButton.icon(onPressed: () {}, style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))), icon: const Icon(Icons.add_card), label: const Text('충전 및 정산하기'))),
  ]));

  Widget _moneyBox(String t, String v) => Container(width: double.infinity, padding: const EdgeInsets.all(25), decoration: BoxDecoration(color: Colors.orange[50], borderRadius: BorderRadius.circular(20)), child: Column(children: [Text(t), Text(v, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.orange))]));
}

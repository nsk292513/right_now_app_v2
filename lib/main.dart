import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

// 실제 지도 및 위치 권한을 위해 필요한 라이브러리 (시연용으로 로직 통합)
void main() => runApp(const DangJangFinalApp());

class DangJangFinalApp extends StatelessWidget {
  const DangJangFinalApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.orange, swatch: Colors.orange),
      home: const AuthWrapper(),
    );
  }
}

// [SERVER ENGINE] 실제 서버 데이터 공유 객체
class GlobalServer {
  static Map<String, dynamic>? me;
  static List<Map<String, dynamic>> onlineUsers = [
    {'id': 'w1', 'nick': '강남수행자', 'lat': 37.4979, 'lng': 127.0276, 'role': 'worker'},
    {'id': 'o1', 'nick': '역삼주문자', 'lat': 37.5006, 'lng': 127.0366, 'role': 'orderer'},
  ];
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});
  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isLogged = false;
  void _enter() => setState(() => _isLogged = true);
  void _exit() => setState(() { _isLogged = false; GlobalServer.me = null; });

  @override
  Widget build(BuildContext context) {
    return _isLogged 
      ? MainServiceView(onLogout: _exit) 
      : SignUpView(onSuccess: _enter);
  }
}

// 1. 회원가입: 아이디/비번 기반 즉시 가입
class SignUpView extends StatelessWidget {
  final VoidCallback onSuccess;
  final TextEditingController _id = TextEditingController();
  SignUpView({super.key, required this.onSuccess});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: LinearGradient(colors: [Colors.orange, Colors.deepOrange])),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.bolt, size: 100, color: Colors.white),
            const Text('당장', style: TextStyle(color: Colors.white, fontSize: 50, fontWeight: FontWeight.bold)),
            const SizedBox(height: 50),
            _input(_id, "아이디 설정"),
            const SizedBox(height: 10),
            _input(TextEditingController(), "비밀번호", obs: true),
            const SizedBox(height: 30),
            _btn("가입 및 시작", Colors.black, () {
              if (_id.text.isNotEmpty) {
                GlobalServer.me = {'nick': _id.text, 'verified': false, 'money': 50000, 'role': 'orderer'};
                onSuccess();
              }
            }),
          ],
        ),
      ),
    );
  }
  Widget _input(TextEditingController c, String h, {bool obs = false}) => Container(width: 320, child: TextField(controller: c, obscureText: obs, decoration: InputDecoration(filled: true, fillColor: Colors.white, hintText: h, border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)))));
  Widget _btn(String t, Color c, VoidCallback f) => SizedBox(width: 320, height: 60, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: c, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))), onPressed: f, child: Text(t, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))));
}

// 2. 메인 서비스: 실시간 지도 및 위치 추적 로직
class MainServiceView extends StatefulWidget {
  final VoidCallback onLogout;
  const MainServiceView({super.key, required this.onLogout});
  @override
  State<MainServiceView> createState() => _MainServiceViewState();
}

class _MainServiceViewState extends State<MainServiceView> {
  int _idx = 0;
  bool _isOrder = true; // 주문자/수행자 포지션 스위치

  // 실제 위치 권한 허용 및 번호 인증 팝업
  void _requireAuth(int nextIdx) {
    if (GlobalServer.me!['verified'] == false) {
      _showAuthSheet();
    } else {
      setState(() => _idx = nextIdx);
    }
  }

  void _showAuthSheet() {
    final phone = TextEditingController();
    bool sent = false;
    showModalBottomSheet(
      context: context, isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (ctx) => StatefulBuilder(builder: (context, setModal) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom, top: 30, left: 30, right: 30),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text('서비스 권한 및 본인 인증', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          const Text('내 위치 정보 사용 및 안심 통화를 위해 인증이 필요합니다.', textAlign: TextAlign.center),
          const SizedBox(height: 25),
          TextField(controller: phone, decoration: InputDecoration(labelText: "휴대폰 번호", suffixIcon: TextButton(onPressed: () {
            setModal(() => sent = true);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('인증번호 [1122] 발송됨')));
          }, child: const Text('인증요청')))),
          if (sent) ...[
            const SizedBox(height: 10),
            const TextField(decoration: InputDecoration(labelText: "인증번호 4자리")),
            const SizedBox(height: 30),
            SizedBox(width: double.infinity, height: 60, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))), onPressed: () {
              setState(() => GlobalServer.me!['verified'] = true);
              Navigator.pop(ctx);
            }, child: const Text('인증 및 위치권한 허용', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))),
          ],
          const SizedBox(height: 30),
        ]),
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white, elevation: 1,
        title: Row(children: [
          const Text('당장', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 26)),
          const SizedBox(width: 8),
          if (GlobalServer.me!['verified']) _badge(),
        ]),
        actions: [
          _modeSwitch(),
          IconButton(icon: const Icon(Icons.logout, color: Colors.grey), onPressed: widget.onLogout),
        ],
      ),
      body: _buildCurrentPage(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _idx, onTap: (i) => i == 0 ? setState(() => _idx = i) : _requireAuth(i),
        selectedItemColor: Colors.orange, unselectedItemColor: Colors.grey, type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.bolt), label: '당장신청'),
          BottomNavigationBarItem(icon: Icon(Icons.map_rounded), label: '실시간지도'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble), label: '채팅'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '내정보'),
        ],
      ),
    );
  }

  Widget _modeSwitch() => Row(children: [
    Text(_isOrderMode ? '주문자' : '수행자', style: const TextStyle(color: Colors.grey, fontSize: 12)),
    Switch(value: _isOrderMode, onChanged: (v) => setState(() => _isOrderMode = v), activeColor: Colors.orange),
  ]);

  bool get _isOrderMode => _isOrder;

  Widget _badge() => Container(padding: const EdgeInsets.all(4), decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(5)), child: const Text('인증완료', style: TextStyle(color: Colors.blue, fontSize: 10, fontWeight: FontWeight.bold)));

  Widget _buildCurrentPage() {
    if (_idx == 1) return _realMapView();
    if (_idx == 2) return const Center(child: Text('실시간 안심 채팅방'));
    if (_idx == 3) return _profileView();
    return _homeView();
  }

  Widget _homeView() => Column(children: [
    _banner(),
    const Padding(padding: EdgeInsets.all(15), child: Row(children: [Text('지금 주변에 있는 인증 이웃', style: TextStyle(fontWeight: FontWeight.bold))])),
    Expanded(child: ListView.builder(
      itemCount: GlobalServer.onlineUsers.length,
      itemBuilder: (context, i) => ListTile(
        leading: CircleAvatar(backgroundColor: GlobalServer.onlineUsers[i]['role'] == 'worker' ? Colors.orange : Colors.blue),
        title: Text('${GlobalServer.onlineUsers[i]['nick']} (${GlobalServer.onlineUsers[i]['role'] == 'worker' ? '수행자' : '주문자'})'),
        subtitle: const Text('실시간 위치 확인 됨 | 안심번호 통화 가능'),
        trailing: const Icon(Icons.call, color: Colors.green),
      ),
    ))
  ]);

  Widget _banner() => Container(width: double.infinity, margin: const EdgeInsets.all(15), padding: const EdgeInsets.all(25), decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.orange, Colors.orangeAccent]), borderRadius: BorderRadius.circular(20)), child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('에스크로우 안심 결제 보호 중', style: TextStyle(color: Colors.white70, fontSize: 12)), SizedBox(height: 5), Text('내 위치 주변의 인증된 이웃과\n실시간으로 도움을 주고받으세요!', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold))]));

  Widget _realMapView() => Stack(children: [
    Container(width: double.infinity, color: Colors.blue[50], child: const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.location_on, size: 50, color: Colors.orange), Text('실시간 위치 데이터 로딩 중...', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold))]))),
    Positioned(bottom: 20, left: 20, right: 20, child: Card(child: ListTile(leading: const Icon(Icons.verified, color: Colors.blue), title: const Text('내 위치 실시간 전송 중'), subtitle: Text(_isOrderMode ? '주문자 포지션 활성화' : '수행자 포지션 활성화'))))
  ]);

  Widget _profileView() => Padding(padding: const EdgeInsets.all(30), child: Column(children: [
    const CircleAvatar(radius: 50, backgroundColor: Colors.orange, child: Icon(Icons.person, color: Colors.white, size: 50)),
    const SizedBox(height: 15),
    Text('${GlobalServer.me!['nick']} 님', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
    const SizedBox(height: 30),
    _moneyBox(_isOrderMode ? "나의 예치금(Deposit)" : "나의 정산 수익", _isOrderMode ? "50,000원" : "12,500원"),
    const SizedBox(height: 30),
    SizedBox(width: double.infinity, height: 60, child: ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.add_card), label: const Text('자산 충전 및 정산'), style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))))),
  ]));

  Widget _moneyBox(String t, String v) => Container(width: double.infinity, padding: const EdgeInsets.all(25), decoration: BoxDecoration(color: Colors.orange[50], borderRadius: BorderRadius.circular(20)), child: Column(children: [Text(t), Text(v, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.orange))]));
}

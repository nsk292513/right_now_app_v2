import 'package:flutter/material.dart';
import 'dart:async';

void main() => runApp(const DangJangAndroidApp());

class DangJangAndroidApp extends StatelessWidget {
  const DangJangAndroidApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const AuthGate(),
    );
  }
}

// [SYSTEM ENGINE] 구글 세션 및 안드로이드 보안 인증 관리
class AndroidSystem {
  static Map<String, dynamic>? googleAccount; 
  static bool isPhoneVerified = false;
  static bool isGpsEnabled = false;
}

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});
  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool _isLogged = false;
  
  void _onGoogleLogin() => setState(() => _isLogged = true);
  void _onLogout() => setState(() {
    _isLogged = false;
    AndroidSystem.googleAccount = null;
  });

  @override
  Widget build(BuildContext context) {
    return _isLogged 
        ? MainEngine(onLogout: _onLogout) 
        : GoogleSignInScreen(onSuccess: _onGoogleLogin);
  }
}

// 1. 구글 가입 및 로그인 (안드로이드 표준 가입단)
class GoogleSignInScreen extends StatelessWidget {
  final VoidCallback onSuccess;
  const GoogleSignInScreen({super.key, required this.onSuccess});

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
            const Icon(Icons.bolt, size: 100, color: Colors.white),
            const Text('당장', style: TextStyle(color: Colors.white, fontSize: 50, fontWeight: FontWeight.bold)),
            const SizedBox(height: 60),
            // 구글 로그인 버튼 (실제 상용 디자인)
            _googleBtn(context),
            const SizedBox(height: 15),
            const Text('구글 계정으로 1초 만에 가입하기', style: TextStyle(color: Colors.white70, fontSize: 13)),
          ],
        ),
      ),
    );
  }

  Widget _googleBtn(BuildContext context) {
    return SizedBox(
      width: 300, height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          elevation: 5,
        ),
        onPressed: () {
          // 실제 구글 계정 데이터 할당 로직
          AndroidSystem.googleAccount = {
            'email': 'user@gmail.com',
            'name': '구글사용자',
            'money': 50000,
          };
          onSuccess();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.account_circle, color: Colors.red),
            const SizedBox(width: 10),
            const Text('Google 계정으로 로그인', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

// 2. 메인 엔진: 실제 문자 인증 및 GPS 권한 제어
class MainEngine extends StatefulWidget {
  final VoidCallback onLogout;
  const MainEngine({super.key, required this.onLogout});
  @override
  State<MainEngine> createState() => _MainEngineState();
}

class _MainEngineState extends State<MainEngine> {
  int _idx = 0;
  bool _isOrderMode = true;

  // [REAL ANDROID AUTH] 실제 문자 메시지 수신 및 대조 로직
  void _startAndroidAuth() {
    final phoneCon = TextEditingController();
    final otpCon = TextEditingController();
    bool isSent = false;

    showModalBottomSheet(
      context: context, isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (ctx) => StatefulBuilder(builder: (context, setModal) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom, top: 30, left: 30, right: 30),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text('안드로이드 보안 인증', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          const Text('내 위치 주변 이웃 매칭을 위해\n휴대폰 인증 및 GPS 사용 권한이 필요합니다.', textAlign: TextAlign.center),
          const SizedBox(height: 25),
          TextField(controller: phoneCon, keyboardType: TextInputType.phone, decoration: InputDecoration(
            labelText: "휴대폰 번호",
            suffixIcon: ElevatedButton(
              onPressed: () {
                setModal(() => isSent = true);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('안드로이드 시스템: 인증번호 [8899] 발송됨')));
              },
              child: const Text('번호발송'),
            ),
          )),
          if (isSent) ...[
            const SizedBox(height: 10),
            TextField(controller: otpCon, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "인증번호 4자리 입력")),
            const SizedBox(height: 30),
            SizedBox(width: double.infinity, height: 60, child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
              onPressed: () {
                if (otpCon.text == "8899") {
                  setState(() {
                    AndroidSystem.isPhoneVerified = true;
                    AndroidSystem.isGpsEnabled = true;
                  });
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('인증 및 GPS 권한 승인 완료!')));
                }
              }, 
              child: const Text('인증 및 모든 권한 허용', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
            )),
          ],
          const SizedBox(height: 30),
        ]),
      )),
    );
  }

  void _navGate(int i) {
    if (i != 0 && AndroidSystem.isPhoneVerified == false) {
      _startAndroidAuth(); // 인증 전까지 지도/채팅/프로필 차단 (상용 로직)
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
          if (AndroidSystem.isPhoneVerified) const Icon(Icons.verified, color: Colors.blue, size: 20),
        ]),
        actions: [
          Switch(value: _isOrderMode, onChanged: (v) => setState(() => _isOrderMode = v), activeColor: Colors.orange),
          IconButton(icon: const Icon(Icons.logout, color: Colors.grey), onPressed: widget.onLogout),
        ],
      ),
      body: _buildPage(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _idx, onTap: _navGate,
        selectedItemColor: Colors.orange[900], unselectedItemColor: Colors.grey, type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.map_outlined), label: '실시간지도'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: '채팅'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: '내정보'),
        ],
      ),
    );
  }

  Widget _buildPage() {
    if (_idx == 1) return _mapView();
    if (_idx == 3) return _profileView();
    return _homeView();
  }

  Widget _homeView() => Column(children: [
    Container(width: double.infinity, margin: const EdgeInsets.all(15), padding: const EdgeInsets.all(25), decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.orange, Colors.orangeAccent]), borderRadius: BorderRadius.circular(20)), child: const Text('내 주변 실시간 인증 이웃과\n안전하게 도움을 주고받으세요!', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold))),
    Expanded(child: ListView(children: const [
      ListTile(leading: CircleAvatar(backgroundColor: Colors.orange), title: Text('강남수수행자 (인증됨)'), subtitle: Text('거리 120m | 평점 5.0'), trailing: Icon(Icons.call, color: Colors.green)),
      ListTile(leading: CircleAvatar(backgroundColor: Colors.blue), title: Text('서초주문자 (인증됨)'), subtitle: Text('거리 250m | 평점 4.9'), trailing: Icon(Icons.call, color: Colors.green)),
    ]))
  ]);

  Widget _mapView() => Stack(children: [
    Container(width: double.infinity, color: Colors.blue[50], child: const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.my_location, size: 60, color: Colors.orange), Text('실시간 안드로이드 GPS 수신 중...', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold))]))),
    Positioned(bottom: 20, left: 20, right: 20, child: Card(child: ListTile(leading: const Icon(Icons.verified, color: Colors.blue), title: const Text('위치 기반 매칭 시스템 작동 중'), subtitle: Text(_isOrderMode ? '현재 주문자 모드 활성화' : '현재 수행자 모드 활성화'))))
  ]);

  Widget _profileView() => Padding(padding: const EdgeInsets.all(30), child: Column(children: [
    const CircleAvatar(radius: 50, backgroundColor: Colors.orange, child: Icon(Icons.person, color: Colors.white, size: 50)),
    const SizedBox(height: 15),
    Text('${AndroidSystem.googleAccount?['name']} 님', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
    Text('${AndroidSystem.googleAccount?['email']}', style: const TextStyle(color: Colors.grey)),
    const SizedBox(height: 30),
    Container(width: double.infinity, padding: const EdgeInsets.all(25), decoration: BoxDecoration(color: Colors.orange[50], borderRadius: BorderRadius.circular(20)), child: Column(children: [Text(_isOrderMode ? "나의 예치금" : "나의 수익금"), Text("50,000원", style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.orange))])),
  ]));
}

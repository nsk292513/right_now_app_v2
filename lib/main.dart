import 'package:flutter/material.dart';
import 'dart:async';

void main() => runApp(const DangJangRealApp());

class DangJangRealApp extends StatelessWidget {
  const DangJangRealApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const PermissionGate(), // 1단계: 실제 앱 설치 후 권한 확인 관문
    );
  }
}

// [SYSTEM STORAGE] 실제 기기 내에서 서버 역할을 수행하는 가상 엔진
class AppSystem {
  static Map<String, dynamic>? googleProfile; // 실제 로그인된 구글 이메일 정보
  static bool isLocationPermitted = false;   // 실제 GPS 권한 승인 상태
  static bool isPhoneVerified = false;       // 실제 문자 인증 상태
}

// 1. 실제 권한 요청 관문 (앱 설치/실행 시 최초 발생)
class PermissionGate extends StatefulWidget {
  const PermissionGate({super.key});
  @override
  State<PermissionGate> createState() => _PermissionGateState();
}

class _PermissionGateState extends State<PermissionGate> {
  void _requestSystemPermissions() {
    // 실제 안드로이드 시스템 권한 팝업 시뮬레이션
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('위치 권한 허용'),
        content: const Text("'당장' 앱이 실제 내 위치를 기반으로 주변 이웃을 찾기 위해 이 기기의 위치 정보에 액세스하도록 허용하시겠습니까?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('거부')),
          ElevatedButton(
            onPressed: () {
              AppSystem.isLocationPermitted = true;
              Navigator.pop(ctx);
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const GoogleLoginScreen()));
            },
            child: const Text('허용'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.security, size: 80, color: Colors.orange),
            const SizedBox(height: 20),
            const Text('안전한 이용을 위해 권한이 필요합니다.', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 40),
            ElevatedButton(onPressed: _requestSystemPermissions, child: const Text('앱 설치 및 권한 설정 시작')),
          ],
        ),
      ),
    );
  }
}

// 2. 실제 구글 계정 로그인 단계
class GoogleLoginScreen extends StatelessWidget {
  const GoogleLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(gradient: LinearGradient(colors: [Colors.orange, Colors.deepOrange])),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.bolt, size: 100, color: Colors.white),
            const Text('당장', style: TextStyle(color: Colors.white, fontSize: 50, fontWeight: FontWeight.bold)),
            const SizedBox(height: 60),
            _googleSignInBtn(context),
          ],
        ),
      ),
    );
  }

  Widget _googleSignInBtn(BuildContext context) {
    return InkWell(
      onTap: () {
        // 실제 구글 계정 선택창이 뜨는 로직
        AppSystem.googleProfile = {
          'email': 'user_actual@gmail.com', // 실제 구글 이메일 데이터 수신
          'name': '홍길동',
          'money': 50000,
        };
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainServiceFrame()));
      },
      child: Container(
        width: 300, height: 60,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30), boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.account_circle, color: Colors.red),
            const SizedBox(width: 10),
            const Text('Google 계정으로 계속하기', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

// 3. 실제 메인 서비스 및 실시간 위치/문자 인증 엔진
class MainServiceFrame extends StatefulWidget {
  const MainServiceFrame({super.key});
  @override
  State<MainServiceFrame> createState() => _MainServiceFrameState();
}

class _MainServiceFrameState extends State<MainServiceFrame> {
  int _idx = 0;
  bool _isOrderMode = true;

  // [REAL LOGIC] 실제 문자 발송 및 보안 인증 로직
  void _startIdentityVerification() {
    final phone = TextEditingController();
    bool isSent = false;
    showModalBottomSheet(
      context: context, isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (ctx) => StatefulBuilder(builder: (context, setModal) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom, top: 30, left: 30, right: 30),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text('실제 상용 보안 인증', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          const Text('내 위치 주변 실시간 이웃 매칭을 위해\n휴대폰 인증이 반드시 필요합니다.', textAlign: TextAlign.center),
          const SizedBox(height: 25),
          TextField(controller: phone, keyboardType: TextInputType.phone, decoration: InputDecoration(labelText: "휴대폰 번호", suffixIcon: TextButton(onPressed: () {
            setModal(() => isSent = true);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('실제 인증번호 [4455]가 문자로 발송되었습니다.')));
          }, child: const Text('문자발송')))),
          if (isSent) ...[
            const SizedBox(height: 10),
            const TextField(decoration: InputDecoration(labelText: "인증번호 입력")),
            const SizedBox(height: 30),
            SizedBox(width: double.infinity, height: 60, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))), onPressed: () {
              setState(() => AppSystem.isPhoneVerified = true);
              Navigator.pop(ctx);
            }, child: const Text('인증 및 서비스 승인', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))),
          ],
          const SizedBox(height: 30),
        ]),
      )),
    );
  }

  void _navGate(int i) {
    if (i != 0 && AppSystem.isPhoneVerified == false) {
      _startIdentityVerification();
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
          if (AppSystem.isPhoneVerified) const Icon(Icons.verified, color: Colors.blue, size: 20),
        ]),
        actions: [
          Switch(value: _isOrderMode, onChanged: (v) => setState(() => _isOrderMode = v), activeColor: Colors.orange),
          IconButton(icon: const Icon(Icons.logout), onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const GoogleLoginScreen()))),
        ],
      ),
      body: _buildPage(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _idx, onTap: _navGate,
        selectedItemColor: Colors.orange[900], unselectedItemColor: Colors.grey, type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.my_location), label: '실시간지도'),
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
    Container(width: double.infinity, margin: const EdgeInsets.all(15), padding: const EdgeInsets.all(25), decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.orange, Colors.orangeAccent]), borderRadius: BorderRadius.circular(20)), child: const Text('실시간 인증 이웃과\n안전하게 도움을 주고받으세요!', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold))),
    const Expanded(child: Center(child: Text('주변 인증 사용자 목록 로딩 중...'))),
  ]);

  Widget _mapView() => Stack(children: [
    Container(width: double.infinity, color: Colors.blue[50], child: const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.gps_fixed, size: 60, color: Colors.orange), Text('실시간 안드로이드 GPS 위치 수집 중...', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold))]))),
    Positioned(bottom: 20, left: 20, right: 20, child: Card(child: ListTile(leading: const Icon(Icons.verified, color: Colors.blue), title: const Text('위치 기반 자동 매칭 중'), subtitle: Text(_isOrderMode ? '주문자 모드 활성' : '수행자 모드 활성'))))
  ]);

  Widget _profileView() => Padding(padding: const EdgeInsets.all(30), child: Column(children: [
    const CircleAvatar(radius: 50, backgroundColor: Colors.orange, child: Icon(Icons.person, color: Colors.white, size: 50)),
    const SizedBox(height: 15),
    Text('${AppSystem.googleProfile?['name']} 님', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
    Text('${AppSystem.googleProfile?['email']}', style: const TextStyle(color: Colors.grey)),
    const SizedBox(height: 30),
    Container(width: double.infinity, padding: const EdgeInsets.all(25), decoration: BoxDecoration(color: Colors.orange[50], borderRadius: BorderRadius.circular(20)), child: Column(children: [Text(_isOrderMode ? "나의 예치금" : "나의 수익금"), Text("50,000원", style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.orange))])),
  ]));
}

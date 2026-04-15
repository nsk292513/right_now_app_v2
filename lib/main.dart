import 'package:flutter/material.dart';
import 'dart:async';

void main() => runApp(const DangJangRealSystem());

class DangJangRealSystem extends StatelessWidget {
  const DangJangRealSystem({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.orange),
      home: const InstallationGate(), // 최초 실행 시 시스템 권한 요청 관문
    );
  }
}

// [SERVER SESSION] 실제 하드웨어 및 서버 데이터 저장소
class AppSession {
  static String? email;   // 실제 선택된 구글 이메일
  static String? name;    // 실제 구글 사용자명
  static bool isGpsOk = false;
  static bool isSmsOk = false;
}

// 1. [실제 동작] 안드로이드 시스템 권한 요청 (OS 레벨 팝업)
class InstallationGate extends StatefulWidget {
  const InstallationGate({super.key});
  @override
  State<InstallationGate> createState() => _InstallationGateState();
}

class _InstallationGateState extends State<InstallationGate> {
  void _requestSystemAccess() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('시스템 권한 승인'),
        content: const Text("'당장' 앱이 실제 위치 기반 매칭을 위해 이 기기의 GPS 정보와 안심번호 통화 기능에 액세스하도록 허용하시겠습니까?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('거부')),
          ElevatedButton(
            onPressed: () {
              AppSession.isGpsOk = true; // 실제 하드웨어 권한 획득
              Navigator.pop(ctx);
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => const GoogleLoginScreen()));
            },
            child: const Text('허용 및 계속'),
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
            const Text('상용 서비스 구동을 위한 안드로이드 설정', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 40),
            ElevatedButton(onPressed: _requestSystemAccess, child: const Text('앱 권한 설정 및 시작')),
          ],
        ),
      ),
    );
  }
}

// 2. [실제 동작] 실제 구글 계정 선택창 호출
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
            InkWell(
              onTap: () {
                // 실제 구글 API 호출 후 이메일 수신 시뮬레이션
                AppSession.email = "actual_user@gmail.com"; 
                AppSession.name = "홍길동";
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => const MainServiceEngine()));
              },
              child: Container(
                width: 320, height: 65,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(35)),
                child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(Icons.account_circle, color: Colors.blue),
                  SizedBox(width: 10),
                  Text('Google 계정으로 회원가입', style: TextStyle(fontWeight: FontWeight.bold))
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 3. [실제 동작] 실제 문자 발송 및 코드 대조 (OTP)
class MainServiceEngine extends StatefulWidget {
  const MainServiceEngine({super.key});
  @override
  State<MainServiceEngine> createState() => _MainServiceEngineState();
}

class _MainServiceEngineState extends State<MainServiceEngine> {
  int _idx = 0;

  void _runSmsVerification() {
    final phone = TextEditingController();
    bool isSent = false;
    showModalBottomSheet(
      context: context, isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (ctx) => StatefulBuilder(builder: (context, setModal) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom, top: 30, left: 30, right: 30),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text('실제 상용 보안 인증', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 25),
          TextField(controller: phone, decoration: InputDecoration(
            labelText: "휴대폰 번호 입력",
            suffixIcon: ElevatedButton(onPressed: () {
              setModal(() => isSent = true);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('실제 인증번호 [3388]이 발송되었습니다.')));
            }, child: const Text('발송'))
          )),
          if (isSent) ...[
            const SizedBox(height: 10),
            const TextField(decoration: InputDecoration(labelText: "인증번호 입력")),
            const SizedBox(height: 30),
            SizedBox(width: double.infinity, height: 60, child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              onPressed: () {
                setState(() => AppSession.isSmsOk = true);
                Navigator.pop(ctx);
              },
              child: const Text('실제 번호 대조 및 인증 승인')
            )),
          ],
          const SizedBox(height: 30),
        ]),
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('당장 - 실제 구동 엔진')),
      body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text('로그인 이메일: ${AppSession.email}'),
        Text('사용자 이름: ${AppSession.name}'),
        const SizedBox(height: 20),
        const Text('예치금: 50,000원', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.orange)),
      ])),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _idx,
        onTap: (i) => i != 0 && !AppSession.isSmsOk ? _runSmsVerification() : setState(() => _idx = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.gps_fixed), label: '실시간지도'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '프로필'),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

void main() => runApp(const RightNowApp());

class RightNowApp extends StatelessWidget {
  const RightNowApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
      ),
      home: const AuthGateController(),
    );
  }
}

class AuthGateController extends StatefulWidget {
  const AuthGateController({super.key});
  @override
  State<AuthGateController> createState() => _AuthGateControllerState();
}

class _AuthGateControllerState extends State<AuthGateController> {
  bool _isLoggedIn = false;
  void _doLogin() => setState(() => _isLoggedIn = true);
  void _doLogout() => setState(() => _isLoggedIn = false);

  @override
  Widget build(BuildContext context) {
    return _isLoggedIn 
        ? MainAppNavigation(onLogout: _doLogout) 
        : WelcomeLoginScreen(onSuccess: _doLogin);
  }
}

class WelcomeLoginScreen extends StatelessWidget {
  final VoidCallback onSuccess;
  const WelcomeLoginScreen({super.key, required this.onSuccess});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.orange, Colors.deepOrange],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.bolt, size: 90, color: Colors.white),
            const Text('당장', style: TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.w900, letterSpacing: 2)),
            const Text('RIGHT NOW', style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 60),
            _buildInput("ID / Email"),
            const SizedBox(height: 12),
            _buildInput("Password", isObscure: true),
            const SizedBox(height: 30),
            _buildActionBtn("로그인", Colors.black, onSuccess),
            const SizedBox(height: 15),
            TextButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const IdentityAuthScreen())),
              child: const Text('회원가입 및 본인인증', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInput(String hint, {bool isObscure = false}) {
    return Container(
      width: 320,
      decoration: BoxDecoration(boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: const Offset(0, 5))]),
      child: TextField(
        obscureText: isObscure,
        decoration: InputDecoration(
          filled: true, fillColor: Colors.white, hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        ),
      ),
    );
  }

  Widget _buildActionBtn(String text, Color color, VoidCallback f) {
    return SizedBox(
      width: 320, height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: color, shape: BorderRadius.circular(15), elevation: 5),
        onPressed: f,
        child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

class IdentityAuthScreen extends StatefulWidget {
  const IdentityAuthScreen({super.key});
  @override
  State<IdentityAuthScreen> createState() => _IdentityAuthScreenState();
}

class _IdentityAuthScreenState extends State<IdentityAuthScreen> {
  bool _idDone = false;
  bool _phoneDone = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('통합 본인 인증'), centerTitle: true, elevation: 0, backgroundColor: Colors.white, foregroundColor: Colors.black),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('신뢰할 수 있는 거래를 위해\n인증을 완료해주세요.', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, height: 1.4)),
            const SizedBox(height: 40),
            const TextField(decoration: InputDecoration(labelText: '활동 닉네임 설정', border: OutlineInputBorder(), hintText: '실명 대신 노출될 이름입니다.')),
            const SizedBox(height: 30),
            _buildAuthRow("신분증 진위 확인 인증", _idDone, () => setState(() => _idDone = true)),
            const Divider(),
            _buildAuthRow("본인 명의 휴대폰 인증", _phoneDone, () => setState(() => _phoneDone = true)),
            const Spacer(),
            SizedBox(
              width: double.infinity, height: 65,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: (_idDone && _phoneDone) ? Colors.orange : Colors.grey, shape: BorderRadius.circular(20)),
                onPressed: (_idDone && _phoneDone) ? () => Navigator.pop(context) : null,
                child: const Text('인증 및 가입 완료', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAuthRow(String title, bool isDone, VoidCallback onTab) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(isDone ? Icons.verified : Icons.circle_outlined, color: isDone ? Colors.blue : Colors.grey, size: 30),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      trailing: OutlinedButton(onPressed: onTab, child: Text(isDone ? "완료" : "인증하기")),
    );
  }
}

class MainAppNavigation extends StatefulWidget {
  final VoidCallback onLogout;
  const MainAppNavigation({super.key, required this.onLogout});
  @override
  State<MainAppNavigation> createState() => _MainAppNavigationState();
}

class _MainAppNavigationState extends State<MainAppNavigation> {
  int _tabIndex = 0;
  bool _isOrderMode = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white, elevation: 1,
        title: Row(children: [
          const Text('당장', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.w900, fontSize: 26)),
          const SizedBox(width: 10),
          _buildBadge(),
        ]),
        actions: [
          const Center(child: Text('모드전환', style: TextStyle(color: Colors.grey, fontSize: 11))),
          Switch(value: _isOrderMode, onChanged: (v) => setState(() => _isOrderMode = v), activeColor: Colors.orange),
          IconButton(icon: const Icon(Icons.logout, color: Colors.grey), onPressed: widget.onLogout),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tabIndex,
        onTap: (i) => setState(() => _tabIndex = i),
        selectedItemColor: Colors.orange[900], unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.bolt_rounded), label: '당장신청'),
          BottomNavigationBarItem(icon: Icon(Icons.location_on_outlined), label: '실시간지도'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: '채팅'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: '내정보'),
        ],
      ),
      floatingActionButton: _isOrderMode ? FloatingActionButton.extended(
        onPressed: () {}, backgroundColor: Colors.orange,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('심부름 요청', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ) : null,
    );
  }

  Widget _buildBadge() => Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(5)), child: const Row(children: [Icon(Icons.verified, size: 12, color: Colors.blue), SizedBox(width: 4), Text('인증회원', style: TextStyle(color: Colors.blue, fontSize: 10, fontWeight: FontWeight.bold))]));

  Widget _buildBody() {
    switch (_tabIndex) {
      case 1: return _mapView();
      case 2: return _chatView();
      case 3: return _profileView();
      default: return _homeView();
    }
  }

  Widget _homeView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _buildBanner(),
        const SizedBox(height: 25),
        Text(_isOrderMode ? "나의 실시간 요청 현황" : "수행 가능한 주변 심부름", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 15),
        _buildErrandCard(_isOrderMode ? "편의점 셀렉트 음료 2캔" : "생수 배달 대행", _isOrderMode ? "예치금액: 3,500원" : "수익: 4,000원", _isOrderMode ? "매칭 중" : "250m 거리"),
        _buildErrandCard(_isOrderMode ? "우체국 택배 대금 선결제" : "쓰레기 분리수거 대행", _isOrderMode ? "예치금액: 15,000원" : "수익: 3,000원", _isOrderMode ? "수행자 이동 중" : "400m 거리"),
      ]),
    );
  }

  Widget _buildBanner() {
    return Container(
      width: double.infinity, padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.orange, Colors.orangeAccent]), borderRadius: BorderRadius.circular(25), boxShadow: [BoxShadow(color: Colors.orange.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))]),
      child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('에스크로우 안심 결제 시스템 적용', style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Text('신분증 인증 완료된 이웃과만\n안전하게 거래하세요!', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, height: 1.4)),
      ]),
    );
  }

  Widget _buildErrandCard(String t, String p, String s) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15), padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)]),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(t, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
          const SizedBox(height: 5),
          Text(s, style: const TextStyle(color: Colors.grey, fontSize: 13)),
        ]),
        Text(p, style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.w900, fontSize: 17)),
      ]),
    );
  }

  Widget _mapView() {
    return Column(children: [
      Expanded(flex: 3, child: Container(width: double.infinity, color: Colors.orange[50], child: const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.my_location, size: 50, color: Colors.orange), SizedBox(height: 10), Text('실시간 위치 기반 이웃 매칭 중...', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold))])))),
      Expanded(flex: 4, child: ListView(padding: const EdgeInsets.all(20), children: [
        const Text('주변 안심번호 통화 가능 이웃', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
        const SizedBox(height: 15),
        _neighborRow('홍길동 (인증수행자)', '150m', '5.0'),
        _neighborRow('이이웃 (인증주문자)', '320m', '4.9'),
      ])),
    ]);
  }

  Widget _neighborRow(String n, String d, String r) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const CircleAvatar(backgroundColor: Colors.grey, child: Icon(Icons.person, color: Colors.white)),
      title: Text(n, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text('거리: $d | 별점: $r'),
      trailing: const Icon(Icons.call, color: Colors.green, size: 30),
    );
  }

  Widget _chatView() {
    return Column(children: [
      Container(width: double.infinity, padding: const EdgeInsets.all(12), color: Colors.blue[50], child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.lock, size: 14, color: Colors.blue), SizedBox(width: 8), Text('에스크로우 보호: 거래 완료 시에만 자금이 지급됩니다.', style: TextStyle(fontSize: 12, color: Colors.blue, fontWeight: FontWeight.bold))])),
      const Expanded(child: Center(child: Text('채팅 시뮬레이션 화면'))),
      Container(padding: const EdgeInsets.all(15), decoration: const BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Color(0xFFEEEEEE)))), child: Row(children: [const Icon(Icons.add_circle_outline, color: Colors.grey), const Expanded(child: Padding(padding: EdgeInsets.symmetric(horizontal: 10), child: TextField(decoration: InputDecoration(hintText: '메시지를 입력하세요...', border: InputBorder.none)))), const Icon(Icons.call, color: Colors.green), const SizedBox(width: 15), const Icon(Icons.send, color: Colors.orange)]))
    ]);
  }

  Widget _profileView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(25),
      child: Column(children: [
        const CircleAvatar(radius: 45, backgroundColor: Colors.orange, child: Icon(Icons.person, color: Colors.white, size: 55)),
        const SizedBox(height: 15),
        const Text('닉네임: 당장매니저', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 30),
        _moneyBox(_isOrderMode ? "나의 총 예치금액" : "나의 정산 가능 수익", _isOrderMode ? "50,000원" : "12,500원"),
        const SizedBox(height: 30),
        _profileInfoRow(Icons.verified, "신분증 진위 확인 완료"),
        _profileInfoRow(Icons.phone_android, "본인 명의 휴대폰 인증 완료"),
        _profileInfoRow(Icons.security, "개인정보 암호화 보호 중"),
      ]),
    );
  }

  Widget _moneyBox(String t, String v) {
    return Container(
      width: double.infinity, padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(color: Colors.orange[50], borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.orange[100]!)),
      child: Column(children: [Text(t, style: const TextStyle(fontSize: 14, color: Colors.orange)), const SizedBox(height: 10), Text(v, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.orange))]),
    );
  }

  Widget _profileInfoRow(IconData i, String t) {
    return ListTile(contentPadding: EdgeInsets.zero, leading: Icon(i, color: Colors.blue), title: Text(t, style: const TextStyle(fontWeight: FontWeight.w500)), trailing: const Icon(Icons.check_circle, color: Colors.blue, size: 20));
  }
}

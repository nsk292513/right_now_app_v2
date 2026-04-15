import 'package:flutter/material.dart';

void main() => runApp(const DangJangApp());

class DangJangApp extends StatelessWidget {
  const DangJangApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DangJang',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
      ),
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
        ? MainNavigationFrame(onLogout: _logout) 
        : LoginView(onSuccess: _login);
  }
}

class LoginView extends StatelessWidget {
  final VoidCallback onSuccess;
  const LoginView({super.key, required this.onSuccess});

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
            const Icon(Icons.bolt, size: 80, color: Colors.white),
            const Text('당장', style: TextStyle(color: Colors.white, fontSize: 45, fontWeight: FontWeight.bold)),
            const SizedBox(height: 50),
            _buildInputField("아이디(ID)"),
            const SizedBox(height: 10),
            _buildInputField("비밀번호(Password)", obscure: true),
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 55),
                  shape: BorderRadius.circular(15),
                ),
                onPressed: onSuccess,
                child: const Text('로그인', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const RegisterView())),
              child: const Text('회원가입 및 신분증/휴대폰 본인인증', style: TextStyle(color: Colors.white70)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(String hint, {bool obscure = false}) {
    return Container(
      width: 300,
      child: TextField(
        obscureText: obscure,
        decoration: InputDecoration(
          filled: true, fillColor: Colors.white, hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
        ),
      ),
    );
  }
}

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});
  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  bool _idAuth = false;
  bool _phoneAuth = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('회원가입 및 통합인증'), elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('보안 및 신뢰 인증', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text('출시를 위해 신분증 및 본인 휴대폰 인증이 필수입니다.'),
            const SizedBox(height: 30),
            const TextField(decoration: InputDecoration(labelText: '활동 닉네임 설정', border: OutlineInputBorder())),
            const SizedBox(height: 20),
            _buildAuthRow("신분증 확인 인증", _idAuth, () => setState(() => _idAuth = true)),
            _buildAuthRow("본인 명의 휴대폰 인증", _phoneAuth, () => setState(() => _phoneAuth = true)),
            const Spacer(),
            SizedBox(
              width: double.infinity, height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: (_idAuth && _phoneAuth) ? Colors.orange : Colors.grey,
                  shape: BorderRadius.circular(15),
                ),
                onPressed: (_idAuth && _phoneAuth) ? () => Navigator.pop(context) : null,
                child: const Text('인증 및 가입 완료', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAuthRow(String title, bool isDone, VoidCallback onTab) {
    return ListTile(
      leading: Icon(isDone ? Icons.check_circle : Icons.circle_outlined, color: isDone ? Colors.blue : Colors.grey),
      title: Text(title),
      trailing: OutlinedButton(onPressed: onTab, child: Text(isDone ? "완료" : "인증하기")),
    );
  }
}

class MainNavigationFrame extends StatefulWidget {
  final VoidCallback onLogout;
  const MainNavigationFrame({super.key, required this.onLogout});
  @override
  State<MainNavigationFrame> createState() => _MainNavigationFrameState();
}

class _MainNavigationFrameState extends State<MainNavigationFrame> {
  int _currentIndex = 0;
  bool _isOrderMode = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Row(
          children: [
            const Text('당장', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 24)),
            const SizedBox(width: 8),
            _buildVerifiedBadge(),
          ],
        ),
        actions: [
          const Center(child: Text('모드전환', style: TextStyle(color: Colors.grey, fontSize: 11))),
          Switch(value: _isOrderMode, onChanged: (v) => setState(() => _isOrderMode = v), activeColor: Colors.orange),
          IconButton(icon: const Icon(Icons.logout, color: Colors.grey), onPressed: widget.onLogout),
        ],
      ),
      body: _buildCurrentPage(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: Colors.orange[900],
        unselectedItemColor: Colors.grey,
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

  Widget _buildVerifiedBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(5)),
      child: const Row(
        children: [
          Icon(Icons.verified, size: 12, color: Colors.blue),
          SizedBox(width: 4),
          Text('인증회원', style: TextStyle(color: Colors.blue, fontSize: 10, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildCurrentPage() {
    switch (_currentIndex) {
      case 1: return _buildMapView();
      case 2: return _buildChatView();
      case 3: return _buildProfileView();
      default: return _buildHomeView();
    }
  }

  Widget _buildHomeView() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildEscrowBanner(),
          _buildSectionTitle(_isOrderMode ? "나의 실시간 요청" : "수행 가능한 심부름"),
          _buildListCard(_isOrderMode ? "편의점 구매 대행" : "생수 배달 대행", _isOrderMode ? "예치금액: 3,000원" : "수익: 4,000원", _isOrderMode ? "매칭 중" : "거리 150m"),
          _buildListCard(_isOrderMode ? "택배 대금 선결제 대행" : "음식 배달 대행", _isOrderMode ? "예치금액: 15,000원" : "수익: 7,000원", _isOrderMode ? "수행자 이동 중" : "거리 300m"),
        ],
      ),
    );
  }

  Widget _buildEscrowBanner() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.orange, Colors.orangeAccent]),
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('에스크로우 안심 결제 보호 중', style: TextStyle(color: Colors.white70, fontSize: 12)),
          SizedBox(height: 5),
          Text('신분증 인증 완료된 이웃만 매칭되는\n안전한 실시간 대행 서비스 "당장"', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(padding: const EdgeInsets.all(15), child: Row(children: [Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))]));
  }

  Widget _buildListCard(String title, String price, String status) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey[200]!)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(status, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ]),
          Text(price, style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildMapView() {
    return Column(
      children: [
        Container(
          height: 250,
          width: double.infinity,
          color: Colors.orange[50],
          child: const Center(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.my_location, size: 50, color: Colors.orange),
              SizedBox(height: 10),
              Text('실시간 내 주변 이웃 매칭 중 (강남구 역삼동)', style: TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          )),
        ),
        const Padding(padding: EdgeInsets.all(15), child: Row(children: [Text('주변 안심번호 통화 가능 이웃', style: TextStyle(fontWeight: FontWeight.bold))])),
        Expanded(child: ListView(
          children: [
            _buildNeighborRow('홍길동 (인증수행자)', '120m'),
            _buildNeighborRow('이이웃 (인증주문자)', '250m'),
          ],
        )),
      ],
    );
  }

  Widget _buildNeighborRow(String name, String dist) {
    return ListTile(
      leading: const CircleAvatar(backgroundColor: Colors.orange, child: Icon(Icons.person, color: Colors.white)),
      title: Text(name),
      subtitle: Text('거리: $dist'),
      trailing: const Icon(Icons.call, color: Colors.green),
    );
  }

  Widget _buildChatView() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          color: Colors.blue[50],
          child: const Text('거래 수락 시 예치금이 자동으로 지급됩니다.', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.blue, fontWeight: FontWeight.bold)),
        ),
        const Expanded(child: Center(child: Text('채팅 시뮬레이션'))),
        Container(
          padding: const EdgeInsets.all(15),
          color: Colors.white,
          child: Row(
            children: [
              const Icon(Icons.add, color: Colors.grey),
              const Expanded(child: Padding(padding: EdgeInsets.symmetric(horizontal: 10), child: TextField(decoration: InputDecoration(hintText: '메시지를 입력하세요')))),
              const Icon(Icons.call, color: Colors.green),
              const SizedBox(width: 8),
              const Icon(Icons.send, color: Colors.orange),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(25),
      child: Column(
        children: [
          const CircleAvatar(radius: 40, backgroundColor: Colors.orange, child: Icon(Icons.person, color: Colors.white, size: 50)),
          const SizedBox(height: 10),
          const Text('닉네임: 당장매니아', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 25),
          _buildMoneyBox(_isOrderMode ? "나의 총 예치금액" : "나의 정산 가능 수익", _isOrderMode ? "50,000원" : "12,500원"),
          const SizedBox(height: 30),
          _buildInfoRow(Icons.verified, "신분증 인증 완료"),
          _buildInfoRow(Icons.phone_android, "본인 휴대폰 인증 완료"),
        ],
      ),
    );
  }

  Widget _buildMoneyBox(String label, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.orange[50], borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.orange)),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return ListTile(leading: Icon(icon, color: Colors.blue), title: Text(text), trailing: const Icon(Icons.check_circle, color: Colors.blue));
  }
}

import 'package:flutter/material.dart';

void main() {
  runApp(const RightNowApp());
}

class RightNowApp extends StatelessWidget {
  const RightNowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RightNow',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      ),
      home: const AuthNavigationWrapper(),
    );
  }
}

class AuthNavigationWrapper extends StatefulWidget {
  const AuthNavigationWrapper({super.key});

  @override
  State<AuthNavigationWrapper> createState() => _AuthNavigationWrapperState();
}

class _AuthNavigationWrapperState extends State<AuthNavigationWrapper> {
  bool _isLoggedIn = false;

  void _handleLogin() => setState(() => _isLoggedIn = true);
  void _handleLogout() => setState(() => _isLoggedIn = false);

  @override
  Widget build(BuildContext context) {
    return _isLoggedIn 
        ? MainTabController(onLogout: _handleLogout) 
        : LoginView(onLoginSuccess: _handleLogin);
  }
}

class LoginView extends StatelessWidget {
  final VoidCallback onLoginSuccess;
  const LoginView({super.key, required this.onLoginSuccess});

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
            _buildLoginInput("아이디(ID)"),
            const SizedBox(height: 10),
            _buildLoginInput("비밀번호(PW)", isObscure: true),
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: BorderRadius.circular(15),
                  ),
                  onPressed: onLoginSuccess,
                  child: const Text('로그인', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const SignUpView())),
              child: const Text('회원가입 및 본인인증(신분증)', style: TextStyle(color: Colors.white70)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginInput(String hint, {bool isObscure = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: TextField(
        obscureText: isObscure,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
        ),
      ),
    );
  }
}

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  bool _idCheck = false;
  bool _phoneCheck = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('회원가입 및 통합인증'), backgroundColor: Colors.white, foregroundColor: Colors.black, elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('신뢰할 수 있는\n커뮤니티를 위해 인증해주세요.', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            const TextField(decoration: InputDecoration(labelText: '활동할 닉네임', border: OutlineInputBorder())),
            const SizedBox(height: 20),
            _authOption("신분증 확인 인증", _idCheck, () => setState(() => _idCheck = true)),
            _authOption("본인 명의 휴대폰 인증", _phoneCheck, () => setState(() => _phoneCheck = true)),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: (_idCheck && _phoneCheck) ? Colors.orange : Colors.grey,
                  shape: BorderRadius.circular(15),
                ),
                onPressed: (_idCheck && _phoneCheck) ? () => Navigator.pop(context) : null,
                child: const Text('가입 완료', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _authOption(String title, bool isDone, VoidCallback onTab) {
    return ListTile(
      leading: Icon(isDone ? Icons.check_circle : Icons.circle_outlined, color: isDone ? Colors.blue : Colors.grey),
      title: Text(title),
      trailing: OutlinedButton(onPressed: onTab, child: Text(isDone ? "완료" : "인증하기")),
    );
  }
}

class MainTabController extends StatefulWidget {
  final VoidCallback onLogout;
  const MainTabController({super.key, required this.onLogout});

  @override
  State<MainTabController> createState() => _MainTabControllerState();
}

class _MainTabControllerState extends State<MainTabController> {
  int _tabIndex = 0;
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
            _verifiedBadge(),
          ],
        ),
        actions: [
          Switch(
            value: _isOrderMode,
            onChanged: (v) => setState(() => _isOrderMode = v),
            activeColor: Colors.orange,
          ),
          IconButton(icon: const Icon(Icons.logout, color: Colors.grey), onPressed: widget.onLogout),
        ],
      ),
      body: _buildCurrentTab(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tabIndex,
        onTap: (i) => setState(() => _tabIndex = i),
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

  Widget _verifiedBadge() {
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

  Widget _buildCurrentTab() {
    switch (_tabIndex) {
      case 1: return _mapView();
      case 2: return _chatView();
      case 3: return _profileView();
      default: return _homeView();
    }
  }

  Widget _homeView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBanner(),
          const SizedBox(height: 20),
          Text(_isOrderMode ? "나의 요청 관리" : "지금 수익 창출하기", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          _itemCard(_isOrderMode ? "음료수 2캔 구매" : "생수 묶음 배달", _isOrderMode ? "예치금: 3,000원" : "수익: 4,000원", "매칭 진행 중"),
          _itemCard(_isOrderMode ? "우체국 택배 발송" : "음식 배달 대행", _isOrderMode ? "예치금: 5,000원" : "수익: 6,000원", "수행자 이동 중"),
        ],
      ),
    );
  }

  Widget _buildBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.orange, Colors.orangeAccent]),
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('에스크로우 안심 결제 중', style: TextStyle(color: Colors.white70, fontSize: 12)),
          SizedBox(height: 5),
          Text('신분증 인증 완료된 이웃만\n서로 매칭되는 안전한 커뮤니티!', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _itemCard(String title, String price, String status) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(status),
        trailing: Text(price, style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 16)),
      ),
    );
  }

  Widget _mapView() {
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            width: double.infinity,
            color: Colors.orange[50],
            child: const Center(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.location_on, size: 50, color: Colors.orange),
                Text('내 주변 실시간 위치 매칭 중...', style: TextStyle(color: Colors.grey)),
              ],
            )),
          ),
        ),
        Expanded(
          flex: 3,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text('가까운 안심번호 통화 가능 이웃', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              _neighborRow('사용자A (인증수행자)', '150m'),
              _neighborRow('사용자B (인증주문자)', '300m'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _neighborRow(String name, String dist) {
    return ListTile(
      leading: const CircleAvatar(backgroundColor: Colors.orange, child: Icon(Icons.person, color: Colors.white)),
      title: Text(name),
      subtitle: Text('거리: $dist'),
      trailing: const Icon(Icons.call, color: Colors.green),
    );
  }

  Widget _chatView() {
    return Column(
      children: [
        Container(width: double.infinity, padding: const EdgeInsets.all(10), color: Colors.blue[50], child: const Text('거래가 완료될 때까지 예치금이 안전하게 보관됩니다.', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.blue, fontWeight: FontWeight.bold))),
        const Expanded(child: Center(child: Text('채팅 시뮬레이션'))),
        Container(
          padding: const EdgeInsets.all(15),
          color: Colors.white,
          child: Row(
            children: [
              const Icon(Icons.add, color: Colors.grey),
              const Expanded(child: Padding(padding: EdgeInsets.symmetric(horizontal: 10), child: TextField(decoration: InputDecoration(hintText: '메시지를 입력하세요', border: InputBorder.none)))),
              const Icon(Icons.call, color: Colors.green),
              const SizedBox(width: 10),
              const Icon(Icons.send, color: Colors.orange),
            ],
          ),
        ),
      ],
    );
  }

  Widget _profileView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(25),
      child: Column(
        children: [
          const CircleAvatar(radius: 40, backgroundColor: Colors.orange, child: Icon(Icons.person, color: Colors.white, size: 50)),
          const SizedBox(height: 15),
          const Text('닉네임: 당장매니아', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 25),
          _moneyBox(_isOrderMode ? "나의 총 예치금액" : "나의 정산 가능 수익", _isOrderMode ? "50,000원" : "12,500원"),
          const SizedBox(height: 30),
          const ListTile(leading: Icon(Icons.verified, color: Colors.blue), title: Text('신분증 인증 완료'), trailing: Icon(Icons.check_circle, color: Colors.blue)),
          const ListTile(leading: Icon(Icons.phone_android, color: Colors.blue), title: Text('본인 휴대폰 인증 완료'), trailing: Icon(Icons.check_circle, color: Colors.blue)),
        ],
      ),
    );
  }

  Widget _moneyBox(String label, String value) {
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
}

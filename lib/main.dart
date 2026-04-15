import 'package:flutter/material.dart';

void main() => runApp(const DangJangApp());

class DangJangApp extends StatelessWidget {
  const DangJangApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.orange, fontFamily: 'Pretendard'),
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

  @override
  Widget build(BuildContext context) {
    return _isLoggedIn ? MainNavigation(onLogout: () => setState(() => _isLoggedIn = false)) : LoginScreen(onLoginSuccess: _login);
  }
}

class LoginScreen extends StatelessWidget {
  final VoidCallback onLoginSuccess;
  const LoginScreen({super.key, required this.onLoginSuccess});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(30),
        width: double.infinity,
        decoration: const BoxDecoration(gradient: LinearGradient(colors: [Colors.orange, Colors.deepOrange])),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.bolt, size: 80, color: Colors.white),
            const Text('당장', style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.black)),
            const SizedBox(height: 50),
            TextField(decoration: InputDecoration(filled: true, fillColor: Colors.white, hintText: '아이디', border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)))),
            const SizedBox(height: 10),
            TextField(obscureText: true, decoration: InputDecoration(filled: true, fillColor: Colors.white, hintText: '비밀번호', border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)))),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black, shape: BorderRadius.circular(15)),
                onPressed: onLoginSuccess,
                child: const Text('로그인', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterScreen())),
              child: const Text('처음이신가요? 회원가입하기', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _isIdVerified = false;
  bool _isPhoneVerified = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('회원가입 및 인증'), elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('안전한 거래를 위해\n본인 인증이 필요합니다.', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            TextField(decoration: InputDecoration(labelText: '사용할 닉네임', hintText: '활동할 닉네임을 입력하세요', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)))),
            const SizedBox(height: 20),
            _authTile('신분증 인증', _isIdVerified, () => setState(() => _isIdVerified = true)),
            _authTile('본인 명의 휴대폰 인증', _isPhoneVerified, () => setState(() => _isPhoneVerified = true)),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: (_isIdVerified && _isPhoneVerified) ? Colors.orange : Colors.grey, shape: BorderRadius.circular(15)),
                onPressed: (_isIdVerified && _isPhoneVerified) ? () => Navigator.pop(context) : null,
                child: const Text('가입 완료', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _authTile(String t, bool isDone, VoidCallback onTap) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(isDone ? Icons.check_circle : Icons.circle_outlined, color: isDone ? Colors.blue : Colors.grey),
      title: Text(t),
      trailing: OutlinedButton(onPressed: onTap, child: Text(isDone ? '완료' : '인증하기')),
    );
  }
}

class MainNavigation extends StatefulWidget {
  final VoidCallback onLogout;
  const MainNavigation({super.key, required this.onLogout});
  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _idx = 0;
  bool _isOrderMode = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(children: [const Text('당장', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)), const SizedBox(width: 8), _badge()]),
        actions: [
          Switch(value: _isOrderMode, onChanged: (v) => setState(() => _isOrderMode = v), activeColor: Colors.orange),
          IconButton(icon: const Icon(Icons.exit_to_app, color: Colors.grey), onPressed: widget.onLogout),
        ],
      ),
      body: _body(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _idx,
        onTap: (i) => setState(() => _idx = i),
        selectedItemColor: Colors.orange[900],
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.bolt), label: '당장신청'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: '주변지도'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: '채팅'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '내정보'),
        ],
      ),
    );
  }

  Widget _badge() => Container(padding: const EdgeInsets.all(4), decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(5)), child: const Text('인증회원', style: TextStyle(color: Colors.blue, fontSize: 10, fontWeight: FontWeight.bold)));

  Widget _body() {
    if (_idx == 3) return _profilePage();
    return Center(child: Text(_isOrderMode ? '주문자 모드 활성화' : '수행자 모드 활성화'));
  }

  Widget _profilePage() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(children: [
        const CircleAvatar(radius: 40, backgroundColor: Colors.orange, child: Icon(Icons.person, color: Colors.white, size: 50)),
        const SizedBox(height: 10),
        const Text('닉네임: 당장매니아', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        _moneyBox(_isOrderMode ? '예치금액' : '정산가능금액', _isOrderMode ? '50,000원' : '12,500원'),
        const Divider(height: 40),
        const ListTile(leading: Icon(Icons.verified, color: Colors.blue), title: Text('신분증 및 본인인증 완료')),
      ]),
    );
  }

  Widget _moneyBox(String t, String v) => Container(width: double.infinity, padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.orange[50], borderRadius: BorderRadius.circular(15)), child: Column(children: [Text(t), Text(v, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.orange))]));
}

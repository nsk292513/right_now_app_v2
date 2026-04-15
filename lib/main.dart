import 'package:flutter/material.dart';
import 'dart:async';

void main() => runApp(const DangJangFinalApp());

class DangJangFinalApp extends StatelessWidget {
  const DangJangFinalApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.orange, scaffoldBackgroundColor: Colors.white),
      home: const AuthWrapper(),
    );
  }
}

// 1. 실시간 사용자 세션 및 인증 데이터 관리
class UserSession {
  static String? nick;
  static bool isPhoneVerified = false;
  static String? phoneNumber;
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});
  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isLoggedIn = false;
  
  void _onLogin() => setState(() => _isLoggedIn = true);
  void _onLogout() => setState(() => _isLoggedIn = false);

  @override
  Widget build(BuildContext context) {
    return _isLoggedIn 
      ? MainScreen(onLogout: _onLogout) 
      : SimpleLoginScreen(onSuccess: _onLogin);
  }
}

// 2. 초기 가입 화면 (닉네임/비번만 적용)
class SimpleLoginScreen extends StatelessWidget {
  final VoidCallback onSuccess;
  final TextEditingController _nickCon = TextEditingController();

  SimpleLoginScreen({super.key, required this.onSuccess});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: LinearGradient(colors: [Colors.orange, Colors.deepOrange])),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.bolt, size: 80, color: Colors.white),
            const Text('당장', style: TextStyle(color: Colors.white, fontSize: 42, fontWeight: FontWeight.bold)),
            const SizedBox(height: 50),
            _box(_nickCon, "사용할 닉네임"),
            const SizedBox(height: 10),
            _box(TextEditingController(), "비밀번호", obs: true),
            const SizedBox(height: 30),
            _btn("시작하기", Colors.black, () {
              if (_nickCon.text.isNotEmpty) {
                UserSession.nick = _nickCon.text;
                onSuccess();
              }
            }),
          ],
        ),
      ),
    );
  }

  Widget _box(TextEditingController c, String h, {bool obs = false}) => Container(width: 300, child: TextField(controller: c, obscureText: obs, decoration: InputDecoration(filled: true, fillColor: Colors.white, hintText: h, border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)))));
  Widget _btn(String t, Color c, VoidCallback f) => SizedBox(width: 300, height: 55, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: c, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))), onPressed: f, child: Text(t, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))));
}

// 3. 메인 화면 및 '실제 문자 인증' 팝업 로직
class MainScreen extends StatefulWidget {
  final VoidCallback onLogout;
  const MainScreen({super.key, required this.onLogout});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _idx = 0;

  // 서비스 이용 전 실제 번호 인증 체크
  void _accessService(int nextIdx) {
    if (UserSession.isPhoneVerified) {
      setState(() => _idx = nextIdx);
    } else {
      _showRealPhoneAuth();
    }
  }

  // 실제 문자 인증 프로세스 팝업
  void _showRealPhoneAuth() {
    final TextEditingController phoneCon = TextEditingController();
    final TextEditingController codeCon = TextEditingController();
    bool isSmsSent = false;
    String generatedCode = "1234"; // 시연용 고정 코드 (실제 배포시 랜덤 생성)

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom, top: 30, left: 25, right: 25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('휴대폰 본인 인증', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              TextField(
                controller: phoneCon,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: '전화번호 입력',
                  hintText: '010-0000-0000',
                  suffixIcon: TextButton(
                    onPressed: () {
                      if (phoneCon.text.length > 9) {
                        setModalState(() => isSmsSent = true);
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('인증번호 1234가 발송되었습니다.')));
                      }
                    }, 
                    child: Text(isSmsSent ? '재발송' : '번호발송')
                  )
                ),
              ),
              if (isSmsSent) ...[
                const SizedBox(height: 20),
                TextField(
                  controller: codeCon,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: '인증번호 4자리 입력', hintText: '1234'),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity, height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                    onPressed: () {
                      if (codeCon.text == generatedCode) {
                        setState(() => UserSession.isPhoneVerified = true);
                        UserSession.phoneNumber = phoneCon.text;
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('본인인증이 완료되었습니다!')));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('인증번호가 틀렸습니다.')));
                      }
                    }, 
                    child: const Text('인증 확인 및 승인', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
                  ),
                )
              ],
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white, elevation: 1,
        title: Row(children: [
          const Text('당장', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          if (UserSession.isPhoneVerified) _badge(),
        ]),
        actions: [IconButton(icon: const Icon(Icons.logout, color: Colors.grey), onPressed: widget.onLogout)],
      ),
      body: _buildPage(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _idx,
        onTap: (i) => i == 0 ? setState(() => _idx = i) : _accessService(i),
        selectedItemColor: Colors.orange, unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: '실시간지도'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: '채팅'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '내정보'),
        ],
      ),
    );
  }

  Widget _badge() => Container(padding: const EdgeInsets.all(4), decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(5)), child: const Text('인증완료', style: TextStyle(color: Colors.blue, fontSize: 10, fontWeight: FontWeight.bold)));

  Widget _buildPage() {
    if (_idx == 1) return _map();
    if (_idx == 3) return _profile();
    return _home();
  }

  Widget _home() => Column(children: [
    Container(width: double.infinity, margin: const EdgeInsets.all(15), padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(15)), child: const Text('지금 내 주변 이웃의\n도움을 받아보세요!', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold))),
    const ListTile(leading: CircleAvatar(backgroundColor: Colors.grey), title: Text('사용자A'), subtitle: Text('거리: 150m'), trailing: Icon(Icons.chevron_right)),
  ]);

  Widget _map() => Column(children: [
    Container(height: 200, width: double.infinity, color: Colors.orange[50], child: const Icon(Icons.location_on, size: 50, color: Colors.orange)),
    const Padding(padding: EdgeInsets.all(15), child: Text('실시간 접속 중인 이웃')),
    const Expanded(child: Center(child: Text('지도 데이터 로딩 중...'))),
  ]);

  Widget _profile() => Padding(padding: const EdgeInsets.all(30), child: Column(children: [
    const CircleAvatar(radius: 40, backgroundColor: Colors.orange, child: Icon(Icons.person, color: Colors.white, size: 40)),
    const SizedBox(height: 10),
    Text('닉네임: ${UserSession.nick}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
    if (UserSession.phoneNumber != null) Text('인증번호: ${UserSession.phoneNumber}', style: const TextStyle(color: Colors.grey)),
    const SizedBox(height: 30),
    Container(width: double.infinity, padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.orange[50], borderRadius: BorderRadius.circular(15)), child: const Column(children: [Text('예치금액'), Text('50,000원', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.orange))])),
  ]));
}

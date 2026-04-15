import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:geolocator/geolocator.dart'; // GPS 기능
import 'package:permission_handler/permission_handler.dart'; // 권한 관리

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // 파이어베이스 초기화
  runApp(const DangJangApp());
}

class DangJangApp extends StatelessWidget {
  const DangJangApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '당장(Right Now)',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      home: const AuthWrapper(),
    );
  }
}

// [로그인 상태 감시자]
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) return const MainServiceScreen(); // 로그인 완료 시 메인으로
        return const LoginSelectionScreen(); // 미로그인 시 로그인 화면으로
      },
    );
  }
}

// -------------------------------------------------------------------
// 1. 통합 로그인 화면 (구글 로그인 + SMS 인증 진입)
// -------------------------------------------------------------------
class LoginSelectionScreen extends StatefulWidget {
  const LoginSelectionScreen({super.key});

  @override
  State<LoginSelectionScreen> createState() => _LoginSelectionScreenState();
}

class _LoginSelectionScreenState extends State<LoginSelectionScreen> {
  final TextEditingController _phoneController = TextEditingController();
  bool _isSending = false;

  // [기능 1] 실제 구글 로그인 로직
  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      _showError("구글 로그인 실패: $e");
    }
  }

  // [기능 2] 실제 SMS 문자 인증 번호 발송
  Future<void> _verifyPhoneNumber() async {
    String phone = _phoneController.text.trim();
    if (phone.isEmpty) return;
    
    setState(() => _isSending = true);
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone, // 예: +821012345678
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        _showError("인증 실패: ${e.message}");
        setState(() => _isSending = false);
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() => _isSending = false);
        _showOtpDialog(verificationId); // 번호 발송 후 입력창 띄움
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  void _showOtpDialog(String vId) {
    final otpController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("인증번호 입력"),
        content: TextField(controller: otpController, keyboardType: TextInputType.number),
        actions: [
          TextButton(onPressed: () async {
            final credential = PhoneAuthProvider.credential(
              verificationId: vId,
              smsCode: otpController.text.trim(),
            );
            await FirebaseAuth.instance.signInWithCredential(credential);
            Navigator.pop(context);
          }, child: const Text("확인"))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              const Text("당장", style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Colors.blue)),
              const SizedBox(height: 50),
              // 구글 로그인 버튼
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _signInWithGoogle,
                  icon: const Icon(Icons.login),
                  label: const Text("구글 계정으로 시작"),
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 15)),
                ),
              ),
              const SizedBox(height: 20),
              const Text("또는"),
              const SizedBox(height: 20),
              // 휴대폰 인증 입력창
              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: "휴대폰 번호 (+8210...)"),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: _isSending ? null : _verifyPhoneNumber,
                  child: Text(_isSending ? "발송 중..." : "인증 문자 받기"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// -------------------------------------------------------------------
// 2. 메인 서비스 화면 (GPS 위치 추적 기능 탑재)
// -------------------------------------------------------------------
class MainServiceScreen extends StatefulWidget {
  const MainServiceScreen({super.key});

  @override
  State<MainServiceScreen> createState() => _MainServiceScreenState();
}

class _MainServiceScreenState extends State<MainServiceScreen> {
  String _locationStatus = "위치 정보를 가져오는 중...";
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _determinePosition(); // 앱 켜자마자 GPS 위치 파악 시작
  }

  // [기능 3] 실제 GPS 위치 좌표 획득 로직
  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() => _locationStatus = "GPS가 꺼져 있습니다.");
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() => _locationStatus = "위치 권한이 거부되었습니다.");
        return;
      }
    }

    // 실제 현재 위도, 경도 좌표 가져오기
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = position;
      _locationStatus = "위치 파악 완료";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("당장 - 서비스 센터"),
        actions: [IconButton(onPressed: () => FirebaseAuth.instance.signOut(), icon: const Icon(Icons.logout))],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // GPS 상태 카드
            Card(
              color: Colors.blue.shade50,
              child: ListTile(
                leading: const Icon(Icons.gps_fixed, color: Colors.blue),
                title: const Text("내 실시간 위치(GPS)"),
                subtitle: Text(_currentPosition == null 
                  ? _locationStatus 
                  : "위도: ${_currentPosition!.latitude}\n경도: ${_currentPosition!.longitude}"),
              ),
            ),
            const SizedBox(height: 20),
            // 긴급 버튼 서비스
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                children: [
                  _buildMenuCard("긴급 호출", Icons.warning, Colors.red),
                  _buildMenuCard("주변 병원", Icons.local_hospital, Colors.green),
                  _buildMenuCard("안심 귀가", Icons.home, Colors.orange),
                  _buildMenuCard("설정", Icons.settings, Colors.grey),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(String title, IconData icon, Color color) {
    return Card(
      child: InkWell(
        onTap: () {},
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

void main() => runApp(const RightNowApp());

class RightNowApp extends StatelessWidget {
  const RightNowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.orange),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('당장 (Right Now)', 
          style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 22)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: Center(child: Text('3,500P', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _banner(),
            _header("내 근처 실시간 심부름 🔥"),
            _card("편의점 음료수 2캔 사다주실 분!", "3,000원", "500m", "방금 전"),
            _card("우체국 택배 대신 보내주기", "5,000원", "800m", "3분 전"),
            _card("강아지 산책 15분만 도와주세요", "7,000원", "1.2km", "10분 전"),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.bolt), label: '당장신청'),
          BottomNavigationBarItem(icon: Icon(Icons.map_outlined), label: '주변지도'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: '채팅'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: '내정보'),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: Colors.orange,
        label: const Text('심부름 요청하기', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        icon: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _banner() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Colors.orange, Colors.redAccent]),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('누구나 수익을 만드는 앱테크', style: TextStyle(color: Colors.white70, fontSize: 14)),
          SizedBox(height: 8),
          Text('지금 바로 근처에서\n도움을 주고 돈을 벌어보세요!', 
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, height: 1.3)),
        ],
      ),
    );
  }

  Widget _header(String t) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(t, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const Text('전체보기', style: TextStyle(color: Colors.grey, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _card(String t, String p, String d, String tm) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.orange[50], shape: BoxShape.circle),
            child: const Icon(Icons.run_circle_outlined, color: Colors.orange),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 4),
                Text('$d | $tm', style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(p, style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 16)),
              const Text('지급확정', style: TextStyle(fontSize: 10, color: Colors.green, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

void main() => runApp(const RightNowApp());

class RightNowApp extends StatelessWidget {
  const RightNowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.orange, fontFamily: 'Pretendard'),
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
          style: TextStyle(color: Colors.orange, fontWeight: FontWeight.black, fontSize: 22)),
        centerTitle: false,
        actions: [
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.wallet, color: Colors.black54),
            label: const Text('3,500P ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildActionBanner(),
            _buildSectionHeader("내 근처 실시간 심부름 🔥"),
            _buildErrandCard("편의점 음료수 2캔 사다주실 분!", "3,000원", "500m 이내", "방금 전"),
            _buildErrandCard("우체국 택배 대신 보내주기", "5,000원", "800m 이내", "3분 전"),
            _buildErrandCard("강아지 산책 15분만 도와주세요", "7,000원", "1.2km 이내", "10분 전"),
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
        onPressed: () => _showRequestDialog(context),
        backgroundColor: Colors.orange,
        label: const Text('심부름 요청하기', style: TextStyle(fontWeight: FontWeight.bold)),
        icon: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildActionBanner() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Colors.orange, Colors.darkOrange]),
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

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const Text('전체보기', style: TextStyle(color: Colors.grey, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildErrandCard(String title, String price, String distance, String time) {
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
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text('$distance | $time', style: const TextStyle(color: Colors.grey, fontSize: 13)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(price, style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.black, fontSize: 17)),
              const Text('지급확정', style: TextStyle(fontSize: 10, color: Colors.green, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  void _showRequestDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('심부름 요청하기', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            const TextField(decoration: InputDecoration(hintText: '무엇을 도와드릴까요? (예: 음료수 사다주기)')),
            const SizedBox(height: 15),
            const TextField(decoration: InputDecoration(hintText: '사례금 입력 (원)'), keyboardType: TextInputType.number),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('요청이 게시되었습니다! 근처 이웃에게 알림을 보냅니다.')));
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                child: const Text('등록하기', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

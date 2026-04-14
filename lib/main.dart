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
        fontFamily: 'Pretendard',
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
      ),
      home: const MainNavigation(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});
  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  bool _isOrderMode = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Row(
          children: [
            const Text('당장', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.w900, fontSize: 26)),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(color: _isOrderMode ? Colors.blue[50] : Colors.green[50], borderRadius: BorderRadius.circular(5)),
              child: Text(_isOrderMode ? '주문자 모드' : '수수행자 모드', 
                style: TextStyle(color: _isOrderMode ? Colors.blue : Colors.green, fontSize: 12, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        actions: [
          const Center(child: Text('모드전환', style: TextStyle(color: Colors.grey, fontSize: 12))),
          Switch(
            value: _isOrderMode,
            onChanged: (v) => setState(() => _isOrderMode = v),
            activeColor: Colors.orange,
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildHome(),
          _buildMap(),
          _buildChat(),
          _buildProfile(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: Colors.orange[900],
        unselectedItemColor: Colors.grey[400],
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.bolt), label: '당장신청'),
          const BottomNavigationBarItem(icon: Icon(Icons.map_outlined), label: '주변지도'),
          BottomNavigationBarItem(
            icon: Badge(label: const Text('1'), child: const Icon(Icons.chat_bubble_outline)), 
            label: '채팅'
          ),
          const BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: '내정보'),
        ],
      ),
    );
  }

  Widget _buildHome() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeroBanner(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Text(_isOrderMode ? "나의 요청 현황" : "수행 가능한 심부름", 
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          if (_isOrderMode) ...[
            _buildCard("편의점 음료수 2캔", "3,000원", "매칭 대기 중", Icons.timer_outlined, Colors.orange),
            _buildCard("우체국 택배 대행", "5,000원", "결제 완료", Icons.check_circle, Colors.blue),
          ] else ...[
            _buildCard("생수 묶음 배달", "4,000원", "250m 이내", Icons.location_on, Colors.green),
            _buildCard("강아지 산책 도우미", "10,000원", "600m 이내", Icons.pets, Colors.brown),
            _buildCard("쓰레기 분리수거", "3,000원", "150m 이내", Icons.delete_outline, Colors.grey),
          ],
        ],
      ),
    );
  }

  Widget _buildHeroBanner() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: _isOrderMode ? [Colors.blue[400]!, Colors.blue[700]!] : [Colors.orange[400]!, Colors.orange[800]!]),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_isOrderMode ? '누군가의 도움이 필요한가요?' : '지금 바로 수익을 만드세요', 
            style: const TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 8),
          Text(_isOrderMode ? '당장 요청하고\n시간을 아끼세요!' : '내 주변 심부름\n오늘의 앱테크 시작!', 
            style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold, height: 1.3)),
        ],
      ),
    );
  }

  Widget _buildCard(String t, String p, String s, IconData i, Color c) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)]),
      child: Row(
        children: [
          CircleAvatar(backgroundColor: c.withOpacity(0.1), child: Icon(i, color: c)),
          const SizedBox(width: 15),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(t, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text(s, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
          ])),
          Text(p, style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.black, fontSize: 17)),
        ],
      ),
    );
  }

  Widget _buildMap() {
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            width: double.infinity,
            color: Colors.orange[50],
            child: const Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.my_location, size: 40, color: Colors.orange),
              SizedBox(height: 10),
              Text('실시간 내 주변 지도 (강남구 역삼동)', style: TextStyle(fontWeight: FontWeight.bold)),
            ]),
          ),
        ),
        Expanded(
          flex: 3,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Text('가까운 거리순 이웃', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 15),
              _buildUserRow('김당장 (수행자)', '200m', '별점 5.0'),
              _buildUserRow('이이웃 (주문자)', '350m', '별점 4.9'),
              _buildUserRow('박번개 (수행자)', '500m', '별점 4.8'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUserRow(String n, String d, String s) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(children: [
        const CircleAvatar(backgroundImage: NetworkImage('https://via.placeholder.com/150')),
        const SizedBox(width: 15),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(n, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text('$d | $s', style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ]),
        const Spacer(),
        OutlinedButton(onPressed: () {}, child: const Text('지정요청')),
      ]),
    );
  }

  Widget _buildChat() {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _chatBubble('주문자', '편의점에서 콜라 2캔 맞으시죠?', '오후 2:10', false),
              _chatBubble('수행자', '네 맞습니다! 지금 구매 완료했어요.', '오후 2:12', true),
              _chatBubble('주문자', '감사합니다. 도착하시면 수락 눌러드릴게요!', '오후 2:13', false),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(15),
          color: Colors.white,
          child: Row(children: [
            const Icon(Icons.add_circle_outline, color: Colors.grey),
            const Expanded(child: Padding(padding: EdgeInsets.symmetric(horizontal: 10), child: TextField(decoration: InputDecoration(hintText: '메시지 입력...', border: InputBorder.none)))),
            const Icon(Icons.send, color: Colors.orange),
          ]),
        ),
      ],
    );
  }

  Widget _chatBubble(String sender, String msg, String time, bool isMe) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(sender, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: isMe ? Colors.orange : Colors.grey[200], borderRadius: BorderRadius.circular(15)),
            child: Text(msg, style: TextStyle(color: isMe ? Colors.white : Colors.black)),
          ),
          const SizedBox(height: 2),
          Text(time, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildProfile() {
    return const Center(child: Text('프로필 및 정산 관리 화면'));
  }
}

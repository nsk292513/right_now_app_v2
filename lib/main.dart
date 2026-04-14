import 'package:flutter/material.dart';

void main() => runApp(const DangJangApp());

class DangJangApp extends StatelessWidget {
  const DangJangApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '당장',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        fontFamily: 'Pretendard',
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
      ),
      home: const MainAppNavigation(),
    );
  }
}

class MainAppNavigation extends StatefulWidget {
  const MainAppNavigation({super.key});
  @override
  State<MainAppNavigation> createState() => _MainAppNavigationState();
}

class _MainAppNavigationState extends State<MainAppNavigation> {
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
            const Text('당장', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.w900, fontSize: 26)),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(color: _isOrderMode ? Colors.blue[50] : Colors.orange[50], borderRadius: BorderRadius.circular(5)),
              child: Text(_isOrderMode ? '주문중' : '수행중', style: TextStyle(color: _isOrderMode ? Colors.blue : Colors.orange, fontSize: 12, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        actions: [
          const Center(child: Text('모드전환', style: TextStyle(color: Colors.grey, fontSize: 11))),
          Switch(
            value: _isOrderMode,
            onChanged: (val) => setState(() => _isOrderMode = val),
            activeColor: Colors.orange,
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _homeView(),
          _mapView(),
          _chatView(),
          _profileView(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (idx) => setState(() => _currentIndex = idx),
        selectedItemColor: Colors.orange[900],
        unselectedItemColor: Colors.grey[400],
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.bolt), label: '당장신청'),
          BottomNavigationBarItem(icon: Icon(Icons.map_outlined), label: '주변지도'),
          BottomNavigationBarItem(icon: Badge(label: Text('1'), child: Icon(Icons.chat_bubble_outline)), label: '채팅'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: '내정보'),
        ],
      ),
      floatingActionButton: _isOrderMode ? FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: Colors.orange,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('심부름 요청하기', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ) : null,
    );
  }

  Widget _homeView() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _headerBanner(),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(_isOrderMode ? "나의 실시간 요청" : "수행 가능한 심부름 🔥", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          if (_isOrderMode) ...[
            _itemCard("편의점 음료수 2캔", "3,000원", "매칭 대기 중", Icons.timer, Colors.orange),
            _itemCard("우체국 택배 대신 수령", "5,000원", "수행자 이동 중", Icons.directions_run, Colors.blue),
          ] else ...[
            _itemCard("생수 한 묶음 배달", "4,000원", "250m 거리", Icons.local_shipping, Colors.green),
            _itemCard("강아지 산책 (30분)", "10,000원", "500m 거리", Icons.pets, Colors.brown),
            _itemCard("약국 타이레놀 구매", "3,500원", "150m 거리", Icons.medical_services, Colors.red),
          ],
        ],
      ),
    );
  }

  Widget _headerBanner() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: _isOrderMode ? [Colors.blue[400]!, Colors.blue[800]!] : [Colors.orange[400]!, Colors.orange[800]!]),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_isOrderMode ? '시간이 필요하신가요?' : '지금 바로 수익을 만드세요', style: const TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 8),
          Text(_isOrderMode ? '가까운 이웃에게\n당장 요청하세요!' : '내 주변 500m 이내\n새로운 심부름 3건!', 
            style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold, height: 1.3)),
        ],
      ),
    );
  }

  Widget _itemCard(String t, String p, String s, IconData i, Color c) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey[100]!)),
      child: Row(
        children: [
          CircleAvatar(backgroundColor: c.withOpacity(0.1), child: Icon(i, color: c)),
          const SizedBox(width: 15),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(t, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text(s, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
          ])),
          Text(p, style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.black, fontSize: 18)),
        ],
      ),
    );
  }

  Widget _mapView() {
    return Column(
      children: [
        Expanded(
          flex: 3,
          child: Container(color: Colors.orange[50], child: const Center(child: Icon(Icons.my_location, size: 50, color: Colors.orange))),
        ),
        Expanded(
          flex: 4,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Text('가까운 거리순 이웃', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 15),
              _userListTile('김당장 (수행자)', '150m', '별점 5.0'),
              _userListTile('이이웃 (주문자)', '300m', '별점 4.9'),
              _userListTile('박번개 (수행자)', '450m', '별점 4.8'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _userListTile(String n, String d, String s) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const CircleAvatar(backgroundColor: Colors.grey, child: Icon(Icons.person, color: Colors.white)),
      title: Text(n, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text('$d | $s'),
      trailing: OutlinedButton(onPressed: () {}, child: const Text('지정요청')),
    );
  }

  Widget _chatView() {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _bubble('주문자', '편의점에서 콜라 2캔 사다주실 수 있나요?', '오후 2:10', false),
              _bubble('수행자', '네! 지금 바로 매장으로 가겠습니다.', '오후 2:12', true),
              _bubble('주문자', '감사합니다. 도착하시면 집 앞에 놓아주세요.', '오후 2:13', false),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(15),
          decoration: const BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Color(0xFFEEEEEE)))),
          child: Row(children: [
            const Icon(Icons.add_circle_outline, color: Colors.grey),
            const Expanded(child: Padding(padding: EdgeInsets.symmetric(horizontal: 10), child: TextField(decoration: InputDecoration(hintText: '메시지를 입력하세요...', border: InputBorder.none)))),
            const Icon(Icons.send, color: Colors.orange),
          ]),
        ),
      ],
    );
  }

  Widget _bubble(String s, String m, String t, bool isMe) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(s, style: const TextStyle(fontSize: 11, color: Colors.grey)),
          const SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(color: isMe ? Colors.orange : Colors.grey[200], borderRadius: BorderRadius.circular(15)),
            child: Text(m, style: TextStyle(color: isMe ? Colors.white : Colors.black)),
          ),
          const SizedBox(height: 4),
          Text(t, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _profileView() {
    return const Center(child: Text('앱테크 정산 및 프로필 관리 서비스 준비 중', style: TextStyle(fontWeight: FontWeight.bold)));
  }
}

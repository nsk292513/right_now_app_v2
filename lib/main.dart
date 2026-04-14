import 'package:flutter/material.dart';

void main() => runApp(const DangJangApp());

class DangJangApp extends StatelessWidget {
  const DangJangApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.orange, fontFamily: 'Pretendard'),
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
  int _tabIdx = 0;
  bool _isOrderMode = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Row(
          children: [
            const Text('당장', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 24)),
            const SizedBox(width: 8),
            _modeBadge(),
          ],
        ),
        actions: [
          const Center(child: Text('모드전환', style: TextStyle(color: Colors.grey, fontSize: 11))),
          Switch(value: _isOrderMode, onChanged: (v) => setState(() => _isOrderMode = v), activeColor: Colors.orange),
          const SizedBox(width: 10),
        ],
      ),
      body: IndexedStack(
        index: _tabIdx,
        children: [_home(), _map(), _chat(), _profile()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tabIdx,
        onTap: (idx) => setState(() => _tabIdx = idx),
        selectedItemColor: Colors.orange[900],
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.bolt), label: '당장신청'),
          BottomNavigationBarItem(icon: Icon(Icons.map_outlined), label: '주변지도'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: '채팅'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: '내정보'),
        ],
      ),
    );
  }

  Widget _modeBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: _isOrderMode ? Colors.blue[50] : Colors.green[50], borderRadius: BorderRadius.circular(5)),
      child: Text(_isOrderMode ? '주문자' : '수행자', style: TextStyle(color: _isOrderMode ? Colors.blue : Colors.green, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }

  Widget _home() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _banner(),
          if (_isOrderMode) ...[
            _escrowCard("음료수 2캔", "3,000원", "디파짓 완료", Colors.blue, "물건 수령 대기"),
            _escrowCard("택배 수령 대행", "5,000원", "결제 대기", Colors.grey, "매칭 중"),
          ] else ...[
            _workCard("편의점 구매 대행", "3,000원", "방금 전", "200m"),
            _workCard("약국 타이레놀 배달", "4,000원", "3분 전", "450m"),
          ],
        ],
      ),
    );
  }

  Widget _banner() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.orange, Colors.orangeAccent]), borderRadius: BorderRadius.circular(20)),
      child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('에스크로우 안심 결제 시스템', style: TextStyle(color: Colors.white70, fontSize: 13)),
        SizedBox(height: 8),
        Text('믿고 맡기는 초단기 대행\n당장에서 시작하세요!', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
      ]),
    );
  }

  Widget _escrowCard(String t, String p, String s, Color c, String sub) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(t, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Text(p, style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
        ]),
        const Divider(height: 30),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(s, style: TextStyle(color: c, fontWeight: FontWeight.bold)),
          ElevatedButton(onPressed: () {}, child: const Text('수락(입금확정)')),
        ]),
      ]),
    );
  }

  Widget _workCard(String t, String p, String tm, String d) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(t, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text('$d | $tm', style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ]),
        Text(p, style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
      ]),
    );
  }

  Widget _map() {
    return Column(children: [
      Container(height: 200, color: Colors.orange[50], child: const Center(child: Icon(Icons.my_location, size: 50, color: Colors.orange))),
      const Padding(padding: EdgeInsets.all(15), child: Text('안심번호 통화 가능 이웃 (실시간)', style: TextStyle(fontWeight: FontWeight.bold))),
      Expanded(child: ListView(children: [
        _userRow('김당장 (수행자)', '150m'),
        _userRow('이이웃 (수행자)', '300m'),
      ])),
    ]);
  }

  Widget _userRow(String n, String d) {
    return ListTile(
      leading: const Icon(Icons.account_circle, size: 40),
      title: Text(n),
      subtitle: Text('거리: $d'),
      trailing: IconButton(icon: const Icon(Icons.call, color: Colors.green), onPressed: () {}),
    );
  }

  Widget _chat() {
    return Column(children: [
      Container(padding: const EdgeInsets.all(10), color: Colors.green[50], child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.security, size: 14), Text(' 안심번호 통화 및 에스크로우 보호 중', style: TextStyle(fontSize: 12))])),
      Expanded(child: ListView(padding: const EdgeInsets.all(20), children: [
        _bubble('주문자', '구매 완료하셨나요?', false),
        _bubble('수행자', '네! 집 앞으로 배송 중입니다.', true),
      ])),
      Container(padding: const EdgeInsets.all(15), color: Colors.white, child: Row(children: [const Icon(Icons.add), const Expanded(child: TextField()), IconButton(icon: const Icon(Icons.call, color: Colors.green), onPressed: () {})])),
    ]);
  }

  Widget _bubble(String s, String m, bool isMe) {
    return Column(crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start, children: [
      Text(s, style: const TextStyle(fontSize: 10)),
      Container(margin: const EdgeInsets.symmetric(vertical: 5), padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: isMe ? Colors.orange : Colors.grey[200], borderRadius: BorderRadius.circular(15)), child: Text(m)),
    ]);
  }

  Widget _profile() => const Center(child: Text('개인정보 및 정산 관리'));
}

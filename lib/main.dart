import 'package:flutter/material.dart';

void main() => runApp(const DangJangApp());

class DangJangApp extends StatelessWidget {
  const DangJangApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.orange, fontFamily: 'Pretendard'),
      home: const IntegratedNavigation(),
    );
  }
}

class IntegratedNavigation extends StatefulWidget {
  const IntegratedNavigation({super.key});
  @override
  State<IntegratedNavigation> createState() => _IntegratedNavigationState();
}

class _IntegratedNavigationState extends State<IntegratedNavigation> {
  int _idx = 0;
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
            _buildAuthBadge(),
          ],
        ),
        actions: [
          Switch(value: _isOrderMode, onChanged: (v) => setState(() => _isOrderMode = v), activeColor: Colors.orange),
          const SizedBox(width: 10),
        ],
      ),
      body: IndexedStack(
        index: _idx,
        children: [_home(), _map(), _chat(), _profile()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _idx,
        onTap: (i) => setState(() => _idx = i),
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

  Widget _buildAuthBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(4), border: Border.all(color: Colors.blue[200]!)),
      child: const Row(
        children: [
          Icon(Icons.verified, size: 10, color: Colors.blue),
          SizedBox(width: 2),
          Text('인증회원', style: TextStyle(color: Colors.blue, fontSize: 10, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _home() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _banner(),
          if (_isOrderMode) ...[
            _itemCard("음료수 2캔 사다주기", "예치금액: 3,000원", "수행자 매칭 중", Colors.blue),
            _itemCard("택배 보관함 대행", "예치금액: 5,000원", "배송 진행 중", Colors.green),
          ] else ...[
            _itemCard("편의점 구매 대행", "수익: 3,000원", "200m 이내", Colors.orange),
            _itemCard("약국 타이레놀 배달", "수익: 4,500원", "450m 이내", Colors.red),
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
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('신분증/휴대폰 인증 완료 회원 전용', style: TextStyle(color: Colors.white70, fontSize: 12)),
        const SizedBox(height: 8),
        Text(_isOrderMode ? '안전하게 예치하고\n당장 도움을 받으세요!' : '지금 바로 주변에서\n당장 수익을 만드세요!', 
          style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
      ]),
    );
  }

  Widget _itemCard(String t, String p, String s, Color c) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey[100]!)),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(t, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Text(s, style: TextStyle(color: c, fontSize: 13, fontWeight: FontWeight.bold)),
        ]),
        Text(p, style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 16)),
      ]),
    );
  }

  Widget _map() {
    return Column(children: [
      Container(height: 180, color: Colors.orange[50], child: const Center(child: Icon(Icons.location_on, size: 40, color: Colors.orange))),
      const Padding(padding: EdgeInsets.all(15), child: Text('실시간 안심번호 통화 가능 이웃', style: TextStyle(fontWeight: FontWeight.bold))),
      Expanded(child: ListView(children: [
        _userRow('홍길동 (인증회원)', '150m'),
        _userRow('이순신 (인증회원)', '320m'),
      ])),
    ]);
  }

  Widget _userRow(String n, String d) {
    return ListTile(
      leading: const Icon(Icons.account_circle, size: 40),
      title: Text(n),
      subtitle: Text('거리: $d'),
      trailing: const Icon(Icons.call, color: Colors.green),
    );
  }

  Widget _chat() {
    return Column(children: [
      Container(padding: const EdgeInsets.all(10), color: Colors.blue[50], child: const Text('수락 완료 시 예치금이 자동으로 지급됩니다.', style: TextStyle(fontSize: 12, color: Colors.blue, fontWeight: FontWeight.bold))),
      Expanded(child: ListView(padding: const EdgeInsets.all(20), children: [
        _bubble('수행자', '물건 사고 출발합니다!', true),
        _bubble('주문자', '네, 도착 후 수락 버튼 누를게요.', false),
      ])),
      Container(padding: const EdgeInsets.all(15), color: Colors.white, child: const Row(children: [Icon(Icons.add), Expanded(child: TextField()), Icon(Icons.send)])),
    ]);
  }

  Widget _bubble(String s, String m, bool isMe) {
    return Column(crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start, children: [
      Text(s, style: const TextStyle(fontSize: 10)),
      Container(margin: const EdgeInsets.symmetric(vertical: 4), padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: isMe ? Colors.orange : Colors.grey[200], borderRadius: BorderRadius.circular(15)), child: Text(m)),
    ]);
  }

  Widget _profile() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const CircleAvatar(radius: 30, backgroundColor: Colors.grey, child: Icon(Icons.person, color: Colors.white, size: 40)),
          const SizedBox(width: 15),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Row(children: [Text('사용자님', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), SizedBox(width: 5), Icon(Icons.verified, size: 16, color: Colors.blue)]),
            Text(_isOrderMode ? '주문자 회원' : '수행자 회원', style: const TextStyle(color: Colors.grey)),
          ]),
        ]),
        const SizedBox(height: 30),
        _infoBox(_isOrderMode ? "미리 예치한 금액" : "정산 가능한 금액", _isOrderMode ? "50,000원" : "12,500원"),
        const SizedBox(height: 20),
        const Text('개인정보 관리 (인증완료)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 10),
        _inputField("이름", "홍길동"),
        _inputField("전화번호", "010-1234-5678"),
        const SizedBox(height: 20),
        const Text('인증 시스템', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const ListTile(leading: Icon(Icons.credit_card, color: Colors.blue), title: Text('신분증 인증 완료'), trailing: Icon(Icons.check_circle, color: Colors.blue)),
        const ListTile(leading: Icon(Icons.phone_android, color: Colors.blue), title: Text('휴대폰 본인 인증 완료'), trailing: Icon(Icons.check_circle, color: Colors.blue)),
      ]),
    );
  }

  Widget _infoBox(String t, String v) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.orange[50], borderRadius: BorderRadius.circular(15)),
      child: Column(children: [
        Text(t, style: const TextStyle(fontSize: 14)),
        const SizedBox(height: 5),
        Text(v, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.orange)),
      ]),
    );
  }

  Widget _inputField(String label, String val) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(decoration: InputDecoration(labelText: label, hintText: val, border: const OutlineInputBorder())),
    );
  }
}

import 'package:flutter/material.dart';

void main() => runApp(const RightNowApp());

class RightNowApp extends StatelessWidget {
  const RightNowApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.orange),
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
  final List<Widget> _pages = [
    const HomeScreen(),
    const Center(child: Text('주변 지도에서 당장 찾기', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
    const Center(child: Text('새로운 채팅 메시지가 없습니다', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
    const Center(child: Text('내 프로필 및 앱테크 정산', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
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
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCat = '전체';
  final List<String> _categories = ['전체', '편의점', '배달', '청소', '심부름'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: const Text('당장 (Right Now)', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.w900, fontSize: 24)),
        actions: [
          IconButton(icon: const Icon(Icons.search, color: Colors.black), onPressed: () {}),
          const Icon(Icons.notifications_none, color: Colors.black),
          const SizedBox(width: 15),
        ],
      ),
      body: Column(
        children: [
          _buildHero(),
          _buildCategoryBar(),
          Expanded(
            child: ListView(
              children: _buildFilteredList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHero() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Colors.orange, Colors.deepOrangeAccent]),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.orange.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('지금 바로 수익내기', style: TextStyle(color: Colors.white70, fontSize: 14)),
          SizedBox(height: 8),
          Text('근처 500m 이내의\n도움을 당장 시작하세요!', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, height: 1.3)),
        ],
      ),
    );
  }

  Widget _buildCategoryBar() {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: _categories.length,
        itemBuilder: (context, i) {
          bool isSel = _selectedCat == _categories[i];
          return GestureDetector(
            onTap: () => setState(() => _selectedCat = _categories[i]),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: isSel ? Colors.orange[900] : Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: isSel ? Colors.orange[900]! : Colors.grey[300]!),
              ),
              child: Center(child: Text(_categories[i], style: TextStyle(color: isSel ? Colors.white : Colors.black, fontWeight: FontWeight.bold))),
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildFilteredList() {
    List<Widget> items = [];
    if (_selectedCat == '전체' || _selectedCat == '편의점') {
      items.add(_buildItem("편의점 음료수 사다주기", "3,000원", "역삼동", "300m", "편의점"));
    }
    if (_selectedCat == '전체' || _selectedCat == '배달') {
      items.add(_buildItem("음식 배달 대행 (급구)", "5,000원", "논현동", "600m", "배달"));
    }
    if (_selectedCat == '전체' || _selectedCat == '청소') {
      items.add(_buildItem("사무실 쓰레기 분리수거", "10,000원", "삼성동", "1.2km", "청소"));
    }
    if (_selectedCat == '전체' || _selectedCat == '심부름') {
      items.add(_buildItem("강아지 산책 20분", "7,000원", "대치동", "900m", "심부름"));
    }
    return items;
  }

  Widget _buildItem(String t, String p, String l, String d, String tag) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey[200]!)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(t, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
              Text(tag, style: const TextStyle(color: Colors.orange, fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(p, style: TextStyle(color: Colors.orange[900], fontWeight: FontWeight.w900, fontSize: 18)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(8)),
                child: const Text('수락하기', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text('$l | $d', style: const TextStyle(color: Colors.grey, fontSize: 13)),
        ],
      ),
    );
  }
}

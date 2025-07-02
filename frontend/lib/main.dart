import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  String backendMessage = '로딩 중...';

  @override
  void initState() {
    super.initState();
    fetchBackendMessage();
  }

  Future<void> fetchBackendMessage() async {
    try {
      // 웹에서 실행하면 localhost, 에뮬레이터에서는 10.0.2.2 사용
      final url = Uri.parse('http://10.0.2.2:3000/api/message');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          backendMessage = jsonDecode(response.body)['message'];
        });
      } else {
        setState(() {
          backendMessage = '백엔드 연결 실패';
        });
      }
    } catch (e) {
      setState(() {
        backendMessage = '에러: $e';
      });
    }
  }

  static const List<Widget> _widgetOptions = <Widget>[
    // 첫 화면
    Center(child: Text('이건 test 화면입니다', style: TextStyle(fontSize: 24))),
    Center(child: Text('지도 화면', style: TextStyle(fontSize: 24))),
    Center(child: Text('마이페이지 화면', style: TextStyle(fontSize: 24))),
  ];

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('이건 test 화면입니다', style: TextStyle(fontSize: 24)),
          const SizedBox(height: 24),
          Text('백엔드 메시지: $backendMessage', style: const TextStyle(fontSize: 16)),
        ],
      ),
      _widgetOptions[1],
      _widgetOptions[2],
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Demo Home Page'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(child: pages[_selectedIndex]),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: '지도',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '마이페이지',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepPurple,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}

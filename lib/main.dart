import 'package:flutter/material.dart';
import 'services/api_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'API Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AdviceScreen(),
    );
  }
}

class AdviceScreen extends StatefulWidget {
  @override
  _AdviceScreenState createState() => _AdviceScreenState();
}

class _AdviceScreenState extends State<AdviceScreen> {
  final ApiService apiService = ApiService();
  late Future<String> advice;

  @override
  void initState() {
    super.initState();
    advice = apiService.fetchAdvice(); // Dastlabki maslahatni olish
  }

  // Buttom bosilganda API ga murojaat qilish
  void _getNewAdvice() {
    setState(() {
      advice = apiService.fetchAdvice(); // Yangi maslahatni olish
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Advice API"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder<String>(
              future: advice, // API chaqiruvini kutish
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator(); // Yuklanayotganda spinner
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}'); // Xatolik bo'lsa
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      snapshot.data ?? 'No advice found',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 24),
                    ),
                  );
                }
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getNewAdvice, // Buttun bosilganda API ga murojaat qilish
              child: Text("Get New Advice"),
            ),
          ],
        ),
      ),
    );
  }
}

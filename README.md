Bu bosqichda biz http paketidan foydalanib, internetdan ma'lumot olishni o‘rganamiz, shuningdek, FutureBuilder yordamida asinxron ma'lumotlarni yuklashni ko‘rib chiqamiz.

3-bosqich: JSON bilan ishlash (API orqali ma’lumot olish)
1. http paketini o‘rnatish
Avvalo, http paketini o‘rnatishimiz kerak. pubspec.yaml faylini ochib, quyidagi satrni qo‘shamiz:

yaml
Копировать
dependencies:
  flutter:
    sdk: flutter
  http: ^0.13.4  # eng so'nggi versiyasini tekshirib o'rnating
Keyin, flutter pub get buyrug‘ini bajarib, http paketini o‘rnatamiz:

bash
Копировать
flutter pub get
2. API bilan ishlash
Bu yerda biz API orqali tasodifiy maslahat (advice) yoki hazil (joke) olishni ko‘ramiz. http paketi yordamida API chaqiramiz va olingan JSON ma'lumotlarini Flutter ilovamizda ko‘rsatamiz.

3. API chaqirishi uchun xizmat (Service) yaratish
Birinchi navbatda, API chaqiruvini amalga oshiradigan xizmatni yaratamiz. Misol uchun, Advice API dan ma'lumot olish uchun services/api_service.dart faylini yaratib, quyidagicha yozamiz:

dart
Копировать
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'https://api.adviceslip.com/advice';

  // API dan maslahat olish
  Future<String> fetchAdvice() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['slip']['advice'];  // JSON dan advice ma'lumotini olish
    } else {
      throw Exception('Failed to load advice');
    }
  }
}
Bu yerda:

http.get() yordamida API chaqiriladi.
Javob JSON formatida keladi, va biz jsonDecode() yordamida uni Dart obyektiga o‘zgartiramiz.
JSON dan kerakli ma'lumotni (advice) olamiz.
4. UI qismini yaratish
Endi esa, foydalanuvchi interfeysini yaratamiz. FutureBuilder yordamida API chaqiruvini amalga oshiramiz va ma'lumotlarni ko‘rsatamiz.

lib/main.dart faylini quyidagicha yangilaymiz:

dart
Копировать
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

class AdviceScreen extends StatelessWidget {
  final ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Advice API"),
      ),
      body: Center(
        child: FutureBuilder<String>(
          future: apiService.fetchAdvice(),  // API chaqiruvi
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();  // Yuklanayotganda spinner
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');  // Xatolik bo'lsa
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
      ),
    );
  }
}
5. Kodning ishlashini tushuntirish:
FutureBuilder<String> widgeti API chaqiruvini amalga oshiradi va javobni kutadi.
snapshot.connectionState == ConnectionState.waiting holatida yuklanayotgani haqida ko‘rsatiladi.
Agar API muvaffaqiyatli javob qaytarsa, snapshot.data orqali maslahat ko‘rsatiladi.
Agar xatolik yuzaga kelsa, snapshot.hasError tekshiriladi va xatolik matni ko‘rsatiladi.
6. Test qilish
Endi dasturni ishga tushirib, Advice APIdan tasodifiy maslahatlarni olishingiz mumkin.

bash
Копировать
flutter run
Xulosa
Biz http paketidan foydalanib, API chaqiruvi amalga oshirdik.
FutureBuilder yordamida asinxron ma'lumotlarni olib, UI ni yangiladik.
JSON formatidagi ma'lumotlarni Dart obyektlariga aylantirdik.
Agar kerakli API o‘zgartirishlar yoki qo‘shimcha savollar bo‘lsa, yordam bera olishim mumkin!

Вы сказали:
shu dasturga bitta buttun qo'shish kerak. Bosilganida http apiga qayta murojat qilsin
ChatGPT сказал:
Albatta! Agar sizga bitta buttun qo'shish kerak bo'lsa, bu butun bosilganda API ga qayta murojaat qilish uchun setState() yordamida interfeysni yangilashni amalga oshiramiz.

Mana, kodni qanday o'zgartirish mumkin:

1. main.dart faylini yangilash
Quyidagi kodda yangi buttun qo‘shamiz, u bosilganda API ga qayta murojaat qilib, yangi maslahat oladi.

dart
Копировать
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
O'zgarishlar:
StatefulWidget ga o'zgartirdik (AdviceScreen ni StatefulWidget qilib).
_getNewAdvice() funksiyasini qo‘shdik, u butun bosilganda API ga yangi murojaat qiladi va setState() yordamida UI ni yangilaydi.
Buttun qo'shildi – "Get New Advice" nomi bilan. Buttun bosilganda _getNewAdvice() funksiyasi ishlaydi va yangi maslahatni yuklaydi.
FutureBuilder endi advice degan Future ga murojaat qiladi, bu esa yangilanishi kerak bo‘lsa, setState() bilan yangilanadi.
2. Dastur ishga tushganda:
Dastlabki maslahat API dan olinadi.
Har safar "Get New Advice" tugmasi bosilganda, API dan yangi maslahat olinadi va ekranda yangilanish yuz beradi.
3. Test qilish
Endi, dastur ishga tushirilganda, ekranda maslahat ko‘rsatiladi, va butun bosilganda, yangi maslahat olinadi.

bash
Копировать
flutter run
Agar xatoliklar bo‘lsa yoki qo‘shimcha savollar bo‘lsa, yordam bera olishim mumkin!
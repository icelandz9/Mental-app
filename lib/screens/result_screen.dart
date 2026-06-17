import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'question_screen.dart';

class ResultScreen extends StatefulWidget {
  final List<int> answers;

  const ResultScreen({super.key, required this.answers});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool _saved = false;

  // ===== คะแนนรวม =====
  int get totalScore =>
      widget.answers.fold(0, (sum, a) => sum + (a == -1 ? 0 : a));

  int get maxScore => widget.answers.length * 3;

  // ===== คะแนนรายหมวด =====
  int _categoryScore(int from, int to) =>
      widget.answers.sublist(from, to).fold(
            0,
            (sum, a) => sum + (a == -1 ? 0 : a),
          );

  // ===== ผลประเมิน =====
  Map<String, dynamic> get result {
    final score = totalScore;

    if (score <= 48) {
      return {
        'level': 'ดีเยี่ยม',
        'message': 'สุขภาพจิตของคุณอยู่ในเกณฑ์ดีมาก',
        'color': const Color(0xFF2E7D32),
        'bgColor': const Color(0xFFE8F5E9),
        'icon': Icons.sentiment_very_satisfied,
      };
    } else if (score <= 96) {
      return {
        'level': 'ดี',
        'message': 'อยู่ในเกณฑ์ดี ลองพักผ่อนเพิ่ม',
        'color': const Color(0xFF388E3C),
        'bgColor': const Color(0xFFF1F8E9),
        'icon': Icons.sentiment_satisfied,
      };
    } else if (score <= 144) {
      return {
        'level': 'ควรใส่ใจ',
        'message': 'อาจมีความเครียด',
        'color': const Color(0xFFF57F17),
        'bgColor': const Color(0xFFFFFDE7),
        'icon': Icons.sentiment_neutral,
      };
    } else if (score <= 192) {
      return {
        'level': 'ควรระวัง',
        'message': 'ควรปรึกษาผู้เชี่ยวชาญ',
        'color': const Color(0xFFE65100),
        'bgColor': const Color(0xFFFBE9E7),
        'icon': Icons.sentiment_dissatisfied,
      };
    } else {
      return {
        'level': 'ต้องการความช่วยเหลือ',
        'message': 'ควรพบผู้เชี่ยวชาญทันที',
        'color': const Color(0xFFB71C1C),
        'bgColor': const Color(0xFFFFEBEE),
        'icon': Icons.sentiment_very_dissatisfied,
      };
    }
  }

  // ===== Firebase Save (แยกหมวด) =====
  Future<void> _saveToFirebase() async {
  if (_saved) return;
  _saved = true;

  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  final categories = [
    {'name': 'PHQ-9', 'score': _categoryScore(0, 10), 'max': 30},
    {'name': 'GAD-7', 'score': _categoryScore(10, 20), 'max': 30},
    {'name': 'ASRS', 'score': _categoryScore(20, 30), 'max': 30},
    {'name': 'OCD', 'score': _categoryScore(30, 40), 'max': 30},
    {'name': 'MDQ', 'score': _categoryScore(40, 50), 'max': 30},
    {'name': 'AQ', 'score': _categoryScore(50, 60), 'max': 30},
    {'name': 'PCL-5', 'score': _categoryScore(60, 70), 'max': 30},
    {'name': 'PSS', 'score': _categoryScore(70, 80), 'max': 30},
  ];

  await FirebaseFirestore.instance
      .collection('users')            // 🔥 เพิ่มตรงนี้
      .doc(user.uid)                  // 🔥 แยกตาม user
      .collection('results')         // 🔥 history ของแต่ละคน
      .add({
    'totalScore': totalScore,
    'maxScore': maxScore,
    'percent': (totalScore / maxScore * 100),
    'createdAt': FieldValue.serverTimestamp(),
    'categories': categories,
  });
}

  @override
  void initState() {
    super.initState();

    // ยิง Firebase ครั้งเดียว
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _saveToFirebase();
    });
  }

  @override
  Widget build(BuildContext context) {
    final res = result;
    final score = totalScore;
    final percent = (score / maxScore * 100).round();

    final categories = [
      {'name': 'PHQ-9', 'score': _categoryScore(0, 10), 'max': 30},
      {'name': 'GAD-7', 'score': _categoryScore(10, 20), 'max': 30},
      {'name': 'ASRS', 'score': _categoryScore(20, 30), 'max': 30},
      {'name': 'OCD', 'score': _categoryScore(30, 40), 'max': 30},
      {'name': 'MDQ', 'score': _categoryScore(40, 50), 'max': 30},
      {'name': 'AQ', 'score': _categoryScore(50, 60), 'max': 30},
      {'name': 'PCL-5', 'score': _categoryScore(60, 70), 'max': 30},
      {'name': 'PSS', 'score': _categoryScore(70, 80), 'max': 30},
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Text("ผลการทดสอบ"),

            const SizedBox(height: 20),

            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: res['bgColor'],
                border: Border.all(color: res['color'], width: 3),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(res['icon'], color: res['color']),
                  Text(
                    "$score",
                    style: TextStyle(
                      fontSize: 28,
                      color: res['color'],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text("จาก $maxScore"),
                ],
              ),
            ),

            const SizedBox(height: 10),

            Text(
              "ระดับ: ${res['level']} ($percent%)",
              style: TextStyle(
                color: res['color'],
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                res['message'],
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: ListView(
                children: categories.map((c) {
                  final v = (c['score'] as int) / (c['max'] as int);

                  return ListTile(
                    title: Text(c['name'] as String),
                    trailing: Text("${c['score']}/${c['max']}"),
                    subtitle: LinearProgressIndicator(value: v),
                  );
                }).toList(),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(12),
              child: ElevatedButton(
                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const QuestionScreen()),
                ),
                child: const Text("ทำแบบทดสอบอีกครั้ง"),

                
              ),
              
            ),
            const SizedBox(height: 12),

SizedBox(
  width: double.infinity,
  child: OutlinedButton(
    onPressed: () {
      Navigator.popUntil(context, (route) => route.isFirst);
    },
    style: OutlinedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      side: const BorderSide(color: Colors.grey),
    ),
    child: const Text(
      'กลับหน้าโฮม',
      style: TextStyle(fontSize: 16, color: Colors.black87),
    ),
  ),
),
          ],
        ),
      ),
    );
  }
}
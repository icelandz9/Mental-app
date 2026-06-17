import 'package:flutter/material.dart';

import '../โรค/depression_page.dart';
import '../โรค/anxiety_page.dart';
import '../โรค/aq_page.dart';
import '../แบบทดสอบ/quiz_page.dart';
import '../ดูแล/sleep_page.dart';
import '../ดูแล/food_page.dart';
import '../ดูแล/exercise_page.dart';
import '../ดูแล/relax_page.dart';
import '../ประวัติส่วนตัว/profile_page.dart';
import '../login/register/login_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        //  ส่วนที่ 1: Gradient ตามรูปที่แนบ
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.14, 0.27, 0.72, 1.0],
            colors: [
              Color(0xFF6687FF),
              Color(0xFFB3C3FF),
              Color(0xFFFFFFFF),
              Color(0xFFFDFDFF),
              Color(0xFF708BF4),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // ===== HEADER =====
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.logout,
                          color: Colors.white,
                          size: 30,
                        ),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginPage(),
                            ),
                          );
                        },
                      ),
                      const Text(
                        "สภาวะทางจิต",
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 35,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ProfilePage(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                //  ส่วนที่ 2: การ์ดสภาวะทางจิตทั้งหมด
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      // แถวที่ 1
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _symptomCard(
                            context,
                            "ซึมเศร้า\nPHQ-9",
                            const DepressionPage(),
                          ),
                          _symptomCard(
                            context,
                            "วิตกกังวล\nGAD-7",
                            const AnxietyPage(),
                          ),
                          _symptomCard(
                            context,
                            "สมาธิสั้น\nASRS",
                            const DepressionPage(),
                          ), // เปลี่ยน page ให้ตรง
                          _symptomCard(
                            context,
                            "ย้ำคิดย้ำทำ\nOCI-R",
                            const DepressionPage(),
                          ), // เปลี่ยน page ให้ตรง
                        ],
                      ),
                      const SizedBox(height: 12),
                      // แถวที่ 2
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _symptomCard(
                            context,
                            "ไบโพลาร์\nMDQ",
                            const DepressionPage(),
                          ), // เปลี่ยน page ให้ตรง
                          _symptomCard(
                            context,
                            "ออทิสติก\nAQ/RAA",
                            const Aqpage(),
                          ),
                          _symptomCard(
                            context,
                            "PTSD\nPCL-5",
                            const DepressionPage(),
                          ), // เปลี่ยน page ให้ตรง
                          _symptomCard(
                            context,
                            "ความเครียด\nPSS",
                            const DepressionPage(),
                          ), // เปลี่ยน page ให้ตรง
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                //  ส่วนที่ 3: รูปดาว กดแล้วไปหน้า Quiz
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const QuizPage()),
                    );
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        "assets/image/component.png",
                        width: 200,
                        height: 200,
                      ),
                      const Text(
                        "เริ่มทำแบบประเมิน\nสภาวะทางจิต",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF3A5FCD), // สีน้ำเงินเข้มตามรูป
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 35),

                //  ส่วนที่ 4: แนวทางการฟื้นฟู
                const Text(
                  "แนวทางการฟื้นฟู",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 25),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _careButton(
                      context,
                      "การนอน",
                      "assets/image/componenta.png",
                      const SleepPage(),
                    ),
                    _careButton(
                      context,
                      "อาหาร",
                      "assets/image/componentb.png",
                      const FoodPage(),
                    ),
                    _careButton(
                      context,
                      "ออกกำลังกาย",
                      "assets/image/componentc.png",
                      const ExercisePage(),
                    ),
                    _careButton(
                      context,
                      "ผ่อนคลาย",
                      "assets/image/componentd.png",
                      const RelaxPage(),
                    ),
                  ],
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ===== การ์ดสภาวะ =====
  Widget _symptomCard(BuildContext context, String title, Widget page) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => page));
      },
      child: Container(
        width: 80,
        height: 90,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  // ===== ปุ่มแนวทางฟื้นฟู =====
  Widget _careButton(
    BuildContext context,
    String title,
    String imagePath,
    Widget page,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => page));
      },
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.7),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ClipOval(child: Image.asset(imagePath, fit: BoxFit.cover)),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(fontSize: 12, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../diseases/depression_page.dart';
import '../diseases/anxiety_page.dart';
import '../diseases/aq_page.dart';
import '../symptoms/disease_detail_page.dart';
import '../quiz/quiz_page.dart';
import '../care/sleep_page.dart';
import '../care/food_page.dart';
import '../care/exercise_page.dart';
import '../care/relax_page.dart';
import '../profile/profile_page.dart';
import '../login/register/login_page.dart';
import '../theme/app_theme.dart';

// ===== ข้อมูลการ์ดสภาวะทางจิต 1 ใบ =====
class _Symptom {
  final String name; // ชื่อไทย เช่น "ซึมเศร้า"
  final String code; // รหัสแบบทดสอบ เช่น "PHQ-9"
  final IconData icon;
  final Color color; // สีประจำการ์ด
  final Widget page; // หน้าปลายทาง
  const _Symptom(this.name, this.code, this.icon, this.color, this.page);
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // รายการสภาวะทั้งหมด (8 อย่าง) — ไอคอน + สีเฉพาะตัว
  List<_Symptom> get _symptoms => const [
    _Symptom(
      'ซึมเศร้า',
      'PHQ-9',
      Icons.sentiment_dissatisfied_rounded,
      AppColors.primary,
      DepressionPage(),
    ),
    _Symptom(
      'วิตกกังวล',
      'GAD-7',
      Icons.psychology_rounded,
      Color(0xFF4A90D9),
      AnxietyPage(),
    ),
    _Symptom(
      'สมาธิสั้น',
      'ASRS',
      Icons.blur_on_rounded,
      Color(0xFF9B7EDE),
      DiseaseDetailPage(diseaseName: 'ASRS', diseaseTitle: 'สมาธิสั้น'),
    ),
    _Symptom(
      'ย้ำคิดย้ำทำ',
      'OCI-R',
      Icons.loop_rounded,
      AppColors.accent,
      DiseaseDetailPage(diseaseName: 'OCI-R', diseaseTitle: 'ย้ำคิดย้ำทำ'),
    ),
    _Symptom(
      'ไบโพลาร์',
      'MDQ',
      Icons.swap_vert_rounded,
      Color(0xFFF0A93C),
      DiseaseDetailPage(diseaseName: 'MDQ', diseaseTitle: 'ไบโพลาร์'),
    ),
    _Symptom(
      'ออทิสติก',
      'AQ/RAA',
      Icons.extension_rounded,
      Color(0xFF53B98A),
      Aqpage(),
    ),
    _Symptom(
      'PTSD',
      'PCL-5',
      Icons.bolt_rounded,
      AppColors.peach,
      DiseaseDetailPage(diseaseName: 'PCL-5', diseaseTitle: 'PTSD'),
    ),
    _Symptom(
      'ความเครียด',
      'PSS',
      Icons.whatshot_rounded,
      Color(0xFFE07A9B),
      DiseaseDetailPage(diseaseName: 'PSS', diseaseTitle: 'ความเครียด'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // ===== พื้นหลังไล่เฉดอินดิโกนุ่ม =====
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.32, 1.0],
            colors: [AppColors.primary, AppColors.bg, AppColors.bg],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ===== HEADER =====
                _header(context),
                const SizedBox(height: 22),

                // ===== หัวข้อหมวดประเมิน =====
                _sectionHeader(
                  'แบบประเมินสุขภาพจิต',
                  'ทำความเข้าใจสุขภาพทางจิตเบื้องต้น',
                  Colors.white,
                  const Color.fromARGB(255, 255, 255, 255),
                ),
                const SizedBox(height: 14),

                // ===== กริดการ์ดสภาวะ 2 คอลัมน์ =====
                LayoutBuilder(
                  builder: (context, c) {
                    final cardW = (c.maxWidth - 12) / 2;
                    return Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: _symptoms
                          .map((s) => _symptomCard(context, s, cardW))
                          .toList(),
                    );
                  },
                ),
                const SizedBox(height: 24),

                // ===== การ์ด CTA เริ่มทำแบบประเมิน =====
                _assessmentCta(context),
                const SizedBox(height: 28),

                // ===== หัวข้อแนวทางฟื้นฟู =====
                _sectionHeader(
                  'แนวทางการฟื้นฟู',
                  'แนวทางการดูแลสภาพจิตใจและกายเบื้องต้น',
                  AppColors.textPrimary,
                  AppColors.textSecondary,
                ),
                const SizedBox(height: 16),

                // ===== ปุ่มฟื้นฟู 4 อย่าง =====
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _careButton(
                      context,
                      'การนอน',
                      'assets/image/componenta.png',
                      const SleepPage(),
                    ),
                    _careButton(
                      context,
                      'อาหาร',
                      'assets/image/componentb.png',
                      const FoodPage(),
                    ),
                    _careButton(
                      context,
                      'ออกกำลังกาย',
                      'assets/image/componentc.png',
                      const ExercisePage(),
                    ),
                    _careButton(
                      context,
                      'ผ่อนคลาย',
                      'assets/image/componentd.png',
                      const RelaxPage(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ===== แถบหัว: ทักทาย + ปุ่มออก/โปรไฟล์ =====
  Widget _header(BuildContext context) {
    return Row(
      children: [
        _circleIconButton(
          icon: Icons.logout_rounded,
          onTap: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const LoginPage()),
          ),
        ),
        const SizedBox(width: 14),
        const Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start),
        ),
        _circleIconButton(
          icon: Icons.person_rounded,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ProfilePage()),
          ),
        ),
      ],
    );
  }

  Widget _circleIconButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white.withValues(alpha: 0.2),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(9),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
      ),
    );
  }

  // ===== หัวข้อ section (ปรับสีตัวอักษรได้) =====
  Widget _sectionHeader(
    String title,
    String subtitle,
    Color titleColor,
    Color subColor,
  ) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: subColor),
          ),
        ],
      ),
    );
  }

  // ===== การ์ดสภาวะ 1 ใบ (ไอคอน + ชื่อ + รหัส) =====
  Widget _symptomCard(BuildContext context, _Symptom s, double width) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () =>
            Navigator.push(context, MaterialPageRoute(builder: (_) => s.page)),
        child: Ink(
          width: width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.06),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: s.color.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(s.icon, color: s.color, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      s.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      s.code,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===== การ์ด CTA เริ่มทำแบบประเมิน (ไล่เฉด) =====
  Widget _assessmentCta(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const QuizPage()),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primary, AppColors.primaryDark],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.35),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          children: [
            // วงกลมตกแต่งจางๆ
            Positioned(
              right: -10,
              top: -18,
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.08),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'เริ่มทำแบบประเมิน',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 9,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'เริ่มเลย',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(width: 6),
                            Icon(
                              Icons.arrow_forward_rounded,
                              color: AppColors.primary,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.18),
                  ),
                  child: const Icon(
                    Icons.spa_rounded,
                    color: Colors.white,
                    size: 34,
                  ),
                ),
              ],
            ),
          ],
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
      onTap: () =>
          Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
      child: Column(
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: AppColors.border),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(6),
            child: ClipOval(child: Image.asset(imagePath, fit: BoxFit.cover)),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

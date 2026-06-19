import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // เก็บความคืบหน้าในเครื่อง
import '../data/questions_data.dart'; // นำเข้าข้อมูลคำถาม (questions)
import '../models/question.dart';      // โมเดลคำถาม
import '../theme/app_theme.dart';     // ระบบสีกลาง
import 'result_screen.dart';          // นำเข้าหน้าผลลัพธ์ เพื่อไปแสดงเมื่อตอบครบ

// หน้าจอคำถาม - StatefulWidget เพราะมีสถานะที่เปลี่ยนได้ (ข้อปัจจุบัน / คำตอบ)
class QuestionScreen extends StatefulWidget {
  const QuestionScreen({super.key});

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  int _currentIndex = 0;
  final List<int> _answers = List.filled(questions.length, -1);

  // ทิศทางสไลด์ของ animation (1 = ไปข้างหน้า, -1 = ย้อนกลับ)
  int _dir = 1;

  // ===== คีย์เก็บความคืบหน้าใน SharedPreferences =====
  static const String _kAnswers = 'quiz_progress_answers';
  static const String _kIndex = 'quiz_progress_index';

  // โหมดธีม (false = สว่าง, true = มืด)
  bool _isDark = false;

  // ===== ชุดสีตามธีม (มืด = โทน navy เข้ากับสีน้ำเงินของแอป) =====
  Color get _bg => _isDark ? const Color(0xFF0F1426) : Colors.white;
  Color get _surface => _isDark ? const Color(0xFF1A2138) : Colors.white;
  Color get _textPrimary =>
      _isDark ? const Color(0xFFEDF0FB) : AppColors.textPrimary;
  Color get _textSecondary =>
      _isDark ? const Color(0xFF96A0C2) : AppColors.textSecondary;
  Color get _border =>
      _isDark ? const Color(0xFF2C3656) : AppColors.border;
  Color get _chipBg =>
      _isDark ? const Color(0xFF26304D) : const Color(0xFFEEF1FB);
  Color get _track =>
      _isDark ? const Color(0xFF26304D) : const Color(0xFFE7EBF8);

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  // โหลดคำตอบ/ข้อที่ค้างไว้ (ถ้ามีและจำนวนข้อตรงกัน)
  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList(_kAnswers);
    if (saved == null || saved.length != questions.length) return;

    final idx = prefs.getInt(_kIndex) ?? 0;
    if (!mounted) return;
    setState(() {
      for (int i = 0; i < saved.length; i++) {
        _answers[i] = int.tryParse(saved[i]) ?? -1;
      }
      _currentIndex = (idx >= 0 && idx < questions.length) ? idx : 0;
    });
  }

  // บันทึกความคืบหน้าปัจจุบัน
  Future<void> _saveProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _kAnswers,
      _answers.map((e) => e.toString()).toList(),
    );
    await prefs.setInt(_kIndex, _currentIndex);
  }

  // ล้างความคืบหน้า (เรียกเมื่อทำแบบทดสอบเสร็จ)
  Future<void> _clearProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kAnswers);
    await prefs.remove(_kIndex);
  }

  // ===== ฟังก์ชันเมื่อกดปุ่ม Next =====
  void _onNext() {
    if (_answers[_currentIndex] == -1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('กรุณาเลือกคำตอบก่อนไปข้อถัดไป'),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    if (_currentIndex == questions.length - 1) {
      _clearProgress(); // ทำเสร็จแล้ว ล้างความคืบหน้า
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(answers: List.from(_answers)),
        ),
      );
      return;
    }
    setState(() {
      _dir = 1;
      _currentIndex++;
    });
    _saveProgress();
  }

  void _onBack() {
    if (_currentIndex == 0) return;
    setState(() {
      _dir = -1;
      _currentIndex--;
    });
    _saveProgress();
  }

  // ===== เลือกคำตอบ → เลื่อนไปข้อถัดไปเอง =====
  void _selectAnswer(int index) {
    final int q = _currentIndex; // จำข้อปัจจุบันไว้
    setState(() => _answers[q] = index);
    _saveProgress(); // เก็บคำตอบทันที กันเผลอกดออก

    // ข้อสุดท้ายไม่เลื่อนเอง ให้กดปุ่ม "ดูผลลัพธ์"
    if (q == questions.length - 1) return;

    // หน่วงเล็กน้อยให้เห็นสถานะที่เลือกก่อนเลื่อน
    Future.delayed(const Duration(milliseconds: 250), () {
      // ยกเลิกถ้าออกจากหน้าไปแล้ว หรือผู้ใช้เลื่อน/ย้อนข้อเอง
      if (!mounted || _currentIndex != q) return;
      setState(() {
        _dir = 1;
        _currentIndex++;
      });
      _saveProgress();
    });
  }

  // ===== ปุ่ม Reset: ยืนยันแล้วล้างคำตอบ กลับไปข้อแรก =====
  Future<void> _confirmReset() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text('เริ่มทำใหม่?'),
        content: const Text('คำตอบทั้งหมดจะถูกล้าง และกลับไปเริ่มที่ข้อแรก'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('ยกเลิก'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('เริ่มใหม่'),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    setState(() {
      _dir = -1;
      _currentIndex = 0;
      for (int i = 0; i < _answers.length; i++) {
        _answers[i] = -1;
      }
    });
    _clearProgress();
  }

  // สีเน้น (accent) โทนครามเดียวทั้งหน้า เข้าชุดกับธีมน้ำเงินของแอป
  Color _accentColor(String instrument) => const Color(0xFF5468FF);

  // ทำสีให้เข้มลงเล็กน้อย (สำหรับไล่เฉดปุ่ม)
  Color _darken(Color c, [double amount = 0.12]) =>
      Color.lerp(c, Colors.black, amount)!;

  @override
  Widget build(BuildContext context) {
    final question = questions[_currentIndex];
    final int currentNumber = _currentIndex + 1;
    final int total = questions.length;
    final double progress = currentNumber / total;
    final int percent = (progress * 100).round();
    final int selectedAnswer = _answers[_currentIndex];
    final Color accent = _accentColor(question.instrument);
    final bool isLast = _currentIndex == questions.length - 1;
    final bool answered = selectedAnswer != -1;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        // ===== พื้นหลัง gradient อ่อน โทนสีประจำหมวด =====
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.0, 0.4],
            colors: [
              Color.lerp(accent, _bg, _isDark ? 0.80 : 0.88)!,
              _bg,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ===== หัว: ปุ่มปิด + ชื่อ =====
                Row(
                  children: [
                    _circleBtn(
                      icon: Icons.close_rounded,
                      onTap: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Text(
                        'MentalCheck',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: _textPrimary,
                        ),
                      ),
                    ),
                    _circleBtn(
                      icon: _isDark
                          ? Icons.light_mode_rounded
                          : Icons.dark_mode_rounded,
                      onTap: () => setState(() => _isDark = !_isDark),
                    ),
                    const SizedBox(width: 8),
                    _circleBtn(
                      icon: Icons.refresh_rounded,
                      onTap: () => _confirmReset(),
                    ),
                  ],
                ),
                const SizedBox(height: 22),

                // ===== เลขข้อ + เปอร์เซ็นต์ (pill) =====
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ข้อ $currentNumber จาก $total',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: _textSecondary,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        color: accent,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: accent.withValues(alpha: 0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        '$percent%',
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // ===== แถบความคืบหน้า (สีตามหมวด) =====
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: progress),
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeOut,
                    builder: (_, value, _) => LinearProgressIndicator(
                      value: value,
                      minHeight: 8,
                      backgroundColor: _track,
                      valueColor: AlwaysStoppedAnimation(accent),
                    ),
                  ),
                ),
                const SizedBox(height: 22),

                // ===== เนื้อหา (การ์ด + ตัวเลือก) มี animation เปลี่ยนข้อ =====
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 280),
                    transitionBuilder: (child, anim) {
                      final offset = Tween<Offset>(
                        begin: Offset(0.12 * _dir, 0),
                        end: Offset.zero,
                      ).animate(anim);
                      return FadeTransition(
                        opacity: anim,
                        child: SlideTransition(position: offset, child: child),
                      );
                    },
                    child: SingleChildScrollView(
                      key: ValueKey(_currentIndex),
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _questionCard(question, accent),
                          const SizedBox(height: 20),
                          ...List.generate(
                            question.options.length,
                            (i) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _buildOption(
                                i,
                                selectedAnswer == i,
                                accent,
                                question.options[i],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // ===== ปุ่ม Back / Next =====
                Row(
                  children: [
                    OutlinedButton(
                      onPressed: _currentIndex == 0 ? null : _onBack,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: _textPrimary,
                        backgroundColor: _chipBg,
                        side: BorderSide.none,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 26, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text('ย้อนกลับ'),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: _nextButton(accent, answered, isLast)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ===== ปุ่มวงกลม (ปิด) =====
  Widget _circleBtn({required IconData icon, required VoidCallback onTap}) {
    return Material(
      color: _surface,
      shape: const CircleBorder(),
      elevation: 1,
      shadowColor: Colors.black12,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(icon, size: 22, color: _textPrimary),
        ),
      ),
    );
  }

  // ===== การ์ดคำถาม (มีแถบสีหมวดด้านซ้าย) =====
  Widget _questionCard(Question question, Color accent) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: 0.12),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // แถบสีหมวดด้านซ้าย
            Container(
              width: 5,
              decoration: BoxDecoration(
                color: accent,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18),
                  bottomLeft: Radius.circular(18),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Text(
                    question.questionTh,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      height: 1.4,
                      color: _textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    question.questionEn,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.4,
                      color: _textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          ],
        ),
      ),
    );
  }

  // ===== ตัวเลือกคำตอบ (ตัวอักษร A–D + เช็คตอนเลือก) =====
  Widget _buildOption(int index, bool isSelected, Color accent, String label) {
    final String letter = String.fromCharCode(65 + index); // A, B, C, ...
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => _selectAnswer(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? accent.withValues(alpha: 0.10) : _surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? accent : _border,
              width: isSelected ? 1.6 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: accent.withValues(alpha: 0.18),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              // ป้ายตัวอักษร
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 30,
                height: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? accent : _chipBg,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Text(
                  letter,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : _textSecondary,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.3,
                    color: _textPrimary,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
              // ไอคอนเช็คเมื่อเลือก
              if (isSelected)
                Icon(Icons.check_circle_rounded, color: accent, size: 22),
            ],
          ),
        ),
      ),
    );
  }

  // ===== ปุ่ม Next / ดูผลลัพธ์ (ไล่เฉดสีหมวด) =====
  Widget _nextButton(Color accent, bool answered, bool isLast) {
    final List<Color> grad = answered
        ? [accent, _darken(accent, 0.18)]
        : [const Color(0xFFCBCBD4), const Color(0xFFBDBDC8)];

    return GestureDetector(
      onTap: _onNext,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 52,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: grad),
          borderRadius: BorderRadius.circular(30),
          boxShadow: answered
              ? [
                  BoxShadow(
                    color: accent.withValues(alpha: 0.35),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isLast ? 'ดูผลลัพธ์' : 'ถัดไป',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 6),
            Icon(
              isLast
                  ? Icons.assignment_turned_in_rounded
                  : Icons.arrow_forward_rounded,
              color: Colors.white,
              size: 19,
            ),
          ],
        ),
      ),
    );
  }
}

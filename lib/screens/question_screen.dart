import 'package:flutter/material.dart';
import '../data/questions_data.dart'; // นำเข้าข้อมูลคำถาม (questions)
import 'result_screen.dart';          // นำเข้าหน้าผลลัพธ์ เพื่อไปแสดงเมื่อตอบครบ

// หน้าจอคำถาม - ใช้ StatefulWidget เพราะมีสถานะที่เปลี่ยนได้
// (ข้อปัจจุบัน, คำตอบที่เลือก) ซึ่งต้อง rebuild หน้าจอเมื่อมีการเปลี่ยน
class QuestionScreen extends StatefulWidget {
  const QuestionScreen({super.key});

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  // index ของคำถามที่กำลังแสดง (เริ่มที่ข้อแรก = 0)
  int _currentIndex = 0;

  // เก็บคำตอบของทุกข้อ; เริ่มต้นทุกข้อเป็น -1 (ยังไม่ได้ตอบ)
  final List<int> _answers = List.filled(questions.length, -1);

  // ===== สีที่ใช้ในหน้านี้ =====
  static const Color _purple = Color(0xFF6B5B95); // แถบ progress
  static const Color _cardBg = Color(0xFFFAF7F2); // พื้นการ์ดคำถาม
  static const Color _brown = Color(0xFF5A3E2B);  // ปุ่ม Next / ตัวเลือกที่เลือก

  // ===== ฟังก์ชันเมื่อกดปุ่ม Next =====
  void _onNext() {
    // ถ้ายังไม่ได้ตอบข้อนี้ → แสดงข้อความเตือนแล้วหยุด (ไม่ไปข้อถัดไป)
    if (_answers[_currentIndex] == -1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('กรุณาเลือกคำตอบก่อนไปข้อถัดไป'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    // ถ้าเป็นข้อสุดท้ายแล้ว → ไปหน้าผลลัพธ์ (ส่งสำเนาคำตอบไปด้วย)
    if (_currentIndex == questions.length - 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          // List.from() สร้างสำเนาใหม่ ป้องกันการแก้ไขย้อนกลับมากระทบ
          builder: (_) => ResultScreen(answers: List.from(_answers)),
        ),
      );
      return;
    }
    // กรณีปกติ → เลื่อนไปข้อถัดไป แล้ว rebuild หน้าจอ
    setState(() => _currentIndex++);
  }

  // ===== ฟังก์ชันเมื่อกดปุ่ม Back =====
  void _onBack() {
    if (_currentIndex == 0) return;      // ถ้าอยู่ข้อแรกแล้ว ไม่ทำอะไร
    setState(() => _currentIndex--);     // ถอยกลับไปข้อก่อนหน้า
  }

  // ===== กำหนดสีพื้นของแท็กหมวดหมู่ ตามชื่อหมวด =====
  // แต่ละหมวดมีสีเฉพาะตัว เพื่อให้แยกแยะได้ง่าย
  Color _tagBgColor(String category) {
    switch (category) {
      case 'Anxiety Screening':
        return const Color(0xFFB8D4F0);
      case 'Stress Assessment':
        return const Color(0xFFD4F0B8);
      case 'Sleep Quality':
        return const Color(0xFFE8D4F0);
      case 'Social Functioning':
        return const Color(0xFFF0D4E8);
      case 'Overall Well-being':
        return const Color(0xFFD4E8F0);
      default: // หมวดอื่น (เช่น Depression Screening) ใช้สีส้มอ่อน
        return const Color(0xFFF4C99A);
    }
  }

  // ===== กำหนดสีตัวอักษรของแท็ก ให้เข้ากับสีพื้นข้างบน =====
  Color _tagTextColor(String category) {
    switch (category) {
      case 'Anxiety Screening':
        return const Color(0xFF2B5A8A);
      case 'Stress Assessment':
        return const Color(0xFF3A6B2B);
      case 'Sleep Quality':
        return const Color(0xFF5A2B8A);
      case 'Social Functioning':
        return const Color(0xFF8A2B5A);
      case 'Overall Well-being':
        return const Color(0xFF2B6B6B);
      default:
        return const Color(0xFF8A5A2B);
    }
  }

  @override
  Widget build(BuildContext context) {
    // ===== เตรียมข้อมูลของข้อปัจจุบัน =====
    final question = questions[_currentIndex];          // object คำถามข้อนี้
    final int currentNumber = _currentIndex + 1;        // เลขข้อ (เริ่มนับจาก 1)
    final int total = questions.length;                 // จำนวนข้อทั้งหมด
    final double progress = currentNumber / total;      // สัดส่วนความคืบหน้า 0.0-1.0
    final int percent = (progress * 100).round();       // เปอร์เซ็นต์ (ปัดเศษ)
    final int selectedAnswer = _answers[_currentIndex]; // คำตอบที่เลือกของข้อนี้

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea( // กันเนื้อหาทับ notch / status bar
        child: Column(
          children: [
            // ----- เนื้อหาทั้งหมด เต็มหน้าจอ (ไม่มีขอบข้าง/แถบหัว) -----
            Expanded(
              child: Container(
                width: double.infinity,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ===== แถวหัว: ปุ่มปิด/ย้อนกลับ + โลโก้ =====
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context), // แตะที่ไอคอนเพื่อย้อนกลับ
                            child: Icon(
                              Icons.close,
                              size: 24,
                              // ถ้าอยู่ข้อแรก ทำให้ไอคอนจางลง (กดไม่ได้ผล)
                              color: _currentIndex == 0
                                  ? Colors.black26
                                  : Colors.black87,
                            ),
                          ),
                          const SizedBox(width: 24),
                          const Expanded(
                            child: Text(
                              'MentalCheck',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          const SizedBox(width: 48), // เว้นช่องให้ชื่ออยู่กึ่งกลาง
                        ],
                      ),
                      const SizedBox(height: 24),

                      // ===== แถวเลขข้อ + เปอร์เซ็นต์ =====
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Question $currentNumber of $total',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.black54,
                            ),
                          ),
                          Text(
                            '$percent%',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: _purple,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // ===== แถบความคืบหน้า =====
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: progress, // อัปเดตตามข้อปัจจุบัน
                          minHeight: 6,
                          backgroundColor: const Color(0xFFE8E8E8),
                          valueColor:
                              const AlwaysStoppedAnimation(_purple),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // ===== การ์ดคำถาม =====
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: _cardBg,
                          borderRadius: BorderRadius.circular(12),
                          border:
                              Border.all(color: const Color(0xFFEDE6DD)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // แท็กหมวดหมู่ (สีเปลี่ยนตามหมวด)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: _tagBgColor(question.category),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                question.category,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: _tagTextColor(question.category),
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),

                            // คำถามภาษาไทย
                            Text(
                              question.questionTh,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                height: 1.4,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 10),

                            // คำถามภาษาอังกฤษ (สีเทา)
                            Text(
                              question.questionEn,
                              style: const TextStyle(
                                fontSize: 13,
                                height: 1.4,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // ===== รายการตัวเลือกคำตอบ =====
                      // Expanded + ListView ทำให้เลื่อนได้ถ้าตัวเลือกยาว
                      Expanded(
                        child: ListView.separated(
                          padding: EdgeInsets.zero,
                          itemCount: question.options.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12), // ระยะห่างระหว่างตัวเลือก
                          itemBuilder: (context, index) {
                            // สร้างตัวเลือก พร้อมบอกว่าตัวนี้ถูกเลือกอยู่หรือไม่
                            return _buildOption(index, selectedAnswer == index);
                          },
                        ),
                      ),
                      const SizedBox(height: 12),

                      // ===== ปุ่ม Back / Next =====
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // ปุ่ม Back - ปิดใช้งาน (null) เมื่ออยู่ข้อแรก
                          OutlinedButton(
                            onPressed: _currentIndex == 0 ? null : _onBack,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.black87,
                              backgroundColor: _currentIndex == 0
                                  ? const Color(0xFFF5F5F5)  // สีจางเมื่อปิดใช้งาน
                                  : const Color(0xFFEDEAE4),
                              side: BorderSide.none,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 28, vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Text('Back'),
                          ),
                          // ปุ่ม Next / ดูผลลัพธ์
                          ElevatedButton(
                            onPressed: _onNext,
                            style: ElevatedButton.styleFrom(
                              // สีเทาถ้ายังไม่ตอบ, สีน้ำตาลถ้าตอบแล้ว
                              backgroundColor: _answers[_currentIndex] == -1
                                  ? Colors.grey.shade400
                                  : _brown,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 28, vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // เปลี่ยนข้อความเป็น "ดูผลลัพธ์" เมื่อถึงข้อสุดท้าย
                                Text(_currentIndex == questions.length - 1
                                    ? 'ดูผลลัพธ์'
                                    : 'Next'),
                                const SizedBox(width: 6),
                                const Icon(Icons.arrow_forward, size: 18),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===== Widget สร้างตัวเลือกคำตอบแต่ละอัน =====
  Widget _buildOption(int index, bool isSelected) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      // เมื่อแตะ → บันทึกคำตอบของข้อปัจจุบันเป็น index นี้ แล้ว rebuild
      onTap: () => setState(() => _answers[_currentIndex] = index),
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          // เปลี่ยนสีพื้น/ขอบเมื่อถูกเลือก
          color: isSelected ? const Color(0xFFFAF5EF) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? _brown : const Color(0xFFE5E0D8),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            // วงกลม radio button
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? _brown : const Color(0xFFCFC8BD),
                  width: 2,
                ),
                color: isSelected ? _brown : Colors.transparent,
              ),
              // จุดสีขาวตรงกลางเมื่อถูกเลือก
              child: isSelected
                  ? const Icon(Icons.circle, size: 8, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 14),
            // ข้อความตัวเลือก (Expanded กันข้อความล้นจอ)
            Expanded(
              child: Text(
                questions[_currentIndex].options[index],
                style: const TextStyle(fontSize: 15, color: Colors.black87),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
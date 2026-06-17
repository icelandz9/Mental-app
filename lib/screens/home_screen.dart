import 'package:flutter/material.dart';
import 'question_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const Color _brown = Color(0xFF5A3E2B);
  static const Color _bgColor = Color(0xFFF8F5F0);
  static const Color _purple = Color(0xFF6B5B95);

  @override                                                                                                                                                                                                     
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    _buildHeroCard(),
                    const SizedBox(height: 24),

                    // ชื่อแบบทดสอบ
                    const Text(
                      'แบบทดสอบคัดกรอง\nสุขภาพจิตเบื้องต้น',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D1F14),
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // คำอธิบาย
                    const Text(
                      'แบบทดสอบนี้จัดทำขึ้นเพื่อช่วยให้คุณเข้าใจสภาวะทางจิตใจเบื้องต้น '
                      'และแยกแยะประเภทของความผิดปกติที่อาจเกิดขึ้น '
                      'เพื่อรับคำแนะนำที่เหมาะสม',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                        height: 1.7,
                      ),
                    ),
                    const SizedBox(height: 24),

                    _buildSectionCard(),
                    const SizedBox(height: 32),

                    // ปุ่มเริ่มทำแบบทดสอบ
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const QuestionScreen()),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _brown,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 0,
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'เริ่มทำแบบทดสอบ',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward, size: 18),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // ข้อความความเป็นส่วนตัว
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.lock_outline, size: 13, color: Colors.black38),
                        SizedBox(width: 4),
                        Text(
                          'ข้อมูลของคุณจะถูกเก็บเป็นความลับสูงสุด',
                          style: TextStyle(fontSize: 12, color: Colors.black38),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            _buildBottomNav(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          const Icon(Icons.self_improvement, color: _brown, size: 26),
          const Expanded(
            child: Text(
              'MentalCheck',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D1F14),
              ),
            ),
          ),
          const Icon(Icons.settings_outlined, color: _brown, size: 24),
        ],
      ),
    );
  }

  Widget _buildHeroCard() {
    return Container(
      width: double.infinity,
      height: 160,
      decoration: BoxDecoration(
        color: const Color(0xFFEDE8E3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Center(
        child: Icon(
          Icons.psychology,
          size: 72,
          color: Color(0xFF8A7060),
        ),
      ),
    );
  }

  Widget _buildSectionCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEDE6DD)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // แท็ก Section 1
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFF4C99A),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Section 1',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFF8A5A2B),
              ),
            ),
          ),
          const SizedBox(height: 18),

          _buildInfoRow(Icons.format_list_numbered_outlined, 'จำนวน 80 ข้อ'),
          const SizedBox(height: 14),
          _buildInfoRow(Icons.access_time_outlined, 'ใช้เวลาประมาณ  10-15 นาที'),
          const SizedBox(height: 14),
          _buildInfoRow(
              Icons.chat_bubble_outline, 'โปรดตอบตามความเป็นจริง'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: const Color(0xFF8A7060)),
        const SizedBox(width: 12),
        Text(
          text,
          style: const TextStyle(fontSize: 14, color: Colors.black87),
        ),
      ],
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.assignment_outlined, 'Screening', true),
          _buildNavItem(Icons.history, 'History', false),
          _buildNavItem(Icons.menu_book_outlined, 'Resources', false),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isSelected) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
          decoration: isSelected
              ? BoxDecoration(
                  color: const Color(0xFFEEE9F5),
                  borderRadius: BorderRadius.circular(20),
                )
              : null,
          child: Icon(
            icon,
            color: isSelected ? _purple : Colors.black38,
            size: 22,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: isSelected ? _purple : Colors.black38,
            fontWeight:
                isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}

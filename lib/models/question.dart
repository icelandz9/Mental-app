// โมเดลคำถาม 1 ข้อ
// รองรับแต่ละแบบทดสอบที่มีตัวเลือก/คะแนนต่างกัน (เช่น 0-3, 0-4, ใช่/ไม่ใช่)
class Question {
  final String instrument;   // รหัสแบบทดสอบ เช่น 'PHQ-9' (ใช้จัดกลุ่มตอนคิดคะแนน)
  final String category;     // ป้ายหมวดที่โชว์บนการ์ด (ถ้าว่างจะใช้ instrument แทน)
  final String questionTh;   // คำถามภาษาไทย
  final String questionEn;   // คำถามภาษาอังกฤษ
  final List<String> options; // ตัวเลือกของข้อนี้ (เรียงจากน้อยไปมาก)
  final List<int> scores;     // คะแนนของแต่ละตัวเลือก (รองรับข้อกลับคะแนน/ใช่-ไม่ใช่)
  final int? threshold;       // เกณฑ์นับสำหรับ ASRS Part A (ข้ออื่นเป็น null)

  const Question({
    required this.instrument,
    this.category = '',
    required this.questionTh,
    required this.questionEn,
    required this.options,
    required this.scores,
    this.threshold,
  });
}
